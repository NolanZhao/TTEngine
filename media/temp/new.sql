-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.35 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             8.0.0.4396
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table ttmgrportal.account_account
DROP TABLE IF EXISTS `account_account`;
CREATE TABLE `account_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `szse` varchar(30) DEFAULT NULL,
  `sse` varchar(30) DEFAULT NULL,
  `password` varchar(100) NOT NULL,
  `splited` tinyint(1) NOT NULL,
  `left_sub_count` int(11) NOT NULL,
  `fund_proportion` int(11) DEFAULT NULL,
  `platform_id` int(11) DEFAULT NULL,
  `broker_id` varchar(32) DEFAULT NULL,
  `idcLine_id` int(11) DEFAULT NULL,
  `types` int(11) DEFAULT NULL,
  `api_type` varchar(32) DEFAULT 'CTP' COMMENT ' API',
  `bank_no` varchar(64) DEFAULT NULL,
  `SH_account` varchar(64) DEFAULT NULL,
  `SZ_account` varchar(64) DEFAULT NULL,
  `stk_type` int(11) DEFAULT '49',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `account_account_b6620684` (`project_id`) USING BTREE,
  KEY `account_account_d1a43793` (`platform_id`) USING BTREE,
  KEY `account_account_ebe0f661` (`idcLine_id`) USING BTREE,
  CONSTRAINT `account_account_ibfk_1` FOREIGN KEY (`idcLine_id`) REFERENCES `tradeplatform_idcline` (`id`),
  CONSTRAINT `account_account_ibfk_2` FOREIGN KEY (`platform_id`) REFERENCES `tradeplatform_platform` (`id`),
  CONSTRAINT `account_account_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1470 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table ttmgrportal.account_account: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_account` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_account_servers
DROP TABLE IF EXISTS `account_account_servers`;
CREATE TABLE `account_account_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `serverline_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_id` (`account_id`,`serverline_id`),
  KEY `account_account_servers_6f2fe10e` (`account_id`),
  KEY `account_account_servers_a552e003` (`serverline_id`),
  CONSTRAINT `account_id_refs_id_4b7d5912` FOREIGN KEY (`account_id`) REFERENCES `account_account` (`id`),
  CONSTRAINT `serverline_id_refs_id_de79a7b1` FOREIGN KEY (`serverline_id`) REFERENCES `tradeplatform_serverline` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_account_servers: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_account_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_account_servers` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_bankfinancialnet
DROP TABLE IF EXISTS `account_bankfinancialnet`;
CREATE TABLE `account_bankfinancialnet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `otherInterestsSum` double DEFAULT NULL,
  `timeStamp` double DEFAULT NULL,
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_bankfinancialnet_6f2fe10e` (`account_id`),
  CONSTRAINT `account_id_refs_id_55f4e8e7` FOREIGN KEY (`account_id`) REFERENCES `account_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_bankfinancialnet: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_bankfinancialnet` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_bankfinancialnet` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_bsonrisk
DROP TABLE IF EXISTS `account_bsonrisk`;
CREATE TABLE `account_bsonrisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_account_id` int(11) NOT NULL,
  `content` longtext,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_bsonrisk_742c8213` (`sub_account_id`),
  CONSTRAINT `sub_account_id_refs_id_49c9dbe1` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

alter table account_bsonrisk add column `type` int(11) NULL;

-- Dumping data for table ttmgrportal.account_bsonrisk: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_bsonrisk` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_bsonrisk` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_compliancechecks
DROP TABLE IF EXISTS `account_compliancechecks`;
CREATE TABLE `account_compliancechecks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_account_id` int(11) NOT NULL,
  `bValid` tinyint(1) NOT NULL,
  `code` varchar(10) NOT NULL,
  `maxOpen` int(11) DEFAULT NULL,
  `alarmOpen` int(11) DEFAULT NULL,
  `maxCancel` int(11) DEFAULT NULL,
  `alarmCancel` int(11) DEFAULT NULL,
  `maxHold` int(11) DEFAULT NULL,
  `alarmHold` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_compliancechecks_8bd37ded` (`sub_account_id`),
  KEY `account_compliancechecks_65da3d2c` (`code`),
  CONSTRAINT `sub_account_id_refs_id_57429962` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1748 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_compliancechecks: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_compliancechecks` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_compliancechecks` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_depositpercent
DROP TABLE IF EXISTS `account_depositpercent`;
CREATE TABLE `account_depositpercent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_account_id` int(11) NOT NULL,
  `max_net_value` double DEFAULT NULL,
  `value` double DEFAULT NULL,
  `denominator` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_depositpercent_742c8213` (`sub_account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_depositpercent: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_depositpercent` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_depositpercent` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_futuresinterest
DROP TABLE IF EXISTS `account_futuresinterest`;
CREATE TABLE `account_futuresinterest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `value` double DEFAULT NULL,
  `timeStamp` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_futuresinterest_6f2fe10e` (`account_id`),
  CONSTRAINT `account_id_refs_id_75f49f64` FOREIGN KEY (`account_id`) REFERENCES `account_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_futuresinterest: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_futuresinterest` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_futuresinterest` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_hedgingcombination
DROP TABLE IF EXISTS `account_hedgingcombination`;
CREATE TABLE `account_hedgingcombination` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_id` int(11) NOT NULL,
  `code1` varchar(15) NOT NULL,
  `code2` varchar(15) NOT NULL,
  `restriction` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_hedgingcombination_ea3525ab` (`sub_id`),
  KEY `account_hedgingcombination_e4765fa` (`code1`),
  KEY `account_hedgingcombination_e3823b7` (`code2`),
  CONSTRAINT `sub_id_refs_id_16151c97` FOREIGN KEY (`sub_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_hedgingcombination: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_hedgingcombination` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_hedgingcombination` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_initialassets
DROP TABLE IF EXISTS `account_initialassets`;
CREATE TABLE `account_initialassets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `value` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_initialassets_6f2fe10e` (`account_id`),
  CONSTRAINT `account_id_refs_id_35304879` FOREIGN KEY (`account_id`) REFERENCES `account_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_initialassets: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_initialassets` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_initialassets` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_stock
DROP TABLE IF EXISTS `account_stock`;
CREATE TABLE `account_stock` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `stockCode` varchar(6) DEFAULT NULL,
  `stockMarket` varchar(20) DEFAULT NULL,
  `stockName` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9966 DEFAULT CHARSET=utf8;
/*!40000 ALTER TABLE `account_stock` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_stockcategory
DROP TABLE IF EXISTS `account_stockcategory`;
CREATE TABLE `account_stockcategory` (
  `categoryType` int(2) DEFAULT '0',
  `categoryName` varchar(20) DEFAULT NULL,
  `isSys` int(2) NOT NULL DEFAULT '0',
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_stockcategory: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_stockcategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_stockcategory` ENABLE KEYS */;

