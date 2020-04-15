#### codis 安装文档

[TOC]

##### 环境准备

	操作系统：CentOS7
	JDK版本：jdk-8u60
	GO版本：go1.8
	zookeeper：zookeeper-3.4.11
	codis 版本：codis-release3.2
	
	机器 三台机器：
	192.168.247.130/131/132
	
	三台机器分别部署jdk/go环境/zookeeper/codis-proxy/codis-server
	192.168.247.131 部署codis-dashboard/codis-fe

##### JDK安装

	三台机器上依次操作：
	tar -xf jdk-8u60-linux-x64.tar.gz
	mv jdk1.8.0_60 /usr/local/jdk1.8
	vim /etc/profile
		export JAVA_HOME=/usr/local/jdk1.8
	    export JRE_HOME=/usr/local/jdk1.8/jre
	    export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib
	    export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

##### GO语言环境

	三台机器上依次操作：
	tar -xf go1.7.3.linux-amd64.tar.gz
	mv go /usr/local/
	vim /etc/profile
		export GOROOT=/usr/local/go
	    export GOPATH=/usr/local/go/work
	    export PATH=$PATH:$HOME/bin:$GOROOT/bin:$GOPATH/bin:$PATH

##### zookeeper 安装

	下载地址：
		http://mirrors.hust.edu.cn/apache/zookeeper/zookeeper-3.4.11/zookeeper-3.4.11.tar.gz
	三台机器上依次操作：
	tar -xf zookeeper-3.4.11.tar.gz -C /usr/local/
	ln -s /usr/local/zookeeper /usr/local/zookeeper-3.4.11
	vim /etc/profile
		export ZK_HOME=/usr/local/zookeeper
	
	配置文件修改：
		三台机器上依次操作：
		cd /usr/local/zookeeper/conf
		cp zoo_sample.cfg zoo.cfg
		vim zoo.cfg
			tickTime=2000
	        initLimit=5
	        syncLimit=2
	        dataDir=/usr/local/zookeeper/data
	        clientPort=2181		## 三个端口不能一样，客户端连接 Zookeeper 服务器的端口
	        server.1=192.168.247.130:2881:3181	# 2881为这个服务器与集群中的 Leader 服务器交换信息的端口；3181 为执行选举时服务器相互通信的端口
	        server.2=192.168.247.131:2881:3181
	        server.3=192.168.247.132:2881:3181
	
		在/usr/local/zookeeper/data 目录下写入id 在myid 文件
		在130主机写入 echo 1 > /usr/local/zookeeper/data/myid
		在131主机写入 echo 2 > /usr/local/zookeeper/data/myid
		在132主机写入 echo 3 > /usr/local/zookeeper/data/myidmyid
		
		启动zookeeper：
		/usr/local/zookeeper/bin/zkServer.sh start 
		/usr/local/zookeeper/bin/zkServer.sh status
		ZooKeeper JMX enabled by default
	    Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
	    Mode: follower
	    /usr/local/zookeeper/bin/zkCli.sh -server 192.168.247.131:2181	# 客户端连接

##### codis3.2 安装

	二进制包下载地址：
		https://github.com/CodisLabs/codis/releases/download/3.2.1/codis3.2.1-go1.7.6-linux.tar.gz
	#解压程序包
	tar xf codis3.2.1-go1.7.6-linux.tar.gz
	#移动到指定目录
	mv codis3.2.1-go1.7.6-linux /usr/local/
	#进入指定目录,并创建程序软连接
	cd /usr/local/
	ln -sf codis3.2.1-go1.7.6-linux/ codis

