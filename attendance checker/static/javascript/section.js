document.addEventListener('DOMContentLoaded', function() {
    const sectionsList = document.getElementById('sections-list');
    const sectionContainer = document.getElementById('section-container');
    const studentContainer = document.getElementById('student-container');
    const backToSectionsButton = document.getElementById('back-to-sections');
    const addSectionButton = document.getElementById('add-section-button');
    const addStudentButton = document.getElementById('add-student-button');
    const sectionNameInput = document.getElementById('section-name');
    const gradeLevelInput = document.getElementById('grade-level');
    const firstNameInput = document.getElementById('first-name');
    const lastNameInput = document.getElementById('last-name');
    const studentIdInput = document.getElementById('student-id');
    const genderInput = document.getElementById('gender');

    let sections = []; // Placeholder for section data
    let students = {}; // Placeholder for student data by section

    function renderSections() {
        sectionsList.innerHTML = '';
        sections.forEach((section, index) => {
            const sectionCard = document.createElement('div');
            sectionCard.classList.add('card');
            sectionCard.innerHTML = `
                <img src="static/images/section-placeholder.jpg" alt="Section Image">
                <h3>${section.name}</h3>
                <p>Grade Level: ${section.gradeLevel}</p>
                <button class="open-button" data-index="${index}">Open</button>
                <button class="edit-button" data-index="${index}">Edit</button>
                <button class="delete-button" data-index="${index}">Delete</button>
            `;
            sectionsList.appendChild(sectionCard);
        });
    }

    function renderStudentList(sectionName) {
        const studentListContainer = document.getElementById('student-list');
        const sectionStudents = students[sectionName] || [];
        studentListContainer.innerHTML = '';
        sectionStudents.forEach(student => {
            const studentRow = document.createElement('tr');
            studentRow.innerHTML = `
                <td>${student.firstName}</td>
                <td>${student.lastName}</td>
                <td>${student.studentId}</td>
                <td>${student.gender}</td>
            `;
            studentListContainer.appendChild(studentRow);
        });
    }

    // Add Section
    addSectionButton.addEventListener('click', () => {
        const sectionName = sectionNameInput.value.trim();
        const gradeLevel = parseInt(gradeLevelInput.value);
        if (sectionName && gradeLevel) {
            sections.push({ name: sectionName, gradeLevel });
            students[sectionName] = [];
            sectionNameInput.value = '';
            gradeLevelInput.value = '';
            renderSections();
        }
    });

    // Open Section (show student list)
    sectionsList.addEventListener('click', (e) => {
        if (e.target.classList.contains('open-button')) {
            const sectionIndex = e.target.getAttribute('data-index');
            const sectionName = sections[sectionIndex].name;
            sectionContainer.style.display = 'none';
            studentContainer.style.display = 'block';
            document.getElementById('current-section-name').innerText = `Manage Students in ${sectionName}`;
            renderStudentList(sectionName);
        }
    });

    // Back to Sections
    backToSectionsButton.addEventListener('click', () => {
        studentContainer.style.display = 'none';
        sectionContainer.style.display = 'block';
    });

    // Add Student
    addStudentButton.addEventListener('click', () => {
        const firstName = firstNameInput.value.trim();
        const lastName = lastNameInput.value.trim();
        const studentId = studentIdInput.value.trim();
        const gender = genderInput.value;
        if (firstName && lastName && studentId && gender) {
            const sectionName = document.getElementById('current-section-name').innerText.replace('Manage Students in ', '');
            students[sectionName].push({ firstName, lastName, studentId, gender });
            firstNameInput.value = '';
            lastNameInput.value = '';
            studentIdInput.value = '';
            genderInput.value = '';
            renderStudentList(sectionName);
        }
    });

    renderSections(); // Initial render of sections
});
