
CREATE DATABASE [SCHDB]

 ON  PRIMARY 
( NAME = 'SCH_data',
FILENAME = 'D:\DataBase\SCHDB2_data.mdf',
SIZE = 8MB,
FILEGROWTH = 5MB)
 LOG ON 
( NAME = 'SCH_lo',
FILENAME = 'D:\DataBase\SCHDB2_log.ldf',
SIZE = 5MB,
FILEGROWTH = 5MB)
 COLLATE Arabic_CI_AI

GO

CREATE TABLE JobTitle
(
id INT IDENTITY(1,1) PRIMARY KEY,
job VARCHAR(100)
);

GO

CREATE TABLE [Degree]
(
id INT IDENTITY(1,1) PRIMARY KEY,
[degree] VARCHAR(100)
);

GO

USE [SCHDB]

CREATE TABLE Staff
(
id INT IDENTITY(1,1) PRIMARY KEY,
[name] VARCHAR(75) NOT NULL,
NID CHAR(14) NOT NULL UNIQUE,
gender BIT NOT NULL DEFAULT 0,
phone CHAR(20) NULL,
jobTitle INT NOT NULL,
birthDate DATE NOT NULL,
email NVARCHAR(75),
[address] VARCHAR(100) NULL,
[degree] int NOT NULL DEFAULT 1,
creatDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
idle BIT NOT NULL DEFAULT 0,
info NVARCHAR(MAX),
CONSTRAINT FK_JobTitle FOREIGN KEY(id) REFERENCES JobTitle(id),
CONSTRAINT FK_[degree] FOREIGN KEY(id) REFERENCES [Degree](id)

);

GO

CREATE TABLE Bus
(
id INT IDENTITY (1,1) PRIMARY KEY,
panelNo VARCHAR(25) NULL,
model NVARCHAR(30) NULL,
[type] VARCHAR(25) NULL,
capacity SMALLINT DEFAULT 0 CHECK(capacity >= 0),
creatDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
idle BIT NOT NULL DEFAULT 0,
);

GO

CREATE TABLE Parent
(
id INT IDENTITY(1,1) PRIMARY KEY,
[name] VARCHAR(75) NOT NULL,
NID CHAR(14) NOT NULL UNIQUE,
gender BIT NOT NULL DEFAULT 0,
phone CHAR(20) NULL,
email NVARCHAR(75) NULL,
info NVARCHAR(MAX) NULL
);

GO

CREATE TABLE [Language]
(
id INT IDENTITY(1,1) PRIMARY KEY,
[language] VARCHAR(50)
);

GO

CREATE TABLE [Level]
(
id INT IDENTITY(1,1) PRIMARY KEY,
[level] VARCHAR(50)
);

GO

CREATE TABLE Stage
(
id INT IDENTITY(1,1) PRIMARY KEY,
stage INT NOT NULL,
[langId] INT NOT NULL,
levelId INT NOT NULL,
CONSTRAINT FK_Lang FOREIGN KEY ([langId]) REFERENCES [Language](id) ON DELETE CASCADE,
CONSTRAINT FK_Level FOREIGN KEY (levelId) REFERENCES [Level](id) ON DELETE CASCADE
);

GO

CREATE TABLE [Subject]
(
id INT IDENTITY(1,1) PRIMARY KEY,
sbjName NVARCHAR(70) NOT NULL,
stgId INT NOT NULL,
clsWorkGradeMax INT NOT NULL,
clsWorkGradeMin INT NOT NULL,
semesterGradeMax INT NOT NULL,
semesterGradeMin INT NOT NULL,
finalGradeMax INT NOT NULL,
finalGradeMin INT NOT NULL,
monthlyGradeMax INT NOT NULL,
monthlyGradeMin INT NOT NULL,
inTotal BIT NOT NULL DEFAULT 0,
CONSTRAINT FK_SubjectStage FOREIGN KEY (stgId) REFERENCES Stage(id)
);

GO

CREATE TABLE [ClassRoom]
(
id INT IDENTITY(1,1) PRIMARY KEY,
classRoomNum int NOT NULL,
stgId int NOT NULL,
[year] INT NOT NULL DEFAULT YEAR(GETDATE()),
CONSTRAINT FK_ClassRoomStage FOREIGN KEY (stgId) REFERENCES Stage(id)
);

GO

CREATE TABLE [Status]
(
id INT IDENTITY(1,1) PRIMARY KEY,
[status] VARCHAR(30) NOT NULL,
);

GO