##### codis-server 配置：

    三台都配置codis-server 分别监听6379和6380

    #创建redis数据目录,配置文件目录,日志目录
    mkdir -p /data/redis/data/config/
    mkdir -p /data/redis/data/logs/
    #创建主库的配置文件,暂时只配置这些,其他先默认
    vim /data/redis/data/config/redis_6379.conf
    #允许后台运行
    daemonize yes
    #设置端口,最好是非默认端口
    port 6379
    #绑定登录IP,安全考虑,最好是内网
    bind *
    #命名并指定当前redis的PID路径,用以区分多个redis
    pidfile "/data/redis/data/config/redis_6379.pid"
    #命名并指定当前redis日志文件路径
    logfile "/data/redis/data/logs/redis_6379.log"
    #指定RDB文件名,用以备份数据到硬盘并区分不同redis,当使用内存超过可用内存的45%时触发快照功能
    dbfilename "dump_6379.rdb"
    #指定当前redis的根目录,用来存放RDB/AOF文件
    dir "/data/redis/data"
    #当前redis的认证密钥,redis运行速度非常快,这个密码要足够强大,
    #所有codis-proxy集群相关的redis-server认证密码必须全部一致
    requirepass "123"
    #当前redis的最大容量限制,建议设置为可用内存的45%内,最高能设置为系统可用内存的95%,可用config set maxmemory 去在线修改,但重启失效,需要使用config rewrite命令去刷新配置文件
    #注意,使用codis集群,必须配置容量大小限制,不然无法启动
    maxmemory 100000kb
    #LRU的策略,有四种,看情况选择
    maxmemory-policy allkeys-lru
    #如果做故障切换，不论主从节点都要填写密码且要保持一致
    masterauth "123"
    
    #创建从库的配置文件,暂时只配置这些,其他先默认
    vim /data/redis/data/config/redis_6380.conf
    #允许后台运行
    daemonize yes
    #设置端口,最好是非默认端口
    port 6380
    #绑定登录IP,安全考虑,最好是内网
    bind *
    #命名并指定当前redis的PID路径,用以区分多个redis
    pidfile "/data/redis/data/config/redis_6380.pid"
    #命名并指定当前redis日志文件路径
    logfile "/data/redis/data/logs/redis_6380.log"
    #指定RDB文件名,用以备份数据到硬盘并区分不同redis,当使用内存超过可用内存的45%时触发快照功能
    dbfilename "dump_6380.rdb"
    #指定当前redis的根目录,用来存放RDB/AOF文件
    dir "/data/redis/data"
    #当前redis的认证密钥,redis运行速度非常快,这个密码要足够强大
    #所有codis-proxy集群相关的redis-server认证密码必须全部一致
    requirepass "123"
    #当前redis的最大容量限制,建议设置为可用内存的45%内,最高能设置为系统可用内存的95%,可用config set maxmemory 去在线修改,但重启失效,需要使用config rewrite命令去刷新配置文件
    #注意,使用codis集群,必须配置容量大小限制,不然无法启动
    maxmemory 100000kb
    #LRU的策略,有四种,看情况选择
    maxmemory-policy allkeys-lru
    #如果做故障切换，不论主从节点都要填写密码且要保持一致
    masterauth "123"
    #配置主节点信息
    slaveof 192.168.247.130 6379		## 不必配置slaveof ，可以在dashboard 上进行指定
启动codis-server

	#然后就可以启动了,我一开始就说过codis-server就是redis-server
	/usr/local/codis/codis-server /data/redis/data/config/redis_6379.conf
	/usr/local/codis/codis-server /data/redis/data/config/redis_6380.conf

##### redis-serntinel 配置

```
三台都进行配置
vim /data/redis/data/config/sentinel.conf
port 26379
bind 0.0.0.0
daemonize yes
protected-mode no
dir "/data/redis/data"
pidfile "/data/redis/data/config/sentinel_26379.pid"
logfile "/data/redis/data/logs/sentinel_26379.log"

以下内容在codis 中可以不进行配置，正确来说,redis-sentinel是要配置主从架构才能生效,但是在codis集群中并不一样,因为他的配置由zookeeper来维护,所以,这里codis使用的redis-sentinel只需要配置一些基本配置就可以了
sentinel monitor mymaster0 192.168.247.132 6379 2
sentinel down-after-milliseconds mymaster0 10000
sentinel parallel-syncs mymaster0 5
sentinel auth-pass mymaster0 123456

sentinel monitor mymaster1 192.168.247.130 6379 2
sentinel down-after-milliseconds mymaster1 10000
sentinel parallel-syncs mymaster1 5
sentinel auth-pass mymaster1 123456

sentinel monitor mymaster2 192.168.247.131 6379 2
sentinel down-after-milliseconds mymaster2 10000
sentinel parallel-syncs mymaster2 5
sentinel auth-pass mymaster2 123456
```

