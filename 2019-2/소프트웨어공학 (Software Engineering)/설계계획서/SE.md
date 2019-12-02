```sql
CREATE TABLE User(
    UserID int not null,
    UserName char(20) not null,
    UserEmail char(50) not null,
    PRIMARY KEY(UserID)
)ENGINE=InnoDB;
```

```sql
CREATE TABLE User_Use(
    UseNo int not null,
    UserID int not null,
    kBoardID char(50) not null,
    StartUseTime TIMESTAMP not null,
    EndUseTime TIMESTAMP not null,
    PRIMARY KEY(UseNo, UserID)
)ENGINE=InnoDB;
```
```sql
CREATE TABLE Reservation(
    UseNo int not null,
    UserID int not null,
    kBoardID char(50) not null,
    CompanyID int not null,
    CardNO char(16) not null,
    Charge int not null,
    PRIMARY KEY(UseNo, UserID)
)ENGINE=InnoDB;
```
```sql
CREATE TABLE Company(
    CompanyID int not null,
    CompanyName char(30) not null,
    PRIMARY KEY(CompanyID)
)ENGINE=InnoDB;
```
```sql
CREATE TABLE KBoard(
    UserID int not null,
    kBoardID char(50) not null,
    kCompany int not null,
    kGPSX float,
    kGPSY float,
    kBattery int,
    kAvailDist float,
    PRIMARY KEY(kBoardID, kCompany)
)ENGINE=InnoDB;
```
```sql
ALTER table User_Use add(
FOREIGN KEY(UserID) REFERENCES User(UserID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(kBoardID) REFERENCES KBoard(kBoardID) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY(UseNo) REFERENCES Reservation(UseNo) ON DELETE CASCADE ON UPDATE CASCADE
);
```
```sql
alter table Reservation add(
FOREIGN KEY(UserID) REFERENCES User(UserID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(kBoardID) REFERENCES KBoard(kBoardID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(CompanyID) REFERENCES Company(CompanyID) ON DELETE CASCADE ON UPDATE CASCADE
);
```
```sql
alter table KBoard add(
FOREIGN KEY(UserID) REFERENCES User(UserID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(kCompany) REFERENCES Company(CompanyID) ON DELETE CASCADE ON UPDATE CASCADE
);
```