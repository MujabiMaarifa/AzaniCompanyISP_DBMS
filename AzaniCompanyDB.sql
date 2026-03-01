-- Create DB
CREATE DATABASE AzaniCompanyDB;
USE AzaniCompanyDB;

-- institution table
CREATE TABLE `Institution` (
  `InstitutionID` int PRIMARY KEY AUTO_INCREMENT,
  `Name` varchar(255),
  `Type` varchar(255),
  `Address` varchar(255),
  `Status` varchar(255),
  `RegistrationDate` date,
  `ContactID` int
);

-- contact person table
CREATE TABLE `ContactPerson` (
  `ContactID` int PRIMARY KEY AUTO_INCREMENT,
  `FullName` varchar(255),
  `Phone` varchar(255),
  `Email` varchar(255)
);

-- subscription service table
CREATE TABLE `Service` (
  `ServiceID` int PRIMARY KEY AUTO_INCREMENT,
  `Bandwidth` varchar(255),
  `MonthlyCost` decimal
);

-- installation table 
CREATE TABLE `Installation` (
  `InstallationID` int PRIMARY KEY AUTO_INCREMENT,
  `InstitutionID` int,
  `InstallationFee` decimal,
  `InstallationDate` date
);

-- company infarstructure purchase table
CREATE TABLE `InfrastructurePurchase` (
  `PurchaseID` int PRIMARY KEY AUTO_INCREMENT,
  `InstitutionID` int,
  `NumberOfPCs` int,
  `PCUnitCost` decimal,
  `LANPackageID` int
);

-- LAN nodes package purchase table
CREATE TABLE `LANPackage` (
  `LANPackageID` int PRIMARY KEY AUTO_INCREMENT,
  `MinNodes` int,
  `MaxNodes` int,
  `Cost` decimal
);

-- upgrade bandwidth service table
CREATE TABLE `Upgrade` (
  `UpgradeID` int PRIMARY KEY AUTO_INCREMENT,
  `InstitutionID` int,
  `OldServiceID` int,
  `NewServiceID` int,
  `UpgradeDate` date,
  `DiscountApplied` decimal
);

-- billing fee for the services table
CREATE TABLE `Billing` (
  `BillID` int PRIMARY KEY AUTO_INCREMENT,
  `InstitutionID` int,
  `ServiceID` int,
  `Month` date,
  `Amount` decimal,
  `Fine` decimal,
  `ReconnectionFee` decimal,
  `TotalAmount` decimal,
  `PaidStatus` varchar(255)
);

-- payment table
CREATE TABLE `Payment` (
  `PaymentID` int PRIMARY KEY AUTO_INCREMENT,
  `InstitutionID` int,
  `BillID` int,
  `PaymentType` varchar(255),
  `Amount` decimal,
  `PaymentDate` date
);

-- disconnection of service table
CREATE TABLE `Disconnection` (
  `DisconnectionID` int PRIMARY KEY AUTO_INCREMENT,
  `InstitutionID` int,
  `DisconnectionDate` date,
  `Reason` varchar(255),
  `ReconnectionDate` date
);

-- FK constraints

ALTER TABLE `Institution` ADD FOREIGN KEY (`ContactID`) REFERENCES `ContactPerson` (`ContactID`);
ALTER TABLE `Installation` ADD FOREIGN KEY (`InstitutionID`) REFERENCES `Institution` (`InstitutionID`);
ALTER TABLE `InfrastructurePurchase` ADD FOREIGN KEY (`InstitutionID`) REFERENCES `Institution` (`InstitutionID`);
ALTER TABLE `InfrastructurePurchase` ADD FOREIGN KEY (`LANPackageID`) REFERENCES `LANPackage` (`LANPackageID`);
ALTER TABLE `Upgrade` ADD FOREIGN KEY (`InstitutionID`) REFERENCES `Institution` (`InstitutionID`);
ALTER TABLE `Upgrade` ADD FOREIGN KEY (`OldServiceID`) REFERENCES `Service` (`ServiceID`);
ALTER TABLE `Upgrade` ADD FOREIGN KEY (`NewServiceID`) REFERENCES `Service` (`ServiceID`);
ALTER TABLE `Billing` ADD FOREIGN KEY (`InstitutionID`) REFERENCES `Institution` (`InstitutionID`);
ALTER TABLE `Billing` ADD FOREIGN KEY (`ServiceID`) REFERENCES `Service` (`ServiceID`);
ALTER TABLE `Payment` ADD FOREIGN KEY (`InstitutionID`) REFERENCES `Institution` (`InstitutionID`);
ALTER TABLE `Payment` ADD FOREIGN KEY (`BillID`) REFERENCES `Billing` (`BillID`);
ALTER TABLE `Disconnection` ADD FOREIGN KEY (`InstitutionID`) REFERENCES `Institution` (`InstitutionID`);

-- inserting sample values / Register contact person and the institution
-- contact person
INSERT INTO ContactPerson(ContactID, FullName, Phone, Email) VALUES (101, 'John Doe', '0712345678', 'johndoe@gmail.com'),(102, 'Mercy Doe', '0787654321', 'mercydoe@gmail.com');

-- Institution
INSERT INTO Institution (Name, Type, Address, Status, RegistrationDate)
VALUES
    ('Tusome School', 'Junior', '123 Nyeri, Nyeri', 'Active', CURDATE(), 101),
    ('Sunrise High School', 'Senior', '45 Nairobi Rd, Nairobi', 'Active', CURDATE(), 102);