启动sentinel

```
./bin/codis-server config/sentinel.conf --sentinel
```

##### codis-proxy 配置

这个是codis集群的核心

生成默认配置文件，三台都进行配置

	/usr/local/codis/codis-proxy --default-config | tee ./proxy.conf
```
#然后我们把配置放到redis数据目录的配置文件目录,再更改关键位置,其他默认即可
vim /data/redis/data/config/proxy.conf
#项目名称,会登记在zookeeper里,如果你想一套zookeeper管理多套codis,就必须区分好
product_name = "codis-GuoJia"
# 设置登录dashboard的密码(与真实redis中requirepass一致)
product_auth = "123"
#客户端(redis-cli)的登录密码(与真实redis中requirepass不一致),是登录codis的密码
session_auth = "123456"
#管理的端口,0.0.0.0即对所有ip开放,基于安全考虑,可以限制内网
admin_addr = "0.0.0.0:11080"
#用那种方式通信,假如你的网络支持tcp6的话就可以设别的
proto_type = "tcp4"
#客户端(redis-cli)访问代理的端口,0.0.0.0即对所有ip开放
proxy_addr = "0.0.0.0:19000"
#外部配置存储类型,我们用的就是zookeeper,当然也是还有其他可以支持,这里不展开说
jodis_name = "zookeeper"
#配置zookeeper的连接地址,这里是三台就填三台
jodis_addr = "192.168.247.130:2181,192.168.247.131:2181,192.168.247.132:2181"
#zookeeper的密码,假如有的话
jodis_auth = ""
#codis代理的最大连接数,默认是1000
proxy_max_clients = 1000
#假如并发太大,你可能需要调这个pipeline参数,大多数情况默认就够了
session_max_pipeline = 10000
```

启动codis-proxy

```
/usr/local/codis/codis-proxy --ncpu=1 --config=/data/redis/data/config/proxy.conf --log=/data/redis/data/logs/proxy.log --log-level=WARN &
```

##### codis-dashboard 配置

Codis Dashboard：管理配置codis集群信息的工具,配置完之后的配置信息会自动加载到zookeeper集群,即使这个服务挂了,配置都还在zookeeper上,所以不用考虑高可用，支持 codis-proxy、codis-server 的添加、删除，以及据迁移等操作。在集群状态发生改变时，codis-dashboard 维护集群下所有 codis-proxy 的状态的一致性。 对于同一个业务集群而言，同一个时刻 codis-dashboard 只能有 0个或者1个；所有对集群的修改都必须通过 codis-dashboard 完成

生成默认配置

```
/usr/local/codis/codis-dashboard --default-config | tee ./dashboard.conf
```

```
vim /data/redis/data/config/dashboard.conf
#外部配置存储类型,我们用的就是zookeeper,当然也是还有其他可以支持,这里不展开说
coordinator_name = "zookeeper"
#配置zookeeper的连接地址,这里是三台就填三台
coordinator_addr = "192.168.247.130:2181,192.168.247.131:2181,192.168.247.132:2181"
#项目名称,会登记在zookeeper里,如果你想一套zookeeper管理多套codis,就必须区分好
product_name = "codis-test1"
#所有redis的登录密码(与真实redis中requirepass一致),因为要登录进去修改数据
product_auth = "123"
#codis-dashboard的通信端口,0.0.0.0表示对所有开放,最好使用内网地址
admin_addr = "0.0.0.0:18080"
#如果想要在codis集群在故障切换功能上执行一些脚本,可以配置以下两个配置
sentinel_notification_script = ""
sentinel_client_reconfig_script = ""
```

启动dashboard

```
/usr/local/codis/codis-dashboard --ncpu=1 --config=/data/redis/data/config/dashboard.conf --log=/data/redis/data/logs/codis_dashboard.log --log-level=WARN &
```

##### codis-fe 配置

这个是属于web界面操作codis-dashboard配置的工具,web代码文件在codis安装文件夹的目录下,具体是:/usr/local/codis/assets/这个目录，只需要配置一台机上

