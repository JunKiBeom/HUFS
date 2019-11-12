**Query 1**: Retrieve the name and address of employees who work for the "Research" department.

```ra
project[fname,lname,address](
  employee
  join
  rename[dname,dno,mgrssn,mgrstartdate](
    select[dname='Research'](department)
  )
);
```
<br>

**Query 2**: For every project located in "Stafford", list the project number, the controlling department number, and the department manager's last name, address, and birth date.
```ra
project[pnumber,dnum,lname,address,bdate](
  employee
  join
  rename[dname,dnum,ssn,mgrstartdate](department)
  join
  select[plocation='Stafford'](projects)
);
```
<br>

**Query 3**: Find the names of employees who work on all the projects controlled by department number 4.
Note that Division operator is NOT supported in RA interpreter

```ra
project[lname,fname](
  (
    employee
    join
    (
      project[ssn](employee)
      minus
      project[ssn](
        (
          (
            project[ssn](employee)
            times
            project[pnumber](
              select[dnum=4](projects)
              )
            )
            minus
            rename[ssn,pnumber](
              project[essn,pno](works_on)
          )
        )
      )
    )
  )
);
```
<br>

**Query 4**: Make a list of project numbers for projects that involve an employee whose last name is "Smith", either as a worker or as a manager of the department that controls the project.

```ra
rename[ssn,pno,hours](works_on)
join
project[ssn](
  select[fname='John' and lname='Smith'](employee)
);
```
<br>

**Query 5**: List the names of all employees with two or more dependents.
Note that aggregation function is NOT supported in RA interpreter

```ra
project[lname,fname](
  (
    rename[ssn](
      project[essn1](
        select[essn1=essn2 and dname1<>dname2](
          (
            rename[essn1,dname1](
              project[essn,dependent_name](dependent)
            )
            times
            rename[essn2,dname2](
              project[essn,dependent_name](dependent)
            )
          )
        )
      )
    )
    join
    employee
  )
);
```
<br>

**Query 6**: Retrieve the names of employees who have no dependents.

```ra
project[lname,fname](
  (
    project[ssn](employee)
    minus
    project[essn](dependent)
  )
  join
  employee
);
```
<br>

**Query 7**: List the names of managers who have at least one dependent.

```ra
project[lname,fname](
  (
    rename[ssn](
      project[mgrssn](department)
    )
    join
    rename[ssn](
      project[essn](dependent)
    )
  )
  join
  employee
);
```
<br>

**Query 8**: Retrieve the names of all employees who do not work on any project number 1.

```ra
project[lname,fname](
  rename[ssn,pno,hours](
    works_on
    minus
    (
      works_on
      join
      project[essn](
        select[pno=1](works_on)
      )
    )
  )
  join
  employee
);
```
<br>

**Query 9**: List the last names of all department managers who have no dependents.

```ra
project[lname,fname](
  (
    rename[ssn](
      project[mgrssn](department)
    )
    minus
    rename[ssn](
      project[essn](dependent)
    )
  )
  join
  employee
);
```
<br>

**Query 10**: Retrieve the names of all employees in department 5 who work more
than 10 hours per week on the ProductX project.

```ra
project[lname,fname](
  rename[pname,pno,ploc,dno](
    select[pname='ProductX'](projects)
  )
  join
  rename[ssn,pno,hours](
    select[hours>=10](works_on)
  )
  join
  select[dno=5](employee)
);
```
<br>

**Query 11**: Find the names and addresses of all employees who work on at least one project located in Houston but whose department has no location in Houston.

```ra
project[lname,fname,address](
  rename[ssn](
    project[essn](
      rename[pname,pno,plocation,dno](
        select[plocation='Houston'](projects)
      )
      join
      works_on
    )
    minus
    project[ssn](
      rename[dno,dlocation](
        select[dlocation='Houston'](dept_locations)
      )
      join
      employee
    )
  )
  join
  employee
);
```