-- inserting values into payment table
INSERT INTO Payment (InstitutionID, PaymentType, Amount, PaymentDate)
VALUES
    -- Registration Fees
    (1, 'Registration Fee', 8500, CURDATE()),
    (2, 'Registration Fee', 8500, CURDATE()),
    (3, 'Registration Fee', 8500, CURDATE()),

    -- Installation Fees
    (1, 'Installation Fee', 10000, CURDATE()),
    (2, 'Installation Fee', 10000, CURDATE()),
    (3, 'Installation Fee', 10000, CURDATE()),

    -- Monthly Payments
    (1, 'Monthly Payment', 1200, CURDATE()),
    (2, 'Monthly Payment', 3500, CURDATE()),
    (3, 'Monthly Payment', 7000, CURDATE());

-- Part 1
-- institution and the contact person 
SELECT i.Name AS InstitutionName,
       i.Type,
       i.Address,
       i.Status,
       i.RegistrationDate,
       c.FullName AS ContactName,
       c.Phone,
       c.Email,
FROM Institution i
JOIN ContactPerson c ON i.ContactID = c.ContactID;

-- Part 2
-- Capture payments(registration fees, installation fees, monthly payments)
SELECT * FROM Payment WHERE PaymentType='Registration Fee';
SELECT * FROM Payement WHERE PaymentType='Installation Fee';
SELECT * FROM Payement WHERE PaymentType='Monthly Payment';

-- Part 3
SELECT * FROM Institution;

-- list of defaulters
SELECT i.InstitutionID,
       i.Name AS InstitutionName,
       i.Type,
       i.Address,
       i.Status
FROM Institution i
LEFT JOIN Payment p
       ON i.InstitutionID = p.InstitutionID
       AND p.PaymentType = 'Monthly Payment'
       AND MONTH(p.PaymentDate) = MONTH(CURDATE())
       AND YEAR(p.PaymentDate) = YEAR(CURDATE())
WHERE p.PaymentID IS NULL;

-- institution with disconnection issues
SELECT i.InstitutionID,
       i.Name AS InstitutionName,
       i.Type,
       i.Status,
       d.DisconnectionDate,
       d.Reason
FROM Institution i
JOIN Disconnection d
       ON i.InstitutionID = d.InstitutionID
WHERE d.ReconnectionDate IS NULL;

-- details of infrasctructural requirements for each institution
SELECT i.InstitutionID,
       i.Name AS InstitutionName,
       ip.NumberOfPCs,
       ip.PCUnitCost,
       (ip.NumberOfPCs * ip.PCUnitCost) AS TotalPCCost,
       lp.NumberOfNodes,
       lp.Cost AS LANCost
FROM Institution i
JOIN InfrastructurePurchase ip
       ON i.InstitutionID = ip.InstitutionID
JOIN LANPackage lp
       ON ip.LANPackageID = lp.LANPackageID;

-- Part 4
-- total installation cost for each institution
SELECT i.InstitutionID,
       i.Name AS InstitutionName,
       SUM(p.Amount) AS TotalInstallationCost
FROM Institution i
JOIN Payment p
       ON i.InstitutionID = p.InstitutionID
WHERE p.PaymentType = 'Installation Fee'
GROUP BY i.InstitutionID, i.Name;

-- cost of personal comps, LANs for institutions with assorted services
SELECT i.InstitutionID,
       i.Name AS InstitutionName,
       SUM(ip.NumberOfPCs * ip.PCUnitCost) AS TotalPCCost,
       SUM(lp.Cost) AS TotalLANCost,
       SUM(ip.NumberOfPCs * ip.PCUnitCost + lp.Cost) AS TotalInfraCost
FROM Institution i
JOIN InfrastructurePurchase ip
       ON i.InstitutionID = ip.InstitutionID
JOIN LANPackage lp
       ON ip.LANPackageID = lp.LANPackageID
GROUP BY i.InstitutionID, i.Name;

-- total monthly charges of the upgraded internet services
SELECT i.InstitutionID,
       i.Name AS InstitutionName,
       SUM(s.MonthlyCost - IFNULL(u.DiscountApplied, 0)) AS TotalUpgradedMonthlyCharge
FROM Upgrade u
JOIN Institution i
       ON u.InstitutionID = i.InstitutionID
JOIN Service s
       ON u.NewServiceID = s.ServiceID
GROUP BY i.InstitutionID, i.Name;

-- total monthly services for internet services from each category of the institution
SELECT i.Type AS InstitutionCategory,
       SUM(CASE WHEN p.PaymentType = 'Monthly Fee' THEN p.Amount ELSE 0 END) AS TotalMonthlyPayments,
       SUM(CASE WHEN p.PaymentType = 'Overdue Fine' THEN p.Amount ELSE 0 END) AS TotalOverdueFines,
       SUM(CASE WHEN p.PaymentType = 'Reconnection Fee' THEN p.Amount ELSE 0 END) AS TotalReconnectionFees,
       SUM(p.Amount) AS GrandTotal
FROM Institution i
JOIN Payment p
       ON i.InstitutionID = p.InstitutionID
GROUP BY i.Type;

-- aggregate amount for each service sorted by an institution
SELECT i.InstitutionID,
       i.Name AS InstitutionName,
       p.PaymentType AS ServiceType,
       SUM(p.Amount) AS TotalAmount
FROM Institution i
JOIN Payment p
       ON i.InstitutionID = p.InstitutionID
GROUP BY i.InstitutionID, i.Name, p.PaymentType
ORDER BY i.InstitutionID, p.PaymentType;

