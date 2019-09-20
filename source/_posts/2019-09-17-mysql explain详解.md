---
layout: post
title: MySQL explain 详解（转载）
date: 2019-09-17
keywords: 
top: 10
categories: 
    - MySQL
tags:
    - MySQL
---
# MySQL explain 详解
# 1.概述
- MySQL提供了一个explain命令，它可以对select语句进行分析，并输出select执行的详细信息，以供开发人员针对性的优化
```
// 示例
EXPLAIN select * from test where age=12;
```

# 2.准备工作
- 创建表
```
CREATE TABLE `test` (
  `name` varchar(255) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  KEY `idx` (`name`(1),`age`,`sex`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
- 利用事务插入测试数据
```
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `auto_insert1`()
BEGIN
	declare i int default 1;
	while(i<3000000)do
        insert into test values(concat('name',i),i,concat('sex',i));
        set i=i+1;
  end while;
END //
DELIMITER
```

# 3.explain输出格式详解
## 1.输出内容
id|select_type|table|partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra
-|-|-|-|-|-|-|-|-|-|-|-|
1|SIMPLE|test|NULL|ref|idx|idx|768|const|1|100.00|Using where

## 2.相应字段解释
```
id:select 查询的标识符，每个select都是自动分配一个唯一的标识符。
select_type:select查询的类型
table:查询的哪一张表
partitions:匹配的分区
type:join类型
possible_keys:此次查询中可能选用的索引
key:此次查询中确切使用到的索引。
ref:哪个字段或常数与key一起被使用。
rows:显示此查询一共扫描了多少行，一个估计值。
filtered:表示此查询条件所过滤的数据的百分比。
extra:额外的信息
```

## 3.相应字段详解
### 1.select_type
- simple,常规查询，表示此查询不包含union查询或者子查询
- primary,查询中若包含任何复杂的子部分，最外层的select会被标记为primary
- union,表示此查询是union的第二或随后的查询
- dependent union,union中的第二个或者后面的查询语句，取决于外面的查询
- union result，union的结果
- subquery，子查询中的第一个select
- dependent subquery,子查询中的第一个select，取决于外面的查询，即子查询依赖于外层查询的结果。

### 2.table
- 表示查询涉及的表或者衍生表

### 3.type
#### 1.常见取值
- system，表中只有一条数据，是特殊的const类型
- const，针对主键或者唯一索引的等值查询条件扫描，最多只返回一行数据，const查询数据非常快，因为它仅仅读取一次即可
- eq_ref,此类型通常出现在多表的join查询，表示对于前表的每一个结果，都只能匹配到后表的一行结果，并且查询的比较操作通常是=，查询效率较高
- ref，此类型通常出现在多表的join查询，针对于非唯一或非主键索引，或者是使用了最左前缀规则索引的查询。对于之前的表的每一个行联合，全部记录都将从表中读出，这个类型严重依赖于根据索引匹配的记录多少-----越少越好，索引的字段必须是有序的，才能实现这种类型的查找，才能利用索引。
- range，表示使用索引范围查询，通过索引字段范围获取表中部分数据记录，这个类型通常现在=,<>,>,>=,<,<=,is null ,<=>,between,in()，当type是range时，ref字段为NULL，并且key_len字段是此次查询中使用到的索引的最长的那个。
- index,表示全索引扫描（full index scan）和All类似，All是扫描全表数据，而index则是扫描所有的索引，不是扫描数据，对索引无特别要求，只要是索引或者联合索引一部分即可。通常出现在数据可以直接在索引树中可以直接获取到，而不需要扫描数据，效率不高，Extra字段会显示Using index。
- All表示全表扫描，性能非常差，如果数据量多则会发生很严重的后果。

#### 2.性能关系
```
system > const > eq_ref > range ~ index_merge >index > All
```
### 4.possible_keys
- possible_keys表示MySQL在查询时，能够使用到的索引，但是即使索引出现在possible_keys中，但是也不代表一定会用，由key决定使用了哪些索引。

### 5.key
- 真正用到的索引

### 6.key_len
- 表示查询优化器使用了索引的字节数，这个字段可以评估组合索引是否完全被使用或只有最左部分字段被使用到

#### 1.key_len的计算规则如下
- 字符串
- - char(n):n字节长度
- - varcahr(n):如果是utf8编码，则是3n+2字节，如果是utf8mb4编码，则是4n+2字节。
- 数值类型
- - tinyint：1字节
- - smallint:2字节
- - mediumint:3字节
- - int:4字节
- - bigint:8字节
- 时间类型
- - date:3字节
- - timestamp:4字节
- - datetime:8字节
- 字段属性
- - NULL占用一个字节，如果是not null则没有此属性。

#### 2.示例
```
EXPLAIN select * from test where name ='name3';
```
id|select_type|table|partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra
-|-|-|-|-|-|-|-|-|-|-|-|
1|SIMPLE|test|NULL|ref|idx|idx|768|const|1|100.00|Using where
- 按照上面varchar占用的字节进行计算应该是4x255+2=1022，但是查看字符集,发现是utf8_general_ci所以占用三个字节 255x3+2=767，然后不非空所以还需要+1，结果是768
```
show full columns from test;

