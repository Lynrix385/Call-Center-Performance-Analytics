/* =========================================================
   CALL CENTER LAB - FULL SETUP
   Database + Schema + Seed + Indexes
========================================================= */

USE master;
GO

/* =========================
   1. DROP IF EXISTS
========================= */
IF DB_ID('CallCenterPro') IS NOT NULL
BEGIN
    ALTER DATABASE CallCenterPro SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CallCenterPro;
END
GO

/* =========================
   2. CREATE DATABASE
========================= */
CREATE DATABASE CallCenterPro;
GO

USE CallCenterPro;
GO

/* =========================
   3. TABLES
========================= */

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100),
    Country VARCHAR(50),
    CustomerType VARCHAR(20),
    SignupDate DATE
);
GO

CREATE TABLE Agents (
    AgentID INT IDENTITY(1,1) PRIMARY KEY,
    AgentName VARCHAR(50),
    Team VARCHAR(50),
    HireDate DATE
);
GO

CREATE TABLE Calls (
    CallID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    AgentID INT,
    CallDate DATETIME,
    CallType VARCHAR(50),
    CallDurationSec INT,
    WaitTimeSec INT,
    ResolutionStatus VARCHAR(20),
    SatisfactionScore INT,
    Channel VARCHAR(20),

    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);
GO

CREATE TABLE CallTransfers (
    TransferID INT IDENTITY(1,1) PRIMARY KEY,
    CallID INT,
    FromTeam VARCHAR(50),
    ToTeam VARCHAR(50),
    TransferReason VARCHAR(100),

    FOREIGN KEY (CallID) REFERENCES Calls(CallID)
);
GO

/* =========================
   4. SEED - CUSTOMERS (200)
========================= */
WITH N AS (
    SELECT TOP (200)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO Customers (FullName, Country, CustomerType, SignupDate)
SELECT
    CONCAT('Customer ', n),
    CASE n % 4
        WHEN 0 THEN 'Germany'
        WHEN 1 THEN 'Croatia'
        WHEN 2 THEN 'Austria'
        ELSE 'Italy'
    END,
    CASE n % 3
        WHEN 0 THEN 'New'
        WHEN 1 THEN 'Returning'
        ELSE 'VIP'
    END,
    DATEADD(DAY, -n, GETDATE())
FROM N;
GO

/* =========================
   5. SEED - AGENTS (10)
========================= */
INSERT INTO Agents (AgentName, Team, HireDate)
VALUES
('Ana', 'Support', '2023-01-10'),
('Marko', 'Sales', '2022-11-05'),
('Ivan', 'Support', '2023-03-15'),
('Petra', 'Retention', '2023-02-01'),
('Luka', 'Sales', '2022-09-20'),
('Sara', 'Support', '2023-04-10'),
('Toni', 'Retention', '2022-12-12'),
('Ivana', 'Support', '2023-05-01'),
('Dario', 'Sales', '2023-01-25'),
('Mia', 'Support', '2023-06-01');
GO

/* =========================
   6. SEED - CALLS (1000)
========================= */
WITH N AS (
    SELECT TOP (1000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO Calls (
    CustomerID,
    AgentID,
    CallDate,
    CallType,
    CallDurationSec,
    WaitTimeSec,
    ResolutionStatus,
    SatisfactionScore,
    Channel
)
SELECT
    (ABS(CHECKSUM(NEWID())) % 200) + 1,
    (ABS(CHECKSUM(NEWID())) % 10) + 1,
    DATEADD(MINUTE, -n * 5, GETDATE()),

    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'Billing'
        WHEN 1 THEN 'Technical'
        WHEN 2 THEN 'Complaint'
        ELSE 'Info'
    END,

    30 + (ABS(CHECKSUM(NEWID())) % 600),
    5 + (ABS(CHECKSUM(NEWID())) % 120),

    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'Resolved'
        WHEN 1 THEN 'Pending'
        ELSE 'Escalated'
    END,

    1 + (ABS(CHECKSUM(NEWID())) % 5),

    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'Phone'
        WHEN 1 THEN 'Chat'
        ELSE 'Email'
    END
FROM N;
GO

/* =========================
   7. SEED - TRANSFERS (200)
========================= */
INSERT INTO CallTransfers (CallID, FromTeam, ToTeam, TransferReason)
SELECT TOP (200)
    CallID,
    'Support',
    'Retention',
    'Escalation / customer complaint'
FROM Calls
WHERE ResolutionStatus = 'Escalated';
GO

/* =========================
   8. INDEXES
========================= */

CREATE INDEX IX_Calls_Date ON Calls(CallDate);
CREATE INDEX IX_Calls_Customer ON Calls(CustomerID);
CREATE INDEX IX_Calls_Agent ON Calls(AgentID);
CREATE INDEX IX_Calls_Status ON Calls(ResolutionStatus);
CREATE INDEX IX_Calls_Channel ON Calls(Channel);
GO

PRINT 'CallCenterPro FULL setup completed successfully';
GO
UPDATE Calls
SET CallDate = DATEADD(MINUTE, -(CallID * 525), GETDATE());