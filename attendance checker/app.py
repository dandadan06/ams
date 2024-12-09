from flask import Flask, render_template, url_for, redirect, request, session, jsonify
from flask_mysqldb import MySQL
from datetime import datetime
import MySQLdb.cursors
import re

app = Flask(__name__)


# Set a secret key for Flask sessions (ensure this is kept private)
app.secret_key = 'your_secret_key_here'  # Replace with a random unique key

# Database configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'ams'

mysql = MySQL(app)

# Home Route -------------------------------------------------------------------------------------

@app.route('/')
def index():
    return render_template('index.html')

# Attendance Route --------------------------------------------------------------------------------

from datetime import timedelta

@app.route('/fetch_student')
def fetch_student():
    student_id = request.args.get('id')
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('''
        SELECT student_info.id, student_info.first_name, student_info.last_name, student_info.student_id, student_info.profile_pic, t_classes.class_name AS section, t_classes.start_time, t_classes.end_time
        FROM student_info
        LEFT JOIN t_classes ON student_info.section_id = t_classes.id
        WHERE student_info.student_id = %s
    ''', (student_id,))
    student = cursor.fetchone()
    
    if student:
        # Record attendance
        attendance_time = datetime.now()
        start_time = datetime.strptime(str(student['start_time']), '%H:%M:%S').time()
        end_time = datetime.strptime(str(student['end_time']), '%H:%M:%S').time()
        
        # Calculate the first quarter of the time frame
        class_duration = datetime.combine(datetime.today(), end_time) - datetime.combine(datetime.today(), start_time)
        first_quarter = (datetime.combine(datetime.today(), start_time) + class_duration / 4).time()
        
        # Determine remarks based on attendance time
        if attendance_time.time() <= first_quarter:
            remarks = 'Present'
        elif first_quarter < attendance_time.time() <= end_time:
            remarks = 'Late'
        else:
            remarks = 'Absent'
        
        # Check if an attendance record already exists for today
        cursor.execute('''
            SELECT * FROM attendance_records
            WHERE student_id = %s AND DATE(time) = CURDATE()
        ''', (student['id'],))
        existing_record = cursor.fetchone()
        
        if existing_record:
            # Update the existing record
            cursor.execute('''
                UPDATE attendance_records
                SET time = %s, remarks = %s
                WHERE record_id = %s
            ''', (attendance_time, remarks, existing_record['record_id']))
        else:
            # Insert a new record
            cursor.execute('INSERT INTO attendance_records (student_id, time, remarks) VALUES (%s, %s, %s)', 
                           (student['id'], attendance_time, remarks))
        
        mysql.connection.commit()
        
        return jsonify({
            'success': True,
            'id': student['id'],
            'first_name': student['first_name'],
            'last_name': student['last_name'],
            'student_id': student['student_id'],
            'profile_pic': student['profile_pic'],
            'section': student['section'],
            'remarks': remarks,
            'time': attendance_time.strftime('%H:%M:%S')
        })
    else:
        return jsonify({'success': False, 'message': 'Student not found'})



# Admin Route -------------------------------------------------------------------------------------

@app.route('/dashboard')
def dashboard():
    if 'loggedin' in session:
        teacher_id = session['id']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM t_classes WHERE teacher_id = %s ORDER BY class_name ASC', (teacher_id,))
        sections = cursor.fetchall()
        return render_template('dashboard.html', sections=sections)
    return redirect(url_for('login'))

@app.route('/section/<int:section_id>/students')
def section_students(section_id):
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Fetch section details
        cursor.execute('SELECT class_name, year FROM t_classes WHERE id = %s', (section_id,))
        section = cursor.fetchone()
        
        # Fetch students and their attendance records
        cursor.execute('''
            SELECT student_info.student_id, student_info.first_name, student_info.last_name, attendance_records.remarks, attendance_records.time
            FROM student_info
            LEFT JOIN attendance_records ON student_info.id = attendance_records.student_id
            WHERE student_info.section_id = %s
        ''', (section_id,))
        students = cursor.fetchall()
        
        return render_template('student_summary.html', students=students, section_name=section['class_name'], section_year=section['year'])
    return redirect(url_for('login'))

