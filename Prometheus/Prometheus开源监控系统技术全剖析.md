## Prometheus开源监控系统技术全剖析

### prometheus 序章

#### prometheus 架构

![1571814046960](assets/1571814046960.png)

#### 商用的报警系统pagerduty

![1571815054103](assets/1571815054103.png)

![1571815080396](assets/1571815080396.png)

#### prometheus的特点

![1571814975354](assets/1571814975354.png)

### 第一讲 企业级运维监控理论基础

![1571815618220](assets/1571815618220.png)

#### 完善的运维体系架构

![1571816088143](assets/1571816088143.png)



#### 监控系统的设计（运维架构师进行）

![1571816391963](assets/1571816391963.png)

#### 监控系统的搭建

![1571817050813](assets/1571817050813.png)



#### 数据采集的编写

![1571817361446](assets/1571817361446.png)

![1571817684512](assets/1571817684512.png)

#### 监控数据分析和算法

![1571818411774](assets/1571818411774.png)

![1571818676140](assets/1571818676140.png)

#### 监控稳定性测试

![1571818888313](assets/1571818888313.png)

#### 监控自动化

![1571818985469](assets/1571818985469.png)

#### 监控图形化

![1571819143780](assets/1571819143780.png)

### 第二讲 企业监控通用技术

#### ![1571983632364](assets/1571983632364.png)

![1571983903312](assets/1571983903312.png)

```
499 连接超时，客户端主动的放弃链接。
```

![1571984123317](assets/1571984123317.png)

### 第三讲 prometheus 监控入门

![1571984479091](assets/1571984479091.png)

![1571984718625](assets/1571984718625.png)

![1571985354509](assets/1571985354509.png)

```
官网：https://prometheus.io
```

![1571985475103](assets/1571985475103.png)

#### prometheus命令行

![1571985654474](assets/1571985654474.png)

![1571985751815](assets/1571985751815.png)

```
计算1min的CPU使用率
```

![1571985889690](assets/1571985889690.png)

```
默认的prometheus 配置文件	
```

![1571985926046](assets/1571985926046.png)

```
Targets显示prometheus的监控的节点
```

![1571986016285](assets/1571986016285.png)

### 第四讲 prometheus运行框架介绍

![1571814046960](assets/1571814046960.png)

#### prometheus Server

![1571986279201](assets/1571986279201.png)

##### prometheus Storage

![1571986740768](assets/1571986740768.png)

#### prometheus 服务发现配置

![1571986922471](assets/1571986922471.png)

![1571986950203](assets/1571986950203.png)

![1571986990816](assets/1571986990816.png)

![1571987027053](assets/1571987027053.png)

#### prometheus的采集客户端

![1571987141734](assets/1571987141734.png)

![1571987210356](assets/1571987210356.png)

### prometheus 监控数据格式

![1571987891147](assets/1571987891147.png)

#### metrics 数据的类型

**Gauge metric类型**

![1571988078134](assets/1571988078134.png)

**Counter metric类型**

![1571988485168](assets/1571988485168.png)

![1571988628435](assets/1571988628435.png)

**Histogram metric类型**

![1571988790003](assets/1571988790003.png)

![1571989080579](assets/1571989080579.png)

![1571989252565](assets/1571989252565.png)

#### prometheus k/v数据格式

![1571990473668](assets/1571990473668.png)

![1571990544739](assets/1571990544739.png)

```
exporter会实时的抓取服务的数据，执行curl 之后的返回数据
# 用于对下面才几点额数据进行说明，并说明了采集的数据的 metric的类型
```

![1571990749376](assets/1571990749376.png)

![1571990773558](assets/1571990773558.png)

![1571991998484](assets/1571991998484.png)

### 第六讲 prometheus 初探和配置

#### Prometheus 的启动和配置

**同步系统时间**

```
[root@localhost ~]# timedatectl set-timezone Asia/Shanghai
[root@localhost ~]# ntpdate -u cn.pool.ntp.org
25 Oct 17:03:49 ntpdate[2369]: adjust time server 119.28.206.193 offset 0.237453 sec
```

**官网下载安装包**

```
wget https://github.com/prometheus/prometheus/releases/download/v2.13.1/prometheus-2.13.1.linux-amd64.tar.gz
```

**解压安装包**

```
[root@localhost src]# tar -xf prometheus-2.13.1.linux-amd64.tar.gz 
[root@localhost local]# ln -s prometheus-2.13.1.linux-amd64/ prometheus
```

**启动prometheus**

