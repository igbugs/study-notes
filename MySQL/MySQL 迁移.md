## MySQL 迁移

- **MySQL 单主模式和多主模式搭建**

   https://www.jianshu.com/p/ca1af156f656 

- **MySQL5.7 不支持的参数**

   **注释掉2个参数（mysql5.7已经不支持的了）：**

  ```
  innodb_additional_mem_pool_size=8M
  thread_concurrency=64
  ```

- **MySQL5.6 升级5.7 远程登录账号无法登录**

  **解决方法：**

  **step1、升级数据字典**

   执行mysql_upgrade 即可看到检查的过程。

  **step2、重启mysql**

   注意重启mysql后，要检查下error日志是否还有这些报错。

  **step3、检查之前的sql用户能否登录**

   如果不能登录的话，需要drop掉原来的用户，重新创建账户，并给相关的数据库授权即可。

- **MySQL 5.6 升级到5.7 官方推荐方式**

  ```
  官方推荐的方法如下:
  1、in-place upgrade:原地升级法，利用已存在的datadir目录进行升级。
  2、logical upgrade：逻辑升级法，利用mysqldump导出导入进行升级。
  
  但在实际的升级过程中很少会用到上面这两种方法，特别是第一种；通常都是通过部署一个新从库来完成升级的(主库老版本，从库目标版本)，这样的话只需要在切换的时候停下机就行了。
  
  逻辑升级(logical upgrade)的话，先导出，接着导入，最后运行mysql_upgrade完成升级；另外，小版本升级可以不运行mysql_upgrade，但在实际的生产环境中，建议不管是小版本升级还是大版本升级
  都运行mysql_upgrade。
  
  备注：运行Mysql_upgrade时需要禁用GTID，因为运行Mysql_upgrade会修改mysql引擎的系统表，这不是一个事务表。
  ```

- **MySQL5.6 升级到 5.7 的方式**

   http://blog.itpub.net/29594292/viewspace-2135085/ 

- **MGR的限制**

  ```
  1. 仅支持InnoDB表，并且每张表一定要有一个主键，用于做write set的冲突检测；
  2. 必须打开GTID特性，二进制日志格式必须设置为ROW，用于选主与write set
  3. COMMIT可能会导致失败，类似于快照事务隔离级别的失败场景
  4. 目前一个MGR集群最多支持9个节点
  5. 不支持外键于save point特性，无法做全局间的约束检测与部分部分回滚
  6. 二进制日志不支持binlog event checksum
  ```

- **binlog event checksum**

    http://blog.sina.com.cn/s/blog_53fab15a0102vodv.html 

- **Mysql Binlog三种格式详细介绍**

   https://www.cnblogs.com/baizhanshi/p/10512399.html

- **MySQL sql_mode 参数说明**

   ```
   参数说明：
   SQL_MODE是一个非常重要的变量，默认为空。SQL_MODE的设置为空其实是比较冒险的一种设置，因为在这种设置下可以允许一些非法操作，比如可以将NULL插入NOT NULL的字段中，也可以插入一些非法日期，如“2012-12-32”。因此在平安这个值设为严格模式，这样有些问题可以在数据库的设计和开发阶段就能发现。此外，正确地设置SQL_MODE还可以做一些约束(Constraint)检查的工作。
   
   平安的默认值（5.6.22版本）：
   sql_mode = STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION,ONLY_FULL_GROUP_BY
   
   模式说明：
   对于STRICT_TRANS_TABLES，MySQL将非法值转换为最接近该列的合法值并插入调整后的值。如果值丢失，MySQL在列中插入隐式默认值。在任何情况下，MySQL都会生成警告而不是给出错误并继续执行语句。
   NO_AUTO_CREATE_USER，禁止GRANT创建密码为空的用户。
   NO_AUTO_VALUE_ON_ZERO影响AUTO_INCREMENT列的处理。一般情况，你可以向该列插入NULL或0生成下一个序列号。NO_AUTO_VALUE_ON_ZERO禁用0，因此只有NULL可以生成下一个序列号。
   NO_ENGINE_SUBSTITUTION在create table 时可以指定engine子句；这个engine子句用于指定表的存储引擎。如果引擎指定成一个并不存在的引擎，这个时候mysql直接报错。
   ONLY_FULL_GROUP_BY使用这个就是使用和oracle一样的group 规则, select的列都要在group中，或者本身是聚合列(SUM,AVG,MAX,MIN) 才行。
   
   趋势：
   可以看到，MySQL 5.7及以后的版本这个参数的模式限制越来越多：
   
   The default SQL modein MySQL 5.7 includes these modes: ONLY_FULL_GROUP_BY, STRICT_TRANS_TABLES, NO_ZERO_IN_DATE, NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO, NO_AUTO_CREATE_USER, and NO_ENGINE_SUBSTITUTION.
   
   The default SQL modein MySQL 8.0 includes these modes: ONLY_FULL_GROUP_BY, STRICT_TRANS_TABLES, NO_ZERO_IN_DATE, NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO, NO_AUTO_CREATE_USER, and NO_ENGINE_SUBSTITUTION.
   ```

- **MySQL 半同步复制**

   https://www.cnblogs.com/justdba/p/7135943.html 

   https://www.cnblogs.com/kevingrace/p/10228694.html 

  ```
  #半同步复制模式
  plugin_dir = "/usr/local/mysql/plugin"
  plugin_load = "rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
  loose_rpl_semi_sync_master_enabled = 1
  loose_rpl_semi_sync_slave_enabled = 1
  loose_rpl_semi_sync_master_timeout = 5000
  ```
  