# Section Route ------------------------------------------------------------------------------------

@app.route('/section', methods=['GET', 'POST'])
def section():
    if 'loggedin' in session:
        teacher_id = session['id']
        message = ''
        if request.method == 'POST':
            # Fetch data from the form
            section = request.form['section']
            year = request.form['year']
            start_time = request.form['start_time']
            end_time = request.form['end_time']

            # Insert the data into the t_classes table
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            try:
                cursor.execute('INSERT INTO t_classes (class_name, year, teacher_id, start_time, end_time) VALUES (%s, %s, %s, %s, %s)', 
                               (section, year, teacher_id, start_time, end_time))
                mysql.connection.commit()
                message = 'Section added successfully!'
            except Exception as e:
                message = 'Error: ' + str(e)

        # Fetch all sections for the logged-in teacher
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM t_classes WHERE teacher_id = %s ORDER BY class_name ASC', (teacher_id,))
        sections = cursor.fetchall()

        return render_template('section.html', sections=sections, message=message)
    return redirect(url_for('login'))

@app.route('/section/delete/<int:section_id>', methods=['POST'])
def delete_section(section_id):
    if 'loggedin' in session:
        teacher_id = session['id']
        message = ''
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        try:
            # Delete the section from the t_classes table where the section ID matches and belongs to the logged-in teacher
            cursor.execute('DELETE FROM t_classes WHERE id = %s AND teacher_id = %s', (section_id, teacher_id))
            mysql.connection.commit()
            message = 'Section deleted successfully!'
        except Exception as e:
            message = 'Error: ' + str(e)

        # Redirect to the section page with a message
        return redirect(url_for('section', message=message))
    return redirect(url_for('login'))

@app.route('/section/view/<int:section_id>')
def view_section(section_id):
    if 'loggedin' in session:
        teacher_id = session['id']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # Fetch the section details using the section_id and teacher_id
        cursor.execute('SELECT * FROM t_classes WHERE id = %s AND teacher_id = %s', (section_id, teacher_id))
        section = cursor.fetchone()

        if section:
            return render_template('view_section.html', section=section)
        else:
            return redirect(url_for('section'))
    return redirect(url_for('login'))

@app.route('/section/add_student', methods=['POST'])
def add_student():
    if 'loggedin' in session:
        message = ''
        if request.method == 'POST':
            # Fetch data from the form
            section_id = request.form['section_id']
            first_name = request.form['first_name']
            last_name = request.form['last_name']
            student_id = request.form['student_id']
            parent_name = request.form['parent_name']
            gender = request.form['gender']
            profile_picture = request.files['profile_picture']

            # Save the profile picture
            profile_pic_path = 'static/uploads/' + profile_picture.filename
            profile_picture.save(profile_pic_path)

            # Insert the data into the student_info table
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            try:
                cursor.execute('INSERT INTO student_info (first_name, last_name, student_id, gender, parent, profile_pic, section_id) VALUES (%s, %s, %s, %s, %s, %s, %s)', 
                               (first_name, last_name, student_id, gender, parent_name, profile_pic_path, section_id))
                mysql.connection.commit()
                return {'success': True}
            except Exception as e:
                return {'success': False, 'message': str(e)}

        return {'success': False, 'message': 'Invalid request'}
    return redirect(url_for('login'))

@app.route('/section/students/<int:section_id>', methods=['GET'])
def get_students(section_id):
    if 'loggedin' in session:
        teacher_id = session['id']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM student_info WHERE section_id = %s AND section_id IN (SELECT id FROM t_classes WHERE teacher_id = %s)', (section_id, teacher_id))
        students = cursor.fetchall()
        return {'students': students}
    return redirect(url_for('login'))
    