CREATE TABLE Student
(
id INT IDENTITY(1,1) PRIMARY KEY,
[name] VARCHAR(75) NOT NULL,
NID CHAR(14) NOT NULL UNIQUE,
gender BIT NOT NULL DEFAULT 0,
mobile CHAR(11) NULL UNIQUE,
birthDate DATE NOT NULL,
email NVARCHAR(75) NULL,
station VARCHAR(50) NULL,
[address] VARCHAR(100) NOT NULL,
busId INT NULL,
clsRoomId INT NOT NULL,
creatDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
info NVARCHAR(MAX) NULL,
idle BIT NOT NULL DEFAULT 0, -- ???? - ?????
[status] INT NOT NULL DEFAULT 0,-- ???? - ????? - ????
CONSTRAINT FK_BusId FOREIGN KEY (busId) REFERENCES Bus(id),
CONSTRAINT FK_Status FOREIGN KEY ([status]) REFERENCES [Status](id),
CONSTRAINT FK_ClassRoomId FOREIGN KEY (clsRoomId) REFERENCES [ClassRoom](id)
);

GO

CREATE TABLE RegParent
(
prtId INT NOT NULL,
stuId INT NOT NULL,
relation CHAR(20) NOT NULL,
CONSTRAINT FK_PrtId FOREIGN KEY (prtId) REFERENCES Parent(id) ON DELETE CASCADE,
CONSTRAINT FK_StuId FOREIGN KEY (stuId) REFERENCES Student(id) ON DELETE CASCADE,
CONSTRAINT PK_RegParent PRIMARY KEY(prtId,stuId)
);

GO

CREATE TABLE Itinerary
(
id INT IDENTITY(1,1) PRIMARY KEY,
title VARCHAR(30) NOT NULL,
);

GO

CREATE TABLE RegStation
(
itnId INT NOT NULL,
station VARCHAR(30) NOT NULL,
CONSTRAINT FK_itnStn FOREIGN KEY (itnId) REFERENCES Itinerary(id) ON DELETE CASCADE,
CONSTRAINT PK_RegStation PRIMARY KEY(itnId,station)
);

GO

CREATE TABLE RegSupervisor
(
spuId INT NOT NULL,
busId INT NOT NULL,
CONSTRAINT FK_Supervisor FOREIGN KEY (spuId) REFERENCES Staff(id) ON DELETE CASCADE,
CONSTRAINT FK_BusSpu FOREIGN KEY (busId) REFERENCES Bus(id) ON DELETE CASCADE,
CONSTRAINT PK_RegSupervisor PRIMARY KEY(spuId,busId)
);

GO

CREATE TABLE RegDriver
(
drvId INT NOT NULL,
busId INT NOT NULL,
itnId INT NOT NULL,
CONSTRAINT FK_Driver FOREIGN KEY (drvId) REFERENCES Staff(id) ON DELETE CASCADE,
CONSTRAINT FK_BusDrv FOREIGN KEY (busId) REFERENCES Bus(id) ON DELETE CASCADE,
CONSTRAINT FK_itnDrv FOREIGN KEY (itnId) REFERENCES Itinerary(id) ON DELETE CASCADE,
CONSTRAINT PK_RegDriver PRIMARY KEY(drvId,busId,itnId)
);

GO

CREATE TABLE RegSubject
(
sbjId INT NOT NULL,
stfId INT NOT NULL,
CONSTRAINT FK_SbjId FOREIGN KEY (sbjId) REFERENCES [Subject](id) ON DELETE CASCADE,
CONSTRAINT FK_StfIdSbj FOREIGN KEY (stfId) REFERENCES Staff(id) ON DELETE CASCADE,
CONSTRAINT PK_RegSubject PRIMARY KEY(sbjId,stfId)
);

GO

CREATE TABLE RegClassRoom
(
clsRoomId INT NOT NULL,
stfId INT NOT NULL,
CONSTRAINT FK_ClsRoomIdReg FOREIGN KEY (clsRoomId) REFERENCES [ClassRoom](id) ON DELETE CASCADE,
CONSTRAINT FK_StfIdCls FOREIGN KEY (stfId) REFERENCES Staff(id) ON DELETE CASCADE,
CONSTRAINT PK_RegClassRoom PRIMARY KEY(clsRoomId,stfId)
);

GO
CREATE TABLE RegBus
(
itnId INT NOT NULL,
busId INT NOT NULL,
CONSTRAINT FK_Itinerary FOREIGN KEY (itnId) REFERENCES Itinerary(id) ON DELETE CASCADE,
CONSTRAINT FK_BusInt FOREIGN KEY (busId) REFERENCES Bus(id) ON DELETE CASCADE,
CONSTRAINT PK_RegBus PRIMARY KEY(itnId,busId)
);

GO

