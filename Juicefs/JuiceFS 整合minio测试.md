## JuiceFS 整合minio导出POSIX文件系统

官网手册：https://juicefs.com/docs/zh/community/introduction/

### JuiceFS介绍

**JuiceFS** 是一款面向云原生设计的高性能共享文件系统，在 Apache 2.0 开源协议下发布。提供完备的 [POSIX](https://en.wikipedia.org/wiki/POSIX) 兼容性，可将几乎所有对象存储接入本地作为海量本地磁盘使用，亦可同时在跨平台、跨地区的不同主机上挂载读写。

JuiceFS 采用「数据」与「元数据」分离存储的架构，从而实现文件系统的分布式设计。使用 JuiceFS 存储数据，数据本身会被持久化在[对象存储](https://juicefs.com/docs/zh/community/how_to_setup_object_storage#支持的存储服务)（例如，Amazon S3），相对应的元数据可以按需持久化在 Redis、MySQL、TiKV、SQLite 等多种[数据库](https://juicefs.com/docs/zh/community/databases_for_metadata)中。

JuiceFS 提供了丰富的 API，适用于各种形式数据的管理、分析、归档、备份，可以在不修改代码的前提下无缝对接大数据、机器学习、人工智能等应用平台，为其提供海量、弹性、低价的高性能存储。运维人员不用再为可用性、灾难恢复、监控、扩容等工作烦恼，专注于业务开发，提升研发效率。同时运维细节的简化，也让运维团队更容易向 DevOps 团队转型。

#### 核心特性

1. **POSIX 兼容**：像本地文件系统一样使用，无缝对接已有应用，无业务侵入性；
2. **HDFS 兼容**：完整兼容 [HDFS API](https://juicefs.com/docs/zh/community/hadoop_java_sdk)，提供更强的元数据性能；
3. **S3 兼容**：提供 [S3 网关](https://juicefs.com/docs/zh/community/s3_gateway) 实现 S3 协议兼容的访问接口；
4. **云原生**：通过 [CSI Driver](https://juicefs.com/docs/zh/community/how_to_use_on_kubernetes) 轻松地在 Kubernetes 中使用 JuiceFS；
5. **分布式设计**：同一文件系统可在上千台服务器同时挂载，高性能并发读写，共享数据；
6. **强一致性**：确认的文件修改会在所有服务器上立即可见，保证强一致性；
7. **强悍性能**：毫秒级延迟，近乎无限的吞吐量（取决于对象存储规模），查看[性能测试结果](https://juicefs.com/docs/zh/community/benchmark/)；
8. **数据安全**：支持传输中加密（encryption in transit）和静态加密（encryption at rest），[查看详情](https://juicefs.com/docs/zh/community/security/encrypt)；
9. **文件锁**：支持 BSD 锁（flock）和 POSIX 锁（fcntl）；
10. **数据压缩**：支持 [LZ4](https://lz4.github.io/lz4) 和 [Zstandard](https://facebook.github.io/zstd) 压缩算法，节省存储空间。

#### 技术架构

JuiceFS 文件系统由三个部分组成：

1. **JuiceFS 客户端**：协调对象存储和元数据存储引擎，以及 POSIX、Hadoop、Kubernetes CSI Driver、S3 Gateway 等文件系统接口的实现；
2. **数据存储**：存储数据本身，支持本地磁盘、公有云或私有云对象存储、HDFS 等介质；
3. **元数据引擎**：存储数据对应的元数据（metadata）包含文件名、文件大小、权限组、创建修改时间和目录结构等，支持 Redis、MySQL、TiKV 等多种引擎

![image-20220713140254578](.\JuiceFS 整合minio测试.assets\image-20220713140254578.png)

### 安装部署

这里测试部署选用的是etcd，etcd提供强一致的读写访问，所有操作都涉及到多机事务更新和数据持久化，性能肯定不能和redis作为元数据引擎相比，但redis作为元数据引擎只支持单机redis（或sentinel集群），有其自身局限，有数据丢失风险（即使开启rbd和AOF，fsync的默认间隔为1s，可能会有1s的元数据丢失风险）

#### 环境说明

| IP              | 服务                   | 配置              |
| --------------- | ---------------------- | ----------------- |
| 192.168.251.102 | minio/etcd             | 16C16G  2HDD* 80G |
| 192.168.251.88  | minio/etcd             | 16C16G  2HDD* 80G |
| 192.168.251.98  | minio/etcd             | 16C16G  2HDD* 80G |
| 192.168.251.126 | ECM 6.0、JuiceFS客户端 | 8C12G  200G       |

#### 下载安装

```
JFS_LATEST_TAG=$(curl -s https://api.github.com/repos/juicedata/juicefs/releases/latest | grep 'tag_name' | cut -d '"' -f 4 | tr -d 'v')
wget "https://github.com/juicedata/juicefs/releases/download/v${JFS_LATEST_TAG}/juicefs-${JFS_LATEST_TAG}-linux-amd64.tar.gz"
tar -zxf "juicefs-${JFS_LATEST_TAG}-linux-amd64.tar.gz"
sudo install juicefs /usr/local/bin
```

#### etcd连接信息

```
[root@node1 minio]# ETCDCTL_API=3 etcdctl member list
6284eeb773af23cc, started, etcd3, http://192.168.251.98:2380, http://192.168.251.98:2379
793ba0aaa9c9a810, started, etcd1, http://192.168.251.133:2380, http://192.168.251.102:2379
80c8b20abbb616fc, started, etcd2, http://192.168.251.88:2380, http://192.168.251.88:2379
```

#### minio连接信息

```
http://192.168.251.102:9000,http://192.168.251.88:9000,http://192.168.251.98:9000
```

#### 格式化文件系统

```
juicefs format \
    --storage minio \
    --bucket http://192.168.251.102:9000/edoc3 \
    --access-key 1KuNsQIqF91ZK1lE \
    --secret-key i86K9M4zlkQj1Ng33b2ZjGzqxYhywA4y \
    etcd://192.168.251.102:2379,192.168.251.88:2379,192.168.251.98:2379/jfs \
    myjfs
```

![image-20220713152405964](.\JuiceFS 整合minio测试.assets\image-20220713152405964.png)

格式化一个名为myjfs的文件系统，元数据引擎使用的是etcd，数据引擎使用的是minio

#### 文件系统挂载到本地目录

```
juicefs mount \
    --background \
    --cache-dir /mycache \
    --cache-size 512 \
    etcd://192.168.251.102:2379,192.168.251.88:2379,192.168.251.98:2379/jfs \
    /mnt/jfs
```

![image-20220713153044301](.\JuiceFS 整合minio测试.assets\image-20220713153044301.png)

指定缓存目录 /mycache，缓存的大小512mb，指定元数据引擎地址，挂载位置为本机 /mnt/jfs 

![image-20220713153359615](.\JuiceFS 整合minio测试.assets\image-20220713153359615.png)

#### 测试文件上传

![image-20220713153626986](.\JuiceFS 整合minio测试.assets\image-20220713153626986.png)

![image-20220713153715760](.\JuiceFS 整合minio测试.assets\image-20220713153715760.png)

![image-20220713154514875](.\JuiceFS 整合minio测试.assets\image-20220713154514875.png)

![image-20220713154604686](.\JuiceFS 整合minio测试.assets\image-20220713154604686.png)

### ecm添加本地存储

![image-20220713161709883](.\JuiceFS 整合minio测试.assets\image-20220713161709883.png)

126节点创建DefaultStorage2目录，juicefs挂载到此路径

```
juicefs mount \
    --background \
    --cache-dir /mycache \
    --cache-size 512 \
    etcd://192.168.251.102:2379,192.168.251.88:2379,192.168.251.98:2379/jfs \
    /home/edoc2/macrowing/edoc2v5/data/edoc2Docs/DefaultStorage2
```

![image-20220713161743420](.\JuiceFS 整合minio测试.assets\image-20220713161743420.png)

![image-20220713161640168](.\JuiceFS 整合minio测试.assets\image-20220713161640168.png)

测试上传没有问题

![image-20220713163157525](.\JuiceFS 整合minio测试.assets\image-20220713163157525.png)

#### 20并发压测（etcd）

![image-20220713163120921](.\JuiceFS 整合minio测试.assets\image-20220713163120921.png)

![image-20220713163218968](.\JuiceFS 整合minio测试.assets\image-20220713163218968.png)

#### 元数据引擎更换redis

![image-20220713164803309](.\JuiceFS 整合minio测试.assets\image-20220713164803309.png)

```
juicefs format \
    --storage minio \
    --bucket http://192.168.251.102:9000/edoc3 \
    --access-key 1KuNsQIqF91ZK1lE \
    --secret-key i86K9M4zlkQj1Ng33b2ZjGzqxYhywA4y \
    redis://:ZgDSvOoY5Q@192.168.251.126:30005/2 \
    myjfsredis
```

![image-20220713164917244](.\JuiceFS 整合minio测试.assets\image-20220713164917244.png)

```
juicefs mount \
    --background \
    redis://:ZgDSvOoY5Q@192.168.251.126:30005/2 \
    /home/edoc2/macrowing/edoc2v5/data/edoc2Docs/DefaultStorage2
```

![image-20220713165107266](.\JuiceFS 整合minio测试.assets\image-20220713165107266.png)

#### 20并发压测（redis）

![image-20220713170104300](.\JuiceFS 整合minio测试.assets\image-20220713170104300.png)

![image-20220713170153978](.\JuiceFS 整合minio测试.assets\image-20220713170153978.png)

可以看到上传下载的流的操作，比etcd有提升，这个下载检查和存储没多大关系。