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
