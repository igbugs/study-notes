## minio调研

### 1. 功能特性

#### 1）Amazon S3兼容

Minio使用Amazon S3 v2 / v4 API。可以使用Minio SDK，Minio Client，AWS SDK和AWS CLI访问Minio服务器。

#### 2）数据保护

Minio使用Minio Erasure Code来防止硬件故障。也许会损坏一半以上的driver，但是仍然可以从中恢复。

#### 3）高度可用

Minio服务器可以容忍分布式设置中高达（N / 2）-1节点故障。而且，您可以配置Minio服务器在Minio与任意Amazon S3兼容服务器之间存储数据。

#### 4）Lambda计算

Minio服务器通过其兼容AWS SNS / SQS的事件通知服务触发Lambda功能。支持的目标是消息队列，如Kafka，NATS，AMQP，MQTT，Webhooks以及Elasticsearch，Redis，Postgres和MySQL等数据库。

#### 5）加密和防篡改

Minio为加密数据提供了机密性，完整性和真实性保证，而且性能开销微乎其微。使用AES-256-GCM，ChaCha20-Poly1305和AES-CBC支持服务器端和客户端加密。加密的对象使用AEAD服务器端加密进行防篡改。

### 2. minio核心概念

- Drive：即存储数据的磁盘，在 MinIO 启动时，以参数的方式传入；

- Erasure Code: 纠删码，就是可以通过数学计算，把丢失的数据进行还原，它可以将n份原始数据，增加m份数据，并能通过n+m份中的任意n份数据，还原为原始数据。即如果有任意小于等于m份的数据失效，仍然能通过剩下的数据还原出来；

- Erasure Set：即一组 Drive 的集合，分布式部署根据集群规模自动划分一个或多个 Erasure Set（每个Erasure Set包含4到16个Drive），每个 Erasure Set 中的 Drive 分布在不同位置。一个对象存储在一个 Erasure Set 上；

- Bucket Version：MinIO 支持在单个存储桶中保存对象的多个“版本”。 通常会覆盖现有对象的写入操作 导致创建新的版本化对象。 MinIO 版本控制可防止 意外覆盖和删除，同时支持“撤消” 写操作。 存储桶版本控制还支持保留和存档策略；

