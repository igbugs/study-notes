#### Dubbo 安装配置

[TOC]

##### JDK安装

```
tar -xf jdk-8u60-linux-x64.tar.gz
mv jdk1.8.0_60 /usr/local/jdk1.8
vim /etc/profile
	export JAVA_HOME=/usr/local/jdk1.8
    export JRE_HOME=/usr/local/jdk1.8/jre
    export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib
    export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

##### zookeeper 安装

```
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
```

##### dubbo 编译安装

```
下载dubbo ：
	https://codeload.github.com/alibaba/dubbo/zip/dubbo-2.6.0
unzip dubbo-dubbo-2.6.0.zip
cd dubbo-dubbo-2.6.0
[root@localhost dubbo-dubbo-2.6.0]# ls
CODE_OF_CONDUCT.md  dubbo-cluster    dubbo-filter    dubbo-remoting  LICENSE   PULL_REQUEST_TEMPLATE.md
codestyle           dubbo-common     dubbo-maven     dubbo-rpc       mvnw      README.md
CONTRIBUTING.md     dubbo-config     dubbo-monitor   dubbo-simple    mvnw.cmd
dubbo               dubbo-container  dubbo-plugin    dubbo-test      NOTICE
dubbo-admin         dubbo-demo       dubbo-registry  hessian-lite    pom.xml
# 全部编译
# mvn install -Dmaven.test.skip=true
# 单独编译dubbo-admin
# cd dubbo-admin/
# mvn install -Dmaven.test.skip=true

# 编译完成后
[root@localhost dubbo-admin]# cd target/
[root@localhost target]# ls
classes            dubbo-admin-2.6.0-sources.jar  generated-sources  test-classes
dubbo-admin-2.6.0  dubbo-admin-2.6.0.war          maven-archiver
```

##### tomcat 安装

```
tar -xf apache-tomcat-8.0.37.tar.gz -C /usr/local/dubbo-admin-tomcat
cp  dubbo-admin-2.6.0.war /usr/local/dubbo-admin-tomcat/webapps/ROOT.war
# 解压war 包
jar -xf ROOT.war
# 更改dubbo.properties
vim dubbo.properties 
    dubbo.registry.address=zookeeper://192.168.247.130:2181?backup=192.168.247.131:2181,192.168.247.132:2181	## 写入zookeeper 的集群地址
    dubbo.admin.root.password=root		## 设置web 页面的root 密码
    dubbo.admin.guest.password=guest
# 启动tomcat 
/usr/local/dubbo-admin-tomcat/bin/startup.sh
```

##### 浏览器访问dubbo web 管理界面

```
http://192.168.247.130:8080
```