这个工具本身不需要配置文件就能启动,只需要指定codis-dashboard的ip和端口（可以从zookeeper中获取）就可以了,但是我为了方便管理,还是生成一个配置文件的好

```
./bin/codis-fe --ncpu=4 --log=./log/fe.log --log-level=WARN --zookeeper=192.168.247.131:2181 --listen=192.168.247.131:8090 &
此种的启动方式直接指定zookeeper 地址，dashboard 的信息从zookeeper 中获取
或
./bin/codis-fe --ncpu=4 --log=./log/fe.log --log-level=WARN --dashboard=192.168.247.131:18080 --listen=192.168.247.131:8090 &
```

生成配置文件，其实就是dashboard 的IP与端口

```
/usr/local/codis/codis-admin --dashboard-list --zookeeper=192.168.247.131:2181 > codis.json

cat codis.json
[
    {
        "name": "codis-GuoJia",
        "dashboard": "192.168.247.131:18080"
    }
]
```

启动codis-fe

```
#然后就可以启动了,-ncpu是指定使用多少个cpu的意思,然后指定配置文件和输出日志,还指定了日志等级,重点是指定了web界面的登录端口8090,0.0.0.0是允许所有ip连接的意思.
/usr/local/codis/codis-fe --ncpu=1 --log=/data/redis/data/logs/fe.log --log-level=WARN --dashboard-list=/data/redis/data/config/codis.json --listen=0.0.0.0:8090 &
```

可以在浏览器输入192.168.247.131:8090 进入codis的管理界面

##### codis-admin 命令行工具的使用

```
# 命令行添加proxy
./bin/codis-admin --dashboard=192.168.247.131:18080 --create-proxy -x 192.168.247.131:11080 

# 命令行创建groupID
./bin/codis-admin --dashboard=192.168.247.131:18080 --create-group --gid=1     # 新建group 1  相当于fe页面“NEW GROUP”按钮  
./bin/codis-admin --dashboard=192.168.247.131:18080 --group-add --gid=1 --addr=192.168.247.131:6379   # 把codis-server 192.168.247.131:6379加入集群，  

# 命令行进行主从同步
./bin/codis-admin  --dashboard=192.168.247.131:18080 --sync-action --create --addr=192.168.247.131:6379  # 相当于fe页面的”SYNC"按钮  
./bin/codis-admin  --dashboard=192.168.247.131:18080 --sync-action --create --addr=192.168.247.131:6380  # 所有server都要执行  
以上命令实现 group1：6379主  6380从 同步，自动选取第一个为master,其他为slave,其他组同样执行上述命令

# GROUP自动槽位分配
./bin/codis-admin  --dashboard=192.168.247.131:18080 --rebalance --confirm  # 相当于fe页面“Rebalance All Slots”按钮  
注：也可以定制化的分配槽位
./bin/codis-admin --dashboard=192.168.247.131:18080 --slot-action --create-range --beg=0 --end=300  --gid=1  

# 添加sentinel 关联集群
./bin/codis-admin  --dashboard=192.168.247.131:18080 --sentinel-add   --addr=192.168.247.131:26379  
./bin/codis-admin  --dashboard=192.168.247.131:18080 --sentinel-add   --addr=192.168.247.132:26379 
```

##### 故障处理

codis-dashboard无法启动,并提示:

[ERROR] store: acquire lock of codis-test1 failed
[error]: zk: node already exists

由于是测试环境,我经常强制关机,导致codis-dashboard没有正常关闭.直接造成zookeeper里面的状态没有更新,最终新启动的codis-dashboard不能注册进zookeeper,一直提示已存在而被强制关闭.

修复方法也不难,就是删除这个lock的状态键值就可以

```
#输入项目名和zookeeper地址
/usr/local/codis/codis-admin --remove-lock --product=codis-test1 --zookeeper=192.168.247.131:2181
```

然后,codis-dashboard又可以正常启动

codis-admin是可以全权控制codis集群的工具,所有添加/删除/修改的工作都可以用他来实现,参数很多,这里只是举例了一个方法,详细可以参照codis-admin --help