- Server Pool:  [`HOSTNAME`](http://docs.minio.org.cn/minio/baremetal/reference/minio-server/minio-server.html#minio-server-HOSTNAME) 参数传递给 [`minio server`](http://docs.minio.org.cn/minio/baremetal/reference/minio-server/minio-server.html#command-minio-server) 命令代表一个服务器池:

  ```
  minio server https://minio{1...4}.example.net/mnt/disk{1...4}
  
               |                    Server Pool                |
  ```

- Cluster:  整个 MinIO 部署由一个或多个服务器池组成。 每个 [`HOSTNAME`](http://docs.minio.org.cn/minio/baremetal/reference/minio-server/minio-server.html#minio-server-HOSTNAME) 参数传递给 [`minio server`](http://docs.minio.org.cn/minio/baremetal/reference/minio-server/minio-server.html#command-minio-server) 命令代表一个服务器池:

  ```
  minio server https://minio{1...4}.example.net/mnt/disk{1...4} \
               https://minio{5...8}.example.net/mnt/disk{1...4}
  
               |                    Server Pool                |
  ```

### 3. 环境说明

| 节点名 | IP              | 配置                      | 带宽     |
| ------ | --------------- | ------------------------- | -------- |
| node1  | 192.168.251.133 | 虚拟机 16c16g  2数据盘80G | 20Gbit/s |
| node2  | 192.168.251.88  | 虚拟机 16c16g  2数据盘80G | 20Gbit/s |
| node3  | 192.168.251.98  | 虚拟机 16c16g  2数据盘80G | 20Gbit/s |
| 压力机 | 192.168.251.153 | 虚拟机 16c16g             | 20Gbit/s |

### 4. 部署说明

**下载地址：**

```
wget https://dl.min.io/server/minio/release/linux-amd64/minio
```

**minio版本：**

![image-20220615193707248](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220615193707248.png)

#### **分布式部署架构**

分布式部署，默认使用纠删码模式进行数据的保护，最少需要 四块磁盘进行纠删码模式的部署，最高可以允许（N/2）一半的磁盘故障。

测试环境三个节点每个节点两块盘，总共六个 drive（测试只使用了drive1）

![image-20220615193824186](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220615193824186.png)

**目录结构：**

```
[root@node1 opt]# tree /opt/
/opt/
└── minio
    ├── config       // 配置文件目录
    │   └── certs
    │       └── CAs
    ├── minio	 	// minio二进制
    └── run.sh       //启动脚本
```

**启动脚本：**

```
#!/bin/bash
export MINIO_ROOT_USER=admin 
export MINIO_ROOT_PASSWORD=edoc2@edoc2

/opt/minio/minio server --config-dir /opt/minio/config/ --console-address ":30000"\
    http://192.168.251.133/data{1..2}/drive1 \
    http://192.168.251.88/data{1..2}/drive1 \
    http://192.168.251.98/data{1..2}/drive1 
```

**service 文件:**

```
[root@node1 opt]# cat /usr/lib/systemd/system/minio.service 
[Unit]
Description=Minio service
Documentation=https://docs.minio.io/

[Service]
WorkingDirectory=/opt/minio/
ExecStart=/opt/minio/run.sh 
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**服务进程**

![image-20220616160642998](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220616160642998.png)

**配置nginx代理（非必须）**

```
upstream minio{
	server 192.168.251.133:9000;
	server 192.168.251.88:9000;
	server 192.168.251.98:9000;

}
server {
    listen 9300; 
    server_name minio;
    location / {
        proxy_pass http://minio;
        proxy_set_header Host $http_host;
        client_max_body_size 1000m;
    }
}
```

**配置minio 客户端 mc**

```
wget https://dl.min.io/client/mc/release/linux-amd64/mc
```

添加配置 minio的连接信息

```
mc config host add minio http://192.168.251.189:9300 admin edoc2@edoc2 --api s3v4
## 这里的9300 是nginx的地址，代理到三个节点的9000
```

![image-20220616163018161](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220616163018161.png)

#### 单机部署

```
[root@node1 minio]# cat run.sh
#!/bin/bash

export MINIO_ROOT_USER=admin 
export MINIO_ROOT_PASSWORD=edoc2@edoc2

# 指定一个存储目录
/opt/minio/minio server --config-dir /opt/minio/config/ --console-address ":30000"\
    /data1/drive1
```

单机部署无法提供数据的安全保障；

测试环境使用192.168.251.133这个机器部署测试。

#### NAS网关部署

NAS网关在最新版本的minio中此功能已经移除，不再进行支持；

![image-20220620093939123](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620093939123.png)

测试使用的之前版本（minio.20210116 version RELEASE.2021-01-16T02-19-44Z）

在192.168.251.88 NFS 共享文件目录到 192.168.251.133 进行 NAS网关的测试。

![image-20220620094058057](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620094058057.png)

```
[root@node1 minio]# cat run.sh
#!/bin/bash

export MINIO_ROOT_USER=admin 
export MINIO_ROOT_PASSWORD=edoc2@edoc2

# /data1/share 是从 192.168.251.88 共享出来的目录
/opt/minio/minio.20210116 gateway nas /data1/share
```

### 5. 单文件上传测试

使用minio官方提供的s3客户端工具mc在压力机192.168.251.153进行文件上传下载测试

**minio分布式集群上传下载**

![image-20220620094701830](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620094701830.png)

![image-20220620094709641](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620094709641.png)

**ceph集群**

![image-20220620095226561](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620095226561.png)

**minio单机**

![image-20220620095826147](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620095826147.png)

**minio单机NAS网关**

![image-20220620095911004](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620095911004.png)

**ceph单机**

![image-20220620094937480](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620094937480.png)

**SCP拷贝**

![image-20220620095959858](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620095959858.png)

| 存储部署类别             | 上传速度                              | 下载速度         |
| ------------------------ | ------------------------------------- | ---------------- |
| minio分布式集群          | 15.89MiB/s  10m44s                    | 654.67MiB/s  15s |
| ceph集群                 | 4.59MiB/s 37m8s                       | 202.79MiBs 50s   |
| minio单机单磁盘          | 46.04 MiB/s 3m42s                     | -                |
| minio NAS网关            | 5.55 MiB/s 30m44s                     | -                |
| ceph 单机                | 50.63 MiB/s 3m22s                     | 328.14 MiB/s 31s |
| SCP拷贝（网络盘/本地盘） | （18.4MB/s   09:15/16.7MB/s   10:14） | -                |

总体上大文件上传，minio的上传下载性能集群上对ceph集群有4倍左右优势，minio的集群上传下载性能基本与本机SCP拷贝持平。使用NAS网关，和minio单机部署方式比较，上传速度衰减明显。

### 6. 压力测试

压测工具使用是minio的官方提供的压测工具 warp，压力机地址192.168.251.153；

```
# 压力机执行
warp mixed --host=192.168.251.133:9000,192.168.251.88:9000,192.168.251.98:9000 --access-key admin --secret-key edoc2@edoc2 --autoterm  --analyze.v

## 默认的 混合压力测试，默认生成2500个对象，每个对象大小10MB，并发20，进行上传、下载、删除、查看状态操作
```

压测方法：分别部署minio分布式集群，minio单机，minio NAS 网关，ceph集群这几种部署方式，分别进行对象大小100Kib，1Mib，5Mib，10Mib的总存储量大概20G左右的 20并发的mixed混合压力测试

**压测记录：** https://v5.edoc2.com/preview.html?fileid=3684760

**压测数据整理：** https://v5.edoc2.com/preview.html?fileid=3684739

#### minio集群与ceph集群

minio分布式集群使用的三个节点6个磁盘作为一个set进行测试；

ceph集群使用的三副本，每个节点两块HDD磁盘作为osd进行部署测试。

![image-20220620115537660](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620115537660.png)

![image-20220620115555391](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620115555391.png)

![image-20220620115840600](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620115840600.png)

![image-20220620115849990](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620115849990.png)

从上面测试数据可以看出，minio集群在压测100Kib小文件的时候，吞吐量弱于ceph集群100Kib的压测；在大文件对象测试中好于ceph集群。

从压测过程中系统资源占用情况，minio的三个节点的CPU负载一直持续在30左右浮动，而ceph集群的CPU负载在2左右，由于minio使用的是纠删码的方式保证数据安全，需要大量计算，CPU成为minio的性能瓶颈点。

#### minio单机与minio NAS 网关

![image-20220620123443390](C:\Users\XYB\Desktop\k8s调研\minio调研.assets\image-20220620123443390.png)

minio 通过网关对共享存储对外提供s3接口的性能相较于minio单机有性能衰减。

### 7. 总结

1. minio对外只提供s3的标准接口，只有一个单一的二进制文件，部署起来极其简单，很容易进行容器化；没有ceph那么多的概念和组件，对实施和运维十分便捷；
2. 由于minio是通过纠删码来进行数据的安全保障的，每个对象都要进行纠删码的计算，对集群的CPU要求会比较高，这也决定了minio最好单独部署为存储集群，不适合与应用进行混布；minio默认在一半磁盘故障的情况下依然数据可用，数据存储大小是实际数据的两倍，减少磁盘空间占用；
3. 在当前测试环境的配置看，minio集群相对于ceph集群看，在大对象上有性能优势，由于小文件压测的数量较多，瓶颈在于测试环境CPU的性能，小文件对于ceph集群没有较大优势；
4. minio分布式集群，官方建议最大部署节点为32个节点，受限于其内部实现的分布式锁Dsync的性能，官方给的扩容方案是建立新的集群，进行联邦扩容；
5. ceph集群在出现问题的时候，有比较强的自愈恢复能力，minio在故障情况下如何处理还需要验证。