name	varchar(255)	utf8_general_ci	YES	MUL			select,insert,update,references	
```

#### 3.详解key_len的计算规则
- 创建测试表
```
// 设置name字段为非空
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test_key_len` (
  `name` varchar(255) not null,
  `age` int(11) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  KEY `idx` (`name`,`age`,`sex`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
```
- 对name字段进行测试
```
explain select * from test_key_len where name='name123123';
```
id|select_type|table|partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra
-|-|-|-|-|-|-|-|-|-|-|-|
1|SIMPLE|test_key_len|NULL|ref|idx|idx|767|const|1|100.00|Using index
```
// 查看编码
show full columns from test_key_len;
name	varchar(255)	utf8_general_ci	NO	MUL			select,insert,update,references	

// 根据上面的计算方法为以及编码方式占用的字节进行计算
// 3n+2：3*255+2=767 
// 如果设置name为可以空，则key_len为768。
// 说明如果是可以为空还得需要判断空，多占用一个字节，则需要加1
```
id|select_type|table|partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra
-|-|-|-|-|-|-|-|-|-|-|-|
1|SIMPLE|test_key_len|NULL|ref|idx|idx|768|const|1|100.00|Using index

- 对两个索引字段进行测试（name,age）
```
explain select * from test_key_len where name='name123123' and age=12;
```
id|select_type|table|partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra
-|-|-|-|-|-|-|-|-|-|-|-|
1|SIMPLE|test_key_len|NULL|ref|idx|idx|773|const,const|1|100.00|Using index
```
// 根据上面的计算方法为以及编码方式占用的字节进行计算
// name(varchar(255)):3n+2+1(可以为null)
// age(int):4+1(可以为null)
// 结果为：3*255+2+1+4+1=773
```

### 7.rows
- 估算结果集扫描读取的数据行数，直观显示sql的效率好坏，原则上rows越少越好

### 8.Extra
- 很多额外信息就在Extra字段显示，以下介绍几种，[更多详细内容，请点击查看](https://dev.mysql.com/doc/refman/5.5/en/explain-output.html#explain-extra-information)
- - Using filesort,表示MySQL需要额外的排序操作，不能通过索引顺序达到排序效果，一般都建议优化去掉，这样的查询CPU资源消耗比较大。
- - Using index,覆盖索引扫描，表示查询在索引树中可查找所需数据，不用扫描表数据文件，往往说明细性能不错。
- - Using temporary，查询使用临时表，一般出现在排序、分组和多表join的情况，查询效率不高，建议优化。
- - Using where,使用索引即可查找到数据而不会读取实际的表数据，表示内容全部都是同一索引返回

>[原文链接，略有增加和删减](https://segmentfault.com/a/1190000008131735)

>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

