CREATE TABLE IF NOT EXISTS `bcc_banks` (
  `ID` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  `X` decimal(15, 2) NOT NULL,
  `Y` decimal(15, 2) NOT NULL,
  `Z` decimal(15, 2) NOT NULL,
  `H` decimal(15, 2) NOT NULL,
  `Blip` bigint DEFAULT -2128054417,
  `OpenHour` int UNSIGNED NULL,
  `CloseHour` int UNSIGNED NULL,
  PRIMARY KEY (`ID`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bcc_bank_accounts` (
  `ID` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  `BankID` bigint UNSIGNED NOT NULL,
  `OwnerID` int NOT NULL,
  `cash` double (15,2) default 0.0,
  `gold` double (15, 2) default 0.0,
  `locked` tinyint default 0,
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_Bank` FOREIGN KEY (`BankID`) REFERENCES `bcc_banks` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Owner` FOREIGN KEY (`OwnerID`) REFERENCES `characters` (`charidentifier`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bcc_accounts_allowed_access` (
  `ID` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `AccountID` bigint UNSIGNED NOT NULL,
  `CharID` int NOT NULL,
  `level` int UNSIGNED default 2,
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_ba_Character` FOREIGN KEY (`CharID`) REFERENCES `characters` (`charidentifier`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ba_Account` FOREIGN KEY (`AccountID`) REFERENCES `bcc_bank_accounts` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bcc_saftey_deposit_boxes` (
  `ID` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `BankID` bigint UNSIGNED NOT NULL,
  `OwnerID` int NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_sdb_Bank` FOREIGN KEY (`BankID`) REFERENCES `bcc_banks` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_sdb_Owner` FOREIGN KEY (`OwnerID`) REFERENCES `characters` (`charidentifier`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample Query to get all accounts you have access to
-- SELECT * FROM `bcc_bank_accounts` INNER JOIN `bcc_accounts_allowed_access` ON `bcc_bank_accounts`.ID = `bcc_accounts_allowed_access`.`AccountID` WHERE `bcc_accounts_allowed_access`.`CharID` = 2;

-- Seed DB
-- INSERT INTO `bcc_banks` (`Name`, `X`, `Y`, `Z`, `H`, Blip) VALUES ('Valentine', -308.16, 773.77, 118.70, 1.31, -2128054417);
-- INSERT INTO `bcc_banks` (`Name`, `X`, `Y`, `Z`, `H`) VALUES ('Blackwater ', 813.18, -1275.42, 42.64, 176.86);
-- INSERT INTO `bcc_banks` (`Name`, `X`, `Y`, `Z`, `H`) VALUES ('SaintDenis', 2645.12, -1294.37, 51.25, 30.64);
-- INSERT INTO `bcc_banks` (`Name`, `X`, `Y`, `Z`, `H`) VALUES ('Rhodes', 1292.84, -1304.74, 76.04, 327.08);