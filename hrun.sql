SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

create database hrun;
use hrun;

-- ----------------------------
-- Table structure for DebugTalk
-- ----------------------------
DROP TABLE IF EXISTS `DebugTalk`;
CREATE TABLE `DebugTalk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `debugtalk` longtext,
  `belong_project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `DebugTalk_belong_project_id_0957612a_fk_ProjectInfo_id` (`belong_project_id`) USING BTREE,
  CONSTRAINT `DebugTalk_belong_project_id_0957612a_fk_ProjectInfo_id` FOREIGN KEY (`belong_project_id`) REFERENCES `ProjectInfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for EnvInfo
-- ----------------------------
DROP TABLE IF EXISTS `EnvInfo`;
CREATE TABLE `EnvInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `env_name` varchar(40) NOT NULL,
  `base_url` varchar(40) NOT NULL,
  `simple_desc` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `env_name` (`env_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='运行环境';

-- ----------------------------
-- Table structure for ModuleInfo
-- ----------------------------
DROP TABLE IF EXISTS `ModuleInfo`;
CREATE TABLE `ModuleInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `module_name` varchar(50) NOT NULL,
  `test_user` varchar(50) NOT NULL,
  `simple_desc` varchar(100) DEFAULT NULL,
  `other_desc` varchar(100) DEFAULT NULL,
  `belong_project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ModuleInfo_belong_project_id_7a17e510_fk_ProjectInfo_id` (`belong_project_id`) USING BTREE,
  CONSTRAINT `ModuleInfo_belong_project_id_7a17e510_fk_ProjectInfo_id` FOREIGN KEY (`belong_project_id`) REFERENCES `ProjectInfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='模块管理';

-- ----------------------------
-- Table structure for ProjectInfo
-- ----------------------------
DROP TABLE IF EXISTS `ProjectInfo`;
CREATE TABLE `ProjectInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `project_name` varchar(50) NOT NULL,
  `responsible_name` varchar(20) NOT NULL,
  `test_user` varchar(100) NOT NULL,
  `dev_user` varchar(100) NOT NULL,
  `publish_app` varchar(100) NOT NULL,
  `simple_desc` varchar(100) DEFAULT NULL,
  `other_desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_name` (`project_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目列表';

-- ----------------------------
-- Table structure for TestCaseInfo
-- ----------------------------
DROP TABLE IF EXISTS `TestCaseInfo`;
CREATE TABLE `TestCaseInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `type` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `belong_project` varchar(50) NOT NULL,
  `include` varchar(1024) DEFAULT NULL,
  `author` varchar(20) NOT NULL,
  `request` longtext NOT NULL,
  `belong_module_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `TestCaseInfo_belong_module_id_040b8702_fk_ModuleInfo_id` (`belong_module_id`) USING BTREE,
  CONSTRAINT `TestCaseInfo_belong_module_id_040b8702_fk_ModuleInfo_id` FOREIGN KEY (`belong_module_id`) REFERENCES `ModuleInfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=462 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用例';

-- ----------------------------
-- Table structure for TestReports
-- ----------------------------
DROP TABLE IF EXISTS `TestReports`;
CREATE TABLE `TestReports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `report_name` varchar(40) NOT NULL,
  `start_at` varchar(40) DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `testsRun` int(11) NOT NULL,
  `successes` int(11) NOT NULL,
  `reports` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='测试报告';

-- ----------------------------
-- Table structure for TestSuite
-- ----------------------------
DROP TABLE IF EXISTS `TestSuite`;
CREATE TABLE `TestSuite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `suite_name` varchar(100) NOT NULL,
  `include` longtext NOT NULL,
  `belong_project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `TestSuite_belong_project_id_76d73d7f_fk_ProjectInfo_id` (`belong_project_id`) USING BTREE,
  CONSTRAINT `TestSuite_belong_project_id_76d73d7f_fk_ProjectInfo_id` FOREIGN KEY (`belong_project_id`) REFERENCES `ProjectInfo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='测试套件';

-- ----------------------------
-- Table structure for UserInfo
-- ----------------------------
DROP TABLE IF EXISTS `UserInfo`;
CREATE TABLE `UserInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户表';

-- ----------------------------
-- Table structure for UserType
-- ----------------------------
DROP TABLE IF EXISTS `UserType`;
CREATE TABLE `UserType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `type_name` varchar(20) NOT NULL,
  `type_desc` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`) USING BTREE,
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`) USING BTREE,
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`) USING BTREE,
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for celery_taskmeta
-- ----------------------------
DROP TABLE IF EXISTS `celery_taskmeta`;
CREATE TABLE `celery_taskmeta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  `result` longtext,
  `date_done` datetime(6) NOT NULL,
  `traceback` longtext,
  `hidden` tinyint(1) NOT NULL,
  `meta` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`) USING BTREE,
  KEY `celery_taskmeta_hidden_23fd02dc` (`hidden`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for celery_tasksetmeta
-- ----------------------------
DROP TABLE IF EXISTS `celery_tasksetmeta`;
CREATE TABLE `celery_tasksetmeta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskset_id` varchar(255) NOT NULL,
  `result` longtext NOT NULL,
  `date_done` datetime(6) NOT NULL,
  `hidden` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taskset_id` (`taskset_id`) USING BTREE,
  KEY `celery_tasksetmeta_hidden_593cfc24` (`hidden`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`) USING BTREE,
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for djcelery_crontabschedule
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_crontabschedule`;
CREATE TABLE `djcelery_crontabschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `minute` varchar(64) NOT NULL,
  `hour` varchar(64) NOT NULL,
  `day_of_week` varchar(64) NOT NULL,
  `day_of_month` varchar(64) NOT NULL,
  `month_of_year` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for djcelery_intervalschedule
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_intervalschedule`;
CREATE TABLE `djcelery_intervalschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `every` int(11) NOT NULL,
  `period` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for djcelery_periodictask
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_periodictask`;
CREATE TABLE `djcelery_periodictask` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `task` varchar(200) NOT NULL,
  `args` longtext NOT NULL,
  `kwargs` longtext NOT NULL,
  `queue` varchar(200) DEFAULT NULL,
  `exchange` varchar(200) DEFAULT NULL,
  `routing_key` varchar(200) DEFAULT NULL,
  `expires` datetime(6) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `last_run_at` datetime(6) DEFAULT NULL,
  `total_run_count` int(10) unsigned NOT NULL,
  `date_changed` datetime(6) NOT NULL,
  `description` longtext NOT NULL,
  `crontab_id` int(11) DEFAULT NULL,
  `interval_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `djcelery_periodictas_crontab_id_75609bab_fk_djcelery_` (`crontab_id`) USING BTREE,
  KEY `djcelery_periodictas_interval_id_b426ab02_fk_djcelery_` (`interval_id`) USING BTREE,
  CONSTRAINT `djcelery_periodictas_crontab_id_75609bab_fk_djcelery_` FOREIGN KEY (`crontab_id`) REFERENCES `djcelery_crontabschedule` (`id`),
  CONSTRAINT `djcelery_periodictas_interval_id_b426ab02_fk_djcelery_` FOREIGN KEY (`interval_id`) REFERENCES `djcelery_intervalschedule` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for djcelery_periodictasks
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_periodictasks`;
CREATE TABLE `djcelery_periodictasks` (
  `ident` smallint(6) NOT NULL,
  `last_update` datetime(6) NOT NULL,
  PRIMARY KEY (`ident`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for djcelery_taskstate
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_taskstate`;
CREATE TABLE `djcelery_taskstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(64) NOT NULL,
  `task_id` varchar(36) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `tstamp` datetime(6) NOT NULL,
  `args` longtext,
  `kwargs` longtext,
  `eta` datetime(6) DEFAULT NULL,
  `expires` datetime(6) DEFAULT NULL,
  `result` longtext,
  `traceback` longtext,
  `runtime` double DEFAULT NULL,
  `retries` int(11) NOT NULL,
  `hidden` tinyint(1) NOT NULL,
  `worker_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`) USING BTREE,
  KEY `djcelery_taskstate_state_53543be4` (`state`) USING BTREE,
  KEY `djcelery_taskstate_name_8af9eded` (`name`) USING BTREE,
  KEY `djcelery_taskstate_tstamp_4c3f93a1` (`tstamp`) USING BTREE,
  KEY `djcelery_taskstate_hidden_c3905e57` (`hidden`) USING BTREE,
  KEY `djcelery_taskstate_worker_id_f7f57a05_fk_djcelery_workerstate_id` (`worker_id`) USING BTREE,
  CONSTRAINT `djcelery_taskstate_worker_id_f7f57a05_fk_djcelery_workerstate_id` FOREIGN KEY (`worker_id`) REFERENCES `djcelery_workerstate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for djcelery_workerstate
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_workerstate`;
CREATE TABLE `djcelery_workerstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) NOT NULL,
  `last_heartbeat` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hostname` (`hostname`) USING BTREE,
  KEY `djcelery_workerstate_last_heartbeat_4539b544` (`last_heartbeat`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

SET FOREIGN_KEY_CHECKS = 1;