- **GTID 配置**

   https://www.cnblogs.com/DataArt/p/10089868.html 

  ```
  #开启gtid模式，5.7特有
  gtid_mode = on
  enforce_gtid_consistency = 1
  log_slave_updates = 1
  ```
  
- MySQL MHA 搭建

   https://www.cnblogs.com/panwenbin-logs/p/8306906.html 

   https://blog.51cto.com/14510269/2431366?source=dra 

   [MySQL+MGR 单主模式和多主模式的集群环境 - 部署手册 (Centos7.5)](https://www.cnblogs.com/kevingrace/p/10470226.html)

- **使用systemctl 启动mysql**

   ```
   1. 创建启动文件 .service
   vim /usr/lib/systemd/system/mysqld.service
   
   [Unit]
   Description=MySQL Server
   After=network.target
   After=syslog.target
   [Service]
   User=mysql
   Group=mysql
   Type=forking
   PermissionsStartOnly=true
   ExecStart= /etc/init.d/mysqld start
   ExecStop= /etc/init.d/mysqld stop
   ExecReload= /etc/init.d/mysqld restart
   LimitNOFILE = 5000
   [Install]
   WantedBy=multi-user.target
   
   2，重新加载一下服务的配置文件
   systemctl daemon-reload
   3，开启mysql服务
   systemctl  start  mysqld.service
   4，关闭mysql服务
   systemctl  stop  mysqld.service
   ```

- **MySQL MYD,MYI.idb,par文件说明**

   ```
   如果存在数据库a，表b。
   
   1、如果表b采用MyISAM，data/a中会产生3个文件：
   b.frm ：描述表结构文件，字段长度等
   b.MYD(MYData)：数据信息文件，存储数据信息(如果采用独立表存储模式)
   b.MYI(MYIndex)：索引信息文件。
    
   2、如果表b采用InnoDB，data/a中会产生1个或者2个文件：
   b.frm ：描述表结构文件，字段长度等
   如果采用**独立表存储模式**，data/a中还会产生b.ibd文件（存储数据信息和索引信息）
   如果采用**共存储模式**的，数据信息和索引信息都存储在ibdata1中
   如果采用**分区存储**，data/a中还会有一个b.par文件（用来存储分区信息）
   ```

- **独立表空间和共享表空间**

   ```
   1. 修改数据库的表空间管理方式
   修改innodb_file_per_table的参数值即可，但是修改不能影响之前已经使用过的共享表空间和独立表空间；
   
   innodb_file_per_table=1 为使用独占表空间
   innodb_file_per_table=0 为使用共享表空间
   
   2. 共享表空间转化为独立表空间的方法（参数innodb_file_per_table=1需要设置）
   单个表的转换操作，脚本：alter table table_name engine=innodb;
   
   当有大量的表需要操作的时候，先把数据库导出，然后删除数据再进行导入操作，该操作可以用mysqldump进行操作（http://blog.itpub.net/12679300/viewspace-1259451/）
   
   3. 共享表空间优缺点
   既然Innodb有共享表空间和独立表空间两种类型，那么这两种表空间存在肯定都有时候自己的应用的场景，存在即合理。以下是摘自mysql官方的一些介绍：
   
   3.1 共享表空间的优点
   
   表空间可以分成多个文件存放到各个磁盘，所以表也就可以分成多个文件存放在磁盘上，表的大小不受磁盘大小的限制（很多文档描述有点问题）。
   
   数据和文件放在一起方便管理。
   
   3.2 共享表空间的缺点
   
   所有的数据和索引存放到一个文件，虽然可以把一个大文件分成多个小文件，但是多个表及索引在表空间中混合存储，当数据量非常大的时候，表做了大量删除操作后表空间中将会有大量的空隙，特别是对于统计分析，对于经常删除操作的这类应用最不适合用共享表空间。
   
   共享表空间分配后不能回缩：当出现临时建索引或是创建一个临时表的操作表空间扩大后，就是删除相关的表也没办法回缩那部分空间了（可以理解为oracle的表空间10G，但是才使用10M，但是操作系统显示mysql的表空间为10G），进行数据库的冷备很慢；
   
   4. 独立表空间的优缺点
   
   4.1 独立表空间的优点
   
   每个表都有自已独立的表空间，每个表的数据和索引都会存在自已的表空间中，可以实现单表在不同的数据库中移动。
   
   空间可以回收（除drop table操作处，表空不能自已回收）
   
   Drop table操作自动回收表空间，如果对于统计分析或是日值表，删除大量数据后可以通过:alter table TableName engine=innodb;回缩不用的空间。
   
   对于使innodb-plugin的Innodb使用turncate table也会使空间收缩。
   
   对于使用独立表空间的表，不管怎么删除，表空间的碎片不会太严重的影响性能，而且还有机会处理。
   
   4.2 独立表空间的缺点
   
   单表增加过大，当单表占用空间过大时，存储空间不足，只能从操作系统层面思考解决方法；
   ```

- **MySQL数据恢复（通过.frm和.idb文件）**

    https://blog.csdn.net/Sonny_alice/article/details/80198200 

- **mysqldump**

    https://www.cnblogs.com/gaogao67/p/10482973.html 

   ```
   /usr/local/mysql/bin/mysqldump -u huohe -p --opt --master-data=2 --single-transaction -R --triggers --events -A > all.2019.11.11.16.33.sql
   ```

- **数据库相关博文**

   - MHA

      https://www.cnblogs.com/gaogao67/category/1492668.html 

   - MySQL Percona Toolkit

      https://www.cnblogs.com/gaogao67/category/1422818.html 

   - Index

      https://www.cnblogs.com/gaogao67/category/1469993.html 

   - 

