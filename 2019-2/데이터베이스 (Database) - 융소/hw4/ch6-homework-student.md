1.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E, PROJECT P, WORKS_ON W
where E.dno=5 and P.pnumber=W.Pno and  P.Pname='ProductX' and W.Hours>10.0 and E.ssn=W.essn;
```
<br>

2.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E
where EXISTS(
	select *
    from DEPENDENT Dp
	where E.ssn=Dp.Essn and E.sex=Dp.sex
);
```
<br>

3.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E
where EXISTS(
	select *
    from EMPLOYEE E2
    where E2.Fname='Franklin' and E2.Lname='Wong' and E.Superssn=E2.ssn
);
```
<br>

4.
```sql
select P.Pname as 'Project name',SUM(W.Hours) as 'Total hours'
from WORKS_ON W, PROJECT P
where P.Pnumber=W.Pno
GROUP BY P.Pname;
```
<br>

5.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E
where NOT EXISTS(
    select *
    from DEPARTMENT D, PROJECT P
    where D.DNUMBER=P.DNUM and D.Dname='Administration'
    and not exists (
    	select *
        from WORKS_ON W
        where W.Essn=E.ssn and W.Pno=P.Pnumber
    )
);
```
<br>

6.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E
where NOT EXISTS(
	select *
    from PROJECT P, WORKS_ON W
    where P.Plocation='Houston' and W.Essn=E.ssn and W.Pno=P.Pnumber
);
```
<br>

7.
```sql
select D.Dname as 'Department name', round(AVG(E.SALARY),2) as 'Average salary'
from DEPARTMENT D, EMPLOYEE E
where D.Dnumber=E.Dno
GROUP BY D.Dname;
```
<br>

8.
```sql
select round(AVG(E.Salary),2) as 'Average salary'
from EMPLOYEE E
where E.sex='F';
```
<br>

9.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name', E.Address
from EMPLOYEE E
where EXISTS(
	select *
    from PROJECT P, WORKS_ON W
    where P.Plocation='Houston' and P.Pnumber=W.Pno and W.Essn=E.ssn and
    NOT EXISTS(
	select *
    from DEPT_LOCATIONS Dp
    where Dp.Dlocation='Houston' and Dp.Dnumber=E.Dno)
);
```
<br>

10.
```sql
select E.Lname as 'Last name'
from EMPLOYEE E, DEPARTMENT D
where EXISTS(
	select *
	where E.ssn=D.Mgrssn and NOT EXISTS(
    	select *
    	from DEPENDENT De
    	where E.ssn=De.Essn
    )
);
```
<br>

11.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E
where not exists(
	select *
    from EMPLOYEE E2
    where E.Dno=E2.Dno and E2.Salary <= ALL(select salary from EMPLOYEE)
);
```
<br>

12-1.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E
where exists(
	select *
    from EMPLOYEE E2
    where E.Superssn=E2.ssn and Exists(
    	select *
        from EMPLOYEE E3
        where E3.Fname='James' and E3.Lname='Borg' and E3.ssn=E2.Superssn
    )
);
```
<br>

12-2.
```sql
select concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E
where exists(
	select *
    from EMPLOYEE E2, EMPLOYEE E3
    where E.Superssn=E2.ssn and E2.Superssn=E3.ssn and E3.Fname='James' and E3.Lname='Borg'
);
```
<br>

13.
```sql
select DISTINCT concat(E.fname,' ',E.Minit,'. ',E.Lname) as 'Employee name'
from EMPLOYEE E, EMPLOYEE E2
where E.Salary > E2.Salary+10000 and E2.Salary <=All (Select Salary from EMPLOYEE);
```
<br>

14.
```sql
CREATE VIEW DEPT_VIEW as 
select dname,fname,minit,lname,salary
from EMPLOYEE E, DEPARTMENT D
where E.ssn=D.Mgrssn;
```
```sql
select * from DEPT_VIEW;
```
<br>

15.
```sql
CREATE View RESEARCH_DEPT_VIEW as
select E.lname as elname, E.minit as eminit, E.fname as efname, S.lname as slname, S.minit as sminit, S.fname as sfname, E.salary as esalary
from EMPLOYEE E, EMPLOYEE S, DEPARTMENT D
where D.Dname='Research' and E.Superssn=S.ssn and D.Dnumber=E.Dno;
```
```sql
select * from RESEARCH_DEPT_VIEW;
```
<br>

16.
```sql
CREATE View PROJECT_VIEW as
select P.Pname as 'pname', D.Dname as 'dname', count(W.essn) as 'num_emps', sum(W.hours) as 'total_hours'
from PROJECT P, DEPARTMENT D, WORKS_ON W
where D.Dnumber=P.Dnum and P.Pnumber=W.Pno
group by P.Pname;
```
```sql
select * from PROJECT_VIEW;
```
<br>

17.
```sql
CREATE View PROJECT_VIEW_GT2 as
select P.Pname as 'pname', D.Dname as 'dname', count(W.essn) as 'num_emps', sum(W.hours) as 'total_hours'
from PROJECT P, DEPARTMENT D, WORKS_ON W
where D.Dnumber=P.Dnum and P.Pnumber=W.Pno
group by P.Pname
having count(W.essn)>2;
```
```sql
select * from PROJECT_VIEW_GT2;
```
<br>

18.
```sql
create table salary_audit(
	ssn char(9) not null,
    before_salary decimal(10,2) not null,
    after_salary decimal(10,2) not null,
    u_datetime datetime not null DEFAULT NOW(),
    PRIMARY KEY(ssn, u_datetime),
    FOREIGN KEY(ssn) REFERENCES EMPLOYEE(ssn) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;
```
```sql
drop table salary_audit;
```
```sql
select * from salary_audit;
```
```sql
delimiter $$
```
```sql
create trigger salary_modify
before update on EMPLOYEE
for each row
BEGIN
	if (NEW.salary <> (select salary from EMPLOYEE where ssn=NEW.ssn))
    then insert into salary_audit values (NEW.ssn, OLD.salary, NEW.salary,now());
    end if;
END;
$$
```
```sql
drop trigger salary_modify;
```
```sql
delimiter ;
```
```sql
update EMPLOYEE set salary = Salary * 2 where dno=5;
```
```sql
select * from salary_audit;
```
<br>