DROP TABLE IF EXISTS `account_stockcategoryitem`;
CREATE TABLE `account_stockcategoryitem` (
  `id`               BIGINT(20)  NOT NULL AUTO_INCREMENT,
  `stockMarket`      VARCHAR(20) DEFAULT NULL,
  `stockCode`        VARCHAR(20) NOT NULL,
  `stockCategory_id` BIGINT(20)  NOT NULL,
  `stockName`        VARCHAR(20) DEFAULT '',
  `is_sys`           SMALLINT(6) DEFAULT NULL,
  `marketName`       VARCHAR(20) NULL,
  `strProductId`     VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_stockcategory_fk` (`stockCategory_id`),
  CONSTRAINT `account_stockcategory_fk` FOREIGN KEY (`stockCategory_id`) REFERENCES `account_stockcategory` (`id`)
)
  ENGINE =InnoDB
  AUTO_INCREMENT =10067548
  DEFAULT CHARSET =utf8;


-- Dumping structure for table ttmgrportal.account_stopearnrules
DROP TABLE IF EXISTS `account_stopearnrules`;
CREATE TABLE `account_stopearnrules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `sub_account_id` int(11) NOT NULL,
  `contract_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `order_type` int(11) DEFAULT NULL,
  `price_type` int(11) DEFAULT NULL,
  `super_price_type` int(11) DEFAULT NULL,
  `super_price_rate` double DEFAULT NULL,
  `super_price_value` double DEFAULT NULL,
  `volume_type` int(11) DEFAULT NULL,
  `volume_rate` double DEFAULT NULL,
  `order_interval` double DEFAULT NULL,
  `cancel_interval` double DEFAULT NULL,
  `min_end` double DEFAULT NULL,
  `super_valent` int(11) DEFAULT NULL,
  `single_max` int(11) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `stopearn_usable` tinyint(1) NOT NULL DEFAULT '0',
  `stopearn_previous` tinyint(1) NOT NULL,
  `stopearn_value` double DEFAULT NULL,
  `min_end_types` int(11) DEFAULT NULL,
  `min_end_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_stoplossrules_6f2fe10e` (`account_id`),
  KEY `account_stoplossrules_742c8213` (`sub_account_id`),
  CONSTRAINT `account_stopearnrules_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account_account` (`id`),
  CONSTRAINT `account_stopearnrules_ibfk_2` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_stopearnrules: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_stopearnrules` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_stopearnrules` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_stoploss
DROP TABLE IF EXISTS `account_stoploss`;
CREATE TABLE `account_stoploss` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_account_id` int(11) NOT NULL,
  `bValid` tinyint(1) NOT NULL,
  `code` varchar(15) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `lprice` double DEFAULT NULL,
  `stopLossValue` double NOT NULL,
  `orderType` varchar(1) NOT NULL,
  `orderNum` int(11) NOT NULL,
  `orderPrice` double NOT NULL,
  `orderInterval` double NOT NULL,
  `cancelInterval` double NOT NULL,
  `firstPer` double NOT NULL,
  `firstCancelInterval` double NOT NULL,
  `bStopLossPrevious` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_stoploss_8bd37ded` (`sub_account_id`),
  KEY `account_stoploss_65da3d2c` (`code`),
  CONSTRAINT `sub_account_id_refs_id_f48a69c5` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1634 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_stoploss: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_stoploss` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_stoploss` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_stoplossrules
DROP TABLE IF EXISTS `account_stoplossrules`;
CREATE TABLE `account_stoplossrules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `sub_account_id` int(11) NOT NULL,
  `contract_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `order_type` int(11) DEFAULT NULL,
  `price_type` int(11) DEFAULT NULL,
  `super_price_type` int(11) DEFAULT NULL,
  `super_price_rate` double DEFAULT NULL,
  `super_price_value` double DEFAULT NULL,
  `volume_type` int(11) DEFAULT NULL,
  `volume_rate` double DEFAULT NULL,
  `order_interval` double DEFAULT NULL,
  `cancel_interval` double DEFAULT NULL,
  `min_end` double DEFAULT NULL,
  `super_valent` int(11) DEFAULT NULL,
  `single_max` int(11) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `stoploss_usable` tinyint(1) NOT NULL DEFAULT '0',
  `stoploss_previous` tinyint(1) NOT NULL,
  `stoploss_value` double DEFAULT NULL,
  `min_end_types` int(11) DEFAULT NULL,
  `min_end_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_stoplossrules_6f2fe10e` (`account_id`),
  KEY `account_stoplossrules_742c8213` (`sub_account_id`),
  CONSTRAINT `account_id_refs_id_752a131e` FOREIGN KEY (`account_id`) REFERENCES `account_account` (`id`),
  CONSTRAINT `sub_account_id_refs_id_4dd2c8e3` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_stoplossrules: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_stoplossrules` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_stoplossrules` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_stoplossstockrules
DROP TABLE IF EXISTS `account_stoplossstockrules`;
CREATE TABLE `account_stoplossstockrules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `sub_account_id` int(11) NOT NULL,
  `contract_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `order_type` int(11) DEFAULT NULL,
  `price_type` int(11) DEFAULT NULL,
  `super_price_type` int(11) DEFAULT NULL,
  `super_price_rate` double DEFAULT NULL,
  `super_price_value` double DEFAULT NULL,
  `volume_type` int(11) DEFAULT NULL,
  `volume_rate` double DEFAULT NULL,
  `order_interval` double DEFAULT NULL,
  `cancel_interval` double DEFAULT NULL,
  `min_end` double DEFAULT NULL,
  `super_valent` int(11) DEFAULT NULL,
  `single_max` int(11) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `stoploss_usable` tinyint(1) NOT NULL DEFAULT '0',
  `stoploss_previous` tinyint(1) NOT NULL,
  `stoploss_value` double DEFAULT NULL,
  `min_end_types` int(11) DEFAULT NULL,
  `min_end_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_stoplossrules_6f2fe10e` (`account_id`),
  KEY `account_stoplossrules_742c8213` (`sub_account_id`),
  CONSTRAINT `account_stoplossstockrules_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account_account` (`id`),
  CONSTRAINT `account_stoplossstockrules_ibfk_2` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_stoplossstockrules: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_stoplossstockrules` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_stoplossstockrules` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_subaccount
DROP TABLE IF EXISTS `account_subaccount`;
CREATE TABLE `account_subaccount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `parent_account_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `fund_proportion` double DEFAULT NULL,
  `pre_balance` decimal(65,2) DEFAULT NULL,
  `nickname` varchar(50) DEFAULT NULL,
  `depositcash_per` double DEFAULT NULL,
  `deposit_denominator` smallint(6) DEFAULT NULL,
  `initialassets` double DEFAULT NULL,
  `otherInterestsSum` double DEFAULT NULL,
  `interestAccording` smallint(6) DEFAULT NULL,
  `minCapital` double DEFAULT NULL,
  `enableMinCaptial` tinyint(1) DEFAULT NULL,
  `enableDepositcash` tinyint(1) DEFAULT NULL,
  `accordToProcess` tinyint(1) DEFAULT NULL,
  `split_date` datetime NOT NULL,
  `forbidTrade` tinyint(1) DEFAULT NULL,
  `trading_weight` int(11) NOT NULL,
  `closeNetValue` double DEFAULT NULL,
  `enableCloseNetValue` tinyint(4) DEFAULT NULL,
  `parentAccountComply` tinyint(4) DEFAULT '1',
  `status` smallint(6) DEFAULT '0',
  `minNet` double DEFAULT NULL,
  `enableMinNet` tinyint(4) DEFAULT NULL,
  `types` int(11) DEFAULT NULL,
  `stk_type` int(11) DEFAULT '49',
  `finMaxQuota` double DEFAULT NULL,
  `sloMaxQuota` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_subaccount_b6620684` (`project_id`),
  KEY `account_subaccount_984bb196` (`parent_account_id`),
  CONSTRAINT `parent_account_id_refs_id_ed2497ac` FOREIGN KEY (`parent_account_id`) REFERENCES `account_account` (`id`),
  CONSTRAINT `project_id_refs_id_c483b984` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3306 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_subaccount: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_subaccount` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_subaccount` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_subprebalancemodify
DROP TABLE IF EXISTS `account_subprebalancemodify`;
CREATE TABLE `account_subprebalancemodify` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operator_id` int(11) DEFAULT NULL,
  `sub_account_id` int(11) DEFAULT NULL,
  `new_value` decimal(65,2) DEFAULT NULL,
  `last_value` decimal(65,2) DEFAULT NULL,
  `timetag` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_subprebalancemodify_4198106c` (`operator_id`),
  KEY `account_subprebalancemodify_8bd37ded` (`sub_account_id`),
  KEY `account_subprebalancemodify_d5d78779` (`timetag`),
  CONSTRAINT `sub_account_id_refs_id_edd05e2a` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_subprebalancemodify: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_subprebalancemodify` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_subprebalancemodify` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.account_trendinvestcontract
DROP TABLE IF EXISTS `account_trendinvestcontract`;
CREATE TABLE `account_trendinvestcontract` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_id` int(11) NOT NULL,
  `code` varchar(15) DEFAULT NULL,
  `product_code` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_trendinvestcontract_ea3525ab` (`sub_id`),
  KEY `account_trendinvestcontract_65da3d2c` (`code`),
  KEY `account_trendinvestcontract_195b8a64` (`product_code`),
  CONSTRAINT `sub_id_refs_id_c4c586b5` FOREIGN KEY (`sub_id`) REFERENCES `account_subaccount` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34878 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.account_trendinvestcontract: ~0 rows (approximately)
/*!40000 ALTER TABLE `account_trendinvestcontract` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_trendinvestcontract` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.auth_group
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.auth_group: ~0 rows (approximately)
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` (`id`, `name`) VALUES
	(200, '交易员'),
	(400, '平仓员'),
	(100, '投资顾问'),
	(101, '投资经理'),
	(102, '接单员'),
	(300, '查询员'),
	(90, '独立投顾'),
	(500, '风控员'),
	(700, '审批员'),
	(600, '运维员');
	(900, '财务会计');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.auth_group_permissions
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_bda51c3c` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `group_id_refs_id_3cea63fe` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `permission_id_refs_id_a7792de1` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.auth_group_permissions: ~0 rows (approximately)
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.auth_permission
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_728de91f` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1542 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.auth_permission: ~0 rows (approximately)
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
	(1, 'Can add permission', 1, 'add_permission'),
	(2, 'Can change permission', 1, 'change_permission'),
	(3, 'Can delete permission', 1, 'delete_permission'),
	(4, 'Can add group', 2, 'add_group'),
	(5, 'Can change group', 2, 'change_group'),
	(6, 'Can delete group', 2, 'delete_group'),
	(7, 'Can add user', 3, 'add_user'),
	(8, 'Can change user', 3, 'change_user'),
	(9, 'Can delete user', 3, 'delete_user'),
	(10, 'Can add content type', 4, 'add_contenttype'),
	(11, 'Can change content type', 4, 'change_contenttype'),
	(12, 'Can delete content type', 4, 'delete_contenttype'),
	(13, 'Can add session', 5, 'add_session'),
	(14, 'Can change session', 5, 'change_session'),
	(15, 'Can delete session', 5, 'delete_session'),
	(16, 'Can add site', 6, 'add_site'),
	(17, 'Can change site', 6, 'change_site'),
	(18, 'Can delete site', 6, 'delete_site'),
	(19, 'Can add viewer', 7, 'add_viewer'),
	(20, 'Can change viewer', 7, 'change_viewer'),
	(21, 'Can delete viewer', 7, 'delete_viewer'),
	(22, 'Can add order board', 8, 'add_orderboard'),
	(23, 'Can change order board', 8, 'change_orderboard'),
	(24, 'Can delete order board', 8, 'delete_orderboard'),
	(25, 'Can add user status', 9, 'add_userstatus'),
	(26, 'Can change user status', 9, 'change_userstatus'),
	(27, 'Can delete user status', 9, 'delete_userstatus'),
	(28, 'Can add project', 11, 'add_project'),
	(29, 'Can change project', 11, 'change_project'),
	(30, 'Can delete project', 11, 'delete_project'),
	(31, 'Can add account', 12, 'add_account'),
	(32, 'Can change account', 12, 'change_account'),
	(33, 'Can delete account', 12, 'delete_account'),
	(34, 'Can add sub account', 13, 'add_subaccount'),
	(35, 'Can change sub account', 13, 'change_subaccount'),
	(36, 'Can delete sub account', 13, 'delete_subaccount'),
	(37, 'Can add stop loss', 14, 'add_stoploss'),
	(38, 'Can change stop loss', 14, 'change_stoploss'),
	(39, 'Can delete stop loss', 14, 'delete_stoploss'),
	(40, 'Can add compliance checks', 15, 'add_compliancechecks'),
	(41, 'Can change compliance checks', 15, 'change_compliancechecks'),
	(42, 'Can delete compliance checks', 15, 'delete_compliancechecks'),
	(43, 'Can add bank financial net', 16, 'add_bankfinancialnet'),
	(44, 'Can change bank financial net', 16, 'change_bankfinancialnet'),
	(45, 'Can delete bank financial net', 16, 'delete_bankfinancialnet'),
	(49, 'Can add initial assets', 18, 'add_initialassets'),
	(50, 'Can change initial assets', 18, 'change_initialassets'),
	(51, 'Can delete initial assets', 18, 'delete_initialassets'),
	(52, 'Can add trend invest contract', 19, 'add_trendinvestcontract'),
	(53, 'Can change trend invest contract', 19, 'change_trendinvestcontract'),
	(54, 'Can delete trend invest contract', 19, 'delete_trendinvestcontract'),
	(55, 'Can add hedging combination', 20, 'add_hedgingcombination'),
	(56, 'Can change hedging combination', 20, 'change_hedgingcombination'),
	(57, 'Can delete hedging combination', 20, 'delete_hedgingcombination'),
	(58, 'Can add sub pre balance modify', 21, 'add_subprebalancemodify'),
	(59, 'Can change sub pre balance modify', 21, 'change_subprebalancemodify'),
	(60, 'Can delete sub pre balance modify', 21, 'delete_subprebalancemodify'),
	(61, 'Can add log', 22, 'add_log'),
	(62, 'Can change log', 22, 'change_log'),
	(63, 'Can delete log', 22, 'delete_log'),
	(64, 'Can add platform', 23, 'add_platform'),
	(65, 'Can change platform', 23, 'change_platform'),
	(66, 'Can delete platform', 23, 'delete_platform'),
	(67, 'Can add broker', 24, 'add_broker'),
	(68, 'Can change broker', 24, 'change_broker'),
	(69, 'Can delete broker', 24, 'delete_broker'),
	(70, 'Can add idc line', 25, 'add_idcline'),
	(71, 'Can change idc line', 25, 'change_idcline'),
	(72, 'Can delete idc line', 25, 'delete_idcline'),
	(73, 'Can add server line', 26, 'add_serverline'),
	(74, 'Can change server line', 26, 'change_serverline'),
	(75, 'Can delete server line', 26, 'delete_serverline'),
	(76, 'Can add task', 27, 'add_task'),
	(77, 'Can change task', 27, 'change_task'),
	(78, 'Can delete task', 27, 'delete_task'),
	(79, 'Can add project trace', 28, 'add_projecttrace'),
	(80, 'Can change project trace', 28, 'change_projecttrace'),
	(81, 'Can delete project trace', 28, 'delete_projecttrace'),
	(82, 'Can add msg', 29, 'add_msg'),
	(83, 'Can change msg', 29, 'change_msg'),
	(84, 'Can delete msg', 29, 'delete_msg'),
	(85, 'Can add c ft position detail', 30, 'add_cftpositiondetail'),
	(86, 'Can change c ft position detail', 30, 'change_cftpositiondetail'),
	(87, 'Can delete c ft position detail', 30, 'delete_cftpositiondetail'),
	(88, 'Can add c ft deal detail', 31, 'add_cftdealdetail'),
	(89, 'Can change c ft deal detail', 31, 'change_cftdealdetail'),
	(90, 'Can delete c ft deal detail', 31, 'delete_cftdealdetail'),
	(91, 'Can add c ft order detail', 32, 'add_cftorderdetail'),
	(92, 'Can change c ft order detail', 32, 'change_cftorderdetail'),
	(93, 'Can delete c ft order detail', 32, 'delete_cftorderdetail'),
	(94, 'Can add c ft account detail', 33, 'add_cftaccountdetail'),
	(95, 'Can change c ft account detail', 33, 'change_cftaccountdetail'),
	(96, 'Can delete c ft account detail', 33, 'delete_cftaccountdetail'),
	(97, 'Can add settlement info', 34, 'add_settlementinfo'),
	(98, 'Can change settlement info', 34, 'change_settlementinfo'),
	(99, 'Can delete settlement info', 34, 'delete_settlementinfo'),
	(100, 'Can add perm', 35, 'add_perm'),
	(101, 'Can change perm', 35, 'change_perm'),
	(102, 'Can delete perm', 35, 'delete_perm'),
	(103, 'Can add log system log', 36, 'add_logsystemlog'),
	(104, 'Can change log system log', 36, 'change_logsystemlog'),
	(105, 'Can delete log system log', 36, 'delete_logsystemlog'),
	(106, 'Can add log system info', 37, 'add_logsysteminfo'),
	(107, 'Can change log system info', 37, 'change_logsysteminfo'),
	(108, 'Can delete log system info', 37, 'delete_logsysteminfo'),
	(109, 'Can add deposit percent', 38, 'add_depositpercent'),
	(110, 'Can change deposit percent', 38, 'change_depositpercent'),
	(111, 'Can delete deposit percent', 38, 'delete_depositpercent'),
	(112, 'Can add smtp setting', 39, 'add_smtpsetting'),
	(113, 'Can change smtp setting', 39, 'change_smtpsetting'),
	(114, 'Can delete smtp setting', 39, 'delete_smtpsetting'),
	(115, 'Can add mail receivers', 40, 'add_mailreceivers'),
	(116, 'Can change mail receivers', 40, 'change_mailreceivers'),
	(117, 'Can delete mail receivers', 40, 'delete_mailreceivers'),
	(118, 'Can add orders monitor', 41, 'add_ordersmonitor'),
	(119, 'Can change orders monitor', 41, 'change_ordersmonitor'),
	(120, 'Can delete orders monitor', 41, 'delete_ordersmonitor'),
	(121, 'Can add positions monitor', 42, 'add_positionsmonitor'),
	(122, 'Can change positions monitor', 42, 'change_positionsmonitor'),
	(123, 'Can delete positions monitor', 42, 'delete_positionsmonitor'),
	(124, 'Can add alarm values', 43, 'add_alarmvalues'),
	(125, 'Can change alarm values', 43, 'change_alarmvalues'),
	(126, 'Can delete alarm values', 43, 'delete_alarmvalues'),
	(127, 'Can add log entry', 45, 'add_logentry'),
	(129, 'Can change log entry', 45, 'change_logentry'),
	(131, 'Can delete log entry', 45, 'delete_logentry'),
	(133, 'Can add migration history', 47, 'add_migrationhistory'),
	(135, 'Can change migration history', 47, 'change_migrationhistory'),
	(137, 'Can delete migration history', 47, 'delete_migrationhistory'),
	(139, 'Can add market source', 49, 'add_marketsource'),
	(141, 'Can change market source', 49, 'change_marketsource'),
	(143, 'Can delete market source', 49, 'delete_marketsource'),
	(145, 'Can add role perm', 51, 'add_roleperm'),
	(147, 'Can change role perm', 51, 'change_roleperm'),
	(149, 'Can delete role perm', 51, 'delete_roleperm'),
	(151, 'Can add 客户端权限配置', 44, 'add_clientconfigs'),
	(153, 'Can change 客户端权限配置', 44, 'change_clientconfigs'),
	(155, 'Can delete 客户端权限配置', 44, 'delete_clientconfigs'),
	(157, 'Can add menu', 53, 'add_menu'),
	(159, 'Can change menu', 53, 'change_menu'),
	(161, 'Can delete menu', 53, 'delete_menu'),
	(163, 'Can add workflow', 55, 'add_workflow'),
	(165, 'Can change workflow', 55, 'change_workflow'),
	(167, 'Can delete workflow', 55, 'delete_workflow'),
	(169, 'Can add nodes', 57, 'add_nodes'),
	(171, 'Can change nodes', 57, 'change_nodes'),
	(173, 'Can delete nodes', 57, 'delete_nodes'),
	(175, 'Can add product', 59, 'add_product'),
	(177, 'Can change product', 59, 'change_product'),
	(179, 'Can delete product', 59, 'delete_product'),
	(187, 'Can add grade', 63, 'add_grade'),
	(189, 'Can change grade', 63, 'change_grade'),
	(191, 'Can delete grade', 63, 'delete_grade'),
	(193, 'Can add risk', 65, 'add_risk'),
	(195, 'Can change risk', 65, 'change_risk'),
	(197, 'Can delete risk', 65, 'delete_risk'),
	(199, 'Can add other right', 67, 'add_otherright'),
	(201, 'Can change other right', 67, 'change_otherright'),
	(203, 'Can delete other right', 67, 'delete_otherright'),
	(205, 'Can add accounts', 69, 'add_accounts'),
	(207, 'Can change accounts', 69, 'change_accounts'),
	(209, 'Can delete accounts', 69, 'delete_accounts'),
	(211, 'Can add product workflow', 71, 'add_productworkflow'),
	(213, 'Can change product workflow', 71, 'change_productworkflow'),
	(215, 'Can delete product workflow', 71, 'delete_productworkflow'),
	(217, 'Can add flow accounts', 73, 'add_flowaccounts'),
	(219, 'Can change flow accounts', 73, 'change_flowaccounts'),
	(221, 'Can delete flow accounts', 73, 'delete_flowaccounts'),
	(223, 'Can add flow users', 75, 'add_flowusers'),
	(225, 'Can change flow users', 75, 'change_flowusers'),
	(227, 'Can delete flow users', 75, 'delete_flowusers'),
	(229, 'Can add alerts', 77, 'add_alerts'),
	(231, 'Can change alerts', 77, 'change_alerts'),
	(233, 'Can delete alerts', 77, 'delete_alerts'),
	(235, 'Can add stock source', 79, 'add_stocksource'),
	(237, 'Can change stock source', 79, 'change_stocksource'),
	(239, 'Can delete stock source', 79, 'delete_stocksource'),
	(265, 'Can add global risk', 89, 'add_globalrisk'),
	(267, 'Can change global risk', 89, 'change_globalrisk'),
	(269, 'Can delete global risk', 89, 'delete_globalrisk'),
	(271, 'Can add account risk', 91, 'add_accountrisk'),
	(273, 'Can change account risk', 91, 'change_accountrisk'),
	(275, 'Can delete account risk', 91, 'delete_accountrisk'),
	(277, 'Can add stock account risk', 93, 'add_stockaccountrisk'),
	(279, 'Can change stock account risk', 93, 'change_stockaccountrisk'),
	(281, 'Can delete stock account risk', 93, 'delete_stockaccountrisk'),
	(283, 'Can add c position detail', 95, 'add_cpositiondetail'),
	(285, 'Can change c position detail', 95, 'change_cpositiondetail'),
	(287, 'Can delete c position detail', 95, 'delete_cpositiondetail'),
	(289, 'Can add c order detail', 97, 'add_corderdetail'),
	(291, 'Can change c order detail', 97, 'change_corderdetail'),
	(293, 'Can delete c order detail', 97, 'delete_corderdetail'),
	(295, 'Can add c deal detail', 99, 'add_cdealdetail'),
	(297, 'Can change c deal detail', 99, 'change_cdealdetail'),
	(299, 'Can delete c deal detail', 99, 'delete_cdealdetail'),
	(301, 'Can add fund', 101, 'add_fund'),
	(303, 'Can change fund', 101, 'change_fund'),
	(305, 'Can delete fund', 101, 'delete_fund'),
	(307, 'Can add position risk', 103, 'add_positionrisk'),
	(309, 'Can change position risk', 103, 'change_positionrisk'),
	(311, 'Can delete position risk', 103, 'delete_positionrisk'),
	(313, 'Can add bson risk', 105, 'add_bsonrisk'),
	(315, 'Can change bson risk', 105, 'change_bsonrisk'),
	(317, 'Can delete bson risk', 105, 'delete_bsonrisk'),
	(331, 'Can add c account detail', 111, 'add_caccountdetail'),
	(333, 'Can change c account detail', 111, 'change_caccountdetail'),
	(335, 'Can delete c account detail', 111, 'delete_caccountdetail'),
	(337, 'Can add stoploss rules', 113, 'add_stoplossrules'),
	(339, 'Can change stoploss rules', 113, 'change_stoplossrules'),
	(341, 'Can delete stoploss rules', 113, 'delete_stoplossrules'),
	(343, 'Can add queriers', 115, 'add_queriers'),
	(345, 'Can change queriers', 115, 'change_queriers'),
	(347, 'Can delete queriers', 115, 'delete_queriers'),
	(349, 'Can add closers', 117, 'add_closers'),
	(351, 'Can change closers', 117, 'change_closers'),
	(353, 'Can delete closers', 117, 'delete_closers'),
	(355, 'Can add c order command', 119, 'add_cordercommand'),
	(357, 'Can change c order command', 119, 'change_cordercommand'),
	(359, 'Can delete c order command', 119, 'delete_cordercommand'),
	(361, 'Can add c task detail', 121, 'add_ctaskdetail'),
	(363, 'Can change c task detail', 121, 'change_ctaskdetail'),
	(365, 'Can delete c task detail', 121, 'delete_ctaskdetail'),
	(367, 'Can add user config', 123, 'add_userconfig'),
	(369, 'Can change user config', 123, 'change_userconfig'),
	(371, 'Can delete user config', 123, 'delete_userconfig'),
	(373, 'Can add c position statics', 125, 'add_cpositionstatics'),
	(375, 'Can change c position statics', 125, 'change_cpositionstatics'),
	(377, 'Can delete c position statics', 125, 'delete_cpositionstatics'),
	(379, 'Can add grade date history', 127, 'add_gradedatehistory'),
	(381, 'Can change grade date history', 127, 'change_gradedatehistory'),
	(383, 'Can delete grade date history', 127, 'delete_gradedatehistory'),
	(385, 'Can view permission', 1, 'view_permission'),
	(387, 'Can add group', 3, 'add_group'),
	(389, 'Can change group', 3, 'change_group'),
	(391, 'Can delete group', 3, 'delete_group'),
	(393, 'Can view group', 3, 'view_group'),
	(395, 'Can add user', 5, 'add_user'),
	(397, 'Can change user', 5, 'change_user'),
	(399, 'Can delete user', 5, 'delete_user'),
	(401, 'Can view user', 5, 'view_user'),
	(403, 'Can add content type', 7, 'add_contenttype'),
	(405, 'Can change content type', 7, 'change_contenttype'),
	(407, 'Can delete content type', 7, 'delete_contenttype'),
	(409, 'Can view content type', 7, 'view_contenttype'),
	(411, 'Can add session', 9, 'add_session'),
	(413, 'Can change session', 9, 'change_session'),
	(415, 'Can delete session', 9, 'delete_session'),
	(417, 'Can view session', 9, 'view_session'),
	(419, 'Can add site', 11, 'add_site'),
	(421, 'Can change site', 11, 'change_site'),
	(423, 'Can delete site', 11, 'delete_site'),
	(425, 'Can view site', 11, 'view_site'),
	(427, 'Can add viewer', 13, 'add_viewer'),
	(429, 'Can change viewer', 13, 'change_viewer'),
	(431, 'Can delete viewer', 13, 'delete_viewer'),
	(433, 'Can view viewer', 13, 'view_viewer'),
	(435, 'Can add order board', 15, 'add_orderboard'),
	(437, 'Can change order board', 15, 'change_orderboard'),
	(439, 'Can delete order board', 15, 'delete_orderboard'),
	(441, 'Can view order board', 15, 'view_orderboard'),
	(443, 'Can add user status', 17, 'add_userstatus'),
	(445, 'Can change user status', 17, 'change_userstatus'),
	(447, 'Can delete user status', 17, 'delete_userstatus'),
	(449, 'Can view user status', 17, 'view_userstatus'),
	(451, 'Can add user config', 19, 'add_userconfig'),
	(453, 'Can change user config', 19, 'change_userconfig'),
	(455, 'Can delete user config', 19, 'delete_userconfig'),
	(457, 'Can view user config', 19, 'view_userconfig'),
	(459, 'Can add account', 95, 'add_account'),
	(461, 'Can change account', 95, 'change_account'),
	(463, 'Can delete account', 95, 'delete_account'),
	(465, 'Can view account', 95, 'view_account'),
	(467, 'Can add sub account', 97, 'add_subaccount'),
	(469, 'Can change sub account', 97, 'change_subaccount'),
	(471, 'Can delete sub account', 97, 'delete_subaccount'),
	(473, 'Can view sub account', 97, 'view_subaccount'),
	(475, 'Can add deposit percent', 99, 'add_depositpercent'),
	(477, 'Can change deposit percent', 99, 'change_depositpercent'),
	(479, 'Can delete deposit percent', 99, 'delete_depositpercent'),
	(481, 'Can view deposit percent', 99, 'view_depositpercent'),
	(483, 'Can add stop loss', 101, 'add_stoploss'),
	(485, 'Can change stop loss', 101, 'change_stoploss'),
	(487, 'Can delete stop loss', 101, 'delete_stoploss'),
	(489, 'Can view stop loss', 101, 'view_stoploss'),
	(491, 'Can add compliance checks', 103, 'add_compliancechecks'),
	(493, 'Can change compliance checks', 103, 'change_compliancechecks'),
	(495, 'Can delete compliance checks', 103, 'delete_compliancechecks'),
	(497, 'Can view compliance checks', 103, 'view_compliancechecks'),
	(499, 'Can add bank financial net', 105, 'add_bankfinancialnet'),
	(501, 'Can change bank financial net', 105, 'change_bankfinancialnet'),
	(503, 'Can delete bank financial net', 105, 'delete_bankfinancialnet'),
	(505, 'Can view bank financial net', 105, 'view_bankfinancialnet'),
	(507, 'Can add initial assets', 107, 'add_initialassets'),
	(509, 'Can change initial assets', 107, 'change_initialassets'),
	(511, 'Can delete initial assets', 107, 'delete_initialassets'),
	(513, 'Can view initial assets', 107, 'view_initialassets'),
	(515, 'Can add trend invest contract', 109, 'add_trendinvestcontract'),
	(517, 'Can change trend invest contract', 109, 'change_trendinvestcontract'),
	(519, 'Can delete trend invest contract', 109, 'delete_trendinvestcontract'),
	(521, 'Can view trend invest contract', 109, 'view_trendinvestcontract'),
	(523, 'Can add hedging combination', 111, 'add_hedgingcombination'),
	(525, 'Can change hedging combination', 111, 'change_hedgingcombination'),
	(527, 'Can delete hedging combination', 111, 'delete_hedgingcombination'),
	(529, 'Can view hedging combination', 111, 'view_hedgingcombination'),
	(531, 'Can add sub pre balance modify', 113, 'add_subprebalancemodify'),
	(533, 'Can change sub pre balance modify', 113, 'change_subprebalancemodify'),
	(535, 'Can delete sub pre balance modify', 113, 'delete_subprebalancemodify'),
	(537, 'Can view sub pre balance modify', 113, 'view_subprebalancemodify'),
	(539, 'Can add stoploss rules', 115, 'add_stoplossrules'),
	(541, 'Can change stoploss rules', 115, 'change_stoplossrules'),
	(543, 'Can delete stoploss rules', 115, 'delete_stoplossrules'),
	(545, 'Can view stoploss rules', 115, 'view_stoplossrules'),
	(547, 'Can add log', 23, 'add_log'),
	(549, 'Can change log', 23, 'change_log'),
	(551, 'Can delete log', 23, 'delete_log'),
	(553, 'Can view log', 23, 'view_log'),
	(555, 'Can add platform', 25, 'add_platform'),
	(557, 'Can change platform', 25, 'change_platform'),
	(559, 'Can delete platform', 25, 'delete_platform'),
	(561, 'Can view platform', 25, 'view_platform'),
	(563, 'Can add broker', 27, 'add_broker'),
	(565, 'Can change broker', 27, 'change_broker'),
	(567, 'Can delete broker', 27, 'delete_broker'),
	(569, 'Can view broker', 27, 'view_broker'),
	(571, 'Can add idc line', 29, 'add_idcline'),
	(573, 'Can change idc line', 29, 'change_idcline'),
	(575, 'Can delete idc line', 29, 'delete_idcline'),
	(577, 'Can view idc line', 29, 'view_idcline'),
	(579, 'Can add server line', 31, 'add_serverline'),
	(581, 'Can change server line', 31, 'change_serverline'),
	(583, 'Can delete server line', 31, 'delete_serverline'),
	(585, 'Can view server line', 31, 'view_serverline'),
	(587, 'Can add task', 33, 'add_task'),
	(589, 'Can change task', 33, 'change_task'),
	(591, 'Can delete task', 33, 'delete_task'),
	(593, 'Can view task', 33, 'view_task'),
	(595, 'Can add msg', 35, 'add_msg'),
	(597, 'Can change msg', 35, 'change_msg'),
	(599, 'Can delete msg', 35, 'delete_msg'),
	(601, 'Can view msg', 35, 'view_msg'),
	(603, 'Can add c ft position detail', 37, 'add_cftpositiondetail'),
	(605, 'Can change c ft position detail', 37, 'change_cftpositiondetail'),
	(607, 'Can delete c ft position detail', 37, 'delete_cftpositiondetail'),
	(609, 'Can view c ft position detail', 37, 'view_cftpositiondetail'),
	(611, 'Can add c ft deal detail', 39, 'add_cftdealdetail'),
	(613, 'Can change c ft deal detail', 39, 'change_cftdealdetail'),
	(615, 'Can delete c ft deal detail', 39, 'delete_cftdealdetail'),
	(617, 'Can view c ft deal detail', 39, 'view_cftdealdetail'),
	(619, 'Can add c ft order detail', 41, 'add_cftorderdetail'),
	(621, 'Can change c ft order detail', 41, 'change_cftorderdetail'),
	(623, 'Can delete c ft order detail', 41, 'delete_cftorderdetail'),
	(625, 'Can view c ft order detail', 41, 'view_cftorderdetail'),
	(627, 'Can add c ft account detail', 43, 'add_cftaccountdetail'),
	(629, 'Can change c ft account detail', 43, 'change_cftaccountdetail'),
	(631, 'Can delete c ft account detail', 43, 'delete_cftaccountdetail'),
	(633, 'Can view c ft account detail', 43, 'view_cftaccountdetail'),
	(635, 'Can add settlement info', 45, 'add_settlementinfo'),
	(637, 'Can change settlement info', 45, 'change_settlementinfo'),
	(639, 'Can delete settlement info', 45, 'delete_settlementinfo'),
	(641, 'Can view settlement info', 45, 'view_settlementinfo'),
	(643, 'Can add perm', 47, 'add_perm'),
	(645, 'Can change perm', 47, 'change_perm'),
	(647, 'Can delete perm', 47, 'delete_perm'),
	(649, 'Can view perm', 47, 'view_perm'),
	(651, 'Can add log system log', 49, 'add_logsystemlog'),
	(653, 'Can change log system log', 49, 'change_logsystemlog'),
	(655, 'Can delete log system log', 49, 'delete_logsystemlog'),
	(657, 'Can view log system log', 49, 'view_logsystemlog'),
	(659, 'Can add log system info', 51, 'add_logsysteminfo'),
	(661, 'Can change log system info', 51, 'change_logsysteminfo'),
	(663, 'Can delete log system info', 51, 'delete_logsysteminfo'),
	(665, 'Can view log system info', 51, 'view_logsysteminfo'),
	(667, 'Can add smtp setting', 53, 'add_smtpsetting'),
	(669, 'Can change smtp setting', 53, 'change_smtpsetting'),
	(671, 'Can delete smtp setting', 53, 'delete_smtpsetting'),
	(673, 'Can view smtp setting', 53, 'view_smtpsetting'),
	(675, 'Can add mail receivers', 55, 'add_mailreceivers'),
	(677, 'Can change mail receivers', 55, 'change_mailreceivers'),
	(679, 'Can delete mail receivers', 55, 'delete_mailreceivers'),
	(681, 'Can view mail receivers', 55, 'view_mailreceivers'),
	(683, 'Can add alarm values', 57, 'add_alarmvalues'),
	(685, 'Can change alarm values', 57, 'change_alarmvalues'),
	(687, 'Can delete alarm values', 57, 'delete_alarmvalues'),
	(689, 'Can view alarm values', 57, 'view_alarmvalues'),
	(691, 'Can add orders monitor', 59, 'add_ordersmonitor'),
	(693, 'Can change orders monitor', 59, 'change_ordersmonitor'),
	(695, 'Can delete orders monitor', 59, 'delete_ordersmonitor'),
	(697, 'Can view orders monitor', 59, 'view_ordersmonitor'),
	(699, 'Can add positions monitor', 61, 'add_positionsmonitor'),
	(701, 'Can change positions monitor', 61, 'change_positionsmonitor'),
	(703, 'Can delete positions monitor', 61, 'delete_positionsmonitor'),
	(705, 'Can view positions monitor', 61, 'view_positionsmonitor'),
	(707, 'Can add migration history', 63, 'add_migrationhistory'),
	(709, 'Can change migration history', 63, 'change_migrationhistory'),
	(711, 'Can delete migration history', 63, 'delete_migrationhistory'),
	(713, 'Can view migration history', 63, 'view_migrationhistory'),
	(715, 'Can add market source', 65, 'add_marketsource'),
	(717, 'Can change market source', 65, 'change_marketsource'),
	(719, 'Can delete market source', 65, 'delete_marketsource'),
	(721, 'Can view market source', 65, 'view_marketsource'),
	(723, 'Can add stock source', 67, 'add_stocksource'),
	(725, 'Can change stock source', 67, 'change_stocksource'),
	(727, 'Can delete stock source', 67, 'delete_stocksource'),
	(729, 'Can view stock source', 67, 'view_stocksource'),
	(731, 'Can add role perm', 69, 'add_roleperm'),
	(733, 'Can change role perm', 69, 'change_roleperm'),
	(735, 'Can delete role perm', 69, 'delete_roleperm'),
	(737, 'Can view role perm', 69, 'view_roleperm'),
	(739, 'Can add 客户端权限配置', 71, 'add_clientconfigs'),
	(741, 'Can change 客户端权限配置', 71, 'change_clientconfigs'),
	(743, 'Can delete 客户端权限配置', 71, 'delete_clientconfigs'),
	(745, 'Can view 客户端权限配置', 71, 'view_clientconfigs'),
	(747, 'Can add menu', 73, 'add_menu'),
	(749, 'Can change menu', 73, 'change_menu'),
	(751, 'Can delete menu', 73, 'delete_menu'),
	(753, 'Can view menu', 73, 'view_menu'),
	(755, 'Can add workflow', 75, 'add_workflow'),
	(757, 'Can change workflow', 75, 'change_workflow'),
	(759, 'Can delete workflow', 75, 'delete_workflow'),
	(761, 'Can view workflow', 75, 'view_workflow'),
	(763, 'Can add nodes', 77, 'add_nodes'),
	(765, 'Can change nodes', 77, 'change_nodes'),
	(767, 'Can delete nodes', 77, 'delete_nodes'),
	(769, 'Can view nodes', 77, 'view_nodes'),
	(771, 'Can add product', 117, 'add_product'),
	(773, 'Can change product', 117, 'change_product'),
	(775, 'Can delete product', 117, 'delete_product'),
	(777, 'Can view product', 117, 'view_product'),
	(779, 'Can add grade date history', 119, 'add_gradedatehistory'),
	(781, 'Can change grade date history', 119, 'change_gradedatehistory'),
	(783, 'Can delete grade date history', 119, 'delete_gradedatehistory'),
	(785, 'Can view grade date history', 119, 'view_gradedatehistory'),
	(787, 'Can add grade', 121, 'add_grade'),
	(789, 'Can change grade', 121, 'change_grade'),
	(791, 'Can delete grade', 121, 'delete_grade'),
	(793, 'Can view grade', 121, 'view_grade'),
	(795, 'Can add product workflow', 123, 'add_productworkflow'),
	(797, 'Can change product workflow', 123, 'change_productworkflow'),
	(799, 'Can delete product workflow', 123, 'delete_productworkflow'),
	(801, 'Can view product workflow', 123, 'view_productworkflow'),
	(803, 'Can add accounts', 125, 'add_accounts'),
	(805, 'Can change accounts', 125, 'change_accounts'),
	(807, 'Can delete accounts', 125, 'delete_accounts'),
	(809, 'Can view accounts', 125, 'view_accounts'),
	(811, 'Can add flow accounts', 127, 'add_flowaccounts'),
	(813, 'Can change flow accounts', 127, 'change_flowaccounts'),
	(815, 'Can delete flow accounts', 127, 'delete_flowaccounts'),
	(817, 'Can view flow accounts', 127, 'view_flowaccounts'),
	(819, 'Can add flow users', 129, 'add_flowusers'),
	(821, 'Can change flow users', 129, 'change_flowusers'),
	(823, 'Can delete flow users', 129, 'delete_flowusers'),
	(825, 'Can view flow users', 129, 'view_flowusers'),
	(827, 'Can add risk', 131, 'add_risk'),
	(829, 'Can change risk', 131, 'change_risk'),
	(831, 'Can delete risk', 131, 'delete_risk'),
	(833, 'Can view risk', 131, 'view_risk'),
	(835, 'Can add alerts', 133, 'add_alerts'),
	(837, 'Can change alerts', 133, 'change_alerts'),
	(839, 'Can delete alerts', 133, 'delete_alerts'),
	(841, 'Can view alerts', 133, 'view_alerts'),
	(843, 'Can add other right', 135, 'add_otherright'),
	(845, 'Can change other right', 135, 'change_otherright'),
	(847, 'Can delete other right', 135, 'delete_otherright'),
	(849, 'Can view other right', 135, 'view_otherright'),
	(851, 'Can add fund', 137, 'add_fund'),
	(853, 'Can change fund', 137, 'change_fund'),
	(855, 'Can delete fund', 137, 'delete_fund'),
	(857, 'Can view fund', 137, 'view_fund'),
	(859, 'Can add position risk', 139, 'add_positionrisk'),
	(861, 'Can change position risk', 139, 'change_positionrisk'),
	(863, 'Can delete position risk', 139, 'delete_positionrisk'),
	(865, 'Can view position risk', 139, 'view_positionrisk'),
	(867, 'Can add bson risk', 141, 'add_bsonrisk'),
	(869, 'Can change bson risk', 141, 'change_bsonrisk'),
	(871, 'Can delete bson risk', 141, 'delete_bsonrisk'),
	(873, 'Can view bson risk', 141, 'view_bsonrisk'),
	(875, 'Can add queriers', 143, 'add_queriers'),
	(877, 'Can change queriers', 143, 'change_queriers'),
	(879, 'Can delete queriers', 143, 'delete_queriers'),
	(881, 'Can view queriers', 143, 'view_queriers'),
	(883, 'Can add risk controller', 145, 'add_riskcontroller'),
	(885, 'Can change risk controller', 145, 'change_riskcontroller'),
	(887, 'Can delete risk controller', 145, 'delete_riskcontroller'),
	(889, 'Can view risk controller', 145, 'view_riskcontroller'),
	(891, 'Can add closers', 147, 'add_closers'),
	(893, 'Can change closers', 147, 'change_closers'),
	(895, 'Can delete closers', 147, 'delete_closers'),
	(897, 'Can view closers', 147, 'view_closers'),
	(899, 'Can add global risk', 149, 'add_globalrisk'),
	(901, 'Can change global risk', 149, 'change_globalrisk'),
	(903, 'Can delete global risk', 149, 'delete_globalrisk'),
	(905, 'Can view global risk', 149, 'view_globalrisk'),
	(907, 'Can add account risk', 151, 'add_accountrisk'),
	(909, 'Can change account risk', 151, 'change_accountrisk'),
	(911, 'Can delete account risk', 151, 'delete_accountrisk'),
	(913, 'Can view account risk', 151, 'view_accountrisk'),
	(915, 'Can add c position detail', 79, 'add_cpositiondetail'),
	(917, 'Can change c position detail', 79, 'change_cpositiondetail'),
	(919, 'Can delete c position detail', 79, 'delete_cpositiondetail'),
	(921, 'Can view c position detail', 79, 'view_cpositiondetail'),
	(923, 'Can add c order detail', 81, 'add_corderdetail'),
	(925, 'Can change c order detail', 81, 'change_corderdetail'),
	(927, 'Can delete c order detail', 81, 'delete_corderdetail'),
	(929, 'Can view c order detail', 81, 'view_corderdetail'),
	(931, 'Can add c deal detail', 83, 'add_cdealdetail'),
	(933, 'Can change c deal detail', 83, 'change_cdealdetail'),
	(935, 'Can delete c deal detail', 83, 'delete_cdealdetail'),
	(937, 'Can view c deal detail', 83, 'view_cdealdetail'),
	(939, 'Can add c account detail', 85, 'add_caccountdetail'),
	(941, 'Can change c account detail', 85, 'change_caccountdetail'),
	(943, 'Can delete c account detail', 85, 'delete_caccountdetail'),
	(945, 'Can view c account detail', 85, 'view_caccountdetail'),
	(947, 'Can add c order command', 87, 'add_cordercommand'),
	(949, 'Can change c order command', 87, 'change_cordercommand'),
	(951, 'Can delete c order command', 87, 'delete_cordercommand'),
	(953, 'Can view c order command', 87, 'view_cordercommand'),
	(955, 'Can add c task detail', 89, 'add_ctaskdetail'),
	(957, 'Can change c task detail', 89, 'change_ctaskdetail'),
	(959, 'Can delete c task detail', 89, 'delete_ctaskdetail'),
	(961, 'Can view c task detail', 89, 'view_ctaskdetail'),
	(963, 'Can add c position statics', 91, 'add_cpositionstatics'),
	(965, 'Can change c position statics', 91, 'change_cpositionstatics'),
	(967, 'Can delete c position statics', 91, 'delete_cpositionstatics'),
	(969, 'Can view c position statics', 91, 'view_cpositionstatics'),
	(971, 'Can add stock query delivery resp', 93, 'add_stockquerydeliveryresp'),
	(973, 'Can change stock query delivery resp', 93, 'change_stockquerydeliveryresp'),
	(975, 'Can delete stock query delivery resp', 93, 'delete_stockquerydeliveryresp'),
	(977, 'Can view stock query delivery resp', 93, 'view_stockquerydeliveryresp'),
	(979, 'Can add c stk subjects', 153, 'add_cstksubjects'),
	(981, 'Can change c stk subjects', 153, 'change_cstksubjects'),
	(983, 'Can delete c stk subjects', 153, 'delete_cstksubjects'),
	(985, 'Can view c stk subjects', 153, 'view_cstksubjects'),
	(987, 'Can add c stk compacts', 155, 'add_cstkcompacts'),
	(989, 'Can change c stk compacts', 155, 'change_cstkcompacts'),
	(991, 'Can delete c stk compacts', 155, 'delete_cstkcompacts'),
	(993, 'Can view c stk compacts', 155, 'view_cstkcompacts'),
	(995, 'Can add c credit account detail', 157, 'add_ccreditaccountdetail'),
	(997, 'Can change c credit account detail', 157, 'change_ccreditaccountdetail'),
	(999, 'Can delete c credit account detail', 157, 'delete_ccreditaccountdetail'),
	(1001, 'Can view c credit account detail', 157, 'view_ccreditaccountdetail'),
	(1003, 'Can add uploaded file', 159, 'add_uploadedfile'),
	(1005, 'Can change uploaded file', 159, 'change_uploadedfile'),
	(1007, 'Can delete uploaded file', 159, 'delete_uploadedfile'),
	(1009, 'Can view uploaded file', 159, 'view_uploadedfile'),
	(1011, 'Can add project', 161, 'add_project'),
	(1013, 'Can change project', 161, 'change_project'),
	(1015, 'Can delete project', 161, 'delete_project'),
	(1017, 'Can view project', 161, 'view_project'),
	(1019, 'Can add project trace', 163, 'add_projecttrace'),
	(1021, 'Can change project trace', 163, 'change_projecttrace'),
	(1023, 'Can delete project trace', 163, 'delete_projecttrace'),
	(1025, 'Can view project trace', 163, 'view_projecttrace'),
	(1027, 'Can add permission', 333, 'add_permission'),
	(1029, 'Can change permission', 333, 'change_permission'),
	(1031, 'Can delete permission', 333, 'delete_permission'),
	(1033, 'Can add group', 335, 'add_group'),
	(1035, 'Can change group', 335, 'change_group'),
	(1037, 'Can delete group', 335, 'delete_group'),
	(1039, 'Can add user', 337, 'add_user'),
	(1041, 'Can change user', 337, 'change_user'),
	(1043, 'Can delete user', 337, 'delete_user'),
	(1045, 'Can add content type', 339, 'add_contenttype'),
	(1047, 'Can change content type', 339, 'change_contenttype'),
	(1049, 'Can delete content type', 339, 'delete_contenttype'),
	(1051, 'Can add session', 341, 'add_session'),
	(1053, 'Can change session', 341, 'change_session'),
	(1055, 'Can delete session', 341, 'delete_session'),
	(1057, 'Can add site', 343, 'add_site'),
	(1059, 'Can change site', 343, 'change_site'),
	(1061, 'Can delete site', 343, 'delete_site'),
	(1063, 'Can add viewer', 345, 'add_viewer'),
	(1065, 'Can change viewer', 345, 'change_viewer'),
	(1067, 'Can delete viewer', 345, 'delete_viewer'),
	(1069, 'Can add order board', 347, 'add_orderboard'),
	(1071, 'Can change order board', 347, 'change_orderboard'),
	(1073, 'Can delete order board', 347, 'delete_orderboard'),
	(1075, 'Can add user status', 349, 'add_userstatus'),
	(1077, 'Can change user status', 349, 'change_userstatus'),
	(1079, 'Can delete user status', 349, 'delete_userstatus'),
	(1081, 'Can add user config', 351, 'add_userconfig'),
	(1083, 'Can change user config', 351, 'change_userconfig'),
	(1085, 'Can delete user config', 351, 'delete_userconfig'),
	(1087, 'Can add stock category', 355, 'add_stockcategory'),
	(1089, 'Can change stock category', 355, 'change_stockcategory'),
	(1091, 'Can delete stock category', 355, 'delete_stockcategory'),
	(1093, 'Can add stock category item', 357, 'add_stockcategoryitem'),
	(1095, 'Can change stock category item', 357, 'change_stockcategoryitem'),
	(1097, 'Can delete stock category item', 357, 'delete_stockcategoryitem'),
	(1099, 'Can add stock', 359, 'add_stock'),
	(1101, 'Can change stock', 359, 'change_stock'),
	(1103, 'Can delete stock', 359, 'delete_stock'),
	(1105, 'Can add account', 361, 'add_account'),
	(1107, 'Can change account', 361, 'change_account'),
	(1109, 'Can delete account', 361, 'delete_account'),
	(1111, 'Can add sub account', 363, 'add_subaccount'),
	(1113, 'Can change sub account', 363, 'change_subaccount'),
	(1115, 'Can delete sub account', 363, 'delete_subaccount'),
	(1117, 'Can add deposit percent', 365, 'add_depositpercent'),
	(1119, 'Can change deposit percent', 365, 'change_depositpercent'),
	(1121, 'Can delete deposit percent', 365, 'delete_depositpercent'),
	(1123, 'Can add stop loss', 367, 'add_stoploss'),
	(1125, 'Can change stop loss', 367, 'change_stoploss'),
	(1127, 'Can delete stop loss', 367, 'delete_stoploss'),
	(1129, 'Can add compliance checks', 369, 'add_compliancechecks'),
	(1131, 'Can change compliance checks', 369, 'change_compliancechecks'),
	(1133, 'Can delete compliance checks', 369, 'delete_compliancechecks'),
	(1135, 'Can add bank financial net', 371, 'add_bankfinancialnet'),
	(1137, 'Can change bank financial net', 371, 'change_bankfinancialnet'),
	(1139, 'Can delete bank financial net', 371, 'delete_bankfinancialnet'),
	(1141, 'Can add initial assets', 373, 'add_initialassets'),
	(1143, 'Can change initial assets', 373, 'change_initialassets'),
	(1145, 'Can delete initial assets', 373, 'delete_initialassets'),
	(1147, 'Can add trend invest contract', 375, 'add_trendinvestcontract'),
	(1149, 'Can change trend invest contract', 375, 'change_trendinvestcontract'),
	(1151, 'Can delete trend invest contract', 375, 'delete_trendinvestcontract'),
	(1153, 'Can add hedging combination', 377, 'add_hedgingcombination'),
	(1155, 'Can change hedging combination', 377, 'change_hedgingcombination'),
	(1157, 'Can delete hedging combination', 377, 'delete_hedgingcombination'),
	(1159, 'Can add sub pre balance modify', 379, 'add_subprebalancemodify'),
	(1161, 'Can change sub pre balance modify', 379, 'change_subprebalancemodify'),
	(1163, 'Can delete sub pre balance modify', 379, 'delete_subprebalancemodify'),
	(1165, 'Can add stoploss rules', 381, 'add_stoplossrules'),
	(1167, 'Can change stoploss rules', 381, 'change_stoplossrules'),
	(1169, 'Can delete stoploss rules', 381, 'delete_stoplossrules'),
	(1171, 'Can add log', 383, 'add_log'),
	(1173, 'Can change log', 383, 'change_log'),
	(1175, 'Can delete log', 383, 'delete_log'),
	(1177, 'Can add platform', 385, 'add_platform'),
	(1179, 'Can change platform', 385, 'change_platform'),
	(1181, 'Can delete platform', 385, 'delete_platform'),
	(1183, 'Can add broker', 387, 'add_broker'),
	(1185, 'Can change broker', 387, 'change_broker'),
	(1187, 'Can delete broker', 387, 'delete_broker'),
	(1189, 'Can add idc line', 389, 'add_idcline'),
	(1191, 'Can change idc line', 389, 'change_idcline'),
	(1193, 'Can delete idc line', 389, 'delete_idcline'),
	(1195, 'Can add server line', 391, 'add_serverline'),
	(1197, 'Can change server line', 391, 'change_serverline'),
	(1199, 'Can delete server line', 391, 'delete_serverline'),
	(1201, 'Can add task', 393, 'add_task'),
	(1203, 'Can change task', 393, 'change_task'),
	(1205, 'Can delete task', 393, 'delete_task'),
	(1207, 'Can add msg', 395, 'add_msg'),
	(1209, 'Can change msg', 395, 'change_msg'),
	(1211, 'Can delete msg', 395, 'delete_msg'),
	(1213, 'Can add c ft position detail', 397, 'add_cftpositiondetail'),
	(1215, 'Can change c ft position detail', 397, 'change_cftpositiondetail'),
	(1217, 'Can delete c ft position detail', 397, 'delete_cftpositiondetail'),
	(1219, 'Can add c ft deal detail', 399, 'add_cftdealdetail'),
	(1221, 'Can change c ft deal detail', 399, 'change_cftdealdetail'),
	(1223, 'Can delete c ft deal detail', 399, 'delete_cftdealdetail'),
	(1225, 'Can add c ft order detail', 401, 'add_cftorderdetail'),
	(1227, 'Can change c ft order detail', 401, 'change_cftorderdetail'),
	(1229, 'Can delete c ft order detail', 401, 'delete_cftorderdetail'),
	(1231, 'Can add c ft account detail', 403, 'add_cftaccountdetail'),
	(1233, 'Can change c ft account detail', 403, 'change_cftaccountdetail'),
	(1235, 'Can delete c ft account detail', 403, 'delete_cftaccountdetail'),
	(1237, 'Can add settlement info', 405, 'add_settlementinfo'),
	(1239, 'Can change settlement info', 405, 'change_settlementinfo'),
	(1241, 'Can delete settlement info', 405, 'delete_settlementinfo'),
	(1243, 'Can add perm', 407, 'add_perm'),
	(1245, 'Can change perm', 407, 'change_perm'),
	(1247, 'Can delete perm', 407, 'delete_perm'),
	(1249, 'Can add log system log', 409, 'add_logsystemlog'),
	(1251, 'Can change log system log', 409, 'change_logsystemlog'),
	(1253, 'Can delete log system log', 409, 'delete_logsystemlog'),
	(1255, 'Can add log system info', 411, 'add_logsysteminfo'),
	(1257, 'Can change log system info', 411, 'change_logsysteminfo'),
	(1259, 'Can delete log system info', 411, 'delete_logsysteminfo'),
	(1261, 'Can add smtp setting', 413, 'add_smtpsetting'),
	(1263, 'Can change smtp setting', 413, 'change_smtpsetting'),
	(1265, 'Can delete smtp setting', 413, 'delete_smtpsetting'),
	(1267, 'Can add mail receivers', 415, 'add_mailreceivers'),
	(1269, 'Can change mail receivers', 415, 'change_mailreceivers'),
	(1271, 'Can delete mail receivers', 415, 'delete_mailreceivers'),
	(1273, 'Can add alarm values', 417, 'add_alarmvalues'),
	(1275, 'Can change alarm values', 417, 'change_alarmvalues'),
	(1277, 'Can delete alarm values', 417, 'delete_alarmvalues'),
	(1279, 'Can add orders monitor', 419, 'add_ordersmonitor'),
	(1281, 'Can change orders monitor', 419, 'change_ordersmonitor'),
	(1283, 'Can delete orders monitor', 419, 'delete_ordersmonitor'),
	(1285, 'Can add positions monitor', 421, 'add_positionsmonitor'),
	(1287, 'Can change positions monitor', 421, 'change_positionsmonitor'),
	(1289, 'Can delete positions monitor', 421, 'delete_positionsmonitor'),
	(1291, 'Can add migration history', 423, 'add_migrationhistory'),
	(1293, 'Can change migration history', 423, 'change_migrationhistory'),
	(1295, 'Can delete migration history', 423, 'delete_migrationhistory'),
	(1297, 'Can add market source', 425, 'add_marketsource'),
	(1299, 'Can change market source', 425, 'change_marketsource'),
	(1301, 'Can delete market source', 425, 'delete_marketsource'),
	(1303, 'Can add stock source', 427, 'add_stocksource'),
	(1305, 'Can change stock source', 427, 'change_stocksource'),
	(1307, 'Can delete stock source', 427, 'delete_stocksource'),
	(1309, 'Can add role perm', 429, 'add_roleperm'),
	(1311, 'Can change role perm', 429, 'change_roleperm'),
	(1313, 'Can delete role perm', 429, 'delete_roleperm'),
	(1315, 'Can add 客户端权限配置', 431, 'add_clientconfigs'),
	(1317, 'Can change 客户端权限配置', 431, 'change_clientconfigs'),
	(1319, 'Can delete 客户端权限配置', 431, 'delete_clientconfigs'),
	(1321, 'Can add menu', 433, 'add_menu'),
	(1323, 'Can change menu', 433, 'change_menu'),
	(1325, 'Can delete menu', 433, 'delete_menu'),
	(1327, 'Can add workflow', 435, 'add_workflow'),
	(1329, 'Can change workflow', 435, 'change_workflow'),
	(1331, 'Can delete workflow', 435, 'delete_workflow'),
	(1333, 'Can add nodes', 437, 'add_nodes'),
	(1335, 'Can change nodes', 437, 'change_nodes'),
	(1337, 'Can delete nodes', 437, 'delete_nodes'),
	(1339, 'Can add assets index', 439, 'add_assetsindex'),
	(1341, 'Can change assets index', 439, 'change_assetsindex'),
	(1343, 'Can delete assets index', 439, 'delete_assetsindex'),
	(1345, 'Can add product', 441, 'add_product'),
	(1347, 'Can change product', 441, 'change_product'),
	(1349, 'Can delete product', 441, 'delete_product'),
	(1351, 'Can add grade date history', 443, 'add_gradedatehistory'),
	(1353, 'Can change grade date history', 443, 'change_gradedatehistory'),
	(1355, 'Can delete grade date history', 443, 'delete_gradedatehistory'),
	(1357, 'Can add grade', 445, 'add_grade'),
	(1359, 'Can change grade', 445, 'change_grade'),
	(1361, 'Can delete grade', 445, 'delete_grade'),
	(1363, 'Can add product workflow', 447, 'add_productworkflow'),
	(1365, 'Can change product workflow', 447, 'change_productworkflow'),
	(1367, 'Can delete product workflow', 447, 'delete_productworkflow'),
	(1369, 'Can add accounts', 449, 'add_accounts'),
	(1371, 'Can change accounts', 449, 'change_accounts'),
	(1373, 'Can delete accounts', 449, 'delete_accounts'),
	(1375, 'Can add flow accounts', 451, 'add_flowaccounts'),
	(1377, 'Can change flow accounts', 451, 'change_flowaccounts'),
	(1379, 'Can delete flow accounts', 451, 'delete_flowaccounts'),
	(1381, 'Can add flow users', 453, 'add_flowusers'),
	(1383, 'Can change flow users', 453, 'change_flowusers'),
	(1385, 'Can delete flow users', 453, 'delete_flowusers'),
	(1387, 'Can add risk', 455, 'add_risk'),
	(1389, 'Can change risk', 455, 'change_risk'),
	(1391, 'Can delete risk', 455, 'delete_risk'),
	(1393, 'Can add alerts', 457, 'add_alerts'),
	(1395, 'Can change alerts', 457, 'change_alerts'),
	(1397, 'Can delete alerts', 457, 'delete_alerts'),
	(1399, 'Can add other right', 459, 'add_otherright'),
	(1401, 'Can change other right', 459, 'change_otherright'),
	(1403, 'Can delete other right', 459, 'delete_otherright'),
	(1405, 'Can add fund', 461, 'add_fund'),
	(1407, 'Can change fund', 461, 'change_fund'),
	(1409, 'Can delete fund', 461, 'delete_fund'),
	(1411, 'Can add position risk', 463, 'add_positionrisk'),
	(1413, 'Can change position risk', 463, 'change_positionrisk'),
	(1415, 'Can delete position risk', 463, 'delete_positionrisk'),
	(1417, 'Can add bson risk', 465, 'add_bsonrisk'),
	(1419, 'Can change bson risk', 465, 'change_bsonrisk'),
	(1421, 'Can delete bson risk', 465, 'delete_bsonrisk'),
	(1423, 'Can add queriers', 467, 'add_queriers'),
	(1425, 'Can change queriers', 467, 'change_queriers'),
	(1427, 'Can delete queriers', 467, 'delete_queriers'),
	(1429, 'Can add risk controller', 469, 'add_riskcontroller'),
	(1431, 'Can change risk controller', 469, 'change_riskcontroller'),
	(1433, 'Can delete risk controller', 469, 'delete_riskcontroller'),
	(1435, 'Can add closers', 471, 'add_closers'),
	(1437, 'Can change closers', 471, 'change_closers'),
	(1439, 'Can delete closers', 471, 'delete_closers'),
	(1441, 'Can add category index', 473, 'add_categoryindex'),
	(1443, 'Can change category index', 473, 'change_categoryindex'),
	(1445, 'Can delete category index', 473, 'delete_categoryindex'),
	(1447, 'Can add global risk', 475, 'add_globalrisk'),
	(1449, 'Can change global risk', 475, 'change_globalrisk'),
	(1451, 'Can delete global risk', 475, 'delete_globalrisk'),
	(1453, 'Can add account risk', 477, 'add_accountrisk'),
	(1455, 'Can change account risk', 477, 'change_accountrisk'),
	(1457, 'Can delete account risk', 477, 'delete_accountrisk'),
	(1459, 'Can add c position detail', 479, 'add_cpositiondetail'),
	(1461, 'Can change c position detail', 479, 'change_cpositiondetail'),
	(1463, 'Can delete c position detail', 479, 'delete_cpositiondetail'),
	(1465, 'Can add c order detail', 481, 'add_corderdetail'),
	(1467, 'Can change c order detail', 481, 'change_corderdetail'),
	(1469, 'Can delete c order detail', 481, 'delete_corderdetail'),
	(1471, 'Can add c deal detail', 483, 'add_cdealdetail'),
	(1473, 'Can change c deal detail', 483, 'change_cdealdetail'),
	(1475, 'Can delete c deal detail', 483, 'delete_cdealdetail'),
	(1477, 'Can add c account detail', 485, 'add_caccountdetail'),
	(1479, 'Can change c account detail', 485, 'change_caccountdetail'),
	(1481, 'Can delete c account detail', 485, 'delete_caccountdetail'),
	(1483, 'Can add c order command', 487, 'add_cordercommand'),
	(1485, 'Can change c order command', 487, 'change_cordercommand'),
	(1487, 'Can delete c order command', 487, 'delete_cordercommand'),
	(1489, 'Can add c task detail', 489, 'add_ctaskdetail'),
	(1491, 'Can change c task detail', 489, 'change_ctaskdetail'),
	(1493, 'Can delete c task detail', 489, 'delete_ctaskdetail'),
	(1495, 'Can add c position statics', 491, 'add_cpositionstatics'),
	(1497, 'Can change c position statics', 491, 'change_cpositionstatics'),
	(1499, 'Can delete c position statics', 491, 'delete_cpositionstatics'),
	(1501, 'Can add stock query delivery resp', 493, 'add_stockquerydeliveryresp'),
	(1503, 'Can change stock query delivery resp', 493, 'change_stockquerydeliveryresp'),
	(1505, 'Can delete stock query delivery resp', 493, 'delete_stockquerydeliveryresp'),
	(1507, 'Can add c stk subjects', 495, 'add_cstksubjects'),
	(1509, 'Can change c stk subjects', 495, 'change_cstksubjects'),
	(1511, 'Can delete c stk subjects', 495, 'delete_cstksubjects'),
	(1513, 'Can add c stk compacts', 497, 'add_cstkcompacts'),
	(1515, 'Can change c stk compacts', 497, 'change_cstkcompacts'),
	(1517, 'Can delete c stk compacts', 497, 'delete_cstkcompacts'),
	(1519, 'Can add c credit account detail', 499, 'add_ccreditaccountdetail'),
	(1521, 'Can change c credit account detail', 499, 'change_ccreditaccountdetail'),
	(1523, 'Can delete c credit account detail', 499, 'delete_ccreditaccountdetail'),
	(1525, 'Can add project', 501, 'add_project'),
	(1527, 'Can change project', 501, 'change_project'),
	(1529, 'Can delete project', 501, 'delete_project'),
	(1531, 'Can add project trace', 503, 'add_projecttrace'),
	(1533, 'Can change project trace', 503, 'change_projecttrace'),
	(1535, 'Can delete project trace', 503, 'delete_projecttrace'),
	(1537, 'Can add assets index condition', 505, 'add_assetsindexcondition'),
	(1539, 'Can change assets index condition', 505, 'change_assetsindexcondition'),
	(1541, 'Can delete assets index condition', 505, 'delete_assetsindexcondition');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.auth_user
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.auth_user: ~1 rows (approximately)
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
INSERT INTO `auth_user` VALUES ('1', 'admin', 'admin', '', '', '40bd001563085fc35165329ea1ff5c5ecbdbbeef', '1', '1', '1', '2013-07-23 16:39:36', '2012-11-01 23:07:02');


-- Dumping structure for table ttmgrportal.auth_user_groups
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_403f60f` (`user_id`),
  KEY `auth_user_groups_425ae3c4` (`group_id`),
  CONSTRAINT `group_id_refs_id_f116770` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `user_id_refs_id_7ceef80f` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=466 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.auth_user_groups: ~0 rows (approximately)
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.auth_user_user_permissions
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_403f60f` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `user_id_refs_id_dfbab7d` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.auth_user_user_permissions: ~0 rows (approximately)
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.client_perm
DROP TABLE IF EXISTS `client_perm`;
CREATE TABLE `client_perm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `perm_data` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_perm_403f60f` (`user_id`),
  CONSTRAINT `user_id_refs_id_1dd34a1b` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=450 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.client_perm: ~0 rows (approximately)
/*!40000 ALTER TABLE `client_perm` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_perm` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.details_cftaccountdetail
DROP TABLE IF EXISTS `details_cftaccountdetail`;
CREATE TABLE `details_cftaccountdetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_nPlatformID` int(11) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(64) NOT NULL,
  `m_strPassword` varchar(64) NOT NULL,
  `m_strAccountName` varchar(64) NOT NULL,
  `m_strSubAccount` varchar(64) NOT NULL,
  `m_strTagKey` varchar(128) NOT NULL,
  `m_dPreMortgage` double NOT NULL,
  `m_dPreCredit` double NOT NULL,
  `m_dPreDeposit` double NOT NULL,
  `m_dPreBalance` double NOT NULL,
  `m_dPreMargin` double NOT NULL,
  `m_dInterestBase` double NOT NULL,
  `m_dInterest` double NOT NULL,
  `m_dDeposit` double NOT NULL,
  `m_dWithdraw` double NOT NULL,
  `m_dFrozenMargin` double NOT NULL,
  `m_dFrozenCash` double NOT NULL,
  `m_dFrozenCommission` double NOT NULL,
  `m_dCurrMargin` double NOT NULL,
  `m_dCashIn` double NOT NULL,
  `m_dCommission` double NOT NULL,
  `m_dCloseProfit` double NOT NULL,
  `m_dPositionProfit` double NOT NULL,
  `m_dBalance` double NOT NULL,
  `m_dAvailable` double NOT NULL,
  `m_dWithdrawQuota` double NOT NULL,
  `m_dReserve` double NOT NULL,
  `m_strTradingDay` varchar(64) NOT NULL,
  `m_nSettlementID` int(11) NOT NULL,
  `m_dCredit` double NOT NULL,
  `m_dMortgage` double NOT NULL,
  `m_dExchangeMargin` double NOT NULL,
  `m_dDeliveryMargin` double NOT NULL,
  `m_dExchangeDeliveryMargin` double NOT NULL,
  `m_dTaskFrozenMaergin` double NOT NULL,
  `m_dTaskFrozenCommission` double NOT NULL,
  `m_dRisk` double NOT NULL,
  `m_dNav` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `details_cftaccountdetail_2bd08d28` (`m_strTagKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.details_cftaccountdetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `details_cftaccountdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `details_cftaccountdetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.details_cftdealdetail
DROP TABLE IF EXISTS `details_cftdealdetail`;
CREATE TABLE `details_cftdealdetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_nPlatformID` int(11) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strPassword` varchar(64) NOT NULL,
  `m_strAccountName` varchar(64) NOT NULL,
  `m_strSubAccount` varchar(64) NOT NULL,
  `m_strTagKey` varchar(128) NOT NULL,
  `m_strBrokerID` varchar(64) NOT NULL,
  `m_strInstrumentID` varchar(64) NOT NULL,
  `m_strOrderRef` varchar(64) NOT NULL,
  `m_strAccountID` varchar(64) NOT NULL,
  `m_strExchangeID` varchar(64) NOT NULL,
  `m_strTradeID` varchar(64) NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_strOrderSysID` varchar(64) NOT NULL,
  `m_strParticipantID` varchar(64) NOT NULL,
  `m_strClientID` varchar(64) NOT NULL,
  `m_nTradingRole` int(11) NOT NULL,
  `m_strExchangeInstID` varchar(64) NOT NULL,
  `m_nOffsetFlag` int(11) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_dPrice` double NOT NULL,
  `m_nVolume` int(11) NOT NULL,
  `m_strTradeDate` varchar(64) NOT NULL,
  `m_strTradeTime` varchar(64) NOT NULL,
  `m_nTradeType` int(11) NOT NULL,
  `m_nPriceSource` int(11) NOT NULL,
  `m_strTraderID` varchar(64) NOT NULL,
  `m_strOrderLocalID` varchar(64) NOT NULL,
  `m_strClearingPartID` varchar(64) NOT NULL,
  `m_strBusinessUnit` varchar(64) NOT NULL,
  `m_nSequenceNo` int(11) NOT NULL,
  `m_strTradingDay` varchar(64) NOT NULL,
  `m_nSettlementID` int(11) NOT NULL,
  `m_nBrokerOrderSeq` int(11) NOT NULL,
  `m_nTradeSource` int(11) NOT NULL,
  `m_dComssion` double NOT NULL,
  `m_dTradeAmount` double NOT NULL,
  `m_dCloseProfit` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `details_cftdealdetail_2bd08d28` (`m_strTagKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.details_cftdealdetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `details_cftdealdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `details_cftdealdetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.details_cftdealstatics
DROP TABLE IF EXISTS `details_cftdealstatics`;
CREATE TABLE `details_cftdealstatics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_nPlatformID` int(11) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strPassword` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strAccountName` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strSubAccount` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strTagKey` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strInstrumentID` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strExchangeID` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_nOffsetFlag` int(11) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_dPrice` double NOT NULL,
  `m_nVolume` int(11) NOT NULL,
  `m_dFee` double NOT NULL,
  `m_nTimes` int(11) NOT NULL,
  `m_strTradingDay` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `details_cftdealstatics_2bd08d28` (`m_strTagKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.details_cftdealstatics: 0 rows
/*!40000 ALTER TABLE `details_cftdealstatics` DISABLE KEYS */;
/*!40000 ALTER TABLE `details_cftdealstatics` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.details_cftorderdetail
DROP TABLE IF EXISTS `details_cftorderdetail`;
CREATE TABLE `details_cftorderdetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_nPlatformID` int(11) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strPassword` varchar(64) NOT NULL,
  `m_strAccountName` varchar(64) NOT NULL,
  `m_strSubAccount` varchar(64) NOT NULL,
  `m_strTagKey` varchar(128) NOT NULL,
  `m_strInstrumentID` varchar(64) NOT NULL,
  `m_strOrderRef` varchar(64) NOT NULL,
  `m_strAccountID` varchar(64) NOT NULL,
  `m_nOrderPriceType` int(11) NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_strCombOffsetFlag` varchar(64) NOT NULL,
  `m_strCombHedgeFlag` varchar(64) NOT NULL,
  `m_dLimitPrice` double NOT NULL,
  `m_nVolumeTotalOriginal` int(11) NOT NULL,
  `m_nTimeCondition` int(11) NOT NULL,
  `m_strGTDDate` varchar(64) NOT NULL,
  `m_nVolumeCondition` int(11) NOT NULL,
  `m_nMinVolume` int(11) NOT NULL,
  `m_nContingentCondition` int(11) NOT NULL,
  `m_dStopPrice` double NOT NULL,
  `m_nForceCloseReason` int(11) NOT NULL,
  `m_nIsAutoSuspend` int(11) NOT NULL,
  `m_strBusinessUnit` varchar(64) NOT NULL,
  `m_nRequestID` int(11) NOT NULL,
  `m_strOrderLocalID` varchar(64) NOT NULL,
  `m_strExchangeID` varchar(64) NOT NULL,
  `m_strParticipantID` varchar(64) NOT NULL,
  `m_strClientID` varchar(64) NOT NULL,
  `m_strExchangeInstID` varchar(64) NOT NULL,
  `m_strTraderID` varchar(64) NOT NULL,
  `m_nInstallID` int(11) NOT NULL,
  `m_nOrderSubmitStatus` int(11) NOT NULL,
  `m_nNotifySequence` int(11) NOT NULL,
  `m_strTradingDay` varchar(64) NOT NULL,
  `m_nSettlementID` int(11) NOT NULL,
  `m_strOrderSysID` varchar(64) NOT NULL,
  `m_nOrderSource` int(11) NOT NULL,
  `m_nOrderStatus` int(11) NOT NULL,
  `m_eOrderType` int(11) NOT NULL,
  `m_nVolumeTraded` int(11) NOT NULL,
  `m_nVolumeTotal` int(11) NOT NULL,
  `m_strInsertDate` varchar(64) NOT NULL,
  `m_strInsertTime` varchar(64) NOT NULL,
  `m_strActiveTime` varchar(64) NOT NULL,
  `m_strSuspendTime` varchar(64) NOT NULL,
  `m_strUpdateTime` varchar(64) NOT NULL,
  `m_strCancelTime` varchar(64) NOT NULL,
  `m_strActiveTraderID` varchar(64) NOT NULL,
  `m_strClearingPartID` varchar(64) NOT NULL,
  `m_nSequenceNo` int(11) NOT NULL,
  `m_nFrontID` int(11) NOT NULL,
  `m_nSessionID` int(11) NOT NULL,
  `m_strUserProductInfo` varchar(64) NOT NULL,
  `m_strStatusMsg` varchar(64) NOT NULL,
  `m_nUserForceClose` int(11) NOT NULL,
  `m_strActiveUserID` varchar(64) NOT NULL,
  `m_nBrokerOrderSeq` int(11) NOT NULL,
  `m_strRelativeOrderSysID` varchar(64) NOT NULL,
  `m_nErrorID` int(11) NOT NULL,
  `m_strErrorMsg` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `details_cftorderdetail_2bd08d28` (`m_strTagKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.details_cftorderdetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `details_cftorderdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `details_cftorderdetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.details_cftpositiondetail
DROP TABLE IF EXISTS `details_cftpositiondetail`;
CREATE TABLE `details_cftpositiondetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_nPlatformID` int(11) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(64) NOT NULL,
  `m_strPassword` varchar(64) NOT NULL,
  `m_strAccountName` varchar(64) NOT NULL,
  `m_strSubAccount` varchar(64) NOT NULL,
  `m_strTagKey` varchar(128) NOT NULL,
  `m_strInstrumentID` varchar(64) NOT NULL,
  `m_strBrokerID` varchar(64) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_strOpenDate` varchar(64) NOT NULL,
  `m_strTradeID` varchar(64) NOT NULL,
  `m_nVolume` int(11) NOT NULL,
  `m_dOpenPrice` double NOT NULL,
  `m_strTradingDay` varchar(64) NOT NULL,
  `m_nSettlementID` int(11) NOT NULL,
  `m_nTradeType` int(11) NOT NULL,
  `m_strCombInstrumentID` varchar(64) NOT NULL,
  `m_strExchangeID` varchar(64) NOT NULL,
  `m_dCloseProfitByDate` double NOT NULL,
  `m_dCloseProfitByTrade` double NOT NULL,
  `m_dPositionProfitByDate` double NOT NULL,
  `m_dPositionProfitByTrade` double NOT NULL,
  `m_dMargin` double NOT NULL,
  `m_dExchMargin` double NOT NULL,
  `m_dMarginRateByMoney` double NOT NULL,
  `m_dMarginRateByVolume` double NOT NULL,
  `m_dLastSettlementPrice` double NOT NULL,
  `m_dSettlementPrice` double NOT NULL,
  `m_nCloseVolume` int(11) NOT NULL,
  `m_dCloseAmount` double NOT NULL,
  `m_dPositionProfit` double NOT NULL,
  `m_dFloatProfit` double NOT NULL,
  `m_dCloseProfit` double NOT NULL,
  `m_dOpenCost` double NOT NULL,
  `m_dPositionCost` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `details_cftpositiondetail_2bd08d28` (`m_strTagKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.details_cftpositiondetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `details_cftpositiondetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `details_cftpositiondetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.details_cftpositionstatics
DROP TABLE IF EXISTS `details_cftpositionstatics`;
CREATE TABLE `details_cftpositionstatics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_nPlatformID` int(11) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strPassword` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strAccountName` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strSubAccount` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strTagKey` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_strInstrumentID` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_nTodayPosition` int(11) NOT NULL DEFAULT '0',
  `m_nTodayTaskOpenFrozen` int(11) NOT NULL DEFAULT '0',
  `m_nTodayTaskCloseFrozen` int(11) NOT NULL DEFAULT '0',
  `m_nTodayCloseFrozen` int(11) NOT NULL DEFAULT '0',
  `m_dTodayOpenCost` double NOT NULL DEFAULT '0',
  `m_dTodayPositionCost` double NOT NULL DEFAULT '0',
  `m_dTodayAvgPrice` double NOT NULL DEFAULT '0',
  `m_dTodayPositionProfit` double NOT NULL DEFAULT '0',
  `m_dTodayFloatProfit` double NOT NULL DEFAULT '0',
  `m_dTodayOpenPrice` double NOT NULL DEFAULT '0',
  `m_nHistoryPosition` int(11) NOT NULL DEFAULT '0',
  `m_nHistoryTaskCloseFrozen` int(11) NOT NULL DEFAULT '0',
  `m_nHistoryCloseFrozen` int(11) NOT NULL DEFAULT '0',
  `m_dHistoryOpenCost` double NOT NULL DEFAULT '0',
  `m_dHistoryPositionCost` double NOT NULL DEFAULT '0',
  `m_dHistoryAvgPrice` double NOT NULL DEFAULT '0',
  `m_dHistoryPositionProfit` double NOT NULL DEFAULT '0',
  `m_dHistoryFloatProfit` double NOT NULL DEFAULT '0',
  `m_dHistoryOpenPrice` double NOT NULL DEFAULT '0',
  `m_strTradingDay` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `m_dMargin` double NOT NULL DEFAULT '0',
  `m_dClostFloat` double NOT NULL DEFAULT '0',
  `m_nOpenTimes` int(11) NOT NULL DEFAULT '0',
  `m_nOpenVolume` int(11) NOT NULL DEFAULT '0',
  `m_nCancelTimes` int(11) NOT NULL DEFAULT '0',
  `m_dTodayValue` double NOT NULL DEFAULT '0',
  `m_dHistoryValue` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `details_cftpositionstatics_2bd08d28` (`m_strTagKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.details_cftpositionstatics: 0 rows
/*!40000 ALTER TABLE `details_cftpositionstatics` DISABLE KEYS */;
/*!40000 ALTER TABLE `details_cftpositionstatics` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.details_settlementinfo
DROP TABLE IF EXISTS `details_settlementinfo`;
CREATE TABLE `details_settlementinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strBrokerID` varchar(32) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(64) NOT NULL,
  `m_strSubAccount` varchar(64) NOT NULL,
  `strTradingDate` varchar(64) NOT NULL,
  `isLocal` smallint(6) NOT NULL,
  `textSettlementInfo` longtext NOT NULL,
  `m_nBrokerType` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `details_settlementinfo_7b8a5ef2` (`m_nPlatformID`),
  KEY `details_settlementinfo_26705185` (`m_strBrokerID`),
  KEY `details_settlementinfo_15a55ffe` (`m_nAccountType`),
  KEY `details_settlementinfo_2c778be4` (`m_strAccountID`),
  KEY `details_settlementinfo_512261c2` (`m_strSubAccount`),
  KEY `details_settlementinfo_3e5b5dcd` (`strTradingDate`)
) ENGINE=InnoDB AUTO_INCREMENT=12032 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.details_settlementinfo: ~0 rows (approximately)
/*!40000 ALTER TABLE `details_settlementinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `details_settlementinfo` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.django_content_type
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=506 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.django_content_type: ~0 rows (approximately)
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` (`id`, `name`, `app_label`, `model`) VALUES
	(333, 'permission', 'auth', 'permission'),
	(335, 'group', 'auth', 'group'),
	(337, 'user', 'auth', 'user'),
	(339, 'content type', 'contenttypes', 'contenttype'),
	(341, 'session', 'sessions', 'session'),
	(343, 'site', 'sites', 'site'),
	(345, 'viewer', 'usrmgr', 'viewer'),
	(347, 'order board', 'usrmgr', 'orderboard'),
	(349, 'user status', 'usrmgr', 'userstatus'),
	(351, 'user config', 'usrmgr', 'userconfig'),
	(353, 'user', 'usrmgr', 'user'),
	(355, 'stock category', 'account', 'stockcategory'),
	(357, 'stock category item', 'account', 'stockcategoryitem'),
	(359, 'stock', 'account', 'stock'),
	(361, 'account', 'account', 'account'),
	(363, 'sub account', 'account', 'subaccount'),
	(365, 'deposit percent', 'account', 'depositpercent'),
	(367, 'stop loss', 'account', 'stoploss'),
	(369, 'compliance checks', 'account', 'compliancechecks'),
	(371, 'bank financial net', 'account', 'bankfinancialnet'),
	(373, 'initial assets', 'account', 'initialassets'),
	(375, 'trend invest contract', 'account', 'trendinvestcontract'),
	(377, 'hedging combination', 'account', 'hedgingcombination'),
	(379, 'sub pre balance modify', 'account', 'subprebalancemodify'),
	(381, 'stoploss rules', 'account', 'stoplossrules'),
	(383, 'log', 'logmgr', 'log'),
	(385, 'platform', 'tradeplatform', 'platform'),
	(387, 'broker', 'tradeplatform', 'broker'),
	(389, 'idc line', 'tradeplatform', 'idcline'),
	(391, 'server line', 'tradeplatform', 'serverline'),
	(393, 'task', 'tasks', 'task'),
	(395, 'msg', 'msgs', 'msg'),
	(397, 'c ft position detail', 'details', 'cftpositiondetail'),
	(399, 'c ft deal detail', 'details', 'cftdealdetail'),
	(401, 'c ft order detail', 'details', 'cftorderdetail'),
	(403, 'c ft account detail', 'details', 'cftaccountdetail'),
	(405, 'settlement info', 'details', 'settlementinfo'),
	(407, 'perm', 'client', 'perm'),
	(409, 'log system log', 'system_monitor', 'logsystemlog'),
	(411, 'log system info', 'system_monitor', 'logsysteminfo'),
	(413, 'smtp setting', 'system_monitor', 'smtpsetting'),
	(415, 'mail receivers', 'system_monitor', 'mailreceivers'),
	(417, 'alarm values', 'system_monitor', 'alarmvalues'),
	(419, 'orders monitor', 'transaction_monitor', 'ordersmonitor'),
	(421, 'positions monitor', 'transaction_monitor', 'positionsmonitor'),
	(423, 'migration history', 'south', 'migrationhistory'),
	(425, 'market source', 'market_source', 'marketsource'),
	(427, 'stock source', 'market_source', 'stocksource'),
	(429, 'role perm', 'roles', 'roleperm'),
	(431, '客户端权限配置', 'roles', 'clientconfigs'),
	(433, 'menu', 'roles', 'menu'),
	(435, 'workflow', 'workflow', 'workflow'),
	(437, 'nodes', 'workflow', 'nodes'),
	(439, 'assets index', 'product', 'assetsindex'),
	(441, 'product', 'product', 'product'),
	(443, 'grade date history', 'product', 'gradedatehistory'),
	(445, 'grade', 'product', 'grade'),
	(447, 'product workflow', 'product', 'productworkflow'),
	(449, 'accounts', 'product', 'accounts'),
	(451, 'flow accounts', 'product', 'flowaccounts'),
	(453, 'flow users', 'product', 'flowusers'),
	(455, 'risk', 'product', 'risk'),
	(457, 'alerts', 'product', 'alerts'),
	(459, 'other right', 'product', 'otherright'),
	(461, 'fund', 'product', 'fund'),
	(463, 'position risk', 'product', 'positionrisk'),
	(465, 'bson risk', 'product', 'bsonrisk'),
	(467, 'queriers', 'product', 'queriers'),
	(469, 'risk controller', 'product', 'riskcontroller'),
	(471, 'closers', 'product', 'closers'),
	(473, 'category index', 'product', 'categoryindex'),
	(475, 'global risk', 'risk_control', 'globalrisk'),
	(477, 'account risk', 'risk_control', 'accountrisk'),
	(479, 'c position detail', 'idata', 'cpositiondetail'),
	(481, 'c order detail', 'idata', 'corderdetail'),
	(483, 'c deal detail', 'idata', 'cdealdetail'),
	(485, 'c account detail', 'idata', 'caccountdetail'),
	(487, 'c order command', 'idata', 'cordercommand'),
	(489, 'c task detail', 'idata', 'ctaskdetail'),
	(491, 'c position statics', 'idata', 'cpositionstatics'),
	(493, 'stock query delivery resp', 'idata', 'stockquerydeliveryresp'),
	(495, 'c stk subjects', 'idata', 'cstksubjects'),
	(497, 'c stk compacts', 'idata', 'cstkcompacts'),
	(499, 'c credit account detail', 'idata', 'ccreditaccountdetail'),
	(501, 'project', 'project', 'project'),
	(503, 'project trace', 'project_trace', 'projecttrace'),
	(505, 'assets index condition', 'product', 'assetsindexcondition');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.django_session
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_3da3d3d8` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.django_session: ~0 rows (approximately)
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.django_site
DROP TABLE IF EXISTS `django_site`;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.django_site: ~0 rows (approximately)
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.file_accountpositionseparationfile
DROP TABLE IF EXISTS `file_accountpositionseparationfile`;
CREATE TABLE `file_accountpositionseparationfile` (
  `userfile_ptr_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`userfile_ptr_id`),
  KEY `file_accountpositionseparationfile_6f2fe10e` (`account_id`),
  CONSTRAINT `account_id_refs_id_16f8b7cb` FOREIGN KEY (`account_id`) REFERENCES `account_subaccount` (`id`),
  CONSTRAINT `userfile_ptr_id_refs_id_4a424d6d` FOREIGN KEY (`userfile_ptr_id`) REFERENCES `file_userfile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.file_accountpositionseparationfile: ~0 rows (approximately)
/*!40000 ALTER TABLE `file_accountpositionseparationfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_accountpositionseparationfile` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.file_uploadedfile
DROP TABLE IF EXISTS `file_uploadedfile`;
CREATE TABLE `file_uploadedfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.file_uploadedfile: ~0 rows (approximately)
/*!40000 ALTER TABLE `file_uploadedfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_uploadedfile` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.file_userconversionratiofile
DROP TABLE IF EXISTS `file_userconversionratiofile`;
CREATE TABLE `file_userconversionratiofile` (
  `userfile_ptr_id` int(11) NOT NULL,
  `tradingDay` date NOT NULL,
  PRIMARY KEY (`userfile_ptr_id`),
  CONSTRAINT `userfile_ptr_id_refs_id_57ce1529` FOREIGN KEY (`userfile_ptr_id`) REFERENCES `file_userfile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.file_userconversionratiofile: ~0 rows (approximately)
/*!40000 ALTER TABLE `file_userconversionratiofile` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_userconversionratiofile` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.file_userfile
DROP TABLE IF EXISTS `file_userfile`;
CREATE TABLE `file_userfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `createtime` datetime NOT NULL,
  `file` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `file_userfile_403f60f` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.file_userfile: ~0 rows (approximately)
/*!40000 ALTER TABLE `file_userfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_userfile` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_caccountdetail
DROP TABLE IF EXISTS `idata_caccountdetail`;
CREATE TABLE `idata_caccountdetail` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_dInstrumentValue` double NOT NULL,
  `m_dPreBalance` double NOT NULL,
  `m_dInitBalance` double NOT NULL,
  `m_dCashIn` double NOT NULL,
  `m_dPreCredit` double NOT NULL,
  `m_strFundProductName` varchar(128) NOT NULL,
  `m_dWithdraw` double NOT NULL,
  `m_dCloseProfit` double NOT NULL,
  `m_dDeposit` double NOT NULL,
  `m_dBalance` double NOT NULL,
  `m_strStatus` varchar(128) NOT NULL,
  `m_dAvailable` double NOT NULL,
  `m_dCommission` double NOT NULL,
  `m_dFrozenCommission` double NOT NULL,
  `m_dCredit` double NOT NULL,
  `m_dPreMortgage` double NOT NULL,
  `m_dPositionProfit` double NOT NULL,
  `m_dCurrMargin` double NOT NULL,
  `m_dNav` double NOT NULL,
  `m_dAssetBalance` double NOT NULL,
  `m_dMaxMarginRate` double NOT NULL,
  `m_bStoped` tinyint(1) NOT NULL,
  `m_dFrozenCash` double NOT NULL,
  `m_nFundProductID` int(11) NOT NULL,
  `m_dMortgage` double NOT NULL,
  `m_dInitCloseMoney` double NOT NULL,
  `m_dFrozenMargin` double NOT NULL,
  `m_dRisk` double NOT NULL,
  `m_strAccountName` varchar(128) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strSZAccount` varchar(128) NOT NULL,
  `m_strSHAccount` varchar(128) NOT NULL,
  `m_strSubAccount` varchar(128) NOT NULL,
  `m_strPassword` varchar(128) NOT NULL,
  `m_nBrokerType` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(128) NOT NULL,
  `m_strBrokerName` varchar(128) NOT NULL,
  `m_strBankNo` varchar(128) NOT NULL,
  `m_strBrokerID` varchar(32) NOT NULL,
  `m_iStatus` int(11) DEFAULT NULL,
  `m_dFetchBalance` double NOT NULL,
  `m_strOpenDate` varchar(128) DEFAULT NULL,
  `m_trade_date` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_caccountdetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_caccountdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_caccountdetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_ccreditaccountdetail
DROP TABLE IF EXISTS `idata_ccreditaccountdetail`;
CREATE TABLE `idata_ccreditaccountdetail` (
  `m_priKey_tag` varchar(127) NOT NULL,
  `m_trade_date` varchar(10) DEFAULT NULL,
  `m_dFinEnableBalance` double DEFAULT NULL,
  `m_dUsedBailBalance` double DEFAULT NULL,
  `m_dOtherFare` double DEFAULT NULL,
  `m_dFinMaxQuota` double DEFAULT NULL,
  `m_dSloMaxQuota` double DEFAULT NULL,
  `m_dSloCompactBalance` double DEFAULT NULL,
  `m_dFundAsset` double DEFAULT NULL,
  `m_dFinCompactFare` double DEFAULT NULL,
  `m_dSloEnrepaidBalance` double DEFAULT NULL,
  `m_dSloCompactFare` double DEFAULT NULL,
  `m_dEnableBailBalance` double DEFAULT NULL,
  `m_dAssureAsset` double DEFAULT NULL,
  `m_dFinEnbuyBalance` double DEFAULT NULL,
  `m_dSloUsedQuota` double DEFAULT NULL,
  `m_dFinIncome` double DEFAULT NULL,
  `m_dTotalDebit` double DEFAULT NULL,
  `m_dAssureEnbuyBalance` double DEFAULT NULL,
  `m_dFinMarketValue` double DEFAULT NULL,
  `m_dFinCompactBalance` double DEFAULT NULL,
  `m_dFinEnableQuota` double DEFAULT NULL,
  `m_dFinUsedQuota` double DEFAULT NULL,
  `m_dFinCompactInterest` double DEFAULT NULL,
  `m_dSloMarketValue` double DEFAULT NULL,
  `m_dSloCompactInterest` double DEFAULT NULL,
  `m_dSloIncome` double DEFAULT NULL,
  `m_dFinEnrepaidBalance` double DEFAULT NULL,
  `m_dInstrumentValue` double NOT NULL,
  `m_dPreBalance` double NOT NULL,
  `m_dInitBalance` double NOT NULL,
  `m_dCashIn` double NOT NULL,
  `m_dPreCredit` double NOT NULL,
  `m_dWithdraw` double NOT NULL,
  `m_dCloseProfit` double DEFAULT NULL,
  `m_dDeposit` double NOT NULL,
  `m_dCommission` double DEFAULT NULL,
  `m_strStatus` varchar(128) DEFAULT NULL,
  `m_dAvailable` double DEFAULT NULL,
  `m_dBalance` double DEFAULT NULL,
  `m_dFrozenCommission` double DEFAULT NULL,
  `m_dFetchBalance` double NOT NULL,
  `m_dCredit` double NOT NULL,
  `m_dPreMortgage` double NOT NULL,
  `m_dPositionProfit` double DEFAULT NULL,
  `m_strOpenDate` varchar(128) DEFAULT NULL,
  `m_dCurrMargin` double DEFAULT NULL,
  `m_dNav` double NOT NULL,
  `m_dAssetBalance` double NOT NULL,
  `m_dMaxMarginRate` double DEFAULT NULL,
  `m_dFrozenCash` double DEFAULT NULL,
  `m_strTradingDate` varchar(128) DEFAULT NULL,
  `m_dMortgage` double NOT NULL,
  `m_dInitCloseMoney` double NOT NULL,
  `m_dFrozenMargin` double DEFAULT NULL,
  `m_dRisk` double DEFAULT NULL,
  `m_strAccountName` varchar(128) DEFAULT NULL,
  `m_strBankNo` varchar(128) DEFAULT NULL,
  `m_strSZAccount` varchar(128) DEFAULT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strBrokerID` varchar(128) DEFAULT NULL,
  `m_strSubAccount` varchar(128) DEFAULT NULL,
  `m_strPassword` varchar(128) DEFAULT NULL,
  `m_nBrokerType` int(11) DEFAULT NULL,
  `m_nAccountType` int(11) DEFAULT NULL,
  `m_strAccountID` varchar(128) DEFAULT NULL,
  `m_strBrokerName` varchar(128) DEFAULT NULL,
  `m_addresses` varchar(1000) DEFAULT NULL,
  `m_iStatus` int(11) NOT NULL,
  `m_strSHAccount` varchar(128) DEFAULT NULL,
  `m_dUnderlyMarketValue` double DEFAULT NULL,
  `m_dSloUsedBail` double DEFAULT NULL,
  `m_dFinUsedBail` double DEFAULT NULL,
  `m_dSloEnableQuota` double DEFAULT NULL,
  `m_dPerAssurescaleValue` double DEFAULT NULL,
  `m_dBuySecuRepayFrozenMargin` double NOT NULL DEFAULT '0',
  `m_dBuySecuRepayFrozenCommission` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`m_priKey_tag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_ccreditaccountdetail: 0 rows
/*!40000 ALTER TABLE `idata_ccreditaccountdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_ccreditaccountdetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_cdealdetail
DROP TABLE IF EXISTS `idata_cdealdetail`;
CREATE TABLE `idata_cdealdetail` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_nOffsetFlag` int(11) NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_strFundProductName` varchar(128) NOT NULL,
  `m_eXtHedgeType` int(11) NOT NULL,
  `m_nRequestId` int(11) NOT NULL,
  `m_nGroupID` int(11) NOT NULL,
  `m_eTraderType` int(11) NOT NULL,
  `m_strSessionTag` varchar(128) NOT NULL,
  `m_nProperty` int(11) NOT NULL,
  `m_strUser` varchar(128) NOT NULL,
  `m_nCommandID` int(11) NOT NULL,
  `m_strDate` varchar(128) NOT NULL,
  `m_strInterfaceId` varchar(128) NOT NULL,
  `m_strSource` varchar(128) NOT NULL,
  `m_nFundProductID` int(11) NOT NULL,
  `m_nVolume` int(11) NOT NULL,
  `m_strOrderSysID` varchar(128) NOT NULL,
  `m_strProductID` varchar(128) NOT NULL,
  `m_strInstrumentID` varchar(128) NOT NULL,
  `m_strTradeID` varchar(128) NOT NULL,
  `m_nTaskId` int(11) NOT NULL,
  `m_strTradeTime` varchar(128) NOT NULL,
  `m_strOrderRef` varchar(128) NOT NULL,
  `m_dPrice` double NOT NULL,
  `m_dTradeAmount` double NOT NULL,
  `m_strExchangeID` varchar(128) NOT NULL,
  `m_strProductName` varchar(128) NOT NULL,
  `m_strInstrumentName` varchar(128) NOT NULL,
  `m_dComssion` double NOT NULL,
  `m_strTradeDate` varchar(128) NOT NULL,
  `m_strAccountName` varchar(128) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strSZAccount` varchar(128) NOT NULL,
  `m_strSHAccount` varchar(128) NOT NULL,
  `m_strSubAccount` varchar(128) NOT NULL,
  `m_strPassword` varchar(128) NOT NULL,
  `m_nBrokerType` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(128) NOT NULL,
  `m_strBrokerName` varchar(128) NOT NULL,
  `m_strBankNo` varchar(128) NOT NULL,
  `m_strExchangeName` varchar(128) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_strBrokerID` varchar(32) NOT NULL,
  `m_nOrderPriceType` int(11) NOT NULL,
  `m_strOptName` varchar(128) NOT NULL,
  `m_iStatus` int(11) DEFAULT NULL,
  `m_eOrderType` int(11) DEFAULT NULL,
  `m_trade_date` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_cdealdetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_cdealdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_cdealdetail` ENABLE KEYS */;


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `idata_criskcontrolmsg`
-- ----------------------------
DROP TABLE IF EXISTS `idata_criskcontrolmsg`;
CREATE TABLE `idata_criskcontrolmsg` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `command_id` bigint(20) NOT NULL,
  `stoploss_msg` longtext,
  `m_trade_date` varchar(10),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `idata_cordercommand`;
CREATE TABLE `idata_cordercommand` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_trade_date` varchar(10) NOT NULL,
  `m_nProductID` int(11) NOT NULL,
  `m_eStatus` int(11) NOT NULL,
  `m_nDeltNum` int(11) NOT NULL,
  `m_nValidTimeStart` int(11) NOT NULL,
  `m_eXtOrderType` int(11) NOT NULL,
  `m_startTime` int(11) NOT NULL,
  `m_eTradeType` int(11) NOT NULL,
  `m_nID` int(11) NOT NULL,
  `m_nValidTimeEnd` int(11) NOT NULL,
  `m_stockParams` longtext NOT NULL,
  `m_vUsers` varchar(1000) NOT NULL,
  `m_nWorkFlowID` int(11) NOT NULL,
  `m_bIsStopLoss` tinyint(1) NOT NULL,
  `m_dDeltAmount` double NOT NULL,
  `m_endTime` int(11) NOT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_cordercommand: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_cordercommand` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_cordercommand` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_corderdetail
DROP TABLE IF EXISTS `idata_corderdetail`;
CREATE TABLE `idata_corderdetail` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_strInsertDate` varchar(128) NOT NULL,
  `m_nVolumeTraded` int(11) NOT NULL,
  `m_strProductName` varchar(128) NOT NULL,
  `m_nVolumeTotal` int(11) NOT NULL,
  `m_nOrderStatus` int(11) NOT NULL,
  `m_strExchangeID` varchar(128) NOT NULL,
  `m_nOffsetFlag` int(11) NOT NULL,
  `m_nErrorID` int(11) NOT NULL,
  `m_nTaskId` int(11) NOT NULL,
  `m_nOrderSubmitStatus` int(11) NOT NULL,
  `m_dFrozenCommission` double NOT NULL,
  `m_strInstrumentName` varchar(128) NOT NULL,
  `m_nFrontID` int(11) NOT NULL,
  `m_dTradedPrice` double NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_strOrderSysID` varchar(128) NOT NULL,
  `m_dFrozenMargin` double NOT NULL,
  `m_strInstrumentID` varchar(128) NOT NULL,
  `m_nOrderPriceType` int(11) NOT NULL,
  `m_strOrderRef` varchar(128) NOT NULL,
  `m_dLimitPrice` double NOT NULL,
  `m_strExchangeName` varchar(128) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_nSessionID` int(11) NOT NULL,
  `m_strErrorMsg` varchar(128) NOT NULL,
  `m_strInsertTime` varchar(128) NOT NULL,
  `m_strProductID` varchar(128) NOT NULL,
  `m_nVolumeTotalOriginal` int(11) NOT NULL,
  `m_strFundProductName` varchar(128) NOT NULL,
  `m_eXtHedgeType` int(11) NOT NULL,
  `m_nRequestId` int(11) NOT NULL,
  `m_nGroupID` int(11) NOT NULL,
  `m_eTraderType` int(11) NOT NULL,
  `m_strSessionTag` varchar(128) NOT NULL,
  `m_nProperty` int(11) NOT NULL,
  `m_strUser` varchar(128) NOT NULL,
  `m_nCommandID` int(11) NOT NULL,
  `m_strDate` varchar(128) NOT NULL,
  `m_strInterfaceId` varchar(128) NOT NULL,
  `m_strSource` varchar(128) NOT NULL,
  `m_nFundProductID` int(11) NOT NULL,
  `m_strAccountName` varchar(128) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strSZAccount` varchar(128) NOT NULL,
  `m_strSHAccount` varchar(128) NOT NULL,
  `m_strSubAccount` varchar(128) NOT NULL,
  `m_strPassword` varchar(128) NOT NULL,
  `m_nBrokerType` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(128) NOT NULL,
  `m_strBrokerName` varchar(128) NOT NULL,
  `m_strBankNo` varchar(128) NOT NULL,
  `m_strBrokerID` varchar(32) NOT NULL,
  `m_strOptName` varchar(128) NOT NULL,
  `m_iStatus` int(11) DEFAULT NULL,
  `m_eOrderType` int(11) DEFAULT NULL,
  `m_dCancelAmount` double DEFAULT NULL,
  `m_trade_date` varchar(31) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_corderdetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_corderdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_corderdetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_cpositiondetail
DROP TABLE IF EXISTS `idata_cpositiondetail`;
CREATE TABLE `idata_cpositiondetail` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_dInstrumentValue` double NOT NULL,
  `m_strProductName` varchar(128) NOT NULL,
  `m_nYesterdayVolume` int(11) NOT NULL,
  `m_strStockHolder` varchar(128) NOT NULL,
  `m_dFloatProfit` double NOT NULL,
  `m_dPositionCost` double NOT NULL,
  `m_nFrozenVolume` int(11) NOT NULL,
  `m_strExchangeID` varchar(128) NOT NULL,
  `m_dCloseProfit` double NOT NULL,
  `m_dMarketValue` double NOT NULL,
  `m_nOnRoadVolume` int(11) NOT NULL,
  `m_dMargin` double NOT NULL,
  `m_strInstrumentName` varchar(128) NOT NULL,
  `m_dLastSettlementPrice` double NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_nVolume` int(11) NOT NULL,
  `m_dPositionProfit` double NOT NULL,
  `m_strInstrumentID` varchar(128) NOT NULL,
  `m_strTradingDay` varchar(128) NOT NULL,
  `m_dOpenPrice` double NOT NULL,
  `m_strExchangeName` varchar(128) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_nCanUseVolume` int(11) NOT NULL,
  `m_dOpenCost` double NOT NULL,
  `m_dSettlementPrice` double NOT NULL,
  `m_bIsToday` tinyint(1) NOT NULL,
  `m_strTradeID` varchar(128) NOT NULL,
  `m_dCloseAmount` double NOT NULL,
  `m_strProductID` varchar(128) NOT NULL,
  `m_strFundProductName` varchar(128) NOT NULL,
  `m_eXtHedgeType` int(11) NOT NULL,
  `m_nRequestId` int(11) NOT NULL,
  `m_nGroupID` int(11) NOT NULL,
  `m_eTraderType` int(11) NOT NULL,
  `m_strSessionTag` varchar(128) NOT NULL,
  `m_nProperty` int(11) NOT NULL,
  `m_strUser` varchar(128) NOT NULL,
  `m_nCommandID` int(11) NOT NULL,
  `m_strDate` varchar(128) NOT NULL,
  `m_strInterfaceId` varchar(128) NOT NULL,
  `m_strSource` varchar(128) NOT NULL,
  `m_nFundProductID` int(11) NOT NULL,
  `m_strAccountName` varchar(128) NOT NULL,
  `m_nBrokerID` int(11) NOT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strSZAccount` varchar(128) NOT NULL,
  `m_strSHAccount` varchar(128) NOT NULL,
  `m_strSubAccount` varchar(128) NOT NULL,
  `m_strPassword` varchar(128) NOT NULL,
  `m_nBrokerType` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(128) NOT NULL,
  `m_strBrokerName` varchar(128) NOT NULL,
  `m_strBankNo` varchar(128) NOT NULL,
  `m_nCloseVolume` int(11) NOT NULL,
  `m_strBrokerID` varchar(32) NOT NULL,
  `m_dProfitRate` double NOT NULL,
  `m_iStatus` int(11) DEFAULT NULL,
  `m_eOrderType` int(11) DEFAULT NULL,
  `m_dLastPrice` double DEFAULT NULL,
  `m_strOpenDate` varchar(128) DEFAULT NULL,
  `m_trade_date` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_cpositiondetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_cpositiondetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_cpositiondetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_cpositionstatics
DROP TABLE IF EXISTS `idata_cpositionstatics`;
CREATE TABLE `idata_cpositionstatics` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_trade_date` varchar(10) NOT NULL,
  `m_dProfitRate` double NOT NULL,
  `m_dInstrumentValue` double NOT NULL,
  `m_nCanCloseVol` int(11) NOT NULL,
  `m_dUsedMargin` double NOT NULL,
  `m_nYesterdayVolume` int(11) NOT NULL,
  `m_strStockHolder` varchar(128) NOT NULL,
  `m_dFloatProfit` double NOT NULL,
  `m_dPositionCost` double NOT NULL,
  `m_nFrozenVolume` int(11) NOT NULL,
  `m_strExchangeID` varchar(128) NOT NULL,
  `m_nCancelTimes` int(11) NOT NULL,
  `m_nOnRoadVolume` int(11) NOT NULL,
  `m_dFrozenCommission` double NOT NULL,
  `m_strInstrumentName` varchar(128) NOT NULL,
  `m_nDirection` int(11) NOT NULL,
  `m_nOpenTimes` int(11) NOT NULL,
  `m_dPositionProfit` double NOT NULL,
  `m_nCanUseVolume` int(11) NOT NULL,
  `m_dFrozenMargin` double NOT NULL,
  `m_strInstrumentID` varchar(128) NOT NULL,
  `m_dUsedCommission` double NOT NULL,
  `m_dOpenPrice` double NOT NULL,
  `m_nOpenVolume` int(11) NOT NULL,
  `m_strExchangeName` varchar(128) NOT NULL,
  `m_nHedgeFlag` int(11) NOT NULL,
  `m_dOpenCost` double NOT NULL,
  `m_dSettlementPrice` double NOT NULL,
  `m_bIsToday` tinyint(1) NOT NULL,
  `m_dAvgPrice` double NOT NULL,
  `m_nPosition` int(11) NOT NULL,
  `m_eXtHedgeType` int(11) NOT NULL,
  `m_strProductID` varchar(128) NOT NULL,
  `m_strAccountName` varchar(128) NOT NULL,
  `m_strBankNo` varchar(128) NOT NULL,
  `m_strSZAccount` varchar(128) NOT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strBrokerID` varchar(128) NOT NULL,
  `m_strSubAccount` varchar(128) NOT NULL,
  `m_strPassword` varchar(128) NOT NULL,
  `m_nBrokerType` int(11) NOT NULL,
  `m_nAccountType` int(11) NOT NULL,
  `m_strAccountID` varchar(128) NOT NULL,
  `m_strBrokerName` varchar(128) NOT NULL,
  `m_addresses` varchar(1000) NOT NULL,
  `m_iStatus` int(11) DEFAULT NULL,
  `m_strSHAccount` varchar(128) NOT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_cpositionstatics: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_cpositionstatics` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_cpositionstatics` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_cstatement
DROP TABLE IF EXISTS `idata_cstatement`;
CREATE TABLE `idata_cstatement` (
  `m_dIOGold` double DEFAULT NULL,
  `m_dEBalance` double DEFAULT NULL,
  `m_priKey_tag` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `m_strDate` varchar(16) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `m_dBBalance` double DEFAULT NULL,
  `m_dDelCommission` double DEFAULT NULL,
  `m_dAvailCap` double DEFAULT NULL,
  `m_dCloseProfit` double DEFAULT NULL COMMENT '?',
  `m_dMortgage` double DEFAULT NULL,
  `m_dRisk` double DEFAULT NULL,
  `m_dPositionProfit` double DEFAULT NULL,
  `m_dClientBalance` double DEFAULT NULL,
  `m_dAddToCash` double DEFAULT NULL COMMENT '?',
  `m_dCommission` double DEFAULT NULL,
  `m_dOccupyMargin` double DEFAULT NULL,
  `m_dBaseMargin` double DEFAULT NULL,
  `m_dChangeAmout` double DEFAULT NULL,
  `m_dDelMargin` double DEFAULT NULL,
  `m_trade_date` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`,`m_strDate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table ttmgrportal.idata_cstatement: 0 rows
/*!40000 ALTER TABLE `idata_cstatement` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_cstatement` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_cstkcompacts
DROP TABLE IF EXISTS `idata_cstkcompacts`;
CREATE TABLE `idata_cstkcompacts` (
  `m_priKey_tag` varchar(127) NOT NULL,
  `m_trade_date` varchar(10) DEFAULT NULL,
  `m_nOpenDate` int(11) DEFAULT NULL,
  `m_dUsedBailBalance` double DEFAULT NULL,
  `m_dCompactInterest` double DEFAULT NULL,
  `m_dRealCompactFare` double DEFAULT NULL,
  `m_dCrdtRatio` double DEFAULT NULL,
  `m_dPrice` double DEFAULT NULL,
  `m_strExchangeID` varchar(128) DEFAULT NULL,
  `m_dYearRate` double DEFAULT NULL,
  `m_strDateClear` varchar(128) DEFAULT NULL,
  `m_dRepaidInterest` double DEFAULT NULL,
  `m_strEntrustNo` varchar(128) DEFAULT NULL,
  `m_eCompactType` int(11) DEFAULT NULL,
  `m_nRealCompactVol` int(11) DEFAULT NULL,
  `m_strInstrumentName` varchar(128) DEFAULT NULL,
  `m_dBusinessFare` double DEFAULT NULL,
  `m_nRetEndDate` int(11) DEFAULT NULL,
  `m_strCompactId` varchar(128) DEFAULT NULL,
  `m_nRepaidVol` int(11) DEFAULT NULL,
  `m_dRealCompactInterest` double DEFAULT NULL,
  `m_strInstrumentID` varchar(128) DEFAULT NULL,
  `m_dBusinessBalance` double DEFAULT NULL,
  `m_eCompactStatus` int(11) DEFAULT NULL,
  `m_strExchangeName` varchar(128) DEFAULT NULL,
  `m_strPositionStr` varchar(128) DEFAULT NULL,
  `m_dEntrustPrice` double DEFAULT NULL,
  `m_dRepaidBalance` double DEFAULT NULL,
  `m_dRealCompactBalance` double DEFAULT NULL,
  `m_nEntrustVol` int(11) DEFAULT NULL,
  `m_strFundProductName` varchar(128) DEFAULT NULL,
  `m_eXtHedgeType` int(11) NOT NULL,
  `m_nRequestId` int(11) NOT NULL,
  `m_nGroupID` int(11) DEFAULT NULL,
  `m_eTraderType` int(11) DEFAULT NULL,
  `m_strSessionTag` varchar(128) DEFAULT NULL,
  `m_nProperty` int(11) NOT NULL,
  `m_strUser` varchar(128) DEFAULT NULL,
  `m_nCommandID` int(11) DEFAULT NULL,
  `m_eOrderType` int(11) DEFAULT NULL,
  `m_strDate` varchar(128) DEFAULT NULL,
  `m_strInterfaceId` varchar(128) DEFAULT NULL,
  `m_strSource` varchar(128) DEFAULT NULL,
  `m_nFundProductID` int(11) DEFAULT NULL,
  `m_strAccountName` varchar(128) DEFAULT NULL,
  `m_strBankNo` varchar(128) DEFAULT NULL,
  `m_strSZAccount` varchar(128) DEFAULT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strBrokerID` varchar(128) DEFAULT NULL,
  `m_strSubAccount` varchar(128) DEFAULT NULL,
  `m_strPassword` varchar(128) DEFAULT NULL,
  `m_nBrokerType` int(11) DEFAULT NULL,
  `m_nAccountType` int(11) DEFAULT NULL,
  `m_strAccountID` varchar(128) DEFAULT NULL,
  `m_strBrokerName` varchar(128) DEFAULT NULL,
  `m_addresses` varchar(1000) DEFAULT NULL,
  `m_iStatus` int(11) NOT NULL,
  `m_strSHAccount` varchar(128) DEFAULT NULL,
  `m_nBusinessVol` int(11) DEFAULT NULL,
  `m_nOffsetFlag` int(11) DEFAULT NULL,
  `m_nOpenTime` int(11) DEFAULT NULL,
  `m_nCancelVol` int(11) DEFAULT NULL,
  `m_nOrderPriceType` int(11) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_cstkcompacts: 0 rows
/*!40000 ALTER TABLE `idata_cstkcompacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_cstkcompacts` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_cstksubjects
DROP TABLE IF EXISTS `idata_cstksubjects`;
CREATE TABLE `idata_cstksubjects` (
  `m_priKey_tag` varchar(127) NOT NULL,
  `m_trade_date` varchar(10) DEFAULT NULL,
  `m_dSloRate` double NOT NULL,
  `m_dFinRate` double NOT NULL,
  `m_dSloRatio` double DEFAULT NULL,
  `m_eSloStatus` int(11) NOT NULL,
  `m_dSloPenaltyRate` double NOT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_dFinRatio` double DEFAULT NULL,
  `m_strInstrumentID` varchar(128) DEFAULT NULL,
  `m_nEnableAmount` int(11) DEFAULT NULL,
  `m_strInstrumentName` varchar(128) DEFAULT NULL,
  `m_dAssureRatio` double NOT NULL,
  `m_eAssureStatus` int(11) NOT NULL,
  `m_strBrokerID` varchar(128) DEFAULT NULL,
  `m_eFinStatus` int(11) NOT NULL,
  `m_strBrokerName` varchar(128) DEFAULT NULL,
  `m_strExchangeID` varchar(128) DEFAULT NULL,
  `m_dFinPenaltyRate` double NOT NULL,
  `m_strAccountID` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_cstksubjects: 0 rows
/*!40000 ALTER TABLE `idata_cstksubjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_cstksubjects` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_ctaskdetail
DROP TABLE IF EXISTS `idata_ctaskdetail`;
CREATE TABLE `idata_ctaskdetail` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_trade_date` varchar(10) NOT NULL,
  `m_script` longtext NOT NULL,
  `m_eStatus` int(11) NOT NULL,
  `m_strFundProductName` varchar(128) NOT NULL,
  `m_eXtHedgeType` int(11) NOT NULL,
  `m_nRequestId` int(11) NOT NULL,
  `m_nGroupID` int(11) NOT NULL,
  `m_eTraderType` int(11) NOT NULL,
  `m_strSessionTag` varchar(128) NOT NULL,
  `m_nProperty` int(11) NOT NULL,
  `m_strUser` varchar(128) NOT NULL,
  `m_nCommandID` int(11) NOT NULL,
  `m_strDate` varchar(128) NOT NULL,
  `m_strInterfaceId` varchar(128) NOT NULL,
  `m_strSource` varchar(128) NOT NULL,
  `m_nFundProductID` int(11) NOT NULL,
  `m_param` longtext NOT NULL,
  `m_orders` longtext NOT NULL,
  `m_startTime` int(11) NOT NULL,
  `m_cancelTime` int(11) NOT NULL,
  `m_nTaskId` int(11) NOT NULL,
  `m_nBusinessNum` int(11) NOT NULL,
  `m_strMsg` varchar(128) NOT NULL,
  `m_vOpRecords` longtext NOT NULL,
  `m_endTime` int(11) NOT NULL,
  `m_eOrderType` int(11) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_ctaskdetail: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_ctaskdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_ctaskdetail` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_litcstksubjects
DROP TABLE IF EXISTS `idata_litcstksubjects`;
CREATE TABLE `idata_litcstksubjects` (
  `m_priKey_tag` varchar(128) NOT NULL,
  `m_litCstkSubJects` longtext NOT NULL,
  PRIMARY KEY (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- Dumping data for table ttmgrportal.idata_litcstksubjects: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_litcstksubjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_litcstksubjects` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.idata_stockquerydeliveryresp
DROP TABLE IF EXISTS `idata_stockquerydeliveryresp`;
CREATE TABLE `idata_stockquerydeliveryresp` (
  `m_priKey_tag` varchar(127) NOT NULL,
  `m_trade_date` varchar(10) NOT NULL,
  `bizDate` int(11) DEFAULT NULL,
  `entrustBS` varchar(128) DEFAULT NULL,
  `stockName` varchar(128) DEFAULT NULL,
  `stockAccount` varchar(128) DEFAULT NULL,
  `bizNo` varchar(128) DEFAULT NULL,
  `bizAmount` double DEFAULT NULL,
  `commission` double DEFAULT NULL,
  `stampTax` double DEFAULT NULL,
  `postBalance` double DEFAULT NULL,
  `bizPrice` double DEFAULT NULL,
  `bizTime` int(11) DEFAULT NULL,
  `postAmount` double DEFAULT NULL,
  `bizBalance` double DEFAULT NULL,
  `entrustBSName` varchar(128) DEFAULT NULL,
  `transFee` double DEFAULT NULL,
  `success` tinyint(1) DEFAULT NULL,
  `entrustNo` varchar(128) DEFAULT NULL,
  `exchangeName` varchar(128) DEFAULT NULL,
  `error` varchar(128) DEFAULT NULL,
  `stockCode` varchar(128) DEFAULT NULL,
  `exchangeType` varchar(128) DEFAULT NULL,
  `m_strAccountName` varchar(128) DEFAULT NULL,
  `m_strBankNo` varchar(128) DEFAULT NULL,
  `m_strSZAccount` varchar(128) DEFAULT NULL,
  `m_nPlatformID` int(11) NOT NULL,
  `m_strApiType` varchar(128) NOT NULL,
  `m_strBrokerID` varchar(128) DEFAULT NULL,
  `m_strSubAccount` varchar(128) DEFAULT NULL,
  `m_strPassword` varchar(128) DEFAULT NULL,
  `m_nBrokerType` int(11) DEFAULT NULL,
  `m_nAccountType` int(11) DEFAULT NULL,
  `m_strAccountID` varchar(128) DEFAULT NULL,
  `m_strBrokerName` varchar(128) DEFAULT NULL,
  `m_addresses` varchar(1000) DEFAULT NULL,
  `m_iStatus` int(11) NOT NULL,
  `m_strSHAccount` varchar(128) DEFAULT NULL,
  `securities_code` varchar(50) DEFAULT NULL,
  `trading_direction` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`m_priKey_tag`),
  KEY `m_priKey_tag` (`m_priKey_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.idata_stockquerydeliveryresp: ~0 rows (approximately)
/*!40000 ALTER TABLE `idata_stockquerydeliveryresp` DISABLE KEYS */;
/*!40000 ALTER TABLE `idata_stockquerydeliveryresp` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.logmgr_log
DROP TABLE IF EXISTS `logmgr_log`;
CREATE TABLE `logmgr_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `builder_id` int(11) DEFAULT NULL,
  `builder_name` varchar(50) DEFAULT NULL,
  `build_time` datetime NOT NULL,
  `object_table` varchar(60) DEFAULT NULL,
  `action` smallint(6) NOT NULL,
  `ip_str` varchar(39) DEFAULT NULL,
  `outcome` varchar(5) DEFAULT NULL,
  `reason` longtext,
  `sql_str` longtext,
  `session_key` varchar(40) DEFAULT NULL,
  `agent` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `logmgr_log_369e889a` (`builder_id`),
  KEY `logmgr_log_1bd4707b` (`action`),
  CONSTRAINT `builder_id_refs_id_32e5de9f` FOREIGN KEY (`builder_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=196092 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.logmgr_log: ~0 rows (approximately)
/*!40000 ALTER TABLE `logmgr_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `logmgr_log` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.logsystem_info
DROP TABLE IF EXISTS `logsystem_info`;
CREATE TABLE `logsystem_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(64) NOT NULL,
  `datetime` datetime NOT NULL,
  `sysinfo` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59834 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.logsystem_info: ~0 rows (approximately)
/*!40000 ALTER TABLE `logsystem_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `logsystem_info` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.logsystem_log
DROP TABLE IF EXISTS `logsystem_log`;
CREATE TABLE `logsystem_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` smallint(6) NOT NULL,
  `datetime` datetime NOT NULL,
  `content` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2467182 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.logsystem_log: ~0 rows (approximately)
/*!40000 ALTER TABLE `logsystem_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `logsystem_log` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.market_source_marketsource
DROP TABLE IF EXISTS `market_source_marketsource`;
CREATE TABLE `market_source_marketsource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform_id` int(11) DEFAULT NULL,
  `broker_id` varchar(32) DEFAULT NULL,
  `idc_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `market_source_marketsource_2e5bc86d` (`platform_id`),
  KEY `market_source_marketsource_6926b23f` (`broker_id`),
  KEY `market_source_marketsource_6ba754ad` (`idc_id`),
  CONSTRAINT `broker_id_refs_id_44d1eec2` FOREIGN KEY (`broker_id`) REFERENCES `tradeplatform_broker` (`id`),
  CONSTRAINT `idc_id_refs_id_5ab20968` FOREIGN KEY (`idc_id`) REFERENCES `tradeplatform_idcline` (`id`),
  CONSTRAINT `platform_id_refs_id_61c8d61e` FOREIGN KEY (`platform_id`) REFERENCES `tradeplatform_platform` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.market_source_marketsource: ~0 rows (approximately)
/*!40000 ALTER TABLE `market_source_marketsource` DISABLE KEYS */;
/*!40000 ALTER TABLE `market_source_marketsource` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.market_source_stocksource
DROP TABLE IF EXISTS `market_source_stocksource`;
CREATE TABLE `market_source_stocksource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform_id` int(11) DEFAULT NULL,
  `broker_id` int(11) DEFAULT NULL,
  `ip` char(15) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `userName` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `market_source_stocksource_2e5bc86d` (`platform_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
INSERT INTO `market_source_stocksource` VALUES ('3', '10000', '0', '210.14.136.66', '55300', 'modelfree', '123456');


-- Dumping data for table ttmgrportal.market_source_stocksource: ~0 rows (approximately)
/*!40000 ALTER TABLE `market_source_stocksource` DISABLE KEYS */;
/*!40000 ALTER TABLE `market_source_stocksource` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.msgs_msg
DROP TABLE IF EXISTS `msgs_msg`;
CREATE TABLE `msgs_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `project_name` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `level` varchar(6) DEFAULT NULL,
  `msg_text` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `msgs_msg_9808b6c` (`project_name`),
  KEY `msgs_msg_582847c7` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.msgs_msg: ~0 rows (approximately)
/*!40000 ALTER TABLE `msgs_msg` DISABLE KEYS */;
/*!40000 ALTER TABLE `msgs_msg` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.o32_deal
DROP TABLE IF EXISTS `o32_deal`;
CREATE TABLE `o32_deal` (
  `code` char(10) DEFAULT NULL,
  `direction` int(11) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `time` char(20) DEFAULT NULL,
  `dealId` char(128) DEFAULT '',
  `balance` float DEFAULT NULL,
  `fundId` char(128) DEFAULT NULL,
  `date` char(10) DEFAULT NULL,
  `orderid` char(128) DEFAULT NULL,
  KEY `o32_order_codedirection_44bdf3ef` (`code`,`direction`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.o32_deal: ~0 rows (approximately)
/*!40000 ALTER TABLE `o32_deal` DISABLE KEYS */;
/*!40000 ALTER TABLE `o32_deal` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.o32_order
DROP TABLE IF EXISTS `o32_order`;
CREATE TABLE `o32_order` (
  `orderId` char(128) DEFAULT '',
  `code` char(10) DEFAULT NULL,
  `direction` int(1) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `dealVolume` int(11) DEFAULT NULL,
  `cancelFlag` char(1) DEFAULT NULL,
  `cancelVolume` int(11) DEFAULT NULL,
  `status` char(20) DEFAULT NULL,
  `time` char(20) DEFAULT NULL,
  `fundId` char(128) DEFAULT NULL,
  KEY `o32_order_codedirection_44bdf3ee` (`code`,`direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.o32_order: ~0 rows (approximately)
/*!40000 ALTER TABLE `o32_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `o32_order` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.o32_position
DROP TABLE IF EXISTS `o32_position`;
CREATE TABLE `o32_position` (
  `code` char(20) NOT NULL DEFAULT '',
  `direction` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `fundId` char(128) DEFAULT NULL,
  KEY `code_fundId_direction` (`code`,`fundId`,`direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Dumping data for table ttmgrportal.o32_position: ~0 rows (approximately)
/*!40000 ALTER TABLE `o32_position` DISABLE KEYS */;
/*!40000 ALTER TABLE `o32_position` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_accounts
DROP TABLE IF EXISTS `product_accounts`;
CREATE TABLE `product_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grade` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `account_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `main_account_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_accounts_44bdf3ee` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2246 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_accounts: 0 rows
/*!40000 ALTER TABLE `product_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_accounts` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_alerts
DROP TABLE IF EXISTS `product_alerts`;
CREATE TABLE `product_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grade` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `red_alert` tinyint(1) NOT NULL,
  `order_stop` tinyint(1) NOT NULL,
  `alert_value` double DEFAULT NULL,
  `stop_value` double DEFAULT NULL,
  `pred_alert` tinyint(1) NOT NULL,
  `porder_stop` tinyint(1) NOT NULL,
  `palert_value` double DEFAULT NULL,
  `pstop_value` double DEFAULT NULL,
  `accord_to_process` tinyint(1) NOT NULL,
  `enable_min_capital` tinyint(1) NOT NULL,
  `min_capital` double DEFAULT NULL,
  `product_net_value_thredhold_red_alert` tinyint(1) NOT NULL,
  `product_net_value_thredhold_order_stop` tinyint(1) NOT NULL,
  `product_net_value_thredhold_alert_value` double DEFAULT NULL,
  `product_net_value_thredhold_stop_value` double DEFAULT NULL,
  `stockAssetRedAlert` tinyint(1) DEFAULT NULL,
  `stockAssetOrderStop` tinyint(1) DEFAULT NULL,
  `stockAssetAlertValue` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_alerts_44bdf3ee` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=252 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_alerts: 0 rows
/*!40000 ALTER TABLE `product_alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_alerts` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_assetsindex
DROP TABLE IF EXISTS `product_assetsindex`;
CREATE TABLE `product_assetsindex` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `index_id` int(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(50) NOT NULL,
  `scope` int(10) DEFAULT NULL,
  `category_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_assetsindex: ~52 rows (approximately)
/*!40000 ALTER TABLE `product_assetsindex` DISABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_assetsindexcondition
DROP TABLE IF EXISTS `product_assetsindexcondition`;
CREATE TABLE `product_assetsindexcondition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `cid` bigint(20) NOT NULL,
  `iid` bigint(20) NOT NULL,
  `m_nScope` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_assetsindexcondition: ~6 rows (approximately)
/*!40000 ALTER TABLE `product_assetsindexcondition` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_assetsindexcondition` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_bsonrisk
DROP TABLE IF EXISTS `product_bsonrisk`;
CREATE TABLE `product_bsonrisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) NOT NULL,
  `grade` char(10) DEFAULT NULL,
  `template_trade_limits_id` int(11) DEFAULT NULL,
  `template_asset_proportion_id` int(11) DEFAULT NULL,
  `template_trade_limits_b_id` int(11) DEFAULT NULL,
  `template_asset_proportion_b_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_bsonrisk_44bdf3ee` (`product_id`),
  KEY `product_bsonrisk_1edfb48` (`update_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_bsonrisk: 0 rows
/*!40000 ALTER TABLE `product_bsonrisk` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_bsonrisk` ENABLE KEYS */;

-- ----------------------------
-- Table structure for product_categoryindex
-- ----------------------------
DROP TABLE IF EXISTS `product_categoryindex`;
CREATE TABLE `product_categoryindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `iid` int(11) DEFAULT NULL,
  `m_nScope` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entity_UNIQUE` (`cid`,`iid`,`m_nScope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table ttmgrportal.product_closers
DROP TABLE IF EXISTS `product_closers`;
CREATE TABLE `product_closers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_closers_44bdf3ee` (`product_id`),
  KEY `product_closers_403f60f` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_closers: ~0 rows (approximately)
/*!40000 ALTER TABLE `product_closers` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_closers` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_flowaccounts
DROP TABLE IF EXISTS `product_flowaccounts`;
CREATE TABLE `product_flowaccounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grade` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `account_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `productWorkflow_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_flowaccounts_66ef056d` (`productWorkflow_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6820 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_flowaccounts: 0 rows
/*!40000 ALTER TABLE `product_flowaccounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_flowaccounts` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_flowusers
DROP TABLE IF EXISTS `product_flowusers`;
CREATE TABLE `product_flowusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grade` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `workflow_id` int(11) NOT NULL,
  `productWorkflow_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `node` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_flowusers_44bdf3ee` (`product_id`),
  KEY `product_flowusers_26cddbc7` (`workflow_id`),
  KEY `product_flowusers_66ef056d` (`productWorkflow_id`),
  KEY `product_flowusers_425ae3c4` (`group_id`),
  KEY `product_flowusers_403f60f` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2896 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_flowusers: 0 rows
/*!40000 ALTER TABLE `product_flowusers` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_flowusers` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_fund
DROP TABLE IF EXISTS `product_fund`;
CREATE TABLE `product_fund` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) NOT NULL,
  `fund_id` int(11) default NULL,
  `en_stock_asset` decimal(18,2) default NULL,
  `en_fund_share` decimal(18,2) default NULL,
  `en_fund_value` decimal(18,2) default NULL,
  `en_fund_value_yesterday` decimal(18,2) default NULL,
  `create_date` datetime NOT NULL,
  `stat_date` varchar(16) default NULL,
  `en_current_cash` double default NULL,
  `en_bond_asset` double default NULL,
  `en_hg_asset` double default NULL,
  `en_warrant_asset` double default NULL,
  `en_other_asset` double default NULL,
  `en_fund_asset` double default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pID_fID` (`product_id`,`fund_id`),
  KEY `product_fund_44bdf3ee` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2826582 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_fund: 0 rows
/*!40000 ALTER TABLE `product_fund` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_fund` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_futureclientrefreshinterval
DROP TABLE IF EXISTS `product_futureclientrefreshinterval`;
CREATE TABLE `product_futureclientrefreshinterval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `account_hold_interval` int(11) NOT NULL,
  `trader_bid_interval` int(11) NOT NULL,
  `instruction_task_interval` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_futureclientrefreshinterval: ~0 rows (approximately)
/*!40000 ALTER TABLE `product_futureclientrefreshinterval` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_futureclientrefreshinterval` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_grade
DROP TABLE IF EXISTS `product_grade`;
CREATE TABLE `product_grade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `fund_name` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `scale` double NOT NULL,
  `gains` double DEFAULT NULL,
  `gains_way` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `annual_yield` double DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `grade` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_grade_44bdf3ee` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=244 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_grade: 0 rows
/*!40000 ALTER TABLE `product_grade` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_grade` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_gradedatehistory
DROP TABLE IF EXISTS `product_gradedatehistory`;
CREATE TABLE `product_gradedatehistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `builder_id` int(11) NOT NULL,
  `history_time` datetime DEFAULT NULL,
  `value` float unsigned zerofill DEFAULT NULL,
  `history_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id_refs_id_96c068a` (`product_id`),
  KEY `build_id_e` (`builder_id`)
) ENGINE=MyISAM AUTO_INCREMENT=146 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_gradedatehistory: 0 rows
/*!40000 ALTER TABLE `product_gradedatehistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_gradedatehistory` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_otherright
DROP TABLE IF EXISTS `product_otherright`;
CREATE TABLE `product_otherright` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `right_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `origin` int(11) NOT NULL,
  `right_value` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_otherright_44bdf3ee` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=228 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_otherright: 0 rows
/*!40000 ALTER TABLE `product_otherright` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_otherright` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_positionrisk
DROP TABLE IF EXISTS `product_positionrisk`;
CREATE TABLE `product_positionrisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `orders` int(11) NOT NULL,
  `m_positionWeights` int(11) DEFAULT NULL,
  `m_thresholds` int(11) DEFAULT NULL,
  `m_rates` int(11) DEFAULT NULL,
  `m_dwarnMultiply` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_positionrisk_44bdf3ee` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_positionrisk: 0 rows
/*!40000 ALTER TABLE `product_positionrisk` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_positionrisk` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_product
DROP TABLE IF EXISTS `product_product`;
CREATE TABLE `product_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `types` int(11) NOT NULL,
  `code` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `manager` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `supervise` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `deposit` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `supervise_fee` double NOT NULL,
  `deposit_fee` double NOT NULL,
  `setup_date` date NOT NULL,
  `fund_id` int(11) DEFAULT NULL,
  `use_day_end` tinyint(1) NOT NULL,
  `day_end_time` time DEFAULT NULL,
  `status` smallint(6) NOT NULL,
  `total_source` int(11) DEFAULT NULL,
  `total_source2` int(11) DEFAULT NULL,
  `total_value` double DEFAULT NULL,
  `total_value2` double DEFAULT NULL,
  `float_fee` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=420 DEFAULT CHARSET=utf8;

alter table product_product add column `type` int(11) default 0;

-- Dumping data for table ttmgrportal.product_product: 0 rows
/*!40000 ALTER TABLE `product_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_product` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_productworkflow
DROP TABLE IF EXISTS `product_productworkflow`;
CREATE TABLE `product_productworkflow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grade` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `flow_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `product_id` int(11) NOT NULL,
  `workflow_id` int(11) NOT NULL,
  `offline` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_productworkflow_44bdf3ee` (`product_id`),
  KEY `product_productworkflow_26cddbc7` (`workflow_id`)
) ENGINE=MyISAM AUTO_INCREMENT=768 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_productworkflow: 0 rows
/*!40000 ALTER TABLE `product_productworkflow` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_productworkflow` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_queriers
DROP TABLE IF EXISTS `product_queriers`;
CREATE TABLE `product_queriers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_queriers_44bdf3ee` (`product_id`),
  KEY `product_queriers_403f60f` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_queriers: ~0 rows (approximately)
/*!40000 ALTER TABLE `product_queriers` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_queriers` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_risk
DROP TABLE IF EXISTS `product_risk`;
CREATE TABLE `product_risk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grade` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `alert_threshold` double NOT NULL,
  `stop_threshold` double NOT NULL,
  `types` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_risk_44bdf3ee` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=17728 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_risk: 0 rows
/*!40000 ALTER TABLE `product_risk` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_risk` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_riskcontroller
DROP TABLE IF EXISTS `product_riskcontroller`;
CREATE TABLE `product_riskcontroller` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_riskcontroller: ~0 rows (approximately)
/*!40000 ALTER TABLE `product_riskcontroller` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_riskcontroller` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_stockclientrefreshinterval
DROP TABLE IF EXISTS `product_stockclientrefreshinterval`;
CREATE TABLE `product_stockclientrefreshinterval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `account_hold_interval` int(11) NOT NULL,
  `trader_bid_interval` int(11) NOT NULL,
  `instruction_task_interval` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_stockclientrefreshinterval: ~0 rows (approximately)
/*!40000 ALTER TABLE `product_stockclientrefreshinterval` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_stockclientrefreshinterval` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.product_stock_netvalue
DROP TABLE IF EXISTS `product_stock_netvalue`;
CREATE TABLE `product_stock_netvalue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tradedate` varchar(8) NOT NULL,
  `bsonstr` blob,
  PRIMARY KEY (`id`,`tradedate`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `tradedate_UNIQUE` (`tradedate`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.product_stock_netvalue: 0 rows
/*!40000 ALTER TABLE `product_stock_netvalue` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_stock_netvalue` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.project_project
DROP TABLE IF EXISTS `project_project`;
CREATE TABLE `project_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `builder_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `offline_rule` smallint(6) NOT NULL,
  `manager_actived` tinyint(1) NOT NULL,
  `director_actived` tinyint(1) NOT NULL,
  `receiver_actived` tinyint(1) NOT NULL,
  `trader_actived` tinyint(1) NOT NULL,
  `closer_actived` tinyint(1) NOT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `director_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `trader_id` int(11) DEFAULT NULL,
  `closer_id` int(11) DEFAULT NULL,
  `build_time` datetime DEFAULT NULL,
  `over_time` datetime DEFAULT NULL,
  `status` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `builder_id_refs_id_b79dcd2` (`builder_id`),
  KEY `manager_id_refs_id_b79dcd2` (`manager_id`),
  KEY `director_id_refs_id_b79dcd2` (`director_id`),
  KEY `receiver_id_refs_id_b79dcd2` (`receiver_id`),
  KEY `trader_id_refs_id_b79dcd2` (`trader_id`),
  KEY `closer_id_refs_id_b79dcd2` (`closer_id`),
  CONSTRAINT `builder_id_refs_id_b79dcd2` FOREIGN KEY (`builder_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `closer_id_refs_id_b79dcd2` FOREIGN KEY (`closer_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `director_id_refs_id_b79dcd2` FOREIGN KEY (`director_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `manager_id_refs_id_b79dcd2` FOREIGN KEY (`manager_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `receiver_id_refs_id_b79dcd2` FOREIGN KEY (`receiver_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `trader_id_refs_id_b79dcd2` FOREIGN KEY (`trader_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.project_project: ~0 rows (approximately)
/*!40000 ALTER TABLE `project_project` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_project` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.project_trace_projecttrace
DROP TABLE IF EXISTS `project_trace_projecttrace`;
CREATE TABLE `project_trace_projecttrace` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `data` longtext,
  `record_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `project_trace_projecttrace_b6620684` (`project_id`),
  CONSTRAINT `project_id_refs_id_b44942a1` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.project_trace_projecttrace: ~0 rows (approximately)
/*!40000 ALTER TABLE `project_trace_projecttrace` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_trace_projecttrace` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.risk_control_accountrisk
DROP TABLE IF EXISTS `risk_control_accountrisk`;
CREATE TABLE `risk_control_accountrisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) NOT NULL,
  `sub_account_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_control_accountrisk_1edfb48` (`update_user_id`),
  KEY `risk_control_accountrisk_742c8213` (`sub_account_id`),
  CONSTRAINT `sub_account_id_refs_id_7340d3fe` FOREIGN KEY (`sub_account_id`) REFERENCES `account_subaccount` (`id`),
  CONSTRAINT `update_user_id_refs_id_176522e6` FOREIGN KEY (`update_user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=812 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.risk_control_accountrisk: ~0 rows (approximately)
/*!40000 ALTER TABLE `risk_control_accountrisk` DISABLE KEYS */;
/*!40000 ALTER TABLE `risk_control_accountrisk` ENABLE KEYS */;


DROP TABLE IF EXISTS `risk_control_globalrisk`;
CREATE TABLE `risk_control_globalrisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) NOT NULL,
  `types` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_control_globalrisk_1edfb48` (`update_user_id`),
  CONSTRAINT `update_user_id_refs_id_72909d5` FOREIGN KEY (`update_user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of risk_control_globalrisk
-- ----------------------------
INSERT INTO `risk_control_globalrisk` VALUES ('7', '{\"stopearn\": {\"m_eSuperPriceType\": 1, \"m_dSuperPriceValue\": 0, \"m_ePriceType\": 15, \"m_eVolumeType\": 4, \"m_eOrderType\": 0}, \"stoploss\": {\"m_nSuperPriceStart\": 1, \"m_dVolumeRate\": 0.10000000000000001, \"m_ePriceType\": 5, \"m_eVolumeType\": 10, \"m_eSuperPriceType\": 1, \"m_dPlaceOrderInterval\": 10.0, \"m_nSingleNumMax\": 100, \"m_eOrderType\": 1, \"m_dWithdrawOrderInterval\": 10.0, \"m_dSuperPriceValue\": 10.0}, \"matchedOrders\": {\"m_bForbiddenSingle\": false}}', '2014-03-10 14:41:45', '1', '1');
INSERT INTO `risk_control_globalrisk` VALUES ('9', '{\"category\": {\"white\": [], \"black\": []}, \"stoploss\": {\"m_eSuperPriceType\": 1, \"m_dSuperPriceValue\": 0.10000000000000001, \"m_ePriceType\": 5, \"m_eVolumeType\": 10, \"m_eOrderType\": 0}, \"bucket\": {\"isReverseEnable\": true, \"isBucketEnable\": true, \"globalBucket\": {}, \"globalReverse\": {}}, \"matchedOrders\": {\"m_bEnabled\": true, \"groups\": {\"123\": [\"37000044_01\", \"37000234_00\"], \"BBB\": [\"37000044_00\", \"37000044_01\"]}}, \"m_default\": {\"rate\": {\"isReverseEnable\": true, \"isBucketEnable\": true, \"globalBucket\": {}, \"globalReverse\": {}}}, \"stocks\": {\"white\": [], \"black\": []}}', '2014-03-10 19:08:06', '1', '2');
INSERT INTO `risk_control_globalrisk` VALUES ('11', '{\"globalRC\":{\"m_assetsRCs\":[]}}', '2014-03-21 10:17:14', '1', '3');


-- Dumping structure for table ttmgrportal.roles_clientconfigs
DROP TABLE IF EXISTS `roles_clientconfigs`;
CREATE TABLE `roles_clientconfigs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `value` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id_refs_id_59d886a5` (`parent_id`),
  CONSTRAINT `parent_id_refs_id_59d886a5` FOREIGN KEY (`parent_id`) REFERENCES `roles_clientconfigs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table ttmgrportal.roles_clientconfigs: ~42 rows (approximately)
/*!40000 ALTER TABLE `roles_clientconfigs` DISABLE KEYS */;
INSERT INTO `roles_clientconfigs` (`id`, `tag`, `name`, `value`, `parent_id`) VALUES
	(1, 'Type', '所有权限', '', NULL),
	(3, 'Type', '期货公司设置', '', 1),
	(5, 'Option', '自定义期货公司', '0x38000000000000000000000000000000000000', 3),
	(7, 'Type', '账号设置', '', 1),
	(9, 'Option', '添加删除账号', '0x1600000000000000000000000000000000000000000', 7),
	(11, 'Option', '多账号交易', '0x800000000000000000000000000000000000000000', 7),
	(13, 'Option', '向他人授权账号', '0x1f70002000000000000000000000000000000', 7),
	(15, 'Option', '被他人授权账号', '0x200000080002000000000000000000000000000000', 7),
	(17, 'Option', '银期转账', '0x80000000000000000000000000000', 7),
	(19, 'Option', '修改账号密码', '0x40000000000000000000000000000', 7),
	(21, 'Type', '账号组设置', '', 1),
	(23, 'Option', '自定义账号组', '0x2000000000000000000000000000000000000000000', 21),
	(25, 'Type', '交易设置', '', 1),
	(27, 'Option', '自动止损', '0xe000000000000000000000000000000000000000', 25),
	(29, 'Type', '交易类型', '', 25),
	(31, 'Option', '股票交易', '0x100000000000000000000000000000000000000000000000', 29),
	(33, 'Option', '期货交易', '0x80000000000000000000000000000000000000000000000', 29),
	(35, 'Option', '组合交易', '0x40000000000000000000000000000000000000000000000', 29),
	(37, 'Type', '算法交易', '', 25),
	(39, 'Option', '首笔大单', '0x80000000100000400000000000000000000000000', 37),
	(41, 'Option', '均笔下单', '0x40000000080000200000000000000000000000000', 37),
	(43, 'Option', '单笔下单', '0x20000000040000100000000000000000000000000', 37),
	(45, 'Option', '普通下单', '0x10000000020000080000000000000000000000000', 37),
	(47, 'Type', '分单模式', '', 25),
	(49, 'Option', '平均分配', '0x8000000020000000000000000000000000', 47),
	(51, 'Option', '按设定量', '0x4000000010000000000000000000000000', 47),
	(53, 'Option', '按权重', '0x2000000008000000000000000000000000', 47),
	(55, 'Type', '下单板风格', '', 25),
	(57, 'Option', '六键风格', '0x3800000000000000000000000', 55),
	(59, 'Option', '四键风格', '0x700000000000000000000000', 55),
	(61, 'Option', '两键风格', '0x80000000000000000000000', 55),
	(63, 'Type', '合规检查', '', 25),
	(65, 'Option', '开仓量检查', '0x1000000000000000000000000000000000000000', 63),
	(67, 'Option', '持仓量检查', '0x800000000000000000000000000000000000000', 63),
	(69, 'Option', '撤单数检查', '0x400000000000000000000000000000000000000', 63),
	(71, 'Type', '其它设置', '', 1),
	(73, 'Option', '配置云备份', '0x4000000000000000000000000000000000000', 71),
	(75, 'Option', '修改用户密码', '0x800000000000000000000000000000000000000000000000', 71),
	(77, 'Option', '布局模板保存', '0x18000000000000000000000000000000000000000000000', 71),
	(79, 'Type', '接口单交易', '0x8000000000000000000000000000000', 1),
	(81, 'Option', '信号源：网络端口', '0x800000000000000000000000000000000', 79),
	(83, 'Option', '信号源：本地文件', '0x400000000000000000000000000000000', 79);
/*!40000 ALTER TABLE `roles_clientconfigs` ENABLE KEYS */;


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `roles_menu`
-- ----------------------------
DROP TABLE IF EXISTS `roles_menu`;
CREATE TABLE `roles_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `icon` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` tinyint(1) NOT NULL,
  `url` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `parent_id` int(11) NOT NULL,
  `subUrls` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1936 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of roles_menu
-- ----------------------------
INSERT INTO `roles_menu` VALUES ('1', 'roles', '基础管理', '', '1', '', '0', '[]');
INSERT INTO `roles_menu` VALUES ('3', '', '角色管理', 'role_manage.png', '2', '/roles/manage/', '1', '[]');
INSERT INTO `roles_menu` VALUES ('5', '', '菜单管理', 'meuns.png', '2', '/roles/menu/query/', '1', '[]');
INSERT INTO `roles_menu` VALUES ('11', '', '用户管理', 'inquire_user.png', '2', '/usrmgr/query/', '1', '[]');
INSERT INTO `roles_menu` VALUES ('13', 'account', '账号管理', '', '1', '', '0', '[]');
INSERT INTO `roles_menu` VALUES ('17', '', '期货账号', 'inquire_account.png', '2', '/account/query/', '13', '[]');
INSERT INTO `roles_menu` VALUES ('21', '', '证券账号', 'inquire_account_zhengquan.png', '2', '/account/stock/query/', '13', '[]');
INSERT INTO `roles_menu` VALUES ('27', '', '产品管理', 'products.png', '2', '/product/query/', '1', '[]');
INSERT INTO `roles_menu` VALUES ('35', '', '经纪公司', 'company_setting.png', '2', '/tradeplatform/query/', '1', '[]');
INSERT INTO `roles_menu` VALUES ('37', 'maketsource', '行情源管理', '', '1', '', '0', '[]');
INSERT INTO `roles_menu` VALUES ('39', '', '期货行情源', 'source.png', '2', '/market_source/query_futures/', '37', '[]');
INSERT INTO `roles_menu` VALUES ('41', '', '证券行情源', 'source_2.png', '2', '/market_source/query_stocks/', '37', '[]');
INSERT INTO `roles_menu` VALUES ('43', 'workflow', '工作流模板管理', '', '1', '', '0', '[]');
INSERT INTO `roles_menu` VALUES ('45', '', '新建工作流模板', 'add_workflow.png', '2', '/workflow/create/', '43', '[]');
INSERT INTO `roles_menu` VALUES ('47', '', '管理工作流模板', 'workflows.png', '2', '/workflow/query/', '43', '[]');
INSERT INTO `roles_menu` VALUES ('49', 'risk', '全局风控管理', 'account_add.png', '1', '', '0', '[]');
INSERT INTO `roles_menu` VALUES ('52', null, '全局风控', 'company_setting.png', '2', '/risk_control/global_risk/', '49', '[]');
INSERT INTO `roles_menu` VALUES ('53', null, '保证金/手续费模板', 'company_setting.png', '2', '/account/instrument_fee_template/', '215', '[]');
INSERT INTO `roles_menu` VALUES ('54', null, '账号组风控', 'account_add.png', '2', '/risk_control/query_account_groups/', '49', '[]');
INSERT INTO `roles_menu` VALUES ('56', '', '风控审批', 'products.png', '2', '/risk_control/approvallist', '49', '[]');
INSERT INTO `roles_menu` VALUES ('57', '', '异常交易监控', 'real_time.png', '2', '/transaction_monitor/orders/', '49', '[]');
INSERT INTO `roles_menu` VALUES ('215', 'datamanagement', '数据管理', 'account_add.png', '1', '', '0', '[]');
INSERT INTO `roles_menu` VALUES ('228', '', '折算率信息', 'pc_login.png', '2', '/file/factor/', '215', '[]');
INSERT INTO `roles_menu` VALUES ('231', 'system', '系统监控', '', '1', '', '0', '[]');
INSERT INTO `roles_menu` VALUES ('233', '', '系统运行状态', 'camera.png', '2', '/system_monitor/instant/', '231', '[]');
INSERT INTO `roles_menu` VALUES ('235', '', '历史日志查询', 'history.png', '2', '/system_monitor/history/', '231', '[]');
INSERT INTO `roles_menu` VALUES ('239', '', '系统设置', 'setting.png', '2', '/system_monitor/settings/', '231', '[]');
INSERT INTO `roles_menu` VALUES ('259', '', '信用账号', 'inquire_account.png', '2', '/account/credit/query/', '13', '[]');
INSERT INTO `roles_menu` VALUES ('260', '', '证券分类', 'reportpanel.png', '2', '/account/category/create/', '215', '[]');
INSERT INTO `roles_menu` VALUES ('261', null, '风控模板', 'company_setting.png', '2', '/risk_control/template/query/', '215', '[]');
INSERT INTO `roles_menu` VALUES ('262', null, '交易日设置', 'real_time.png', '2', '/account/account_invalid_setting/', '215', '[]');
INSERT INTO `roles_menu` VALUES ('1001', 'account_base', '账号信息', null, '3', '', '17', 'baseTab');
INSERT INTO `roles_menu` VALUES ('1002', 'account_trade', '交易限制', null, '3', '', '17', 'tradeTab');
INSERT INTO `roles_menu` VALUES ('1003', 'account_risk', '风控设置', null, '3', '', '17', 'riskTab');
INSERT INTO `roles_menu` VALUES ('1004', 'account_future_rate', '保证金/手续费设置', null, '3', '', '17', 'marginTab');
INSERT INTO `roles_menu` VALUES ('1101', 'account_stock_base', '账号信息', null, '3', '', '21', 'stockBaseTab');
INSERT INTO `roles_menu` VALUES ('1102', 'account_stock_assets_proportion', '资产比例限制', null, '3', '', '21', 'assetsProportionTab');
INSERT INTO `roles_menu` VALUES ('1103', 'account_stock_black_white', '黑白名单', null, '3', '', '21', 'blackWhiteTab');
INSERT INTO `roles_menu` VALUES ('1104', 'account_stock_risk_control', '风控设置', null, '3', '', '21', 'stockRiskControlTab');
INSERT INTO `roles_menu` VALUES ('1105', 'account_stock_rate', '手续费设置', null, '3', '', '21', 'stockRate');
INSERT INTO `roles_menu` VALUES ('1201', 'account_credit_base', '账号信息', null, '3', '', '259', 'creditBaseTab');
INSERT INTO `roles_menu` VALUES ('1202', 'account_credit_black_white', '黑白名单', null, '3', '', '259', 'creditBlackWhiteTab');
INSERT INTO `roles_menu` VALUES ('1203', 'account_credit_risk_control', '风控设置', null, '3', '', '259', '[]');
INSERT INTO `roles_menu` VALUES ('1204', 'account_credit_rate', '手续费设置', null, '3', '', '259', 'creditRate');
INSERT INTO `roles_menu` VALUES ('1301', 'product_base', '基本设置', null, '3', '', '27', 'base');
INSERT INTO `roles_menu` VALUES ('1302', 'product_grade', '分级基金设置', null, '3', '', '27', 'grade');
INSERT INTO `roles_menu` VALUES ('1303', 'product_sel_accounts', '账号设置', null, '3', '', '27', 'sel_accounts');
INSERT INTO `roles_menu` VALUES ('1304', 'product_workflow', '工作流设置', null, '3', '', '27', 'workflowTab');
INSERT INTO `roles_menu` VALUES ('1305', 'product_risk', '风控设置', null, '3', '', '27', 'risk');
INSERT INTO `roles_menu` VALUES ('1306', 'product_clien_refresh_interval', '数据推送设置', null, '3', '', '27', 'clienRefreshInterval');
INSERT INTO `roles_menu` VALUES ('1307', 'product_other', '其他权益设置', null, '3', '', '27', 'other');
INSERT INTO `roles_menu` VALUES ('1401', 'tradeplatform_future_base', '基本信息', null, '3', '', '31', 'baseTab');
INSERT INTO `roles_menu` VALUES ('1402', 'tradeplatform_future_trade_line', '交易线路', null, '3', '', '31', 'tradeLineTab');
INSERT INTO `roles_menu` VALUES ('1403', 'tradeplatform_future_market_line', '行情线路', null, '3', '', '31', 'marketLineTab');
INSERT INTO `roles_menu` VALUES ('1601', 'tradeplatform_edit_base', '基本信息', null, '3', '', '35', 'baseTab');
INSERT INTO `roles_menu` VALUES ('1602', 'tradeplatform_edit_trade_line', '交易线路', null, '3', '', '35', 'tradeLineTab');
INSERT INTO `roles_menu` VALUES ('1603', 'tradeplatform_edit_market_line', '行情线路', null, '3', '', '35', 'marketLineTab');
INSERT INTO `roles_menu` VALUES ('1701', 'risk_futures_stoploss', '默认交易止损', null, '3', '', '52', 'stoplossTab');
INSERT INTO `roles_menu` VALUES ('1702', 'risk_futures_matched_orders', '对敲控制', null, '3', '', '52', 'matchedOrdersTab');
INSERT INTO `roles_menu` VALUES ('1801', 'risk_stoploss', '默认交易止损', null, '3', '', '52', 'stoplossTab');
INSERT INTO `roles_menu` VALUES ('1802', 'risk_black_white', '黑白名单', null, '3', '', '52', 'blackWhiteTab');
INSERT INTO `roles_menu` VALUES ('1803', 'risk_bucket', '反向单控制', null, '3', '', '52', 'bucketTab');
INSERT INTO `roles_menu` VALUES ('1804', 'risk_matched_orders', '对敲控制', null, '3', '', '52', 'matchedOrdersTab');
INSERT INTO `roles_menu` VALUES ('1901', 'system_monitor_settings_smtp', 'SMTP服务器设置', null, '3', '', '239', 'smtpTab');
INSERT INTO `roles_menu` VALUES ('1902', 'system_monitor_settings_email', '异常监控邮件收件人设置', null, '3', '', '239', 'emailTab');
INSERT INTO `roles_menu` VALUES ('1903', 'system_monitor_settings_file', '客户端安装包管理', null, '3', '', '239', '[]');
INSERT INTO `roles_menu` VALUES ('1905', 'system_monitor_query_log', '查询日志', null, '3', '', '235', '[]');
INSERT INTO `roles_menu` VALUES ('1907', 'system_monitor_portal_login', '查询门户登录', null, '3', '', '235', '[]');
INSERT INTO `roles_menu` VALUES ('1909', 'system_monitor_pc_login', '查询终端登录', null, '3', '', '235', '[]');
INSERT INTO `roles_menu` VALUES ('1911', 'system_monitor_history', '历史运行状态', null, '3', '', '235', '[]');
INSERT INTO `roles_menu` VALUES ('1913', 'account_query_position', '持仓', null, '3', '', '17', '[]');
INSERT INTO `roles_menu` VALUES ('1915', 'account_query_order', '委托', null, '3', '', '17', '[]');
INSERT INTO `roles_menu` VALUES ('1917', 'account_query_deal', '成交', null, '3', '', '17', '[]');
INSERT INTO `roles_menu` VALUES ('1919', 'account_query_settlement', '结算单', null, '3', '', '17', '[]');
INSERT INTO `roles_menu` VALUES ('1921', 'account_query_trend', '走势', null, '3', '', '17', '[]');
INSERT INTO `roles_menu` VALUES ('1923', 'system_monitor_settings_ttlog', 'ttlog', null, '3', '', '235', '[]');
INSERT INTO `roles_menu` VALUES ('1925', 'account_future_rate', '保证金手续费', null, '3', '', '17', '[]');
INSERT INTO `roles_menu` VALUES ('1927', 'account_stock_rate', '保证金手续费', null, '3', '', '21', '[]');
INSERT INTO `roles_menu` VALUES ('1929', 'account_credit_rate', '保证金手续费', null, '3', '', '259', '[]');
INSERT INTO `roles_menu` VALUES ('1932', 'system_monitor_settings_smtp_log', '日志邮件发送地址列表', null, '3', '', '239', 'logSmtpTab');
INSERT INTO `roles_menu` VALUES ('1933', 'system_monitor_settings_email_log', '日志邮件接收列表', null, '3', '', '239', 'logEmailTab');
-- INSERT INTO `roles_menu` VALUES ('1935', null, '系统监控日志', 'history.png', '2', '/system_monitor/query_log_page/\r\n\r\n', '231', '[]');


-- 待删除
-- Dumping structure for table ttmgrportal.roles_menu_groups
DROP TABLE IF EXISTS `roles_menu_groups`;
CREATE TABLE `roles_menu_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `menu_id` (`menu_id`,`group_id`),
  KEY `group_id_refs_id_3e5eddc4` (`group_id`),
  CONSTRAINT `group_id_refs_id_3e5eddc4` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `menu_id_refs_id_2ba57377` FOREIGN KEY (`menu_id`) REFERENCES `roles_menu` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3332 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of roles_menu_groups
-- ----------------------------
-- 这个表目测已经不用了
INSERT INTO `roles_menu_groups` VALUES ('3283', '3', '90');
INSERT INTO `roles_menu_groups` VALUES ('3023', '3', '100');
INSERT INTO `roles_menu_groups` VALUES ('1779', '3', '102');
INSERT INTO `roles_menu_groups` VALUES ('1875', '3', '200');
INSERT INTO `roles_menu_groups` VALUES ('2973', '3', '300');
INSERT INTO `roles_menu_groups` VALUES ('3073', '3', '400');
INSERT INTO `roles_menu_groups` VALUES ('3287', '11', '90');
INSERT INTO `roles_menu_groups` VALUES ('3027', '11', '100');
INSERT INTO `roles_menu_groups` VALUES ('3265', '11', '101');
INSERT INTO `roles_menu_groups` VALUES ('1783', '11', '102');
INSERT INTO `roles_menu_groups` VALUES ('1879', '11', '200');
INSERT INTO `roles_menu_groups` VALUES ('2977', '11', '300');
INSERT INTO `roles_menu_groups` VALUES ('3077', '11', '400');
INSERT INTO `roles_menu_groups` VALUES ('3291', '17', '90');
INSERT INTO `roles_menu_groups` VALUES ('3031', '17', '100');
INSERT INTO `roles_menu_groups` VALUES ('3267', '17', '101');
INSERT INTO `roles_menu_groups` VALUES ('1787', '17', '102');
INSERT INTO `roles_menu_groups` VALUES ('1883', '17', '200');
INSERT INTO `roles_menu_groups` VALUES ('2981', '17', '300');
INSERT INTO `roles_menu_groups` VALUES ('3081', '17', '400');
INSERT INTO `roles_menu_groups` VALUES ('3295', '21', '90');
INSERT INTO `roles_menu_groups` VALUES ('3035', '21', '100');
INSERT INTO `roles_menu_groups` VALUES ('3269', '21', '101');
INSERT INTO `roles_menu_groups` VALUES ('1791', '21', '102');
INSERT INTO `roles_menu_groups` VALUES ('1887', '21', '200');
INSERT INTO `roles_menu_groups` VALUES ('2985', '21', '300');
INSERT INTO `roles_menu_groups` VALUES ('3085', '21', '400');
INSERT INTO `roles_menu_groups` VALUES ('3299', '27', '90');
INSERT INTO `roles_menu_groups` VALUES ('3049', '27', '100');
INSERT INTO `roles_menu_groups` VALUES ('3273', '27', '101');
INSERT INTO `roles_menu_groups` VALUES ('1805', '27', '102');
INSERT INTO `roles_menu_groups` VALUES ('1901', '27', '200');
INSERT INTO `roles_menu_groups` VALUES ('2999', '27', '300');
INSERT INTO `roles_menu_groups` VALUES ('3099', '27', '400');
INSERT INTO `roles_menu_groups` VALUES ('3305', '35', '90');
INSERT INTO `roles_menu_groups` VALUES ('3041', '35', '100');
INSERT INTO `roles_menu_groups` VALUES ('1797', '35', '102');
INSERT INTO `roles_menu_groups` VALUES ('1893', '35', '200');
INSERT INTO `roles_menu_groups` VALUES ('2991', '35', '300');
INSERT INTO `roles_menu_groups` VALUES ('3091', '35', '400');
INSERT INTO `roles_menu_groups` VALUES ('3307', '39', '90');
INSERT INTO `roles_menu_groups` VALUES ('3043', '39', '100');
INSERT INTO `roles_menu_groups` VALUES ('1799', '39', '102');
INSERT INTO `roles_menu_groups` VALUES ('1895', '39', '200');
INSERT INTO `roles_menu_groups` VALUES ('2993', '39', '300');
INSERT INTO `roles_menu_groups` VALUES ('3093', '39', '400');
INSERT INTO `roles_menu_groups` VALUES ('3309', '41', '90');
INSERT INTO `roles_menu_groups` VALUES ('3045', '41', '100');
INSERT INTO `roles_menu_groups` VALUES ('1801', '41', '102');
INSERT INTO `roles_menu_groups` VALUES ('1897', '41', '200');
INSERT INTO `roles_menu_groups` VALUES ('2995', '41', '300');
INSERT INTO `roles_menu_groups` VALUES ('3095', '41', '400');
INSERT INTO `roles_menu_groups` VALUES ('3315', '57', '90');
INSERT INTO `roles_menu_groups` VALUES ('3055', '57', '100');
INSERT INTO `roles_menu_groups` VALUES ('3279', '57', '101');
INSERT INTO `roles_menu_groups` VALUES ('1811', '57', '102');
INSERT INTO `roles_menu_groups` VALUES ('1907', '57', '200');
INSERT INTO `roles_menu_groups` VALUES ('3005', '57', '300');
INSERT INTO `roles_menu_groups` VALUES ('3105', '57', '400');
INSERT INTO `roles_menu_groups` VALUES ('3281', '228', '101');
INSERT INTO `roles_menu_groups` VALUES ('3327', '233', '90');
INSERT INTO `roles_menu_groups` VALUES ('3067', '233', '100');
INSERT INTO `roles_menu_groups` VALUES ('1823', '233', '102');
INSERT INTO `roles_menu_groups` VALUES ('1919', '233', '200');
INSERT INTO `roles_menu_groups` VALUES ('3017', '233', '300');
INSERT INTO `roles_menu_groups` VALUES ('3117', '233', '400');
INSERT INTO `roles_menu_groups` VALUES ('3329', '235', '90');
INSERT INTO `roles_menu_groups` VALUES ('3069', '235', '100');
INSERT INTO `roles_menu_groups` VALUES ('1825', '235', '102');
INSERT INTO `roles_menu_groups` VALUES ('1921', '235', '200');
INSERT INTO `roles_menu_groups` VALUES ('3019', '235', '300');
INSERT INTO `roles_menu_groups` VALUES ('3119', '235', '400');
INSERT INTO `roles_menu_groups` VALUES ('3331', '239', '90');
INSERT INTO `roles_menu_groups` VALUES ('3071', '239', '100');
INSERT INTO `roles_menu_groups` VALUES ('1827', '239', '102');
INSERT INTO `roles_menu_groups` VALUES ('1923', '239', '200');
INSERT INTO `roles_menu_groups` VALUES ('3021', '239', '300');
INSERT INTO `roles_menu_groups` VALUES ('3121', '239', '400');

/*!40000 ALTER TABLE `roles_menu_groups` ENABLE KEYS */;

-- 待删除
-- Dumping structure for table ttmgrportal.roles_roleperm
DROP TABLE IF EXISTS `roles_roleperm`;
CREATE TABLE `roles_roleperm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `perm_data` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `selected_values` varchar(4000) COLLATE utf8_unicode_ci NOT NULL,
  `account_perm` varchar(2000) COLLATE utf8_unicode_ci NOT NULL,
  `product_perm` varchar(2000) COLLATE utf8_unicode_ci NOT NULL,
  `credit_account_perm` varchar(2000) COLLATE utf8_unicode_ci NOT NULL,
  `stock_account_perm` varchar(2000) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id_refs_id_f7250bd` (`group_id`),
  CONSTRAINT `group_id_refs_id_f7250bd` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table ttmgrportal.roles_roleperm: ~0 rows (approximately)
/*!40000 ALTER TABLE `roles_roleperm` DISABLE KEYS */;
INSERT INTO `roles_roleperm` (`id`, `group_id`, `perm_data`, `selected_values`, `account_perm`, `product_perm`, `credit_account_perm`, `stock_account_perm`) VALUES
	(1, 90, '', '', '{"allowLogin":"yes","baseTab":["view","modify"],"tradeTab":["view","modify"],"riskTab":["view","modify"]}', '{"base":["view","modify"],"grade":["view","modify"],"sel_accounts":["view","modify"],"workflowTab":["view","modify"],"other":["view","modify"],"risk":["view","modify"]}', '{"creditBaseTab":["view","modify"]}', '{"stockBaseTab":["view","modify"],"assetsProportionTab":["view","modify"],"blackWhiteTab":["view","modify"]}'),
	(3, 100, '', '', '{"allowLogin":"yes","baseTab":["view","modify"],"tradeTab":["view","modify"],"riskTab":["view","modify"]}', '{"base":["view","modify"],"grade":["view","modify"],"sel_accounts":["view","modify"],"workflowTab":["view","modify"],"other":["view","modify"],"risk":["view","modify"]}', '{"creditBaseTab":["view","modify"]}', '{"stockBaseTab":["view","modify"],"assetsProportionTab":["view","modify"],"blackWhiteTab":["view","modify"]}'),
	(5, 102, '', '', '{"allowLogin":"no","baseTab":["view"],"tradeTab":[],"riskTab":[]}', '', '', ''),
	(7, 400, '', '', '{"allowLogin":"no","baseTab":["view"],"tradeTab":["view"],"riskTab":["view"]}', '', '', ''),
	(9, 300, '', '', '{"allowLogin":"yes","baseTab":["view"],"tradeTab":["view"],"riskTab":["view"]}', '', '', ''),
	(11, 200, '', '', '{"allowLogin":"yes","baseTab":["view","modify"],"tradeTab":[],"riskTab":[]}', '', '', ''),
	(13, 101, '', '', '{"allowLogin":"yes","baseTab":["view"],"tradeTab":["view"],"riskTab":["view"]}', '', '', '');
/*!40000 ALTER TABLE `roles_roleperm` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.south_migrationhistory
DROP TABLE IF EXISTS `south_migrationhistory`;
CREATE TABLE `south_migrationhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(255) NOT NULL,
  `migration` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.south_migrationhistory: ~0 rows (approximately)
/*!40000 ALTER TABLE `south_migrationhistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `south_migrationhistory` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.stk_account_stkaccount
DROP TABLE IF EXISTS `stk_account_stkaccount`;
CREATE TABLE `stk_account_stkaccount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `splited` tinyint(1) NOT NULL,
  `left_sub_count` int(11) NOT NULL,
  `fund_proportion` int(11) DEFAULT NULL,
  `broker` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.stk_account_stkaccount: 0 rows
/*!40000 ALTER TABLE `stk_account_stkaccount` DISABLE KEYS */;
/*!40000 ALTER TABLE `stk_account_stkaccount` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.stk_account_stksubaccount
DROP TABLE IF EXISTS `stk_account_stksubaccount`;
CREATE TABLE `stk_account_stksubaccount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_account_id` int(11) DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `fund_proportion` double DEFAULT NULL,
  `pre_balance` decimal(65,2) DEFAULT NULL,
  `nickname` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `initialassets` double DEFAULT NULL,
  `minCapital` double DEFAULT NULL,
  `split_date` datetime NOT NULL,
  `forbidTrade` tinyint(1) DEFAULT NULL,
  `trading_weight` int(11) NOT NULL,
  `parentAccountComply` tinyint(1) DEFAULT NULL,
  `status` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stk_account_stksubaccount_67b44e6a` (`parent_account_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.stk_account_stksubaccount: 0 rows
/*!40000 ALTER TABLE `stk_account_stksubaccount` DISABLE KEYS */;
/*!40000 ALTER TABLE `stk_account_stksubaccount` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.system_monitor_alarmvalues
DROP TABLE IF EXISTS `system_monitor_alarmvalues`;
CREATE TABLE `system_monitor_alarmvalues` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`cpu` DOUBLE NULL DEFAULT NULL,
	`mem` DOUBLE NULL DEFAULT NULL,
	`harddisk` LONGTEXT NULL,
	`net_speed` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
) COLLATE='utf8_general_ci' ENGINE=InnoDB AUTO_INCREMENT=2;

-- Dumping data for table ttmgrportal.system_monitor_alarmvalues: ~0 rows (approximately)
/*!40000 ALTER TABLE `system_monitor_alarmvalues` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_monitor_alarmvalues` ENABLE KEYS */;
insert into system_monitor_alarmvalues (cpu, mem, harddisk, net_speed) values(50, 50, "{}", 500);


-- Dumping structure for table ttmgrportal.system_monitor_mailreceivers
DROP TABLE IF EXISTS `system_monitor_mailreceivers`;
CREATE TABLE `system_monitor_mailreceivers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `smtp_setting_id` int(11) NOT NULL,
  `receiver` varchar(100) NOT NULL,
  `address` varchar(75) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `receiver` (`receiver`),
  KEY `system_monitor_mailreceivers_2c653f6f` (`smtp_setting_id`),
  CONSTRAINT `smtp_setting_id_refs_id_14e0f30a` FOREIGN KEY (`smtp_setting_id`) REFERENCES `system_monitor_smtpsetting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `system_monitor_mailreceivers_trade`;
CREATE TABLE `system_monitor_mailreceivers_trade` (
    `id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `smtp_setting_id` integer NOT NULL,
    `receiver` varchar(100) NOT NULL UNIQUE,
    `address` varchar(75) NOT NULL
)
;
ALTER TABLE `system_monitor_mailreceivers_trade` ADD CONSTRAINT `smtp_setting_id_refs_id_74d28051` FOREIGN KEY (`smtp_setting_id`) REFERENCES `system_monitor_smtpsetting` (`id`);

-- Dumping data for table ttmgrportal.system_monitor_mailreceivers: ~0 rows (approximately)
/*!40000 ALTER TABLE `system_monitor_mailreceivers` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_monitor_mailreceivers` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.system_monitor_smtpsetting
DROP TABLE IF EXISTS `system_monitor_smtpsetting`;
CREATE TABLE `system_monitor_smtpsetting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(256) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `username` varchar(256) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.system_monitor_smtpsetting: ~0 rows (approximately)
/*!40000 ALTER TABLE `system_monitor_smtpsetting` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_monitor_smtpsetting` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.tasks_task
DROP TABLE IF EXISTS `tasks_task`;
CREATE TABLE `tasks_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` datetime NOT NULL,
  `task_group_num` int(11) NOT NULL,
  `task_num` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `over_time` datetime NOT NULL,
  `project_name` varchar(50) NOT NULL,
  `account_name` varchar(50) NOT NULL,
  `task_source` varchar(50) DEFAULT NULL,
  `code` varchar(20) NOT NULL,
  `operation` varchar(50) NOT NULL,
  `order_param` varchar(1024) NOT NULL,
  `transaction_status` varchar(50) NOT NULL,
  `task_info` varchar(50) NOT NULL,
  `task_status` smallint(6) NOT NULL,
  `is_group` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tasks_task_6ecb0d75` (`task_group_num`),
  KEY `tasks_task_51a9831` (`task_num`),
  KEY `tasks_task_9808b6c` (`project_name`),
  KEY `tasks_task_13c1a36a` (`account_name`),
  KEY `tasks_task_65da3d2c` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.tasks_task: ~0 rows (approximately)
/*!40000 ALTER TABLE `tasks_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks_task` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.tradeplatform_broker
DROP TABLE IF EXISTS `tradeplatform_broker`;
CREATE TABLE `tradeplatform_broker` (
  `types` int(11) NOT NULL,
  `id` varchar(32) NOT NULL,
  `platform_id` int(11) NOT NULL,
  `abbrname` varchar(50) NOT NULL,
  `logo` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `investor_id` varchar(10) NOT NULL,
  `password` varchar(30) NOT NULL,
  `nick_name` varchar(100) DEFAULT NULL,
  `creditable` enum('True','False') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tradeplatform_broker_2e5bc86d` (`platform_id`),
  CONSTRAINT `platform_id_refs_id_5c718abf` FOREIGN KEY (`platform_id`) REFERENCES `tradeplatform_platform` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -- Dumping data for table ttmgrportal.tradeplatform_broker: ~0 rows (approximately)
-- /*!40000 ALTER TABLE `tradeplatform_broker` DISABLE KEYS */;
-- INSERT INTO `tradeplatform_broker` (`types`, `id`, `platform_id`, `abbrname`, `logo`, `name`, `investor_id`, `password`, `nick_name`, `creditable`) VALUES
-- 	(1, '1001', 20001, 'tgesst', 'broker_logo_default', 'tgesst', '0', '0', NULL, NULL),
-- 	(2, '101000', 10001, 'ztsp', 'broker_logo_default', '中投实盘', '0', '0', '中投实盘', NULL),
-- 	(2, '102100', 10012, 'hfx', 'broker_logo_default', '恒生O32', '0', '0', '恒生O32', NULL),
-- 	(1, '1040', 21001, 'lzqhmn', 'broker_logo_default', '鲁证期货模拟', '0', '0', NULL, NULL),
-- 	(2, '105000', 10005, 'zxsp', 'broker_logo_default', '中信实盘', '0', '0', '中信实盘', NULL),
-- 	(2, '111000', 11001, 'ztmn', 'broker_logo_default', '中投模拟', '0', '0', '中投模拟', NULL),
-- 	(2, '115000', 11005, 'zxmn', 'broker_logo_default', '中信模拟', '0', '0', '中信模拟', NULL),
-- 	(1, '7080', 21001, 'lzqhfz', 'broker_logo_default', '鲁证期货仿真', '0', '0', NULL, NULL);
-- /*!40000 ALTER TABLE `tradeplatform_broker` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.tradeplatform_idcline
DROP TABLE IF EXISTS `tradeplatform_idcline`;
CREATE TABLE `tradeplatform_idcline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform_id` int(11) NOT NULL,
  `broker_id` varchar(32) NOT NULL,
  `idc_name` varchar(50) NOT NULL,
  `idc_type` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tradeplatform_idcline_2e5bc86d` (`platform_id`),
  KEY `tradeplatform_idcline_4a1f7b17` (`idc_name`),
  CONSTRAINT `platform_id_refs_id_64420d25` FOREIGN KEY (`platform_id`) REFERENCES `tradeplatform_platform` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.tradeplatform_idcline: ~0 rows (approximately)
/*!40000 ALTER TABLE `tradeplatform_idcline` DISABLE KEYS */;
INSERT INTO `tradeplatform_idcline` (`id`, `platform_id`, `broker_id`, `idc_name`, `idc_type`) VALUES
	(39, 21001, '1001', '电信线路', 0),
	(41, 21001, '1001', '电信线路', 1),
	(43, 11001, '111000', '', 0),
	(45, 21001, '1040', '线路01', 0),
	(47, 21001, '1040', '线路01', 1),
	(49, 21001, '7080', '线路02', 0),
	(51, 21001, '7080', '线路02', 1),
	(53, 11005, '115000', '', 0),
	(55, 10005, '105000', '', 0),
	(57, 10001, '101000', '', 0),
	(59, 20001, '1001', '1123', 1);
/*!40000 ALTER TABLE `tradeplatform_idcline` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.tradeplatform_platform
DROP TABLE IF EXISTS `tradeplatform_platform`;
CREATE TABLE `tradeplatform_platform` (
  `abbrname` varchar(50) NOT NULL,
  `logo` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `id` int(11) NOT NULL,
  `types` int(11) NOT NULL DEFAULT '1',
  `creditable` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.tradeplatform_platform: ~0 rows (approximately)
/*!40000 ALTER TABLE `tradeplatform_platform` DISABLE KEYS */;
INSERT INTO `tradeplatform_platform` (`abbrname`, `logo`, `name`, `id`, `types`, `creditable`) VALUES
	('jzsp', 'broker_logo_1', '中投实盘', 10001, 2, 0),
	('zjsp', 'broker_logo_1', '中金实盘', 10002, 2, 0),
	('cjsp', 'broker_logo_1', '长江实盘', 10004, 2, 0),
	('zxsp', 'broker_logo_1', '中信实盘', 10005, 2, 1),
	('qlsp', 'broker_logo_1', '齐鲁实盘', 10006, 2, 0),
	('htsp', 'broker_logo_1', '华泰实盘', 10007, 2, 0),
	('ufx', 'broker_logo_1', '恒生O32', 10012, 2, 0),
	('gzzqsp', 'broker_logo_1', '广州证券', 10013, 2, 0),
	('ztmn', 'broker_logo_1', '中投模拟', 11001, 2, 0),
	('dfsp', 'broker_logo_1', '东方实盘', 11003, 2, 0),
	('zxmn', 'broker_logo_1', '中信模拟', 11005, 2, 1),
	('xtmn', 'broker_logo_1', '迅投模拟', 11009, 2, 0),
	('ydfundmn', 'broker_logo_1', '英大UFX模拟', 11012, 2, 0),
	('gzzqmn', 'broker_logo_1', '广州证券模拟', 11013, 2, 0),
	('ctpsp', 'broker_logo_1', 'CTP实盘', 20001, 1, 0),
	('ctpmn', 'broker_logo_1', 'CTP模拟', 21001, 1, 0);
INSERT INTO `tradeplatform_platform` VALUES ('hhsp', 'broker_logo_1', '恒生期货实盘', '20002', '1','0');
INSERT INTO `tradeplatform_platform` VALUES ('hhmn', 'broker_logo_1', '恒生期货模拟', '21002', '1','0');
INSERT INTO `tradeplatform_platform` VALUES ('gdsp', 'broker_logo_1', '光大证券', '10014', '2','0');
INSERT INTO `tradeplatform_platform` VALUES ('gdmn', 'broker_logo_1', '光大证券模拟', '11014', '2','0');
INSERT INTO `tradeplatform_platform` VALUES ('gtjasp', 'broker_logo_1', '国泰君安实盘', '10011', '2','1');
INSERT INTO `tradeplatform_platform` VALUES ('gtjamn', 'broker_logo_1', '国泰君安模拟', '11011', '2','1');
/*!40000 ALTER TABLE `tradeplatform_platform` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.tradeplatform_serverline
DROP TABLE IF EXISTS `tradeplatform_serverline`;
CREATE TABLE `tradeplatform_serverline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idcLine_id` int(11) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tradeplatform_serverline_141f099f` (`idcLine_id`),
  KEY `tradeplatform_serverline_1d339d38` (`address`),
  CONSTRAINT `idcLine_id_refs_id_76bb05d3` FOREIGN KEY (`idcLine_id`) REFERENCES `tradeplatform_idcline` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.tradeplatform_serverline: ~0 rows (approximately)
/*!40000 ALTER TABLE `tradeplatform_serverline` DISABLE KEYS */;
INSERT INTO `tradeplatform_serverline` (`id`, `idcLine_id`, `address`, `port`) VALUES
	(63, 39, '125.64.36.25', 26205),
	(65, 41, '125.64.36.25', 26213),
	(67, 45, '123.233.249.154', 41205),
	(69, 47, '123.233.249.154', 41213),
	(71, 49, '119.188.3.11', 41205),
	(73, 51, '119.188.3.11', 41213),
	(75, 59, '125.64.36.25', 26213);
/*!40000 ALTER TABLE `tradeplatform_serverline` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.transaction_monitor_ordersmonitor
DROP TABLE IF EXISTS `transaction_monitor_ordersmonitor`;
CREATE TABLE `transaction_monitor_ordersmonitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_type` smallint(6) NOT NULL,
  `interval` int(11) NOT NULL,
  `orders_num_max` int(11) DEFAULT NULL,
  `alarm_types` int(11) NOT NULL,
  `enable` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.transaction_monitor_ordersmonitor: ~0 rows (approximately)
/*!40000 ALTER TABLE `transaction_monitor_ordersmonitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_monitor_ordersmonitor` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.transaction_monitor_positionsmonitor
DROP TABLE IF EXISTS `transaction_monitor_positionsmonitor`;
CREATE TABLE `transaction_monitor_positionsmonitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alarm_types` int(11) NOT NULL,
  `enable` tinyint(1) NOT NULL,
  `alarm_types_sub` int(11) NOT NULL,
  `enable_sub` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.transaction_monitor_positionsmonitor: ~0 rows (approximately)
/*!40000 ALTER TABLE `transaction_monitor_positionsmonitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_monitor_positionsmonitor` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.usrmgr_orderboard
DROP TABLE IF EXISTS `usrmgr_orderboard`;
CREATE TABLE `usrmgr_orderboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mask` smallint(6) NOT NULL,
  `order_mode` smallint(6) NOT NULL,
  `split_mode` smallint(6) NOT NULL,
  `button_setting` smallint(6) NOT NULL,
  `close_option` smallint(6) NOT NULL,
  `close_priority` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.usrmgr_orderboard: ~0 rows (approximately)
/*!40000 ALTER TABLE `usrmgr_orderboard` DISABLE KEYS */;
/*!40000 ALTER TABLE `usrmgr_orderboard` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.usrmgr_userconfig
DROP TABLE IF EXISTS `usrmgr_userconfig`;
CREATE TABLE `usrmgr_userconfig` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `update_time` varchar(17) NOT NULL,
  `conf` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usrmgr_userconfig_403f60f` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.usrmgr_userconfig: ~0 rows (approximately)
/*!40000 ALTER TABLE `usrmgr_userconfig` DISABLE KEYS */;
/*!40000 ALTER TABLE `usrmgr_userconfig` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.usrmgr_userstatus
DROP TABLE IF EXISTS `usrmgr_userstatus`;
CREATE TABLE `usrmgr_userstatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `builder_id` int(11) DEFAULT NULL,
  `build_time` datetime DEFAULT NULL,
  `updater_id` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `venture_order_board_id` int(11) NOT NULL,
  `hedging_order_board_id` int(11) NOT NULL,
  `exhibition_period_board_id` int(11) NOT NULL,
  `interface_orders_num` int(11) NOT NULL,
  `upload_future_config` int(11) NOT NULL,
  `future_config` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `usrmgr_userstatus_369e889a` (`builder_id`),
  KEY `usrmgr_userstatus_6f3629a3` (`build_time`),
  KEY `usrmgr_userstatus_ebc36f0` (`updater_id`),
  KEY `usrmgr_userstatus_688b9aa9` (`update_time`),
  KEY `usrmgr_userstatus_2dd886b6` (`venture_order_board_id`),
  KEY `usrmgr_userstatus_5aa9c849` (`hedging_order_board_id`),
  KEY `usrmgr_userstatus_50b7c5e7` (`exhibition_period_board_id`),
  CONSTRAINT `exhibition_period_board_id_refs_id_6e681cb0` FOREIGN KEY (`exhibition_period_board_id`) REFERENCES `usrmgr_orderboard` (`id`),
  CONSTRAINT `hedging_order_board_id_refs_id_6e681cb0` FOREIGN KEY (`hedging_order_board_id`) REFERENCES `usrmgr_orderboard` (`id`),
  CONSTRAINT `venture_order_board_id_refs_id_6e681cb0` FOREIGN KEY (`venture_order_board_id`) REFERENCES `usrmgr_orderboard` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=458 DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.usrmgr_userstatus: ~0 rows (approximately)
/*!40000 ALTER TABLE `usrmgr_userstatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `usrmgr_userstatus` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.usrmgr_viewer
DROP TABLE IF EXISTS `usrmgr_viewer`;
CREATE TABLE `usrmgr_viewer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) NOT NULL,
  `sub_account_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ttmgrportal.usrmgr_viewer: ~0 rows (approximately)
/*!40000 ALTER TABLE `usrmgr_viewer` DISABLE KEYS */;
/*!40000 ALTER TABLE `usrmgr_viewer` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.workflow_nodes
DROP TABLE IF EXISTS `workflow_nodes`;
CREATE TABLE `workflow_nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(11) DEFAULT NULL,
  `node` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_nodes_26cddbc7` (`workflow_id`),
  KEY `workflow_nodes_425ae3c4` (`group_id`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table ttmgrportal.workflow_nodes: 13 rows
/*!40000 ALTER TABLE `workflow_nodes` DISABLE KEYS */;
INSERT INTO `workflow_nodes` (`id`, `workflow_id`, `node`, `group_id`) VALUES
	(1, 1, 0, 90),
	(3, 3, 0, 100),
	(5, 3, 1, 101),
	(7, 3, 2, 102),
	(9, 3, 3, 200),
	(11, 5, 0, 100),
	(13, 5, 1, 101),
	(15, 5, 2, 200),
	(17, 7, 0, 100),
	(19, 7, 1, 102),
	(21, 7, 2, 200),
	(23, 9, 0, 100),
	(25, 9, 1, 200);
/*!40000 ALTER TABLE `workflow_nodes` ENABLE KEYS */;


-- Dumping structure for table ttmgrportal.workflow_workflow
DROP TABLE IF EXISTS `workflow_workflow`;
CREATE TABLE `workflow_workflow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=160 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
-- 风控模板数据库改动
-- 2014-01-03 15:20:00
-- 王建韬
DROP TABLE IF EXISTS `risk_control_template`;
CREATE TABLE `risk_control_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `content` longtext NOT NULL,
  `memo` longtext,
  `is_enabled` smallint(6) NOT NULL,
  `create_user_id` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user_id` int(11) DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `risk_control_template_4dd022f1` (`create_user_id`),
  KEY `risk_control_template_1edfb48` (`update_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


-- 审批列表新增两张表
-- 宋科政
-- 20140113
DROP TABLE IF EXISTS `risk_control_approvalbsonrisk`;
CREATE TABLE `risk_control_approvalbsonrisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `submit_user_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `status` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `risk_content` longtext NOT NULL,
  `risk_id` int(11) NOT NULL,
  `approve_user_id` int(11) DEFAULT NULL,
  `approve_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `submit_user_u` (`submit_user_id`),
  CONSTRAINT `submit_user_u` FOREIGN KEY (`submit_user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for risk_control_approvallog
-- ----------------------------
DROP TABLE IF EXISTS `risk_control_approvallog`;
CREATE TABLE `risk_control_approvallog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `approval_bsonrisk_id` int(11) NOT NULL,
  `approval_user_id` int(11) NOT NULL,
  `approval_status` int(11) NOT NULL COMMENT '0，通过；1，拒绝',
  `aprroval_time` datetime NOT NULL,
  `risk_content` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for roles_group_permission
-- ----------------------------
DROP TABLE IF EXISTS `roles_group_permission`;
CREATE TABLE `roles_group_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `roles_group_permission_425ae3c4` (`group_id`),
  KEY `roles_group_permission_1e014c8f` (`permission_id`)
) ENGINE=MyISAM AUTO_INCREMENT=452 DEFAULT CHARSET=utf8;

-- songkez 添加帐号资产指标
DROP TABLE IF EXISTS `account_assetsindex`;
CREATE TABLE `account_assetsindex` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `index_id` int(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(50) NOT NULL,
  `scope` int(10) DEFAULT NULL,
  `category_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for `account_categoryindex`
-- ----------------------------
DROP TABLE IF EXISTS `account_categoryindex`;
CREATE TABLE `account_categoryindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `iid` int(11) DEFAULT NULL,
  `type` int(3) NOT NULL COMMENT '1. 期货 2，股票 3，信用账号',
  `m_nScope` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entity_UNIQUE` (`cid`,`iid`,`m_nScope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for account_categoryindex_denominator
-- ----------------------------
DROP TABLE IF EXISTS `account_categoryindex_denominator`;
CREATE TABLE `account_categoryindex_denominator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `type` int(2) NOT NULL DEFAULT '10' COMMENT '10:产品 20:期货',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for account_categoryindex_numerator
-- ----------------------------
DROP TABLE IF EXISTS `account_categoryindex_numerator`;
CREATE TABLE `account_categoryindex_numerator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `type` int(2) NOT NULL DEFAULT '10' COMMENT '10:产品 20:期货',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- by songkez
-- 直接选择的分子分母
DROP TABLE IF EXISTS `product_categoryindex_denominator`;
CREATE TABLE `product_categoryindex_denominator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `type` int(2) NOT NULL DEFAULT '10' COMMENT '10:产品 20:期货',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_categoryindex_numerator
-- ----------------------------
DROP TABLE IF EXISTS `product_categoryindex_numerator`;
CREATE TABLE `product_categoryindex_numerator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `type` int(2) NOT NULL DEFAULT '10' COMMENT '10:产品 20:期货',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for roles_permission
-- ----------------------------
DROP TABLE IF EXISTS `roles_permission`;
CREATE TABLE `roles_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `type` smallint(6) NOT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `method` varchar(5) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  `res_type` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `roles_permission_143efa3` (`menu_id`),
  KEY `idx_type` (`type`),
  KEY `idx_method` (`method`)
) ENGINE=MyISAM AUTO_INCREMENT=10450 DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of roles_permission
-- ----------------------------
INSERT INTO `roles_permission` VALUES ('10001', '登陆权限', '3', null, null, null, '1');
INSERT INTO `roles_permission` VALUES ('10003', null, '1', null, null, '1', '1');
INSERT INTO `roles_permission` VALUES ('10007', null, '1', null, null, '13', '1');
INSERT INTO `roles_permission` VALUES ('10013', null, '1', null, null, '37', '1');
INSERT INTO `roles_permission` VALUES ('10017', null, '1', null, null, '49', '1');
INSERT INTO `roles_permission` VALUES ('10021', null, '1', null, null, '215', '1');
INSERT INTO `roles_permission` VALUES ('10025', null, '1', null, null, '231', '1');
INSERT INTO `roles_permission` VALUES ('10027', null, '1', '^/roles/manage/$', 'GET', '3', '1');
INSERT INTO `roles_permission` VALUES ('10033', null, '1', '^/usrmgr/query/$', 'GET', '11', '1');
INSERT INTO `roles_permission` VALUES ('10037', null, '1', '^/account/query/$', 'GET', '17', '1');
INSERT INTO `roles_permission` VALUES ('10041', null, '1', '^/account/stock/query/$', 'GET', '21', '1');
INSERT INTO `roles_permission` VALUES ('10045', null, '1', '^/product/query/$', 'GET', '27', '1');
INSERT INTO `roles_permission` VALUES ('10051', null, '1', '^/tradeplatform/query/$', 'GET', '35', '1');
INSERT INTO `roles_permission` VALUES ('10053', null, '1', '^/market_source/query/future/$', 'GET', '39', '1');
INSERT INTO `roles_permission` VALUES ('10055', null, '1', '^/market_source/query/stock/$', 'GET', '41', '1');
INSERT INTO `roles_permission` VALUES ('10067', null, '1', '^/transaction_monitor/orders/$', 'GET', '57', '1');
INSERT INTO `roles_permission` VALUES ('10079', null, '1', '^/file/factor/$', 'GET', '228', '1');
INSERT INTO `roles_permission` VALUES ('10081', null, '1', '^/system_monitor/instant/$', 'GET', '233', '1');
INSERT INTO `roles_permission` VALUES ('10083', null, '1', '^/system_monitor/history/$', 'GET', '235', '1');
INSERT INTO `roles_permission` VALUES ('10085', null, '1', '^/system_monitor/settings/$', 'GET', '239', '1');
INSERT INTO `roles_permission` VALUES ('10089', null, '1', '^/account/credit/query/$', 'GET', '259', '1');
INSERT INTO `roles_permission` VALUES ('10091', null, '1', '^/account/category/create/$', 'GET', '260', '1');
INSERT INTO `roles_permission` VALUES ('10092', null, '1', '^/account/instrument_fee_template/$', 'GET', '53', '1');
INSERT INTO `roles_permission` VALUES ('10093', null, '1', '^/risk_control/template/query/$', 'GET', '261', '1');
INSERT INTO `roles_permission` VALUES ('10094', null, '1', '^/account/account_invalid_setting/$', 'GET', '262', '1');
INSERT INTO `roles_permission` VALUES ('10095', null, '1', null, null, '1001', '1');
INSERT INTO `roles_permission` VALUES ('10097', null, '1', null, null, '1002', '1');
INSERT INTO `roles_permission` VALUES ('10099', null, '1', null, null, '1003', '1');
INSERT INTO `roles_permission` VALUES ('10100', null, '1', null, null, '1004', '1');
INSERT INTO `roles_permission` VALUES ('10101', null, '1', null, null, '1101', '1');
INSERT INTO `roles_permission` VALUES ('10105', null, '1', null, null, '1103', '1');
INSERT INTO `roles_permission` VALUES ('10107', null, '1', null, null, '1104', '1');
INSERT INTO `roles_permission` VALUES ('10108', null, '1', null, null, '1105', '1');
INSERT INTO `roles_permission` VALUES ('10109', null, '1', null, null, '1201', '1');
INSERT INTO `roles_permission` VALUES ('10110', null, '1', null, null, '1202', '1');
INSERT INTO `roles_permission` VALUES ('10106', null, '1', null, null, '1203', '1');
INSERT INTO `roles_permission` VALUES ('10111', null, '1', null, null, '1204', '1');
INSERT INTO `roles_permission` VALUES ('10113', null, '1', null, null, '1301', '1');
INSERT INTO `roles_permission` VALUES ('10115', null, '1', null, null, '1302', '1');
INSERT INTO `roles_permission` VALUES ('10117', null, '1', null, null, '1303', '1');
INSERT INTO `roles_permission` VALUES ('10119', null, '1', null, null, '1304', '1');
INSERT INTO `roles_permission` VALUES ('10121', null, '1', null, null, '1305', '1');
INSERT INTO `roles_permission` VALUES ('10123', null, '1', null, null, '1306', '1');
INSERT INTO `roles_permission` VALUES ('10125', null, '1', null, null, '1307', '1');
INSERT INTO `roles_permission` VALUES ('10127', null, '1', null, null, '1401', '1');
INSERT INTO `roles_permission` VALUES ('10129', null, '1', null, null, '1402', '1');
INSERT INTO `roles_permission` VALUES ('10131', null, '1', null, null, '1403', '1');
INSERT INTO `roles_permission` VALUES ('10133', null, '1', null, null, '1601', '1');
INSERT INTO `roles_permission` VALUES ('10135', null, '1', null, null, '1602', '1');
INSERT INTO `roles_permission` VALUES ('10137', null, '1', null, null, '1603', '1');
INSERT INTO `roles_permission` VALUES ('10139', null, '1', null, null, '1701', '1');
INSERT INTO `roles_permission` VALUES ('10141', null, '1', null, null, '1702', '1');
INSERT INTO `roles_permission` VALUES ('10143', null, '1', null, null, '1801', '1');
INSERT INTO `roles_permission` VALUES ('10145', null, '1', null, null, '1802', '1');
INSERT INTO `roles_permission` VALUES ('10147', null, '1', null, null, '1803', '1');
INSERT INTO `roles_permission` VALUES ('10149', null, '1', null, null, '1804', '1');
INSERT INTO `roles_permission` VALUES ('10151', null, '1', null, null, '1901', '1');
INSERT INTO `roles_permission` VALUES ('10153', null, '1', null, null, '1902', '1');
INSERT INTO `roles_permission` VALUES ('10155', '用户组权限-配置', '2', '^/roles/permission/settings/\\?', 'GET', '3', '1');
INSERT INTO `roles_permission` VALUES ('10157', '用户组权限-保存', '2', '^/roles/permission/settings/', 'POST', '3', '2');
INSERT INTO `roles_permission` VALUES ('10161', '用户列表-查询', '2', '^/usrmgr/query_data/\\?', 'GET', '11', '2');
INSERT INTO `roles_permission` VALUES ('10163', '启用用户', '2', '^/usrmgr/start_user/$', 'POST', '11', '2');
INSERT INTO `roles_permission` VALUES ('10165', '停用用户', '2', '^/usrmgr/stop_user/$', 'POST', '11', '2');
INSERT INTO `roles_permission` VALUES ('10167', '修改密码', '2', '^/usrmgr/changepwd/$', 'POST', '11', '2');
INSERT INTO `roles_permission` VALUES ('10169', '用户设置-查询', '2', '^/usrmgr/query_board_data/\\?', 'GET', '11', '1');
INSERT INTO `roles_permission` VALUES ('10171', '用户设置-保存', '2', '^/usrmgr/save_board_settings/$', 'POST', '11', '2');
INSERT INTO `roles_permission` VALUES ('10173', '用户参与产品-查询', '2', '^/usrmgr/products/\\?', 'GET', '11', '3');
INSERT INTO `roles_permission` VALUES ('10175', '用户接口单-查询', '2', '^/interface_orders/query_num/$', 'POST', '11', '1');
INSERT INTO `roles_permission` VALUES ('10177', '用户接口单-保存', '2', '^/interface_orders/set_num/$', 'POST', '11', '2');
INSERT INTO `roles_permission` VALUES ('10181', '列表详情', '2', '^/account/query_data/\\?', 'GET', '17', '2');
INSERT INTO `roles_permission` VALUES ('10183', '重新登录', '2', '^/account/relogin/\\d+/\\?', 'GET', '17', '2');
INSERT INTO `roles_permission` VALUES ('10185', '修改柜台/本地密码', '2', '^/account/change_pwd/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10187', '拆分账号', '2', '^/account/split/\\?', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10189', '合并账号', '2', '^/account/merge/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10191', '启用主/子账号', '2', '^/account/active/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10193', '停用主/子账号', '2', '^/account/stop/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10195', '设置', '2', '^/account/tradeset/\\d+/', 'GET', '17', '1');
INSERT INTO `roles_permission` VALUES ('10197', '主/子账号-查询持仓', '2', '^/account/idata/position/\\d+/\\?', 'GET', '17', '3');
INSERT INTO `roles_permission` VALUES ('10199', '主/子账号-查询持仓-分/调仓', '2', '^/account/update_position/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10201', '主账号-查询持仓-批量分仓', '2', '^/account/splitAllPosition2SubAccount/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10203', '主账号-查询持仓-批量调仓', '2', '^/account/splitAllPosition2ParentAccount/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10205', '主/子账号-查询持仓-导入分仓', '2', '^/file/position/upload/$', 'POST', '17', '2');
INSERT INTO `roles_permission` VALUES ('10207', '主/子账号-查询持仓-导出分仓(数据)', '2', '^/account/idata/position/\\d+/\\?.+export=true.*$', 'GET', '17', '1');
INSERT INTO `roles_permission` VALUES ('10209', '主/子账号-查询委托', '2', '^/account/idata/order/\\d+/\\?', 'GET', '17', '3');
INSERT INTO `roles_permission` VALUES ('10211', '主/子账号-查询委托-导出', '2', '^/account/idata/order/\\d+/\\?.+export=true.*$', 'GET', '17', '2');
INSERT INTO `roles_permission` VALUES ('10213', '主/子账号-查询成交', '2', '^/account/idata/deal/\\d+/\\?', 'GET', '17', '3');
INSERT INTO `roles_permission` VALUES ('10215', '主/子账号-查询成交-导出', '2', '^/account/idata/deal/\\d+/\\?.+export=true.*$', 'GET', '17', '2');
INSERT INTO `roles_permission` VALUES ('10217', '主/子账号-查询结算单', '2', '^/logmgr/query_settlement_pop/\\?', 'GET', '17', '3');
INSERT INTO `roles_permission` VALUES ('10219', '主/子账号-查询走势', '2', '^/statistics/net_trend_iframe/\\?', 'GET', '17', '3');
INSERT INTO `roles_permission` VALUES ('10221', '保存', '2', '^/account/set/$', 'POST', '1001', '2');
INSERT INTO `roles_permission` VALUES ('10223', '保存', '2', '^/account/set/$', 'POST', '1002', '2');
INSERT INTO `roles_permission` VALUES ('10225', '保存', '2', '^/account/set/$', 'POST', '1003', '2');
INSERT INTO `roles_permission` VALUES ('10229', '列表详情', '2', '^/account/stock/query_data/\\?', 'GET', '21', '2');
INSERT INTO `roles_permission` VALUES ('10231', '重新登录', '2', '^/account/relogin/\\d+/\\?', 'GET', '21', '2');
INSERT INTO `roles_permission` VALUES ('10233', '修改柜台/本地密码', '2', '^/account/change_pwd/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10235', '拆分账号', '2', '^/account/split/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10237', '合并账号', '2', '^/account/merge/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10239', '启用主/子账号', '2', '^/account/active/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10241', '停用主/子账号', '2', '^/account/stop/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10243', '设置', '2', '^/account/stock/modify/\\d+/', 'GET', '21', '1');
INSERT INTO `roles_permission` VALUES ('10245', '主/子账号-查询持仓', '2', '^/account/idata/position/\\d+/\\?', 'GET', '21', '3');
INSERT INTO `roles_permission` VALUES ('10247', '主/子账号-查询持仓-分/调仓', '2', '^/account/update_position/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10249', '主账号-查询持仓-批量分仓', '2', '^/account/splitAllPosition2SubAccount/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10251', '主账号-查询持仓-批量调仓', '2', '^/account/splitAllPosition2ParentAccount/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10253', '主/子账号-查询持仓-导入分仓', '2', '^/file/position/upload/$', 'POST', '21', '2');
INSERT INTO `roles_permission` VALUES ('10255', '主/子账号-查询持仓-导出分仓(数据)', '2', '^/account/idata/position/\\d+/\\?.+export=true.*$', 'GET', '21', '1');
INSERT INTO `roles_permission` VALUES ('10257', '主/子账号-查询委托', '2', '^/account/idata/order/\\d+/\\?', 'GET', '21', '3');
INSERT INTO `roles_permission` VALUES ('10259', '主/子账号-查询委托-导出', '2', '^/account/idata/order/\\d+/\\?.+export=true.*$', 'GET', '21', '2');
INSERT INTO `roles_permission` VALUES ('10261', '主/子账号-查询成交', '2', '^/account/idata/deal/\\d+/\\?', 'GET', '21', '3');
INSERT INTO `roles_permission` VALUES ('10263', '主/子账号-查询成交-导出', '2', '^/account/idata/deal/\\d+/\\?.+export=true.*$', 'GET', '21', '2');
INSERT INTO `roles_permission` VALUES ('10265', '主/子账号-查询结算单', '2', '^/logmgr/query_settlement_pop/\\?', 'GET', '21', '3');
INSERT INTO `roles_permission` VALUES ('10267', '主/子账号-查询走势', '2', '^/statistics/net_trend_iframe/\\?', 'GET', '21', '3');
INSERT INTO `roles_permission` VALUES ('10269', '保存', '2', '^/account/stock/modify/\\d+/\\?', 'POST', '1101', '2');
INSERT INTO `roles_permission` VALUES ('10273', '保存', '2', '^/account/stock/risk_stocks/\\?', 'POST', '1103', '2');
INSERT INTO `roles_permission` VALUES ('10275', '保存', '2', '^/stock/stock_tradset/\\?', 'POST', '1104', '2');
INSERT INTO `roles_permission` VALUES ('10279', '列表详情', '2', '^/account/credit/query_data/\\?', 'GET', '259', '2');
INSERT INTO `roles_permission` VALUES ('10281', '重新登录', '2', '^/account/relogin/\\d+/\\?', 'GET', '259', '2');
INSERT INTO `roles_permission` VALUES ('10283', '修改柜台/本地密码', '2', '^/account/change_pwd/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10285', '拆分账号', '2', '^/account/split/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10287', '合并账号', '2', '^/account/merge/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10289', '启用主/子账号', '2', '^/account/active/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10291', '停用主/子账号', '2', '^/account/stop/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10467', '设置', '2', '^/account/credit/modify/\\d+/', 'GET', '259', '1');
INSERT INTO `roles_permission` VALUES ('10293', '主/子账号-查询持仓', '2', '^/account/idata/position/\\d+/\\?', 'GET', '259', '3');
INSERT INTO `roles_permission` VALUES ('10295', '主/子账号-查询持仓-分/调仓', '2', '^/account/update_position/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10297', '主账号-查询持仓-批量分仓', '2', '^/account/splitAllPosition2SubAccount/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10299', '主账号-查询持仓-批量调仓', '2', '^/account/splitAllPosition2ParentAccount/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10301', '主/子账号-查询持仓-导入分仓', '2', '^/file/position/upload/$', 'POST', '259', '2');
INSERT INTO `roles_permission` VALUES ('10303', '主/子账号-查询持仓-导出分仓(数据)', '2', '^/account/idata/position/\\d+/\\?.+export=true.*$', 'GET', '259', '1');
INSERT INTO `roles_permission` VALUES ('10305', '主/子账号-查询委托', '2', '^/account/idata/order/\\d+/\\?', 'GET', '259', '3');
INSERT INTO `roles_permission` VALUES ('10307', '主/子账号-查询委托-导出', '2', '^/account/idata/order/\\d+/\\?.+export=true.*$', 'GET', '259', '2');
INSERT INTO `roles_permission` VALUES ('10309', '主/子账号-查询成交', '2', '^/account/idata/deal/\\d+/\\?', 'GET', '259', '3');
INSERT INTO `roles_permission` VALUES ('10311', '主/子账号-查询成交-导出', '2', '^/account/idata/deal/\\d+/\\?.+export=true.*$', 'GET', '259', '2');
INSERT INTO `roles_permission` VALUES ('10313', '主/子账号-查询结算单', '2', '^/logmgr/query_settlement_pop/\\?', 'GET', '259', '3');
INSERT INTO `roles_permission` VALUES ('10315', '主/子账号-查询走势', '2', '^/statistics/net_trend_iframe/\\?', 'GET', '259', '3');
INSERT INTO `roles_permission` VALUES ('10317', '查询标的信息', '2', '^/account/idata/cstk/\\d+/\\?', 'GET', '259', '1');
INSERT INTO `roles_permission` VALUES ('10319', '查询信用资产明细', '2', '^/account/credit/query_account_detail/\\?', 'GET', '259', '1');
INSERT INTO `roles_permission` VALUES ('10321', '查询负债合约', '2', '^/account/idata/CStkCompacts/\\d+/\\?', 'GET', '259', '1');
INSERT INTO `roles_permission` VALUES ('10323', '保存', '2', '^/account/credit/modify/\\d+/\\?', 'POST', '1201', '2');
INSERT INTO `roles_permission` VALUES ('10325', '保存', '2', '^/account/credit/risk_stocks/\\?', 'POST', '1202', '2');
INSERT INTO `roles_permission` VALUES ('10329', '设置', '2', '^/product/config/\\?', 'GET', '27', '1');
INSERT INTO `roles_permission` VALUES ('10331', '列表详情', '2', '^/product/query_data/\\?', 'GET', '27', '2');
INSERT INTO `roles_permission` VALUES ('10333', '查询净值', '2', '^/product/query_dbalance/$', 'POST', '27', '2');
INSERT INTO `roles_permission` VALUES ('10335', '总览', '2', '^/product/pandect/\\?', 'GET', '27', '3');
INSERT INTO `roles_permission` VALUES ('10337', '指令', '2', '^/product/idata/command/\\?', 'GET', '27', '3');
INSERT INTO `roles_permission` VALUES ('10339', '指令导出', '2', '^/product/idata/command/\\?.+export=true.*$', 'GET', '27', '2');
INSERT INTO `roles_permission` VALUES ('10341', '任务', '2', '^/product/idata/task/\\?', 'GET', '27', '3');
INSERT INTO `roles_permission` VALUES ('10343', '任务导出', '2', '^/product/idata/task/\\?.+export=true.*$', 'GET', '27', '2');
INSERT INTO `roles_permission` VALUES ('10345', '保存', '2', '^/product/config/base/save/$', 'POST', '1301', '2');
INSERT INTO `roles_permission` VALUES ('10347', '保存', '2', '^/product/config/grade/save/$', 'POST', '1302', '2');
INSERT INTO `roles_permission` VALUES ('10349', '保存', '2', '^/product/config/account/save/$', 'POST', '1303', '2');
INSERT INTO `roles_permission` VALUES ('10351', '列表详情', '2', '^/product/config/workflow/query/\\?', 'GET', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10353', '工作流保存', '2', '^/product/config/workflow/save/$', 'POST', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10355', '关联查询员', '2', '^/product/config/link/queriers/$', 'POST', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10357', '关联风控员', '2', '^/product/config/link/riskController/$', 'POST', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10359', '关联平仓员', '2', '^/product/config/link/closers/$', 'POST', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10361', '关联用户', '2', '^/product/config/link/user/$', 'POST', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10363', '关联账号', '2', '^/product/config/link/account/$', 'POST', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10365', '删除', '2', '^/product/config/workflow/delete/$', 'POST', '1304', '2');
INSERT INTO `roles_permission` VALUES ('10367', '保存/提审', '2', '^/product/productRiskControlConfig/\\d+/$', 'POST', '1305', '2');
INSERT INTO `roles_permission` VALUES ('10369', '保存', '2', '^/product/config/clientRefreshInterval/save/$', 'POST', '1306', '2');
INSERT INTO `roles_permission` VALUES ('10371', '保存设置', '2', '^/product/config/other/save/$', 'POST', '1307', '2');
INSERT INTO `roles_permission` VALUES ('10377', '列表详情', '2', '^/tradeplatform/query_data/\\?', 'GET', '35', '2');
INSERT INTO `roles_permission` VALUES ('10379', '设置', '2', '^/tradeplatform/edit/\\?', 'GET', '35', '3');
INSERT INTO `roles_permission` VALUES ('10381', '保存设置', '2', '^/tradeplatform/save_edit_data/$', 'POST', '35', '2');
INSERT INTO `roles_permission` VALUES ('10383', '删除', '2', '^/tradeplatform/del_broker/$', 'POST', '35', '2');
INSERT INTO `roles_permission` VALUES ('10385', '添加', '2', '^/market_source/save/$', 'POST', '39', '2');
INSERT INTO `roles_permission` VALUES ('10387', '删除', '2', '^/market_source/delsource/future/$', 'POST', '39', '2');
INSERT INTO `roles_permission` VALUES ('10389', '保存', '2', '^/market_source/save/$', 'POST', '41', '2');
INSERT INTO `roles_permission` VALUES ('10391', '保存', '2', '^/risk_control/futures/stoploss/$', 'POST', '1701', '2');
INSERT INTO `roles_permission` VALUES ('10393', '保存', '2', '^/risk_control/futures/matchedOrders/$', 'POST', '1702', '2');
INSERT INTO `roles_permission` VALUES ('10395', '保存', '2', '^/risk_control/stoploss/$', 'POST', '1801', '2');
INSERT INTO `roles_permission` VALUES ('10397', '保存', '2', '^/risk_control/stocks/$', 'POST', '1802', '2');
INSERT INTO `roles_permission` VALUES ('10399', '保存', '2', '^/risk_control/bucket/$', 'POST', '1803', '2');
INSERT INTO `roles_permission` VALUES ('10401', '保存', '2', '^/risk_control/matchedOrders/$', 'POST', '1804', '2');
INSERT INTO `roles_permission` VALUES ('10403', '列表详情', '2', '^/risk_control/query_approvallist_data/\\?', 'GET', '56', '2');
INSERT INTO `roles_permission` VALUES ('10405', '通过/驳回审核', '2', '^/risk_control/do_approve/$', 'POST', '56', '2');
INSERT INTO `roles_permission` VALUES ('10407', '保存', '2', '^/transaction_monitor/orders/update_setting/$', 'POST', '57', '2');
INSERT INTO `roles_permission` VALUES ('10409', '查询列表详情', '2', '^/file/factor/status/set/\\?$', 'GET', '228', '2');
INSERT INTO `roles_permission` VALUES ('10411', '查询券商详情', '2', '^/file/factor/status/broker/d+/date/\\d+/$', 'GET', '228', '2');
INSERT INTO `roles_permission` VALUES ('10413', '上传文件', '2', '^/file/factor/upload/$', 'POST', '228', '2');
INSERT INTO `roles_permission` VALUES ('10415', '分类查询', '2', '^/account/category/query/\\?', 'GET', '260', '1');
INSERT INTO `roles_permission` VALUES ('10417', '列表详情', '2', '^/risk_control/template/query_data/\\?', 'GET', '261', '2');
INSERT INTO `roles_permission` VALUES ('10419', '新建模板', '2', '^/risk_control/template/new/\\?', 'GET', '261', '1');
INSERT INTO `roles_permission` VALUES ('10421', '新建模板保存', '2', '^/risk_control/template/save/$', 'POST', '261', '2');
INSERT INTO `roles_permission` VALUES ('10423', '更新模板', '2', '^/risk_control/template/edit/\\?id=\\d+$', 'GET', '261', '1');
INSERT INTO `roles_permission` VALUES ('10425', '更新模板保存', '2', '^/risk_control/template/update/$', 'POST', '261', '2');
INSERT INTO `roles_permission` VALUES ('10427', '删除模板', '2', '^/risk_control/template/del/\\?id=\\d+', 'GET', '261', '2');
INSERT INTO `roles_permission` VALUES ('10439', '查询详情', '2', '^/system_monitor/query_system_status/\\?', 'GET', '233', '2');
INSERT INTO `roles_permission` VALUES ('10441', '更改阈值', '2', '^/system_monitor/update_alarms/$', 'POST', '233', '2');
INSERT INTO `roles_permission` VALUES ('10443', '列表详情', '2', '^/system_monitor/query_history_data/\\?$', 'GET', '235', '2');
INSERT INTO `roles_permission` VALUES ('10445', '测试SMTP服务', '2', '^/system_monitor/validate_settings/$', 'POST', '1901', '2');
INSERT INTO `roles_permission` VALUES ('10447', '保存设置', '2', '^/system_monitor/update_setting/$', 'POST', '1901', '2');
INSERT INTO `roles_permission` VALUES ('10449', '保存设置', '2', '^/system_monitor/update_setting/$', 'POST', '1902', '2');
INSERT INTO `roles_permission` VALUES ('10450', null, '1', null, null, '1903', '1');
INSERT INTO `roles_permission` VALUES ('10451', '删除文件', '2', '^/system_monitor/file_list_u/packages/delete/\\d+/$', 'POST', '1903', '2');
INSERT INTO `roles_permission` VALUES ('10453', '上传文件', '2', '^/system_monitor/file_list/', 'POST', '1903', '2');
INSERT INTO `roles_permission` VALUES ('10452', '下载文件', '2', '^/system_monitor/file_list_u/packages/\\d+/$', 'GET', '1903', '1');
INSERT INTO `roles_permission` VALUES ('10454', '应用产品', '2', '^/risk_control/template/product_query/\\?id=\\d+$', 'GET', '261', '3');
INSERT INTO `roles_permission` VALUES ('10065', null, '1', '^/risk_control/approvallist$', 'GET', '56', '1');
INSERT INTO `roles_permission` VALUES ('10455', '修改用户组名称', '2', '^/roles/change_name/\\d+/\\?', 'POST', '3', '2');
INSERT INTO `roles_permission` VALUES ('10462', null, '1', '^/risk_control/global_risk$', 'GET', '52', '1');
INSERT INTO `roles_permission` VALUES ('10456', '保存', '2', '^/risk_control/global_risk$', 'POST', '52', '2');
INSERT INTO `roles_permission` VALUES ('10457', null, '1', null, null, '1203', '1');
INSERT INTO `roles_permission` VALUES ('10458', '保存', '2', '^/credit/credit_tradset/\\?', 'POST', '1203', '2');
INSERT INTO `roles_permission` VALUES ('10463', '保存模板关联产品', '2', '^/risk_control/template/product_query/$', 'POST', '261', '2');

-- 重复添加待删除
-- INSERT INTO `roles_permission` VALUES ('10464', null, '1', '^/account/account_invalid_setting/$', 'GET', '262', '1');
-- INSERT INTO `roles_permission` VALUES ('10464', '外联账号执行', '2', '^/account/server/execute_ras/$', 'POST', '61', '2');


-- ----------------------------
-- Table structure for roles_group_permission
-- ----------------------------
DROP TABLE IF EXISTS `roles_group_permission`;
CREATE TABLE `roles_group_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `roles_group_permission_425ae3c4` (`group_id`),
  KEY `roles_group_permission_1e014c8f` (`permission_id`)
) ENGINE=MyISAM AUTO_INCREMENT=452 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for system_monitor_package
-- ----------------------------
DROP TABLE IF EXISTS `system_monitor_package`;
CREATE TABLE `system_monitor_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `suffix` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `package` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `download_time` int(11) NOT NULL,
  `upload_user_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `full_name` (`full_name`),
  KEY `system_monitor_package_2ee62ae8` (`upload_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- 证券分类文件上传至服务器保存路径
DROP TABLE IF EXISTS `account_upload`;
CREATE TABLE `account_upload`(
   `id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY,
   `upload_file` varchar(100) NOT NULL,
   `create_time` datetime NOT NULL,
   `files_name` varchar(100) NOT NULL
);


-- o32_deal  表中增加市场ID字段
alter table o32_deal add column `markId` int DEFAULT NULL;
-- o32_order  表中增加委托类型和是否有效委托两个字段
alter table o32_order add column `orderType` varchar(2) DEFAULT NULL;
alter table o32_order add column `isValid` varchar(2) DEFAULT NULL;

-- 创建account_remote表
DROP TABLE IF EXISTS `account_account_remote`;
CREATE TABLE `account_account_remote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `szse` varchar(30) DEFAULT NULL,
  `sse` varchar(30) DEFAULT NULL,
  `password` varchar(100) NOT NULL,
  `splited` tinyint(1) NOT NULL,
  `left_sub_count` int(11) NOT NULL,
  `fund_proportion` int(11) DEFAULT NULL,
  `platform_id` int(11) DEFAULT NULL,
  `broker_id` varchar(32) DEFAULT NULL,
  `idcLine_id` int(11) DEFAULT NULL,
  `types` int(11) DEFAULT NULL,
  `api_type` varchar(32) DEFAULT 'CTP' COMMENT ' API',
  `bank_no` varchar(64) DEFAULT NULL,
  `SH_account` varchar(64) DEFAULT NULL,
  `SZ_account` varchar(64) DEFAULT NULL,
  `stk_type` int(11) DEFAULT '49',
  `server_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `workflow_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- 创建account_remoteinfo表
DROP TABLE IF EXISTS `account_remoteinfo`;
CREATE TABLE `account_remoteinfo` (
    `id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `account_id` integer NOT NULL,
    `serverId` integer NOT NULL,
    `productId` integer NOT NULL,
    `workflowId` integer NOT NULL
);

-- 创建account_server表
DROP TABLE IF EXISTS `account_server`;
CREATE TABLE `account_server`(
`id` int(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
`IP` varchar(50) not null,
`server_name` varchar(50) not null,
`port` varchar(10) not null
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `account_serverusers`;
CREATE TABLE `account_serverusers`(
`id` int(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
`server_id` int(10) not null,
`username` varchar(20) not null,
`password` varchar(200) not null
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


-- account_account表添加islocal字段
alter table account_account add column `is_local` int(11) DEFAULT 1;

-- 创建account_assetsindexcondition表
SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `account_assetsindexcondition`
-- ----------------------------
DROP TABLE IF EXISTS `account_assetsindexcondition`;
CREATE TABLE `account_assetsindexcondition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `cid` bigint(20) NOT NULL,
  `iid` bigint(20) NOT NULL,
  `m_nScope` int(3) NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '1. 期货 2 证券 3 信用账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- product_product表中字段type改为isPassRisk
alter table product_product change type isPassRisk int(11) default 1;


ALTER TABLE idata_caccountdetail ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_ccreditaccountdetail ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_cdealdetail ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_cordercommand ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_corderdetail ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_cpositiondetail ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_cpositionstatics ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_criskcontrolmsg ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_cstatement ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_cstkcompacts ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_cstksubjects ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_ctaskdetail ADD INDEX m_trade_date (m_trade_date);
ALTER TABLE idata_stockquerydeliveryresp ADD INDEX m_trade_date (m_trade_date);

-- ----------------------------
-- Table structure for thread_task_stock_list
-- ----------------------------
DROP TABLE IF EXISTS `thread_task_stock_list`;
CREATE TABLE `thread_task_stock_list` (
  `id`                 INT(11)       NOT NULL AUTO_INCREMENT,
  `version`            VARCHAR(100)  NOT NULL,
  `is_new`             SMALLINT(1)   NOT NULL,
  `broker_type`        SMALLINT(1)   NOT NULL,
  `market_trade_date`  VARCHAR(1000) NOT NULL,
  `stock_list_content` LONGTEXT      NOT NULL,
  `create_time`        DATETIME      NOT NULL,
  PRIMARY KEY (`id`),
  KEY `seq_is_new` (`is_new`),
  KEY `seq_version` (`version`) USING BTREE
)
  ENGINE =MyISAM
  AUTO_INCREMENT =26
  DEFAULT CHARSET =utf8;

-- 用户辅助表
-- Table structure for `usrmgr_userhelp`
-- ----------------------------
DROP TABLE IF EXISTS `usrmgr_userhelp`;
CREATE TABLE `usrmgr_userhelp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `mobile` varchar(11)  NULL,
  `is_mobile_enabled` SMALLINT(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `product_trend_value`;
CREATE TABLE `product_trend_value` (
  `id` bigint(20) NOT NULL auto_increment,
  `product_id` bigint(20) default NULL,
  `net_value` double(20,4) default NULL,
  `tradedate` varchar(20) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `entity_UNIQUE` USING BTREE (`product_id`,`tradedate`)
) ENGINE=MyISAM AUTO_INCREMENT=2938 DEFAULT CHARSET=utf8;

ALTER TABLE `idata_criskcontrolmsg` ADD INDEX `comanddate` (`command_id`,`m_trade_date`);


-- 记录风控审批驳回表
DROP TABLE IF EXISTS `risk_control_rejectmessage`;
CREATE TABLE `risk_control_rejectmessage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `content` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `account_userselectedstock`;
CREATE TABLE `account_userselectedstock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stockCode` varchar(10) NOT NULL,
  `name` varchar(20) NOT NULL,
  `type` int(2) NOT NULL,
  `userId` int(20) NOT NULL,
  `market` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=316 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `product_riskcontrol_msg`;
CREATE TABLE `product_riskcontrol_msg` (
  `id` int(20) NOT NULL auto_increment,
  `trade_time` timestamp NULL default NULL on update CURRENT_TIMESTAMP,
  `product_id` int(20) default NULL,
  `msg` varchar(400) default NULL,
  `is_download` int(2) default '0',
  `trade_date` varchar(40) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 添加证券、期货公司增加保存日盘与夜盘字段
ALTER TABLE `tradeplatform_broker`
    Add COLUMN `trade_json` longtext default null ;

-- 账号无效设置表
DROP TABLE IF EXISTS `market_trade_date_setting`;
CREATE TABLE `market_trade_date_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) DEFAULT NULL,
  `content` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


-- 增量查询
DROP TABLE IF EXISTS `account_query_cache`;
CREATE TABLE `account_query_cache` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `query_data_type` int(11) DEFAULT NULL,
  `cache_data` longblob ,
  `new_add` longtext,
  `new_delete` longtext,
  `date` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=328 DEFAULT CHARSET=utf8;


-- 调仓记录表
DROP TABLE IF EXISTS `account_adjust_position_record`;
CREATE TABLE `account_adjust_position_record` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `account_id` int(10) NOT NULL,
  `account_type` int(2) NOT NULL,
  `change_content` longtext,
  `createTime` varchar(20) DEFAULT NULL,
  `account_name` varchar(20) NOT NULL,
  `str_account_name` varchar(20) DEFAULT NULL,
  `stock_code` varchar(20) DEFAULT NULL,
  `stock_name` varchar(20) NOT NULL DEFAULT '',
  `company` varchar(20) DEFAULT NULL,
  `detailTime` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=212 DEFAULT CHARSET=utf8;

-- 分仓记录表
DROP TABLE IF EXISTS `account_compartments`;
CREATE TABLE `account_compartments` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `code` varchar(200) NOT NULL,
  `type` int(10) NOT NULL,
  `subAccountName` varchar(20) NOT NULL,
  `accountName` varchar(20) NOT NULL,
  `createTime` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;



-- 平安大华升级
drop table if exists `product_extra_fund`;
create table `product_extra_fund` (
  `id`               int(10)     not null auto_increment,
  `m_nProductID`     int(2)      not null,
  `m_strTradingDay`  varchar(10) not null,
  `m_nTotalShare`    double default null,
  `m_dAvailable`     double default null,
  `m_dBalance`       double default null,
  `m_dNav`           double default null,
  `m_dActualCapital` double default null,
  `total_value`      double default null,
  primary key ( `id`)
)
  engine =MyISAM
  default charset =utf8;

-- 增加创建时间字段
ALTER TABLE `tradeplatform_broker`
    Add COLUMN `create_time` timestamp NOT NULL;

ALTER TABLE `idata_stockquerydeliveryresp`
    ADD COLUMN `bizFlag` smallint(6) NOT NULL;

ALTER TABLE `idata_stockquerydeliveryresp`
    ADD COLUMN `bizName` varchar(30) NOT NULL;

-- 分仓记录表
DROP TABLE IF EXISTS `account_compartments`;
CREATE TABLE `account_compartments` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `code` varchar(200) NOT NULL,
  `type` int(10) NOT NULL,
  `subAccountName` varchar(20) NOT NULL,
  `accountName` varchar(20) NOT NULL,
  `createTime` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- 增加时候经过OPT校验字段
ALTER TABLE `usrmgr_userhelp`
ADD COLUMN `is_otp_verify` SMALLINT(1) NULL;


ALTER TABLE `usrmgr_userhelp`
ADD COLUMN `online_num` int(100) NULL;

ALTER TABLE `usrmgr_userhelp`
ADD COLUMN `check_mac` int(10) NULL;

-- 部署记录表
DROP TABLE IF EXISTS `system_monitor_deploy_records`;
CREATE TABLE `system_monitor_deploy_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(20) NOT NULL,
  `port` varchar(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `mysql_username` varchar(20) NOT NULL,
  `mysql_password` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;



-- 新包列表
DROP TABLE IF EXISTS `system_monitor_client_package`;
CREATE TABLE `system_monitor_client_package` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `short_name` varchar(50) NOT NULL,
  `name_suffix` varchar(20) NOT NULL,
  `upload_path` varchar(100) NOT NULL,
  `upload_user_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `deploy_status` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 修改字段类型
alter table idata_cordercommand MODIFY m_bIsStopLoss int(11) NOT NULL;



DROP TABLE IF EXISTS `account_subaccountmoneyadjust`;
CREATE TABLE `account_subaccountmoneyadjust` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `updateTime` datetime NOT NULL,
  `sub_account_id` int(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `later_money` double(100,0) NOT NULL,
  `before_money` double(100,0) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;


-- 账号手续费率
DROP TABLE IF EXISTS `account_instrument_fee_rate`;
CREATE TABLE `account_instrument_fee_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `content` longtext,
  `template_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_template_id` (`template_id`),
  KEY `idx_account_id` (`account_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=120 DEFAULT CHARSET=utf8;

-- 手续费率模板
DROP TABLE IF EXISTS `instrument_fee_rate_template`;
CREATE TABLE `instrument_fee_rate_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(90) NOT NULL,
  `type` smallint(6) NOT NULL,
  `content` longtext,
  `create_user_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `remark` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_type` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

-- ttlog
DROP TABLE IF EXISTS `ttlog`;
CREATE TABLE `ttlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service` varchar(32) DEFAULT NULL,
  `content` varchar(1024) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=41782 DEFAULT CHARSET=utf8;

-- 账号用户角色中间表
DROP TABLE IF EXISTS `account_user`;
CREATE TABLE `account_user` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `account_id` int(20) DEFAULT NULL,
  `user_id` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


alter table account_stock add column `type` int(20) DEFAULT NULL;

DROP TABLE IF EXISTS `account_uploadhelp`;
CREATE TABLE `account_uploadhelp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `upload_file` varchar(100) NOT NULL,
  `create_time` datetime NOT NULL,
  `files_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=236 DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `account_category_help`;
CREATE TABLE `account_category_help` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `stockIdList` longtext,
  `categoryName` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `account_umbrella_record`;
CREATE TABLE `account_umbrella_record` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `type` int(10) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `str_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=128 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `account_umbrella`;
CREATE TABLE `account_umbrella` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `upload_file` varchar(100) NOT NULL,
  `create_time` varchar(100) NOT NULL,
  `files_name` varchar(100) NOT NULL,
  `market` varchar(20) DEFAULT NULL,
  `type` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=520 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `stock_float_total`;
CREATE TABLE `stock_float_total` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `market` char(10) NOT NULL,
  `stock` char(10) NOT NULL,
  `name` char(20) DEFAULT NULL,
  `totalVolume` double DEFAULT NULL,
  `floatVolume` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `idata_cleardetail`;
CREATE TABLE `idata_cleardetail` (
  `m_priKey_tag` varchar(255) NOT NULL,
  `m_strAccountID` varchar(128) NOT NULL,
  `m_strSubAccountID` varchar(128) DEFAULT NULL,
  `m_strExchangeID` varchar(128) NOT NULL,
  `m_strInstrumentName` varchar(128) NOT NULL,
  `m_dPrice` double NOT NULL,
  `m_nVolume` int(11) NOT NULL,
  `m_nType` int(11) NOT NULL,
  `m_strTypeName` varchar(128) NOT NULL,
  `m_strDate` varchar(128) NOT NULL,
  PRIMARY KEY (`m_priKey_tag`,`m_strDate`),
  KEY `m_priKey_tag` (`m_priKey_tag`) USING BTREE,
  KEY `m_strDate` (`m_strDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stock_msg_upload`;
CREATE TABLE `stock_msg_upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `upload_file` varchar(100) NOT NULL,
  `create_time` datetime NOT NULL,
  `files_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

alter table product_otherright add column `management_fee_rate` double;
alter table product_otherright add column `create_time` datetime ;
alter table product_otherright add column `type` int(20) ;
alter table product_otherright add column `start_date` varchar (20);
alter table product_otherright add column `update_time` datetime ;

DROP TABLE IF EXISTS `product_management_fee`;
CREATE TABLE `product_management_fee` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `otherRightId` int(20) DEFAULT NULL,
  `update_time` varchar(200) DEFAULT NULL,
  `management_fee` double DEFAULT NULL,
  `date` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sy_1` (`otherRightId`,`update_time`)
) ENGINE=MyISAM AUTO_INCREMENT=164 DEFAULT CHARSET=utf8;

alter table account_stockcategory add column `description` longtext ;


-- alter table account_stockcategory drop column `categoryIdList`;


DROP TABLE IF EXISTS `account_metadata_juyuan`;
CREATE TABLE `account_metadata_juyuan` (
  `stockMarket` varchar(20) NOT NULL,
  `stockCode` varchar(20) NOT NULL,
  `stockCategory_id` bigint(20) NOT NULL,
  `stockName` varchar(20) DEFAULT '',
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_sys` smallint(6) DEFAULT NULL,
  `strProductId` varchar(100) DEFAULT NULL,
  `bondType1` int(20) DEFAULT NULL,
  `bondType2` int(20) DEFAULT NULL,
  `issuerCode` varchar(100) DEFAULT NULL,
  `indexType` int(20) DEFAULT NULL,
  `componentType` int(20) DEFAULT NULL,
  `industryType` int(20) DEFAULT NULL,
  `riskGrade` int(20) DEFAULT NULL,
  `Type` int(20) DEFAULT NULL,
  `investmentType` int(20) DEFAULT NULL,
  `starRank` int(20) DEFAULT NULL,
  `innerCode` varchar(100) DEFAULT NULL,
  `creditRating` varchar(100) DEFAULT NULL,
  `holderSN` varchar(100) DEFAULT NULL,
  `fundStyle` varchar(100) DEFAULT NULL,
  `duration_mod` float DEFAULT NULL,
  `Bcode` varchar(100) DEFAULT NULL,
  `maturity` float DEFAULT NULL,
  `companyCode` int(20) DEFAULT NULL,
  `agentCode` int(20) DEFAULT NULL,
  `RAcode` varchar(100) DEFAULT NULL,
  `isHSIndex300` smallint(4) DEFAULT NULL,
  `investStyle` int(20) DEFAULT NULL,
  `listedSector` int(20) DEFAULT NULL,
  `listedState` int(20) DEFAULT NULL,
  `bondNature` int(20) DEFAULT NULL,
  `industryStandard` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`,`stockCode`),
  KEY `account_stockcategory_fk` (`stockCategory_id`),
  KEY `stockMarket_index` (`stockMarket`) USING BTREE,
  KEY `stockCode_index` (`stockCode`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=412615 DEFAULT CHARSET=utf8;

alter table idata_stockquerydeliveryresp add column `positionStr` varchar (64);

DROP TABLE IF EXISTS `account_category_conditionindex`;
CREATE TABLE `account_category_conditionindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `indexId` int(11) DEFAULT NULL,
  `type` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

alter table tradeplatform_platform add column `fast_trading` tinyint(1) DEFAULT NULL;

alter table account_account add column `is_fast_trading` smallint(6) NOT NULL DEFAULT '0';

alter table idata_cordercommand add column `m_eXtHedgeType` int(11) DEFAULT NULL;

DROP TABLE IF EXISTS `global_pricetypecondition`;
CREATE TABLE `global_pricetypecondition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `code` varchar(20) NOT NULL,
  `type_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user_mac_address`;
CREATE TABLE `user_mac_address` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `mac_address` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- 快速交易接口

ALTER TABLE `usrmgr_userhelp` ADD COLUMN `is_trading_interface` int(1) NULL;


ALTER TABLE `usrmgr_userhelp` ADD COLUMN `flow_control` longtext;



-- 产品用户中间表
DROP TABLE IF EXISTS `product_user`;
CREATE TABLE `product_user` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `product_id` int(20) DEFAULT NULL,
  `user_id` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- 估值辅助表
DROP TABLE IF EXISTS `product_valuation_upload`;
CREATE TABLE `product_valuation_upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `upload_file` varchar(100) NOT NULL,
  `create_time` datetime NOT NULL,
  `files_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

-- 估值表
DROP TABLE IF EXISTS `product_valuation`;
CREATE TABLE `product_valuation` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `product_id` int(20) DEFAULT NULL,
  `content` longtext,
  `correct_value` double DEFAULT NULL,
  `create_date` varchar(50) DEFAULT NULL,
  `update_date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- 是否估值修正
ALTER TABLE `product_trend_value` ADD COLUMN `is_valuation` int(1) default 0;

ALTER TABLE `product_trend_value` ADD COLUMN `product_net_assets` double  default null ;

ALTER TABLE `product_trend_value` ADD COLUMN `product_share` double default null;

ALTER TABLE `product_trend_value` ADD COLUMN `stock_fund` double default null;
ALTER TABLE `product_trend_value` ADD COLUMN `bond_fund` double default null;
ALTER TABLE `product_trend_value` ADD COLUMN `fund_fund` double default null;
ALTER TABLE `product_trend_value` ADD COLUMN `warrants_fund` double default null;


DROP TABLE IF EXISTS `account_metadata_caihui`;
CREATE TABLE `account_metadata_caihui` (
  `id` bigint(20) NOT NULL DEFAULT '0',
  `stockMarket` varchar(20) DEFAULT NULL,
  `stockCode` varchar(20) NOT NULL,
  `stockCategory_id` bigint(20) NOT NULL,
  `stockName` varchar(20) DEFAULT '',
  `is_sys` smallint(6) NOT NULL DEFAULT '0',
  `strProductId` varchar(100) DEFAULT NULL,
  `duration_mod` float(100,0) DEFAULT NULL,
  `fundStyle` varchar(100) DEFAULT NULL,
  `Bcode` varchar(100) DEFAULT NULL,
  `bondType2` int(20) DEFAULT NULL,
  `issuerCode` varchar(100) DEFAULT NULL,
  `indexType` int(20) DEFAULT NULL,
  `componentType` int(20) DEFAULT NULL,
  `industryType` int(20) DEFAULT NULL,
  `Type` int(20) DEFAULT NULL,
  `investmentType` int(20) DEFAULT NULL,
  `starRank` int(20) DEFAULT NULL,
  `innerCode` varchar(100) DEFAULT NULL,
  `creditRating` varchar(100) DEFAULT NULL,
  `holderSN` varchar(100) DEFAULT NULL,
  `maturity` varchar(100) DEFAULT NULL,
  `companyCode` int(100) DEFAULT NULL,
  `agentCode` int(20) DEFAULT NULL,
  `RAcode` varchar(100) DEFAULT NULL,
  `isHSIndex300` smallint(4) DEFAULT NULL,
  `investStyle` varchar(20) DEFAULT NULL,
  `bondNature` int(20) DEFAULT NULL,
  `warType1` varchar(20) DEFAULT NULL,
  `warType2` varchar(20) DEFAULT NULL,
  `warRightType` varchar(20) DEFAULT NULL,
  `warCountType` varchar(20) DEFAULT NULL,
  `warSecuType` varchar(20) DEFAULT NULL,
  `repType` varchar(20) DEFAULT NULL,
  `repStyle` varchar(20) DEFAULT NULL,
  `bondType1` varchar(20) DEFAULT NULL,
  `fundType` varchar(20) DEFAULT NULL,
  `fundNature` varchar(20) DEFAULT NULL,
  `secuType` varchar(20) DEFAULT NULL,
  `bondStatus` varchar(20) DEFAULT NULL,
  `bondProduct` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 质押券
DROP TABLE IF EXISTS `file_upload`;
CREATE TABLE `file_upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `upload_file` varchar(100) NOT NULL,
  `create_time` datetime NOT NULL,
  `files_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=310 DEFAULT CHARSET=latin1;

-- 风控临时保存表
DROP TABLE IF EXISTS `risk_temporary_bsonrisk`;
CREATE TABLE `risk_temporary_bsonrisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_id` int(11) DEFAULT NULL,
  `is_sub` int(1) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `content` longtext,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 产品分时需要加的表
DROP TABLE IF EXISTS `accountFinance`;
CREATE TABLE `accountFinance` (
  `m_accountKey` varchar(64) NOT NULL,
  `m_trade_date` varchar(8) DEFAULT NULL,
  `m_trade_time` varchar(4) DEFAULT NULL,
  `m_strFinance` varchar(128) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 外部产品设置
DROP TABLE IF EXISTS `system_monitor_trading_setting`;
CREATE TABLE `system_monitor_trading_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform_id` int(11) DEFAULT NULL,
  `m_strName` varchar(50) DEFAULT NULL,
  `m_strAddress` varchar(32) DEFAULT NULL,
  `m_strUserName` varchar(50) DEFAULT NULL,
  `m_strPassWd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

-- INSERT INTO `roles_menu` VALUES ('28', null, '外部产品管理', 'products.png', '2', '/system_monitor/trading_setting/', '1', '[]');
-- INSERT INTO `roles_menu` VALUES ('1930', 'system_monitor_trading_setting', '监控设置', '', '3', '', '28', '[]');
-- INSERT INTO `roles_menu` VALUES ('1931', 'system_monitor_trading_setting_list', '交易监控', '', '3', '', '28', '[]');
--
-- INSERT INTO `roles_menu` VALUES ('1932', 'system_monitor_settings_smtp_log', '日志邮件发送地址列表', '', '3', '', '239', 'logSmtpTab');
-- INSERT INTO `roles_menu` VALUES ('1933', 'system_monitor_settings_email_log', '日志邮件接收列表', '', '3', '', '239', 'logEmailTab');


ALTER TABLE `product_productworkflow` ADD COLUMN `parent_id` int(11) default NULL ;
ALTER TABLE `product_productworkflow` ADD COLUMN `custom_stop` int(1) default NULL ;

ALTER TABLE `product_flowusers` ADD COLUMN `offline` int(11) default NULL ;

DROP TABLE IF EXISTS `product_workflow_help`;
CREATE TABLE `product_workflow_help` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_flowId` int(11) DEFAULT NULL,
  `content` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=90 DEFAULT CHARSET=utf8;
-- update product_productworkflow set parent_id = -1 where parent_id is NULL;
--
-- update workflow_workflow set parent_id = -1 where parent_id is NULL;

-- 止损工作流模板
INSERT INTO `workflow_workflow` VALUES ('1', '独立交易员流程模板', '-1');
INSERT INTO `workflow_workflow` VALUES ('3', '四角色标准工作流', '-1');
INSERT INTO `workflow_workflow` VALUES ('5', '三角色普通工作流1', '-1');
INSERT INTO `workflow_workflow` VALUES ('7', '三角色普通工作流2', '-1');
INSERT INTO `workflow_workflow` VALUES ('9', '两角色简单工作流', '-1');
INSERT INTO `workflow_workflow` VALUES ('101', '独立交易员流程模板', '1');
INSERT INTO `workflow_workflow` VALUES ('103', '风控员  →  独立交易员流程模板', '1');
INSERT INTO `workflow_workflow` VALUES ('105', '平仓员  →  独立交易员流程模板', '1');
INSERT INTO `workflow_workflow` VALUES ('107', '风控员  →  平仓员  →  独立交易员流程模板', '1');
INSERT INTO `workflow_workflow` VALUES ('109', '平仓员  →  风控员  →  独立交易员流程模板', '1');
INSERT INTO `workflow_workflow` VALUES ('111', '四角色标准工作流', '3');
INSERT INTO `workflow_workflow` VALUES ('113', '风控员  →  四角色标准工作流', '3');
INSERT INTO `workflow_workflow` VALUES ('115', '平仓员  →  四角色标准工作流', '3');
INSERT INTO `workflow_workflow` VALUES ('117', '风控员  →  平仓员  →  四角色标准工作流', '3');
INSERT INTO `workflow_workflow` VALUES ('119', '平仓员  →  风控员  →  四角色标准工作流', '3');
INSERT INTO `workflow_workflow` VALUES ('121', '三角色普通工作流1', '5');
INSERT INTO `workflow_workflow` VALUES ('123', '风控员  →  三角色普通工作流1', '5');
INSERT INTO `workflow_workflow` VALUES ('125', '平仓员  →  三角色普通工作流1', '5');
INSERT INTO `workflow_workflow` VALUES ('127', '风控员  →  平仓员  →  三角色普通工作流1', '5');
INSERT INTO `workflow_workflow` VALUES ('129', '平仓员  →  风控员  →  三角色普通工作流1', '5');
INSERT INTO `workflow_workflow` VALUES ('131', '三角色普通工作流2', '7');
INSERT INTO `workflow_workflow` VALUES ('133', '风控员  →  三角色普通工作流2', '7');
INSERT INTO `workflow_workflow` VALUES ('135', '平仓员  →  三角色普通工作流2', '7');
INSERT INTO `workflow_workflow` VALUES ('137', '风控员  →  平仓员  →  三角色普通工作流2', '7');
INSERT INTO `workflow_workflow` VALUES ('139', '平仓员  →  风控员  →  三角色普通工作流2', '7');
INSERT INTO `workflow_workflow` VALUES ('141', '两角色简单工作流', '9');
INSERT INTO `workflow_workflow` VALUES ('143', '风控员  →  两角色简单工作流', '9');
INSERT INTO `workflow_workflow` VALUES ('145', '平仓员  →  两角色简单工作流', '9');
INSERT INTO `workflow_workflow` VALUES ('147', '风控员  →  平仓员  →  两角色简单工作流', '9');
INSERT INTO `workflow_workflow` VALUES ('149', '平仓员  →  风控员  →  两角色简单工作流', '9');
INSERT INTO `workflow_workflow` VALUES ('151', '风控员  →  平仓员 ', '1');
INSERT INTO `workflow_workflow` VALUES ('153', '风控员  →  平仓员 ', '3');
INSERT INTO `workflow_workflow` VALUES ('155', '风控员  →  平仓员 ', '5');
INSERT INTO `workflow_workflow` VALUES ('157', '风控员  →  平仓员 ', '7');
INSERT INTO `workflow_workflow` VALUES ('159', '风控员  →  平仓员 ', '9');


-- 工作流节点
INSERT INTO `workflow_nodes` VALUES ('101', '101', '0', '90');
INSERT INTO `workflow_nodes` VALUES ('103', '103', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('105', '103', '1', '90');

INSERT INTO `workflow_nodes` VALUES ('107', '105', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('109', '105', '1', '90');

INSERT INTO `workflow_nodes` VALUES ('111', '107', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('113', '107', '1', '400');
INSERT INTO `workflow_nodes` VALUES ('115', '107', '2', '90');

INSERT INTO `workflow_nodes` VALUES ('117', '109', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('119', '109', '1', '500');
INSERT INTO `workflow_nodes` VALUES ('121', '109', '2', '90');


INSERT INTO `workflow_nodes` VALUES ('123', '111', '0', '100');
INSERT INTO `workflow_nodes` VALUES ('125', '111', '1', '101');
INSERT INTO `workflow_nodes` VALUES ('127', '111', '2', '102');
INSERT INTO `workflow_nodes` VALUES ('129', '111', '3', '200');

INSERT INTO `workflow_nodes` VALUES ('131', '113', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('133', '113', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('135', '113', '2', '101');
INSERT INTO `workflow_nodes` VALUES ('137', '113', '3', '102');
INSERT INTO `workflow_nodes` VALUES ('139', '113', '4', '200');


INSERT INTO `workflow_nodes` VALUES ('141', '115', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('143', '115', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('145', '115', '2', '101');
INSERT INTO `workflow_nodes` VALUES ('147', '115', '3', '102');
INSERT INTO `workflow_nodes` VALUES ('149', '115', '4', '200');

INSERT INTO `workflow_nodes` VALUES ('151', '117', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('153', '117', '1', '400');
INSERT INTO `workflow_nodes` VALUES ('155', '117', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('157', '117', '3', '101');
INSERT INTO `workflow_nodes` VALUES ('159', '117', '4', '102');
INSERT INTO `workflow_nodes` VALUES ('161', '117', '5', '200');


INSERT INTO `workflow_nodes` VALUES ('163', '119', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('165', '119', '1', '500');
INSERT INTO `workflow_nodes` VALUES ('167', '119', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('169', '119', '3', '101');
INSERT INTO `workflow_nodes` VALUES ('171', '119', '4', '102');
INSERT INTO `workflow_nodes` VALUES ('173', '119', '5', '200');

-- 三角色1
INSERT INTO `workflow_nodes` VALUES ('175', '121', '0', '100');
INSERT INTO `workflow_nodes` VALUES ('177', '121', '1', '101');
INSERT INTO `workflow_nodes` VALUES ('179', '121', '2', '200');


INSERT INTO `workflow_nodes` VALUES ('181', '123', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('183', '123', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('185', '123', '2', '101');
INSERT INTO `workflow_nodes` VALUES ('187', '123', '3', '200');

INSERT INTO `workflow_nodes` VALUES ('189', '125', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('191', '125', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('193', '125', '2', '101');
INSERT INTO `workflow_nodes` VALUES ('195', '125', '3', '200');

INSERT INTO `workflow_nodes` VALUES ('197', '127', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('199', '127', '1', '400');
INSERT INTO `workflow_nodes` VALUES ('201', '127', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('203', '127', '3', '101');
INSERT INTO `workflow_nodes` VALUES ('205', '127', '4', '200');


INSERT INTO `workflow_nodes` VALUES ('207', '129', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('209', '129', '1', '500');
INSERT INTO `workflow_nodes` VALUES ('211', '129', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('213', '129', '3', '101');
INSERT INTO `workflow_nodes` VALUES ('215', '129', '4', '200');

-- 三工作流2
INSERT INTO `workflow_nodes` VALUES ('217', '131', '0', '100');
INSERT INTO `workflow_nodes` VALUES ('219', '131', '1', '102');
INSERT INTO `workflow_nodes` VALUES ('221', '131', '2', '200');

INSERT INTO `workflow_nodes` VALUES ('223', '133', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('225', '133', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('227', '133', '2', '102');
INSERT INTO `workflow_nodes` VALUES ('229', '133', '3', '200');

INSERT INTO `workflow_nodes` VALUES ('231', '135', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('235', '135', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('237', '135', '2', '102');
INSERT INTO `workflow_nodes` VALUES ('239', '135', '3', '200');

INSERT INTO `workflow_nodes` VALUES ('241', '137', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('243', '137', '1', '400');
INSERT INTO `workflow_nodes` VALUES ('245', '137', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('247', '137', '3', '102');
INSERT INTO `workflow_nodes` VALUES ('249', '137', '4', '200');

INSERT INTO `workflow_nodes` VALUES ('251', '139', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('253', '139', '1', '500');
INSERT INTO `workflow_nodes` VALUES ('255', '139', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('257', '139', '3', '102');
INSERT INTO `workflow_nodes` VALUES ('259', '139', '4', '200');

INSERT INTO `workflow_nodes` VALUES ('261', '141', '0', '100');
INSERT INTO `workflow_nodes` VALUES ('263', '141', '1', '200');

INSERT INTO `workflow_nodes` VALUES ('265', '143', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('267', '143', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('269', '143', '2', '200');


INSERT INTO `workflow_nodes` VALUES ('271', '145', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('273', '145', '1', '100');
INSERT INTO `workflow_nodes` VALUES ('275', '145', '2', '200');

INSERT INTO `workflow_nodes` VALUES ('277', '147', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('279', '147', '1', '400');
INSERT INTO `workflow_nodes` VALUES ('281', '147', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('283', '147', '3', '200');

INSERT INTO `workflow_nodes` VALUES ('285', '149', '0', '400');
INSERT INTO `workflow_nodes` VALUES ('287', '149', '1', '500');
INSERT INTO `workflow_nodes` VALUES ('289', '149', '2', '100');
INSERT INTO `workflow_nodes` VALUES ('291', '149', '3', '200');

INSERT INTO `workflow_nodes` VALUES ('293', '151', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('295', '151', '1', '400');

INSERT INTO `workflow_nodes` VALUES ('297', '153', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('299', '153', '1', '400');

INSERT INTO `workflow_nodes` VALUES ('301', '155', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('303', '155', '1', '400');


INSERT INTO `workflow_nodes` VALUES ('305', '157', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('307', '157', '1', '400');

INSERT INTO `workflow_nodes` VALUES ('309', '159', '0', '500');
INSERT INTO `workflow_nodes` VALUES ('311', '159', '1', '400');

-- INSERT INTO `roles_menu` VALUES ('1105', 'account_stock_rate', '手续费设置', null, '3', '', '21', 'stockRate');
-- INSERT INTO `roles_menu` VALUES ('1004', 'account_future_rate', '保证金/手续费设置', null, '3', '', '17', 'marginTab');
-- INSERT INTO `roles_menu` VALUES ('1204', 'account_credit_rate', '手续费设置', null, '3', '', '259', 'creditRate');

INSERT INTO `roles_permission` VALUES ('10465', null, '1', null, null, '1105', '1');
INSERT INTO `roles_permission` VALUES ('10467', null, '1', null, null, '1004', '1');
INSERT INTO `roles_permission` VALUES ('10469', null, '1', null, null, '1203', '1');
INSERT INTO `roles_permission` VALUES ('10471', null, '1', null, null, '1204', '1');

-- ----------------------------
-- Table structure for `ttlog`
-- ----------------------------
DROP TABLE IF EXISTS `ttlog`;
CREATE TABLE `ttlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service` varchar(32) CHARACTER SET utf8 NOT NULL,
  `content` varchar(1024) CHARACTER SET utf8 DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `typeid` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `logLevel` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=989590 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of ttlog
-- ----------------------------


DROP TABLE IF EXISTS `product_product_external`;
CREATE TABLE `product_product_external` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `external_product_id` int(11) DEFAULT NULL,
  `external_content` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=78 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `product_external_settings`;
CREATE TABLE `product_external_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `external_pid` int(11) DEFAULT NULL,
  `content` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- name唯一性
ALTER TABLE account_account DROP INDEX name;
ALTER TABLE logmgr_log add COLUMN `mac_str` VARCHAR(100) DEFAULT NULL ;

CREATE TABLE `system_monitor_smtpsetting_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `system_monitor_mailreceivers_log`;
CREATE TABLE `system_monitor_mailreceivers_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `smtp_setting_id` int(11) NOT NULL,
  `receiver` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `logReceive` (`receiver`) USING BTREE,
  KEY `setting_id` (`smtp_setting_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- 调整其他权益
DROP TABLE IF EXISTS `product_otherrightadjust`;
CREATE TABLE `product_otherrightadjust` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `otherright_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `right_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `right_value` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE `account_adjust_position_record`
ADD COLUMN `adjust_account_name`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL AFTER `str_account_name`;

-- 账号组风控
DROP TABLE IF EXISTS `accountgroup_group`;
CREATE TABLE `accountgroup_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `accountIds` varchar(500) DEFAULT NULL,
  `content` longtext,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=477 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `idata_repurchasepos`;
CREATE TABLE `idata_repurchasepos` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `tradedate` varchar(10) NOT NULL,
  `PosKey` varchar(512) NOT NULL,
  `PosContent` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=656 DEFAULT CHARSET=utf8;
























