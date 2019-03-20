CREATE DATABASE `dwz` /*!40100 DEFAULT CHARACTER SET utf8 */;

CREATE TABLE  `links` (
  `links_id` int(11) NOT NULL COMMENT 'ID',
  `url` varchar(100) DEFAULT NULL COMMENT 'URL长地址',
  `type` varchar(45) DEFAULT NULL COMMENT '类型，SYS系统自分配，CUS用户自定义',
  `keyword` varchar(45) DEFAULT NULL COMMENT '短网址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(100) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`links_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;