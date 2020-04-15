### SOLR  安装部署文档

[TOC]



#### solr 单机版部署文档

##### 环境说明：

```
JDK： 1.8
tomcat： 8.0
solr: 7.1.0
```

##### 安装solr(结合tomcat 部署)

```
cd /usr/local/src
mkdir /usr/local/solr7
unzip solr-7.1.0.zip
mv solr-7.1.0 /usr/local/solr7
tar -xf apache-tomcat-8.0.37.tar.gz
mv apache-tomcat-8.0.37 /usr/local/solr7/solr-tomcat/

# 创建solr 应用目录
rm -rf /usr/local/solr7/solr-tomcat/webapps/*
mkdir /usr/local/solr7/solr-tomcat/webapps/solr

# 复制solr运行需要的文件
cd /usr/local/solr7/solr-tomcat/webapps/solr/
cp -r /usr/local/solr7/solr-7.1.0/server/solr-webapp/webapp/* ./
cp -r /usr/local/solr7/solr-7.1.0/server/lib/ext/* ./WEB-INF/lib/
cp -r /usr/local/solr7/solr-7.1.0/server/lib/metrics*.* ./WEB-INF/lib/
cp -r /usr/local/solr7/solr-7.1.0/dist/solr-dataimporthandler-* ./WEB-INF/lib/

# 创建solr数据存放家目录
mkdir /usr/local/solr7/solr_home
cd  /usr/local/solr7/solr_home
cp -r /usr/local/solr7/solr-7.1.0/server/solr/* ./
cp -r /usr/local/solr7/solr-7.1.0/contrib/ ./
cp -r /usr/local/solr7/solr-7.1.0/dist/ ./

# 日志配置
mkdir -p WEB-INF/classes 
cp /usr/local/solr7/solr-7.1.0/server/resources/log4j.properties WEB-INF/classes/

# 指定solr home 位置
vim WEB-INF/web.xml
    <env-entry>
       <env-entry-name>solr/home</env-entry-name>
       <env-entry-value>/usr/local/solr7/solr_home</env-entry-value>
       <env-entry-type>java.lang.String</env-entry-type>
    </env-entry>
    
 # 注释security-constraint
   <!--
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Disable TRACE</web-resource-name>
      <url-pattern>/</url-pattern>
      <http-method>TRACE</http-method>
    </web-resource-collection>
    <auth-constraint/>
  </security-constraint>
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Enable everything but TRACE</web-resource-name>
      <url-pattern>/</url-pattern>
      <http-method-omission>TRACE</http-method-omission>
    </web-resource-collection>
  </security-constraint>
  -->
  
# 更改tomcat 的server.xml 配置，更改端口，启动
浏览器输入 ： http://ip:port/solr/index.html 进行访问
```

##### 添加core 

solr存放的字段和索引都需要自定义，这里core就是存放这些自定义东西的地方

```
name：自定义的名字，建议和instanceDir保持一致
instanceDir： solrhome目录下的实例类目
dataDir：默认填data即可
config：指定配置文件，new_core/conf/solrconfig.xml
schema：指定schema.xml文件，new_core/conf/schema文件(实际上是managed-schema文件)
注意！在scheme下面有一个感叹号！
instanceDir and dataDir need to exist before you can create the core
```

**新建core  spc_core**

```
cd /usr/local/solr7/solr_home
mkdir spc_core/{conf,data}
cp -r /usr/local/solr7/solr-7.1.0/server/solr/configsets/_default/conf/* ./spc_core/conf/

# 修改 solrconfig.xml 与 contrib 的相对路径
vim spc_core/conf/solrconfig.xml
由：
  <lib dir="${solr.install.dir:../../../..}/contrib/extraction/lib" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-cell-\d.*\.jar" />

  <lib dir="${solr.install.dir:../../../..}/contrib/clustering/lib/" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-clustering-\d.*\.jar" />

  <lib dir="${solr.install.dir:../../../..}/contrib/langid/lib/" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-langid-\d.*\.jar" />

  <lib dir="${solr.install.dir:../../../..}/contrib/velocity/lib" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-velocity-\d.*\.jar" />
更改为：
  <lib dir="${solr.install.dir:../..}/contrib/extraction/lib" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../..}/dist/" regex="solr-cell-\d.*\.jar" />

  <lib dir="${solr.install.dir:../..}/contrib/clustering/lib/" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../..}/dist/" regex="solr-clustering-\d.*\.jar" />

  <lib dir="${solr.install.dir:../..}/contrib/langid/lib/" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../..}/dist/" regex="solr-langid-\d.*\.jar" />

  <lib dir="${solr.install.dir:../..}/contrib/velocity/lib" regex=".*\.jar" />
  <lib dir="${solr.install.dir:../..}/dist/" regex="solr-velocity-\d.*\.jar" />
```