@app.route('/section/student/<int:student_id>', methods=['GET'])
def get_student(student_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM student_info WHERE id = %s', (student_id,))
    student = cursor.fetchone()
    if student:
        return jsonify({'success': True, 'student': student})
    else:
        return jsonify({'success': False, 'message': 'Student not found'})

@app.route('/section/edit_student/<int:student_id>', methods=['POST'])
def edit_student(student_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    student_id_value = request.form['student_id']
    parent_name = request.form['parent_name']
    gender = request.form['gender']
    profile_picture = request.files.get('profile_picture')

    try:
        if profile_picture:
            profile_pic_path = 'static/uploads/' + profile_picture.filename
            profile_picture.save(profile_pic_path)
            cursor.execute('''
                UPDATE student_info
                SET first_name = %s, last_name = %s, student_id = %s, parent = %s, gender = %s, profile_pic = %s
                WHERE id = %s
            ''', (first_name, last_name, student_id_value, parent_name, gender, profile_pic_path, student_id))
        else:
            cursor.execute('''
                UPDATE student_info
                SET first_name = %s, last_name = %s, student_id = %s, parent = %s, gender = %s
                WHERE id = %s
            ''', (first_name, last_name, student_id_value, parent_name, gender, student_id))
        mysql.connection.commit()
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})
    

@app.route('/section/delete_student/<int:student_id>', methods=['POST'])
def delete_student(student_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    try:
        # Delete related records from attendance_records
        cursor.execute('DELETE FROM attendance_records WHERE student_id = %s', (student_id,))
        cursor.execute('DELETE FROM attendance WHERE student_id = %s', (student_id,))
        
        # Delete the student record
        cursor.execute('DELETE FROM student_info WHERE id = %s', (student_id,))
        mysql.connection.commit()
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})

# Registration Route ------------------------------------------------------------------------------

@app.route('/register', methods=['GET', 'POST'])
def register():
    message = ''
    if request.method == 'POST' and 'username' in request.form and 'email' in request.form and 'password' in request.form:
        username = request.form['username']  # Fetch 'username' from the form
        email = request.form['email']  # Fetch 'email' from the form
        password = request.form['password']  # Fetch 'password' from the form

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Check if an account with the same email or username already exists in the teacher table
        cursor.execute('SELECT * FROM teacher WHERE email = %s OR username = %s', (email, username))
        account = cursor.fetchone()

        if account:
            message = 'Account with this email or username already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            message = 'Invalid email address!'
        elif not username or not password or not email:
            message = 'Please fill out all fields!'
        else:
            # Insert the new teacher into the teacher table without password hashing
            cursor.execute('INSERT INTO teacher (username, email, password) VALUES (%s, %s, %s)',
                           (username, email, password))
            mysql.connection.commit()
            message = 'You have successfully registered!'
    elif request.method == 'POST':
        message = 'Please fill out the form!'
    return render_template('register.html', message=message)

# Login Route -------------------------------------------------------------------------------------

@app.route('/login', methods=['GET', 'POST'])
def login():
    message = ''
    if request.method == 'POST' and 'email' in request.form and 'password' in request.form:
        email = request.form['email']
        password = request.form['password']

        # Cursor for executing SQL queries
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # Fetch teacher account matching the provided email and password
        cursor.execute('SELECT * FROM teacher WHERE email = %s AND password = %s', (email, password))
        account = cursor.fetchone()

        if account:
            # Store session information
            session['loggedin'] = True
            session['id'] = account['id']
            session['username'] = account['username']  # Store the username
            session['email'] = account['email']

            # Redirect to the dashboard
            return redirect(url_for('dashboard'))
        else:
            message = 'Invalid email or password!'

    return render_template('login.html', message=message)

# Logout Route -------------------------------------------------------------------------------------

@app.route('/logout')
def logout():
    # Clear the session
    session.clear()
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)