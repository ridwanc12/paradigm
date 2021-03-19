CREATE TABLE `id12866202_paradigm`.`accounts` ( 
	`userID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT , 
	`email` VARCHAR(50) NOT NULL , 
	`hashPass` VARCHAR(80) NOT NULL , 
	`firstName` VARCHAR(30) NOT NULL , 
	`lastName` VARCHAR(30) NOT NULL , 
	`lastEntry` DATE NOT NULL 
	PRIMARY KEY (`userID`))
	ENGINE = InnoDB;
	
	ALTER TABLE `accounts` CHANGE `lastEntry` `lastEntry` 
	DATE NULL DEFAULT NULL;
	
	ALTER TABLE `accounts` ADD `verifyHash` VARCHAR(100) 
	NOT NULL AFTER `lastEntry`;
	
	ALTER TABLE `accounts` ADD `verified` TINYINT 
	NOT NULL DEFAULT '0' AFTER `lastEntry`;
	

CREATE TABLE `id12866202_paradigm`.`journals` ( 
	`jourID` INT NOT NULL AUTO_INCREMENT , 
	`userID` INT NOT NULL , 
	`entry` VARCHAR(250) NOT NULL , 
	`created` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP , 
	`hidden` TINYINT NOT NULL DEFAULT '1' , 
	`sentScore` INT NOT NULL , 
	`rating` INT NOT NULL , 
	`lastEdited` DATE on update CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , 
	`topics` VARCHAR NOT NULL , 
	PRIMARY KEY (`jourID`)) 
	ENGINE = InnoDB;
	
	ALTER TABLE `journals` ADD `sentiment` VARCHAR(64) 
	NOT NULL AFTER `hidden`;
	
	ALTER TABLE `journals` CHANGE `sentScore` `sentScore` DOUBLE(8) 
	NOT NULL;
	
	ALTER TABLE `journals` ADD `positive` DOUBLE NOT NULL AFTER `hidden`, ADD `negative` DOUBLE NOT NULL AFTER `positive`, ADD `mixed` DOUBLE NOT NULL AFTER `negative`, ADD `neutral` DOUBLE NOT NULL AFTER `mixed`;