**重启tomcat**

```
ps -ef | grep solr | grep -v grep | awk '{print $2}' | xargs kill -9 && \
sleep 2 && \
/usr/local/solr7/solr-tomcat/bin/startup.sh 
```



#### Solr Clound 集群部署

##### 环境说明

```
JDK：1.8
tomcat: 8.0
solr: 7.1.0
zookeeper：3.4.11

机器：
	192.168.247.130/131/132
每台机器启动两个tomcat 进程（9000/9001）
```

##### 复制安装单机版的solr 的tomcat

```
cd /usr/local/solr7/
cp -r solr-tomcat solr-tomcat9000
cp -r solr-tomcat solr-tomcat9001
cp -r solr_home solr_home9000
cp -r solr_home solr_home9001
```

##### 更改tomcat的端口

```
vim /usr/local/solr7/solr-tomcat9000/conf/server.xml
vim /usr/local/solr7/solr-tomcat9001/conf/server.xml
```

##### 更改solr_home 的位

```
# 删除solr_home 之前建立的spc_core 和 new_core
rm -f /usr/local/solr7/solr_home9000/*_core
rm -f /usr/local/solr7/solr_home9001/*_core

# solr web.xml 中配置solr_home 位置
vim /usr/local/solr7/solr-tomcat9000/webapps/solr/WEB-INF/web.xml
 <env-entry>
       <env-entry-name>solr/home</env-entry-name>
       <env-entry-value>/usr/local/solr7/solr_home9000</env-entry-value>
       <env-entry-type>java.lang.String</env-entry-type>
    </env-entry>
# 9001 tomcat 同
```

##### 配置solrCloud相关的配置

```
# 每个solrhome下都有一个solr.xml，把其中的ip及端口号配置好
cd /usr/local/solr7/solr_home9000/
vim solr.xml
  <solrcloud>

    <str name="host">192.168.247.130</str>
    <int name="hostPort">9000</int>
  
# 9001 tomcat 同
```

##### 让zookeeper统一管理配置文件，把/conf目录上传到zookeeper

```
cd /usr/local/solr7/solr-7.1.0/server/scripts/cloud-scripts		## 进入到solr 的解压包中
[root@localhost cloud-scripts]# ls
log4j.properties  snapshotscli.sh  zkcli.bat  zkcli.sh		## 必须使用 这个zkcli.sh 上传配置，使用zookeeper 自带的不能上传
./zkcli.sh -zkhost 192.168.247.130:2181,192.168.247.131:2181,192.168.247.132:2181 -cmd upconfig -confdir /usr/local/solr7/solr_home9000/configsets/sample_techproducts_configs/conf -confname myconf
```

登录zookeeper 查看配置文件的上传

```
[root@localhost cloud-scripts]# zkCli.sh -server 192.168.247.130:2181
[zk: 192.168.247.130:2181(CONNECTED) 1] ls /
[configs, zookeeper, dubbo, codis3, zk]
[zk: 192.168.247.130:2181(CONNECTED) 2] ls /configs
[myconf]
[zk: 192.168.247.130:2181(CONNECTED) 3] ls /configs/myconf
[currency.xml, mapping-FoldToASCII.txt, managed-schema, protwords.txt, synonyms.txt, stopwords.txt, velocity, _schema_analysis_synonyms_english.json, admin-extra.html, update-script.js, _schema_analysis_stopwords_english.json, solrconfig.xml, admin-extra.menu-top.html, elevate.xml, clustering, xslt, _rest_managed.json, mapping-ISOLatin1Accent.txt, spellings.txt, lang, params.json, admin-extra.menu-bottom.html]
```

##### 修改tomcat/bin目录下的catalina.sh 文件，关联solr和zookeeper

```
cd /usr/local/solr7/solr-tomcat9000/bin
vim catalina.sh 
	JAVA_OPTS="-DzkHost=192.168.247.130:2181,192.168.247.131:2181,192.168.247.132:2181"
	# 指定zookeeper 地址
```

##### 启动每一个tomcat实例

```
/usr/local/solr7/solr-tomcat9000/bin/startup.sh 
# 其他的主机一样启动，三台机器，启动6个实例
```

##### 访问集群

```
http://192.168.247.130:9000/solr/index.html		## 访问集群任意一个tomcat
```

##### 创建新的Collection进行分片处理

```
在浏览器的图形界面
	collections --> Add collection 
		设置name : collection1
		config set: 选定  zookeeper 中的配置 myconfig
		numShards : 3				## collection1 这个集合有三个分片
		replicationFactor: 2		## 复制因子，2 表示 一主一从
```

