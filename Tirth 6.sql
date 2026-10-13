mysql> CREATE DATABASE IF NOT EXISTS student_tracker_db;
Query OK, 1 row affected (0.01 sec)

mysql> USE student_tracker_db;
Database changed
mysql>
mysql> DROP TABLE IF EXISTS Grades;
Query OK, 0 rows affected, 1 warning (0.02 sec)

mysql> DROP TABLE IF EXISTS Attendance;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP TABLE IF EXISTS Enrollments;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP TABLE IF EXISTS Courses;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> DROP TABLE IF EXISTS Faculty;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP TABLE IF EXISTS Students;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> DROP TABLE IF EXISTS Departments;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql>
mysql> CREATE TABLE Departments (
    ->     department_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     department_name VARCHAR(100) NOT NULL
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE Faculty (
    ->     faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     name VARCHAR(100) NOT NULL,
    ->     email VARCHAR(100),
    ->     phone_number VARCHAR(20),
    ->     department_id INT,
    ->     experience_years INT DEFAULT 0, -- Necessary context field for Task 8.2 subquery
    ->     FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
    -> );
Query OK, 0 rows affected (0.41 sec)

mysql> CREATE TABLE Students (
    ->     student_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     name VARCHAR(100) NOT NULL,
    ->     dob DATE,
    ->     gender VARCHAR(10),
    ->     email VARCHAR(100),
    ->     phone_number VARCHAR(20),
    ->     address VARCHAR(255),
    ->     admission_date DATE NOT NULL,
    ->     department_id INT,
    ->     FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> CREATE TABLE Courses (
    ->     course_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     course_name VARCHAR(100) NOT NULL,
    ->     faculty_id INT,
    ->     FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id) ON DELETE SET NULL
    -> );
Query OK, 0 rows affected (0.17 sec)

mysql> CREATE TABLE Enrollments (
    ->     enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     student_id INT,
    ->     course_id INT,
    ->     enrollment_date DATE NOT NULL,
    ->     FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    ->     FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    ->     CONSTRAINT unique_student_course UNIQUE (student_id, course_id)
    -> );
Query OK, 0 rows affected (0.41 sec)

mysql> CREATE TABLE Attendance (
    ->     attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     student_id INT,
    ->     course_id INT,
    ->     attendance_date DATE NOT NULL,
    ->     status ENUM('Present', 'Absent', 'Late') NOT NULL,
    ->     FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    ->     FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
    -> );
Query OK, 0 rows affected (0.50 sec)

mysql> CREATE TABLE Grades (
    ->     grade_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     student_id INT,
    ->     course_id INT,
    ->     marks_obtained DECIMAL(5,2),
    ->     FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    ->     FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> ^C
mysql> INSERT INTO Departments (department_name) VALUES
    -> ('Computer Science'),
    -> ('Mechanical Engineering'),
    -> ('Electrical Engineering');
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Faculty (name, email, phone_number, department_id, experience_years) VALUES
    -> ('Dr. Alan Turing', 'turing@university.edu', '1234567890', 1, 8),
    -> ('Prof. Ada Lovelace', 'ada@university.edu', '2345678901', 1, 6),
    -> ('Dr. Nikola Tesla', 'tesla@university.edu', '3456789012', 3, 3),
    -> ('Unassigned Professor', NULL, NULL, NULL, 2);
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Students (name, dob, gender, email, phone_number, address, admission_date, department_id) VALUES
    -> ('  Alice Smith  ', '2002-05-15', 'Female', 'alice@edu.com', '9998887771', '123 Elm St', '2021-09-01', 1),
    -> ('Bob Jones', '2001-11-23', 'Male', 'bob@edu.com', '9998887772', '456 Oak St', '2020-09-01', 1),
    -> ('Charlie Brown', '2002-02-10', 'Male', NULL, '9998887773', '789 Pine St', '2022-09-01', 2),
    -> ('Diana Prince', '2003-07-19', 'Female', 'diana@edu.com', '9998887774', '101 Sky Ln', '2023-09-01', 1),
    -> ('Evan Wright', '2001-04-05', 'Male', 'evan@edu.com', '9998887775', '202 Lake Dr', '2021-09-01', 3),
    -> ('Dropout Student', '2000-01-01', 'Male', 'dropout@edu.com', '0000000000', 'None', '2019-09-01', 2);
Query OK, 6 rows affected (0.02 sec)
Records: 6  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Courses (course_name, faculty_id) VALUES
    -> ('Database Systems', 1),
    -> ('Algorithms', 2),
    -> ('Thermodynamics', NULL);
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
    -> (1, 1, '2021-09-05'),
    -> (1, 2, '2021-09-05'),
    -> (2, 1, '2020-09-05'),
    -> (3, 3, '2022-09-05'),
    -> (4, 1, '2023-09-05'),
    -> (6, 1, '2019-09-05');
Query OK, 6 rows affected (0.01 sec)
Records: 6  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Attendance (student_id, course_id, attendance_date, status) VALUES
    -> (1, 1, '2026-10-01', 'Present'), (1, 1, '2026-10-02', 'Present'), (1, 1, '2026-10-03', 'Absent'),
    -> (3, 3, '2026-10-01', 'Present'), (3, 3, '2026-10-02', 'Present'), (3, 3, '2026-10-03', 'Present'),
    -> (4, 1, '2026-10-01', 'Present'), (4, 1, '2026-10-02', 'Present'), (4, 1, '2026-10-03', 'Present'),
    -> (2, 1, '2026-10-01', 'Absent'), (2, 1, '2026-10-02', 'Absent'), (2, 1, '2026-10-03', 'Absent'),
    -> (2, 1, '2026-10-04', 'Absent'), (2, 1, '2026-10-05', 'Absent'), (2, 1, '2026-10-06', 'Absent'),
    -> (2, 1, '2026-10-07', 'Absent'), (2, 1, '2026-10-08', 'Absent'), (2, 1, '2026-10-09', 'Absent'),
    -> (2, 1, '2026-10-10', 'Absent'), (2, 1, '2026-10-11', 'Absent');
Query OK, 20 rows affected (0.01 sec)
Records: 20  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Grades (student_id, course_id, marks_obtained) VALUES
    -> (1, 1, 95.50),
    -> (1, 2, 88.00),
    -> (2, 1, 42.00),
    -> (3, 3, 76.50),
    -> (4, 1, 91.00);
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> UPDATE Students SET phone_number = '9876543210', email = 'alice.new@edu.com' WHERE student_id = 1;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> DELETE FROM Students WHERE name LIKE '%Dropout%';
Query OK, 1 row affected (0.01 sec)

mysql> SELECT s.* FROM Students s
    -> INNER JOIN Departments d ON s.department_id = d.department_id
    -> WHERE d.department_name = 'Computer Science';
+------------+-----------------+------------+--------+-------------------+--------------+------------+----------------+---------------+
| student_id | name            | dob        | gender | email             | phone_number | address    | admission_date | department_id |
+------------+-----------------+------------+--------+-------------------+--------------+------------+----------------+---------------+
|          1 |   Alice Smith   | 2002-05-15 | Female | alice.new@edu.com | 9876543210   | 123 Elm St | 2021-09-01     |             1 |
|          2 | Bob Jones       | 2001-11-23 | Male   | bob@edu.com       | 9998887772   | 456 Oak St | 2020-09-01     |             1 |
|          4 | Diana Prince    | 2003-07-19 | Female | diana@edu.com     | 9998887774   | 101 Sky Ln | 2023-09-01     |             1 |
+------------+-----------------+------------+--------+-------------------+--------------+------------+----------------+---------------+
3 rows in set (0.01 sec)

mysql> SELECT s.student_id, s.name, g.marks_obtained
    -> FROM Students s
    -> INNER JOIN Grades g ON s.student_id = g.student_id
    -> ORDER BY g.marks_obtained DESC
    -> LIMIT 10;
+------------+-----------------+----------------+
| student_id | name            | marks_obtained |
+------------+-----------------+----------------+
|          1 |   Alice Smith   |          95.50 |
|          4 | Diana Prince    |          91.00 |
|          1 |   Alice Smith   |          88.00 |
|          3 | Charlie Brown   |          76.50 |
|          2 | Bob Jones       |          42.00 |
+------------+-----------------+----------------+
5 rows in set (0.00 sec)

mysql> SELECT s.student_id, s.name,
    ->        (COUNT(CASE WHEN a.status = 'Present' THEN 1 END) / COUNT(*)) * 100 AS attendance_percentage
    -> FROM Students s
    -> INNER JOIN Attendance a ON s.student_id = a.student_id
    -> GROUP BY s.student_id, s.name
    -> HAVING attendance_percentage < 75.00;
+------------+-----------------+-----------------------+
| student_id | name            | attendance_percentage |
+------------+-----------------+-----------------------+
|          1 |   Alice Smith   |               66.6667 |
|          2 | Bob Jones       |                0.0000 |
+------------+-----------------+-----------------------+
2 rows in set (0.52 sec)

mysql> SELECT s.student_id, s.name
    -> FROM Students s
    -> INNER JOIN Grades g ON s.student_id = g.student_id
    -> INNER JOIN (
    ->     SELECT student_id, (COUNT(CASE WHEN status = 'Present' THEN 1 END) / COUNT(*)) * 100 AS att_pct
    ->     FROM Attendance GROUP BY student_id
    -> ) att ON s.student_id = att.student_id
    -> WHERE att.att_pct < 50.00 AND g.marks_obtained < 50.00;
+------------+-----------+
| student_id | name      |
+------------+-----------+
|          2 | Bob Jones |
+------------+-----------+
1 row in set (0.01 sec)

mysql> SELECT DISTINCT s.student_id, s.name
    -> FROM Students s
    -> LEFT JOIN Grades g ON s.student_id = g.student_id
    -> LEFT JOIN (
    ->     SELECT student_id, (COUNT(CASE WHEN status = 'Present' THEN 1 END) / COUNT(*)) * 100 AS att_pct
    ->     FROM Attendance GROUP BY student_id
    -> ) att ON s.student_id = att.student_id
    -> WHERE g.marks_obtained > 90.00 OR att.att_pct = 100.00;
+------------+-----------------+
| student_id | name            |
+------------+-----------------+
|          1 |   Alice Smith   |
|          3 | Charlie Brown   |
|          4 | Diana Prince    |
+------------+-----------------+
3 rows in set (0.00 sec)

mysql> SELECT f.* FROM Faculty f
    -> LEFT JOIN Courses c ON f.faculty_id = c.faculty_id
    -> WHERE c.course_id IS NULL;
+------------+----------------------+----------------------+--------------+---------------+------------------+
| faculty_id | name                 | email                | phone_number | department_id | experience_years |
+------------+----------------------+----------------------+--------------+---------------+------------------+
|          3 | Dr. Nikola Tesla     | tesla@university.edu | 3456789012   |             3 |                3 |
|          4 | Unassigned Professor | NULL                 | NULL         |          NULL |                2 |
+------------+----------------------+----------------------+--------------+---------------+------------------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM Students ORDER BY name ASC;
+------------+-----------------+------------+--------+-------------------+--------------+-------------+----------------+---------------+
| student_id | name            | dob        | gender | email             | phone_number | address     | admission_date | department_id |
+------------+-----------------+------------+--------+-------------------+--------------+-------------+----------------+---------------+
|          1 |   Alice Smith   | 2002-05-15 | Female | alice.new@edu.com | 9876543210   | 123 Elm St  | 2021-09-01     |             1 |
|          2 | Bob Jones       | 2001-11-23 | Male   | bob@edu.com       | 9998887772   | 456 Oak St  | 2020-09-01     |             1 |
|          3 | Charlie Brown   | 2002-02-10 | Male   | NULL              | 9998887773   | 789 Pine St | 2022-09-01     |             2 |
|          4 | Diana Prince    | 2003-07-19 | Female | diana@edu.com     | 9998887774   | 101 Sky Ln  | 2023-09-01     |             1 |
|          5 | Evan Wright     | 2001-04-05 | Male   | evan@edu.com      | 9998887775   | 202 Lake Dr | 2021-09-01     |             3 |
+------------+-----------------+------------+--------+-------------------+--------------+-------------+----------------+---------------+
5 rows in set (0.00 sec)

mysql> SELECT d.department_name, COUNT(s.student_id) AS enrolled_students_count
    -> FROM Departments d
    -> LEFT JOIN Students s ON d.department_id = s.department_id
    -> GROUP BY d.department_id, d.department_name;
+------------------------+-------------------------+
| department_name        | enrolled_students_count |
+------------------------+-------------------------+
| Computer Science       |                       3 |
| Mechanical Engineering |                       1 |
| Electrical Engineering |                       1 |
+------------------------+-------------------------+
3 rows in set (0.00 sec)

mysql>
mysql> -- 3. Show the average marks per course
mysql> SELECT c.course_name, AVG(g.marks_obtained) AS average_marks
    -> FROM Courses c
    -> INNER JOIN Grades g ON c.course_id = g.course_id
    -> GROUP BY c.course_id, c.course_name;
+------------------+---------------+
| course_name      | average_marks |
+------------------+---------------+
| Database Systems |     76.166667 |
| Algorithms       |     88.000000 |
| Thermodynamics   |     76.500000 |
+------------------+---------------+
3 rows in set (0.01 sec)

mysql> SELECT AVG(calc.individual_attendance) AS overall_average_attendance
    -> FROM (
    ->     SELECT (COUNT(CASE WHEN status = 'Present' THEN 1 END) / COUNT(*)) * 100 AS individual_attendance
    ->     FROM Attendance GROUP BY student_id
    -> ) calc;
+----------------------------+
| overall_average_attendance |
+----------------------------+
|                66.66667500 |
+----------------------------+
1 row in set (0.00 sec)

mysql>