CREATE TABLE Grade
(
stuId INT NOT NULL,
sbjId INT NOT NULL,
[year] INT NOT NULL DEFAULT YEAR(GETDATE()),
[month] INT NOT NULL DEFAULT MONTH(GETDATE()),
clsWorkGrade INT NOT NULL,
semesterGrade INT NOT NULL,
finalGrade INT NOT NULL,
CONSTRAINT FK_SubjectGrade FOREIGN KEY (sbjId) REFERENCES [Subject](id),
CONSTRAINT FK_StudentGrade FOREIGN KEY (stuId) REFERENCES Student(id) ON DELETE CASCADE,
CONSTRAINT PK_Grade PRIMARY KEY(stuId,sbjId)
);

GO

CREATE TABLE MonthlyGrade
(
stuId INT NOT NULL,
sbjId INT NOT NULL,
Grade INT NOT NULL,
[year] INT NOT NULL DEFAULT YEAR(GETDATE()),
[month] INT NOT NULL DEFAULT MONTH(GETDATE()),
CONSTRAINT FK_SubjectMGrade FOREIGN KEY (sbjId) REFERENCES [Subject](id),
CONSTRAINT FK_StudentMGrade FOREIGN KEY (stuId) REFERENCES Student(id) ON DELETE CASCADE,
CONSTRAINT PK_MonthlyGrade PRIMARY KEY(stuId,sbjId)
);

GO

CREATE TABLE [Agent]
(
id INT PRIMARY KEY,
usrID NCHAR(10) UNIQUE NOT NULL,
[password] NVARCHAR(30) NOT NULL,
creatDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
idle BIT NOT NULL DEFAULT 0,
CONSTRAINT FK_StfIdAgn FOREIGN KEY (id) REFERENCES Staff(id) ON DELETE CASCADE,
);

GO

CREATE TABLE StageFee
(
id INT IDENTITY(1,1) PRIMARY KEY,
band VARCHAR(50) NOT NULL,
fee MONEY NOT NULL,
[year] INT NOT NULL DEFAULT YEAR(GETDATE()),
stgId INT NOT NULL,
CONSTRAINT FK_stgFee FOREIGN KEY (stgId) REFERENCES Stage(id)
);

GO

CREATE TABLE StudentBuy
(
id INT IDENTITY(1,1) PRIMARY KEY,
stuId INT NOT NULL,
stfId INT NOT NULL,
feeId INT NOT NULL,
[month] INT NOT NULL DEFAULT MONTH(GETDATE()),
[year] INT NOT NULL DEFAULT YEAR(GETDATE()),
creatDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
buyment MONEY NOT NULL DEFAULT 0,
CONSTRAINT FK_stdBuy FOREIGN KEY (stuId) REFERENCES Student(id),
CONSTRAINT FK_StfId FOREIGN KEY (stfId) REFERENCES Staff(id),
CONSTRAINT FK_FeeId FOREIGN KEY (feeId) REFERENCES StageFee(id)
);

GO

CREATE TABLE StaffSalary
(
band VARCHAR(50) NOT NULL DEFAULT 'All',
stfDegree INT NOT NULL DEFAULT 0,
stfJobTitle char(20) NOT NULL DEFAULT 'All',
stfId INT NOT NULL DEFAULT 0,
creatDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
salary MONEY NOT NULL,
CONSTRAINT FK_StfIdSlry FOREIGN KEY (stfId) REFERENCES Staff(id),
CONSTRAINT FK_JobTitle FOREIGN KEY(id) REFERENCES JobTitle(id),

CONSTRAINT PK_StaffSalary PRIMARY KEY(band,stfDegree,stfJobTitle,stfId)
);

GO

CREATE TABLE StaffDeduction
(
id INT IDENTITY(1,1) PRIMARY KEY,
stfId INT NOT NULL,
band  VARCHAR(50) NOT NULL,
[month] INT NOT NULL DEFAULT MONTH(GETDATE()),
[year] INT NOT NULL DEFAULT YEAR(GETDATE()),
deduction MONEY NOT NULL DEFAULT 0,
CONSTRAINT FK_StfDdu FOREIGN KEY (stfId) REFERENCES Staff(id)
);

GO

CREATE TABLE [Session]
(
sesNum INT NOT NULL CHECK(sesNum>0),
stfId INT NOT NULL,
clsRoomId INT NOT NULL,
sbjId INT NOT NULL,
CONSTRAINT FK_SbjIdSes FOREIGN KEY (sbjId) REFERENCES [Subject](id),
CONSTRAINT FK_ClsRoomIdSes FOREIGN KEY (clsRoomId) REFERENCES [ClassRoom](id),
CONSTRAINT FK_StfSes FOREIGN KEY (stfId) REFERENCES Staff(id),
CONSTRAINT PK_Session PRIMARY KEY(sesNum,stfId,clsRoomId,sbjId)
);

GO