@app.route('/fetch_student.php', methods=['GET'])
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
        
        # Determine remarks based on attendance time
        if attendance_time.time() <= start_time:
            remarks = 'Present'
        elif start_time < attendance_time.time() <= (datetime.combine(datetime.today(), start_time) + timedelta(minutes=15)).time():
            remarks = 'Late'
        else:
            remarks = 'Absent'
        
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