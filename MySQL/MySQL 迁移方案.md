## MySQL 迁移方案

### 现有MySQL的高可用方案

- MHA
- MMM
- PXC
- MGR

```
其中 MHA 与MMM 都需要使用VIP，在发生宕机之后，配置vip到 要迁移的节点，进行切换
```



### 验证项目

#### MySQL5.6 升级到MySQL5.7

```
1. 停止MySQL5.6 的数据库
2. 更改配置文件 basedir 改动到5.7 的二进制文件的位置
3. 重新启动数据库，使用5.7 的路径
4. 在5.7 的bin 目录下，执行 mysql_update -s 进行表结构的更改
```

#### MySQL5.7 初始化方式

```
./bin/mysqld --defaults-file=/alidata/data/mysql/conf/my.cnf --initialize-insecure --basedir=/usr/local/mysql57 --datadir=/alidata/data/mysql/data/ --user=mysql

##  --defaults-file 必须在 mysqld 的后面
```

#### 半同步复制配置验证

```
#半同步复制模式
plugin_dir = "/usr/local/mysql/plugin"
plugin_load = "rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
loose_rpl_semi_sync_master_enabled = 1
loose_rpl_semi_sync_slave_enabled = 1
loose_rpl_semi_sync_master_timeout = 5000
```

#### MySQL 主从同步版本不一致（5.6 --> 5.7）

```
master 版本为5.6版本
slave 版本为5.7 版本
配置主从方式与同版本一致
```

#### 传统主从复制切换为GTID模式



### MHA部署测试



### MGR部署测试

#### 升级原有的MySQL版本至MySQL5.7



### PXC部署测试