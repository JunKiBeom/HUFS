```sql
create table Students(
	Fname char(20) not null,
    Lname char(20) not null,
    Class char(12) not null,
    SSN char(10) not null,
    Student_number int not null,
    Sex char(1) not null,
    Bdate date not null,
    Current_Addr char(30),
    Current_Phone char(15),
    Permanent_Addr char(30),
    Permanent_Phone char(15),
    Degree_Program char(8),
    Major_department char(15) not null,
    Minor_department char(15),
    PRIMARY KEY(SSN, Student_number),
    Foreign key(Major_department) REFERENCES Departments(Dname) on delete cascade on update cascade,
    Foreign key(Minor_department) REFERENCES Departments(Dname) on delete cascade on update cascade,
    UNIQUE(SSN, Student_number)
)ENGINE=InnoDB;
```

```sql
create table Departments(
	Dname char(15) not null,
    Dcode char(8) not null,
    Doffice char(15) not null,
    DPhone char(15) not null,
    College char(20) not null,
    Primary Key(Dcode, College),
    Unique(Dname, Dcode)
)Engine=InnoDB;
```

```sql
create table Courses(
	Course_name char(20) not null,
    Description char(200),
    Course_num int not null,
    level char(12),
    Semester_Hour int not null,
    Department char(10),
    Primary Key(Course_num),
    Foreign key(Department) REFERENCES Departments(Dname) on delete cascade on update cascade,
    Unique(Course_num)
)Engine=InnoDB;
```

```sql
create table Sections(
	Instructor char(30) not null,
    Semester char(6) not null,
    Year int not null,
    Course_number int not null,
    Section_number int not null,
    Primary key(Section_number),
    Foreign key(Course_number) REFERENCES Courses(Course_num) on delete cascade on update cascade
)Engine=InnoDB;
```

```sql
create table Grade_reports(
	Student_num int not null,
    Section_num int not null,
    Letter_grade char(1),
    Numeric_grade int,
    Primary key(Student_num, Section_num),
    Foreign key(Section_num) REFERENCES Sections(Section_number) on delete cascade on update cascade
)Engine=InnoDB;
```

```sql
ALTER TABLE `Students`
ADD INDEX `fk_Student_num_idx` (`Student_number` ASC);

ALTER TABLE `Grade_reports`
ADD INDEX `fk_Student_num_idx` (`Student_num` ASC);

alter table Grade_reports
add constraint Foreign key(Student_num) REFERENCES Students(Student_number) on delete cascade on update cascade;
```