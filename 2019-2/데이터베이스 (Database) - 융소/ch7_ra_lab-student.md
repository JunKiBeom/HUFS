1

```sql
department;
```

2

```sql
project[ssn](employee);
```

3

```sql
project[sex](select [DNO=5](employee));
```

4

```sql
project[fname,lname](select [DNO=5](employee));
```

5

```sql
(
  (project[ssn](select [dno=5](employee)))
  union
  (project[superssn](select [dno=5](employee)))
);
```

6

```sql
project[fname,lname,address](
  employee
  join
  rename[dname,dno,mgrssn,mgrstartdate](
    select[dname='Research'](department))
);
```

```sql
project[fname,lname,address](
  employee
  join
  rename[dno](
    project[dnumber](
      select[dname='Research'](department)))
);
```

7

```sql
(
  project[dname,dnumber](department)
  join
  project[dnumber,dlocation](dept_locations)
);
```

```sql
project[dname, dlocation](department join dept_locations);
```

8

```sql

```

9

```sql

```

10

```sql

```

11

```sql

```

12

```sql

```

13

```sql

```