```
[root@localhost prometheus]# ./prometheus 
level=info ts=2019-10-25T09:24:53.507Z caller=main.go:296 msg="no time or size retention was set so using the default time retention" duration=15d
level=info ts=2019-10-25T09:24:53.507Z caller=main.go:332 msg="Starting Prometheus" version="(version=2.13.1, branch=HEAD, revision=6f92ce56053866194ae5937012c1bec40f1dd1d9)"
level=info ts=2019-10-25T09:24:53.507Z caller=main.go:333 build_context="(go=go1.13.1, user=root@88e419aa1676, date=20191017-13:15:01)"
level=info ts=2019-10-25T09:24:53.507Z caller=main.go:334 host_details="(Linux 3.10.0-123.el7.x86_64 #1 SMP Mon Jun 30 12:09:22 UTC 2014 x86_64 localhost.localdomain (none))"
level=info ts=2019-10-25T09:24:53.507Z caller=main.go:335 fd_limits="(soft=655350, hard=655350)"
level=info ts=2019-10-25T09:24:53.507Z caller=main.go:336 vm_limits="(soft=unlimited, hard=unlimited)"
level=info ts=2019-10-25T09:24:53.508Z caller=main.go:657 msg="Starting TSDB ..."
level=info ts=2019-10-25T09:24:53.526Z caller=web.go:450 component=web msg="Start listening for connections" address=0.0.0.0:9090
level=info ts=2019-10-25T09:24:53.527Z caller=head.go:514 component=tsdb msg="replaying WAL, this may take awhile"
level=info ts=2019-10-25T09:24:53.540Z caller=head.go:562 component=tsdb msg="WAL segment loaded" segment=0 maxSegment=0
level=info ts=2019-10-25T09:24:53.541Z caller=main.go:672 fs_type=XFS_SUPER_MAGIC
level=info ts=2019-10-25T09:24:53.541Z caller=main.go:673 msg="TSDB started"
level=info ts=2019-10-25T09:24:53.541Z caller=main.go:743 msg="Loading configuration file" filename=prometheus.yml
level=info ts=2019-10-25T09:24:53.545Z caller=main.go:771 msg="Completed loading of configuration file" filename=prometheus.yml
level=info ts=2019-10-25T09:24:53.545Z caller=main.go:626 msg="Server is ready to receive web requests."
```

```
访问9090端口可以看到默认的prometheus 界面
```

![image-20191028171833495](assets/image-20191028171833495.png)

**Prometheus 配置文件**

```

# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']
```

![image-20191028172321024](assets/image-20191028172321024.png)

![image-20191028174142503](assets/image-20191028174142503.png)

```
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
  	## 定义了一个监控的名称

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']
    	## 定义监控的机器服务目标
```

![image-20191028174531618](assets/image-20191028174531618.png)

![image-20191028174609332](assets/image-20191028174609332.png)

#### Prometheus 监控CPU使用率实例

![image-20191029154056172](assets/image-20191029154056172.png)

![image-20191029154404524](assets/image-20191029154404524.png)

```
安装node_exporter 之后收集到的 CPU的时间片的信息
```

![image-20191029154504234](assets/image-20191029154504234.png)

![image-20191029154659959](assets/image-20191029154659959.png)

![image-20191029154808807](assets/image-20191029154808807.png)

![image-20191029155204796](assets/image-20191029155204796.png)

![image-20191029155308623](assets/image-20191029155308623.png)

```
idle 状态的CPU的使用时间总和，用 1 减去，得到不是idle状态的CPU使用时间
再使用node_cpu 的所有mode状态总和时间，求得的比率

(1 - sum(increase(node_cpu_seconds_total{mode="idle"}[1m])) by (instance) / sum(increase(node_cpu_seconds_total[1m])) by (instance)) * 100
```

![image-20191030103716818](assets/image-20191030103716818.png)

### 第七讲 Prometheus 数学理论基础学习

![image-20191029161448452](assets/image-20191029161448452.png)

![image-20191029161612579](assets/image-20191029161612579.png)

![image-20191029161816778](assets/image-20191029161816778.png)

![image-20191029161949319](assets/image-20191029161949319.png)

![image-20191029162229545](assets/image-20191029162229545.png)

**CPU使用率的计算公式的拆分**

![image-20191029163011392](assets/image-20191029163011392.png)

![image-20191029163100108](assets/image-20191029163100108.png)

```
mode 指定CPU耗时的类型，mode实际上为一个标签
node_cpu 没有过滤条件(标签)，实际上是全部的CPU时间
```

![image-20191029163258139](assets/image-20191029163258139.png)

![image-20191029163328627](assets/image-20191029163328627.png)

![image-20191029163357937](assets/image-20191029163357937.png)

![image-20191029163541319](assets/image-20191029163541319.png)

![image-20191029163704472](assets/image-20191029163704472.png)

![image-20191029163905180](assets/image-20191029163905180.png)

![image-20191029164051179](assets/image-20191029164051179.png)

### 第八讲 Prometheus命令行使用扩展

#### **采集的数据使用lable 进行过滤**

![image-20191029164800130](assets/image-20191029164800130.png)

![image-20191029164939322](assets/image-20191029164939322.png)

![image-20191029165014053](assets/image-20191029165014053.png)

#### counter类型数据每秒平均数

##### rate函数

