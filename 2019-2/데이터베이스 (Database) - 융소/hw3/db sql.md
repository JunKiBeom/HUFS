1.
```sql
CREATE TABLE STUDENT(
	Name char(20) not null,
    Student_number int not null,
    Class smallint not null,
    Major char(5),
    PRIMARY KEY(Student_Number)
)ENGINE=InnoDB;
```

```sql
CREATE TABLE COURSE(
	Course_name char(40) not null,
    Course_number char(10) not null,
    Credit_hours int not null,
    Department char(5),
    PRIMARY KEY(Course_number)
)ENGINE=InnoDB;
```

```sql
CREATE TABLE SECTION(
	Section_identifier int not null,
    Course_number char(10) not null,
    Semester char(6) not null,
    Year int not null,
    Instructor char(10) not null,
    PRIMARY KEY(Section_identifier),
    FOREIGN KEY(Course_number) REFERENCES COURSE(Course_number) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;
```

```sql
CREATE TABLE GRADE_REPORT(
	Student_number int not null,
    Section_identifier int not null,
    Crage char(1),
    PRIMARY KEY(Student_number, Section_identifier),
    FOREIGN KEY(Student_number) REFERENCES STUDENT(Student_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Section_identifier) REFERENCES SECTION(Section_identifier) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;
```

```sql
CREATE TABLE PREREQUISITE(
	Course_number char(10) not null,
    Prerequisite_number char(10) not null,
    PRIMARY KEY(Course_number,Prerequisite_number),
    FOREIGN KEY(Course_number) REFERENCES COURSE(Course_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Prerequisite_number) REFERENCES COURSE(Course_number) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;
```
<br>

2.
```sql
INSERT INTO STUDENT VALUES
	('Smith',17,1,'CS'),
    ('Brown',8,2,'CS');
```

```sql
INSERT INTO COURSE VALUES
	('Intro to Computer Science','CS1310',4,'CS'),
    ('Data Structures','CS3320',4,'CS'),
    ('Discrete Mathematics','MATH2410',3,'MATH'),
    ('Database','CS3380',3,'CS');
```

```sql
INSERT INTO SECTION VALUES
	(85,'MATH2410','Fall',07,'King'),
    (92,'CS1310','Fall',07,'Anderson'),
    (102,'CS3320','Spring',08,'Knuth'),
    (112,'MATH2410','Fall',08,'Chang'),
    (119,'CS1310','Fall',08,'Anderson'),
    (135,'CS3380','Fall',08,'Stone');
```

```sql
INSERT INTO GRADE_REPORT VALUES
	(17,112,'B'),
    (17,119,'C'),
    (8,85,'A'),
    (8,92,'A'),
    (8,102,'B'),
    (8,135,'A');
```

```sql
INSERT INTO PREREQUISITE VALUES
	('CS3380','CS3320'),
    ('CS3380','MATH2410'),
    ('CS3320','CS1310');
```
<br>

3.
```sql
Select St.Name
from COURSE C, SECTION Se , GRADE_REPORT GR, STUDENT St
Where C.Course_name='Database' and C.Course_number=Se.Course_number and Se.Section_identifier=GR.Section_identifier and GR.Student_number=St.Student_number;
```
<br>

4.
```sql
insert into GRADE_REPORT values
	(17,85,NULL);
```
```sql
select St.Name
from SECTION Se1, SECTION Se2, GRADE_REPORT Gr, STUDENT St
where Se1.Course_number = Se2.Course_number and Se1.Section_identifier <> Se2.Section_identifier and Gr.Section_identifier = Se1.Section_identifier and Gr.Student_Number = St.Student_Number
group by St.Name, Se1.Course_Number
having count(*) > 1;
```
<br>

5.
```sql
select DISTINCT C2.Course_Name
from COURSE C1, COURSE C2, PREREQUISITE P
where C1.Course_Name = 'Database' and P.Course_Number = C1.Course_Number and C2.Course_Number = P.Prerequisite_Number
union
select DISTINCT C2.Course_Name
from COURSE C1, COURSE C2, PREREQUISITE P1, PREREQUISITE P2, PREREQUISITE P3
where C1.Course_Name = 'Database' and P1.Course_Number = C1.Course_Number and P2.Course_Number = P1.Prerequisite_Number
and P2.Prerequisite_Number = C2.Course_Number;
```
<br>

6.
```sql
select DISTINCT Gr.student_Number, Gr.Section_identifier, Gr.Grade
from COURSE C, SECTION Se, GRADE_REPORT Gr, STUDENT St
where St.Major = C.Department and C.Course_Number = Se.Course_Number and Se.Section_identifier = Gr.Section_identifier;
```
```sql
CREATE TABLE MAJOR_GRADE_REPORT(
	Student_number int not null,
    Section_identifier int not null,
    Grade char(1),
    PRIMARY KEY(Student_number, Section_identifier),
    FOREIGN KEY(Student_number) REFERENCES STUDENT(Student_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Section_identifier) REFERENCES SECTION(Section_identifier) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;
```
```sql
insert into MAJOR_GRADE_REPORT values
    (8,92,'A'),
	(17,119,'C'),
    (8,102,'B'),
    (8,135,'A');
```
<br>

7.
```sql
select St.Major, St.Student_number, St.Name, C.Course_number, C.Course_name, Gr.Grade, Se.Year, Se.Semester
from STUDENT St, GRADE_REPORT Gr, COURSE C,SECTION Se
Where St.Student_number = Gr.Student_number and Gr.Section_identifier = Se.Section_identifier and C.Course_number = Se.Course_number;
```
<br>

8.
```sql
update GRADE_REPORT
set Grade='F'
where Section_identifier = (
	select Se.Section_identifier
    from SECTION Se
    where Se.Course_Number = (
    	select C.Course_Number
        from COURSE C
        where C.Course_Name='Database'
    )
);
```
<br>

9.
```sql
update STUDENT
set Student_Number=9
where Name='Brown';
```

```sql
ALTER TABLE GRADE_REPORT CHANGE Crage Grade Char(1);
```