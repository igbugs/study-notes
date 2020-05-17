## ceph 学习笔记

### Ceph概况

![image-20200515220252228](assets/image-20200515220252228.png)

![image-20200515220344553](assets/image-20200515220344553.png)

![image-20200515220827965](assets/image-20200515220827965.png)

![image-20200515221010341](assets/image-20200515221010341.png)

![image-20200515221147067](assets/image-20200515221147067.png)

### Ceph 集群安装

![image-20200515221314373](assets/image-20200515221314373.png)

![image-20200515221602829](assets/image-20200515221602829.png)

![image-20200515221747273](assets/image-20200515221747273.png)

![image-20200515221845806](assets/image-20200515221845806.png)

![image-20200515223852220](assets/image-20200515223852220.png)

![image-20200515224128423](assets/image-20200515224128423.png)

![image-20200515224254120](assets/image-20200515224254120.png)

![image-20200515224449786](assets/image-20200515224449786.png)

![image-20200515224852816](assets/image-20200515224852816.png)

![image-20200515225229882](assets/image-20200515225229882.png)

![image-20200515225928176](assets/image-20200515225928176.png)

![image-20200515230347251](assets/image-20200515230347251.png)

### Ceph 存储提供

![image-20200515230531431](assets/image-20200515230531431.png)

![image-20200515230702070](assets/image-20200515230702070.png)

```
对象存储：使用 Object Gateway（例如 Rados Gateway）
块存储：Rados Block Device（RBD）
文件存储： Ceph Filesystem （ceph-fs）
```

![image-20200515230844883](assets/image-20200515230844883.png)

```
精简配置：意思是我创建了1T的存储空间，我不会立即把这个存储空间分配给你，而是分配给你需要的空间的大小
动态扩容：支持动态的扩容和缩容块设备
```

![image-20200515231658137](assets/image-20200515231658137.png)

### Ceph 存储与传统的存储的对比

![image-20200515232226029](assets/image-20200515232226029.png)

```
DAS：服务器的本地硬盘存储，磁盘利用率低，不易扩容
SAN：存储区域网络，需要光纤交换机的支持，不是简单的 TCP/IP 协议，成本高
NAS：网络附加存储，直接通过 以太网 进行连接，入 NFS
```

### Ceph块设备监理

![image-20200515233106085](assets/image-20200515233106085.png)

![image-20200515233502686](assets/image-20200515233502686.png)

![image-20200515233700244](assets/image-20200515233700244.png)

![image-20200515233819254](assets/image-20200515233819254.png)

![image-20200515234056571](assets/image-20200515234056571.png)

```
id=admin  这里是最高的权限，可以设置不同的用户拥有 不同的访问ceph块的权限，避免用户删除不属于自己的块设备
```

![image-20200515234805270](assets/image-20200515234805270.png)

![image-20200515235244244](assets/image-20200515235244244.png)

### 快照和克隆

![image-20200515235339644](assets/image-20200515235339644.png)

![image-20200515235513130](assets/image-20200515235513130.png)

```
利用之前创建的快照进行回滚的时候，需要先将快照的 块文件的目录进行 umount
```

![image-20200516000139666](assets/image-20200516000139666.png)

```
列出image 下面的 快照
```

![image-20200516000240195](assets/image-20200516000240195.png)

```
删除快照
```

![image-20200516000314327](assets/image-20200516000314327.png)

```
purge 是清楚 image 下面的所有的快照
```

![image-20200516000434588](assets/image-20200516000434588.png)

![image-20200516000500580](assets/image-20200516000500580.png)

```
保护快照就是不允许对快照进行删除
```

![image-20200516000634025](assets/image-20200516000634025.png)

```
保护快照必须使用 format为2格式的块设备
```

![image-20200516000815484](assets/image-20200516000815484.png)

![image-20200516000911207](assets/image-20200516000911207.png)

![image-20200516001103267](assets/image-20200516001103267.png)

```
只能对 保护的快照进行clone
```

![image-20200516001228710](assets/image-20200516001228710.png)

![image-20200516131125049](assets/image-20200516131125049.png)

![image-20200516131314152](assets/image-20200516131314152.png)

```
protect 的目的是保护快照不被删除
```

![image-20200516131538480](assets/image-20200516131538480.png)

### 安装RADOS Gateway

![image-20200516131710161](assets/image-20200516131710161.png)

![image-20200516135145513](assets/image-20200516135145513.png)

![image-20200516135339716](assets/image-20200516135339716.png)

```
使用 ceph auth list 查看授权的密钥环
```

![image-20200516135544338](assets/image-20200516135544338.png)

![image-20200516135830783](assets/image-20200516135830783.png)

```
上面的配置是因为 使用的key都是 ceph3主机的 密钥环
```

![image-20200516135759761](assets/image-20200516135759761.png)

![image-20200516140253753](assets/image-20200516140253753.png)

![image-20200516140347391](assets/image-20200516140347391.png)

![image-20200516140642407](assets/image-20200516140642407.png)

![image-20200516140850546](assets/image-20200516140850546.png)

### 创建S3和Swift用户

![image-20200516141622028](assets/image-20200516141622028.png)

![image-20200516142927022](assets/image-20200516142927022.png)

![image-20200516142950316](assets/image-20200516142950316.png)

```
使用 radosgw-admin user info 查看用户的 信息，access_key 等信息
```

### 测试S3接口

![image-20200516144804785](assets/image-20200516144804785.png)

![image-20200516144849436](assets/image-20200516144849436.png)

![image-20200516145334710](assets/image-20200516145334710.png)

![image-20200516145724555](assets/image-20200516145724555.png)

![image-20200516145754877](assets/image-20200516145754877.png)

```
使用 s3cmd --configure 进行配置的保存的配置文件的位置
```

![image-20200516145834147](assets/image-20200516145834147.png)

```
列出的 bucket 的目录
```

![image-20200516150026082](assets/image-20200516150026082.png)

![image-20200516150247897](assets/image-20200516150247897.png)

### Ceph架构及组件

![image-20200516150431674](assets/image-20200516150431674.png)

![image-20200516150609128](assets/image-20200516150609128.png)

```
librados: 应用直接通过ceph 提供的 lib库进行 ceph rados 的访问
radosgw: 通过REST 的api进行访问（对象存储）
RBD：提供块设备的存储
Cephfs: 使用 posix 的文件系统接口进行访问
```

![image-20200516150951898](assets/image-20200516150951898.png)

![image-20200516151046055](assets/image-20200516151046055.png)

![image-20200516151131896](assets/image-20200516151131896.png)

![image-20200516151430041](assets/image-20200516151430041.png)

### Ceph RADOS 的设计及原理

![image-20200516151545534](assets/image-20200516151545534.png)

![image-20200516151636685](assets/image-20200516151636685.png)

![image-20200516151810280](assets/image-20200516151810280.png)

```
File 在存入到 ceph中的时候，首先对文件进行 切分限定块大小的 一个个的 对象Object，生成对应的 oid；
通过 对oid 进行hash计算，得到这个 object 分配到哪组PG（每个PG有多个 映射的OSD，两个就是两个副本）；
CRUSH(pgid) 会得到一组的PG
```

![image-20200516152647770](assets/image-20200516152647770.png)

![image-20200516153014079](assets/image-20200516153014079.png)

### 数据的写入流程

![image-20200516153524789](assets/image-20200516153524789.png)

![image-20200516153933077](assets/image-20200516153933077.png)

### 数据的读取流程

![image-20200516154426070](assets/image-20200516154426070.png)

![image-20200516154448515](assets/image-20200516154448515.png)

### Ceph 的 Crush算法

![image-20200516154725694](assets/image-20200516154725694.png)

![image-20200516155410924](assets/image-20200516155410924.png)

![image-20200516160024627](assets/image-20200516160024627.png)

### POOL的概述

![image-20200516160226676](assets/image-20200516160226676.png)

![image-20200516160406563](assets/image-20200516160406563.png)

```
有的PG 含有两个OSD，有的含有三个的OSD
pool 是相当于OSD 上存储数据的 隔离 
```

### CrushMap的概述

![image-20200516161059723](assets/image-20200516161059723.png)

![image-20200516161357690](assets/image-20200516161357690.png)

![image-20200516161558943](assets/image-20200516161558943.png)

```
导出crushmap
```

![image-20200516161821153](assets/image-20200516161821153.png)

### OSD的Journal

![image-20200516162021369](assets/image-20200516162021369.png)

```
最下面的官方提供的 吞吐量太小了
```

![image-20200516162137143](assets/image-20200516162137143.png)

### Ceph集群的容灾

![image-20200516162420258](assets/image-20200516162420258.png)

![image-20200516162606695](assets/image-20200516162606695.png)

### Ceph的集群监控和故障排除

![image-20200516162826494](assets/image-20200516162826494.png)

![image-20200516163156721](assets/image-20200516163156721.png)

![image-20200516163020368](assets/image-20200516163020368.png)

![image-20200516163104257](assets/image-20200516163104257.png)

![image-20200516163218909](assets/image-20200516163218909.png)

![image-20200516163458429](assets/image-20200516163458429.png)

```
up ：一个节点上添加磁盘
out： 添加新的节点
```

![image-20200516163621535](assets/image-20200516163621535.png)

![image-20200516163649847](assets/image-20200516163649847.png)

![image-20200516163923452](assets/image-20200516163923452.png)

![image-20200516164340987](assets/image-20200516164340987.png)

```
查看OSD所有的配置参数
```

![image-20200516164614665](assets/image-20200516164614665.png)

![image-20200516164643147](assets/image-20200516164643147.png)

```
查看 mon 的配置
```

### 添加MON节点

![image-20200516164751156](assets/image-20200516164751156.png)

![image-20200516165142271](assets/image-20200516165142271.png)

![image-20200516165503462](assets/image-20200516165503462.png)

![image-20200516165532984](assets/image-20200516165532984.png)

### 删除OSD

![image-20200516170139232](assets/image-20200516170139232.png)

![image-20200516170518863](assets/image-20200516170518863.png)

![image-20200516170501556](assets/image-20200516170501556.png)

![image-20200516170617883](assets/image-20200516170617883.png)

```
osd.4是在 ceph-06 的机器上的
```

![image-20200516170314076](assets/image-20200516170314076.png)

```
OSD 的认证信息
```

![image-20200516170810470](assets/image-20200516170810470.png)

![image-20200516170828360](assets/image-20200516170828360.png)

![image-20200516170850956](assets/image-20200516170850956.png)

### 删除MON

![image-20200516171055212](assets/image-20200516171055212.png)

### 升级集群

![image-20200516171210851](assets/image-20200516171210851.png)

![image-20200516171315209](assets/image-20200516171315209.png)

### 更换硬盘

![image-20200516171414612](assets/image-20200516171414612.png)

```
不手动 osd out ，集群在300s之后也会自动的进行 out
第三步 是： ceph osd crush remove osd.x 从 crush map 中删除信息
```

![image-20200516171934347](assets/image-20200516171934347.png)

![image-20200516172059790](assets/image-20200516172059790.png)

![image-20200516171513543](assets/image-20200516171513543.png)

### Ceph数据写入流程

![image-20200516172819013](assets/image-20200516172819013.png)

![image-20200516172933539](assets/image-20200516172933539.png)

![image-20200516173014459](assets/image-20200516173014459.png)

![image-20200516173308986](assets/image-20200516173308986.png)

![image-20200516173525975](assets/image-20200516173525975.png)

![image-20200516173606901](assets/image-20200516173606901.png)

![image-20200516173724918](assets/image-20200516173724918.png)

![image-20200516173857563](assets/image-20200516173857563.png)

![image-20200516173940977](assets/image-20200516173940977.png)

![image-20200516174153849](assets/image-20200516174153849.png)

![image-20200516174250549](assets/image-20200516174250549.png)

```
数据primary 选择存储到 ssd的磁盘上，其他的副本 选择默认的 default的存储树
```

![image-20200516174421692](assets/image-20200516174421692.png)

```
bucket 层级类型及关系
```

![image-20200516174752731](assets/image-20200516174752731.png)

```
default 只有 host类型的
```

![image-20200516174837516](assets/image-20200516174837516.png)

![image-20200516174919805](assets/image-20200516174919805.png)

![image-20200516175112093](assets/image-20200516175112093.png)

![image-20200516180745002](assets/image-20200516180745002.png)

```
root 包含 host
```

![image-20200517102317250](assets/image-20200517102317250.png)

![image-20200517102336664](assets/image-20200517102336664.png)

![image-20200517102403264](assets/image-20200517102403264.png)

![image-20200517102455882](assets/image-20200517102455882.png)

```
自定义的 idc01 的crush规则
```

![image-20200517102611292](assets/image-20200517102611292.png)

![image-20200517102703574](assets/image-20200517102703574.png)

![image-20200517102720146](assets/image-20200517102720146.png)

```
查看定义的两个 crush rule 规则
```

![image-20200517102746751](assets/image-20200517102746751.png)

```
查看 ceph 的pool
```

![image-20200517102939703](assets/image-20200517102939703.png)

![image-20200517103050006](assets/image-20200517103050006.png)

```
设置 ceph 的规则
```

![image-20200517103319946](assets/image-20200517103319946.png)

```
删除 bucket 使用 ceph osd crush remove rack01
```

![image-20200517110616491](assets/image-20200517110616491.png)

![image-20200517110639319](assets/image-20200517110639319.png)

![image-20200517110729463](assets/image-20200517110729463.png)

```
删除bucket
```

![image-20200517111038189](assets/image-20200517111038189.png)

```
移动 bucket 到其他的 bucket 下面
```

![image-20200517111515817](assets/image-20200517111515817.png)

![image-20200517111632366](assets/image-20200517111632366.png)

```
移动 osd.4 到ubuntu-ceph-06 下面
```

![image-20200517111739930](assets/image-20200517111739930.png)

![image-20200517111824036](assets/image-20200517111824036.png)

![image-20200517111840120](assets/image-20200517111840120.png)

### Ceph集群的监控

![image-20200517112017554](assets/image-20200517112017554.png)

![image-20200517112045988](assets/image-20200517112045988.png)

![image-20200517112242480](assets/image-20200517112242480.png)

```
正常的情况下 上面的两个的命令显示的内容是一样的，只有集群出现故障的时候，detail 才会出现更详细的信息
```

![image-20200517112419914](assets/image-20200517112419914.png)

```
222 pgs degraded: 222 个pgs 是降级了
221 pgs stuck unclean： 221 pgs stuck 卡住了，没有清理
recovery 37/258： 需要恢复258 个对象 恢复了 37个，恢复的比例
1/4 in osds are down: 4个 osd 中1个是down 的
```

![image-20200517112941975](assets/image-20200517112941975.png)

```
osd.0 is down since epoch 251: 在 版本号为251 的时候 osd.0 是down 的
```

### 监视集群的事件

![image-20200517113138757](assets/image-20200517113138757.png)

![image-20200517113711874](assets/image-20200517113711874.png)

 

![image-20200517123833266](assets/image-20200517123833266.png)

![image-20200517123846266](assets/image-20200517123846266.png)

```
%USED： 显示的是占用整个集群空间的百分比
```

![image-20200517124122791](assets/image-20200517124122791.png)

![image-20200517124155234](assets/image-20200517124155234.png)

```
cluster： 后面的为集群的唯一的表示id， fsid
monmap e3: e3为集群的版本号
	quorum 0 ubuntu-ceph-06 投票数为0的
osdmap e166: osd的版本号
pgmap v5936: pgmap 的版本号
```

### MON的功能

![image-20200517124814140](assets/image-20200517124814140.png)

```
MON 还可以对客户端进行权限的认证
```

**添加MON节点**

![image-20200517125120745](assets/image-20200517125120745.png)

![image-20200517125214123](assets/image-20200517125214123.png)

```
存在配置文件的话 使用--overwrite-conf 进行覆盖
```

![image-20200517125524383](assets/image-20200517125524383.png)

![image-20200517125555509](assets/image-20200517125555509.png)

```
这个id 为主机名
```

![image-20200517125633709](assets/image-20200517125633709.png)

```
停止了一个MON后，只剩一个的 法定票数
```

![image-20200517125804386](assets/image-20200517125804386.png)

```
这个报错 是 MON出现了问题
```

![image-20200517125841070](assets/image-20200517125841070.png)

```
MON 的Leader漂移到了其他的节点 
```

![image-20200517130639490](assets/image-20200517130639490.png)

![image-20200517130702737](assets/image-20200517130702737.png)

```
epoch 13: monmap 版本号
last_changed: 上次的版本号变更的时间
0： 1： 2： MON 的唯一标识
```

![image-20200517130850778](assets/image-20200517130850778.png)

### 监控OSD

![image-20200517130952162](assets/image-20200517130952162.png)

```
一个OSD相当于一个硬盘+osd的守护进程
```

![image-20200517131346830](assets/image-20200517131346830.png)

![image-20200517131704001](assets/image-20200517131704001.png)

![image-20200517131913359](assets/image-20200517131913359.png)

![image-20200517132246795](assets/image-20200517132246795.png)

```
reweight: 进行osd 的权重的 reweight，比如 整体集群的使用率为 80%，但是 osd.1的使用率已经达到了 90 %，可以%80/90% 来进行 osd.1 的权重的调整
```

![image-20200517133023742](assets/image-20200517133023742.png)

![image-20200517133051386](assets/image-20200517133051386.png)

![image-20200517133158986](assets/image-20200517133158986.png)

```
设置不想使 OSD 进程结束
```

![image-20200517133259044](assets/image-20200517133259044.png)

![image-20200517133320368](assets/image-20200517133320368.png)

```
unset 标志
```

![image-20200517133341766](assets/image-20200517133341766.png)

![image-20200517133436895](assets/image-20200517133436895.png)

```
集群中所有的pool的信息
```

![image-20200517133642190](assets/image-20200517133642190.png)

```
up_from: 启动osd的时候版本为 324
down_from： down 的时候版本为321
```

### 监控PG

![image-20200517134019384](assets/image-20200517134019384.png)

![image-20200517134517309](assets/image-20200517134517309.png)

```
pool 承载的 PG的数据
一个pool 的PG 是对应所有的 osd的

三台主机对应的PG数是 均匀分布的，都是464个PG
```

![image-20200517134941286](assets/image-20200517134941286.png)

### Ceph Debug

![image-20200517135528235](assets/image-20200517135528235.png)

![image-20200517135716491](assets/image-20200517135716491.png)

![image-20200517135912704](assets/image-20200517135912704.png)

![image-20200517135946859](assets/image-20200517135946859.png)

![image-20200517140020462](assets/image-20200517140020462.png)

```
使用 Django 开发
```

![image-20200517140056357](assets/image-20200517140056357.png)

![image-20200517140415769](assets/image-20200517140415769.png)

![image-20200517140454504](assets/image-20200517140454504.png)

![image-20200517140506000](assets/image-20200517140506000.png)

![image-20200517140638561](assets/image-20200517140638561.png)

![image-20200517140658634](assets/image-20200517140658634.png)

![image-20200517140720049](assets/image-20200517140720049.png)

![image-20200517140739892](assets/image-20200517140739892.png)

### Ceph内部原理以及Crush设计

![image-20200517141024298](assets/image-20200517141024298.png)

![image-20200517141146499](assets/image-20200517141146499.png)

```
描述数据的数据为 元数据
```

![image-20200517141732462](assets/image-20200517141732462.png)

![image-20200517141637177](assets/image-20200517141637177.png)

### Ceph的一致性hash

![image-20200517142035465](assets/image-20200517142035465.png)

![image-20200517170440166](assets/image-20200517170440166.png)

![image-20200517170751671](assets/image-20200517170751671.png)

```
普通的hash算法(Hash(x) % N) 解决不了，新节点加入和离开的数据重新分布迁移的问题, 因为N的变化，之前通过hash(x)计算得到的 数据存储位置，需要重新的计算

一致性hash： 虚拟了一个hash环，N0节点存储的数据分区在[N0, N1] 之间，当如果N0 节点down之后， 数据分布[N1, N2] 分区的数据不会发生改变，而 N2负责的数据 改变为[N2,N0], 发生分区的合并，避免过多的数据迁移

一致性hash的问题，节点的数据可能不太均匀
```

![image-20200517172650948](assets/image-20200517172650948.png)

![image-20200517173159739](assets/image-20200517173159739.png)

![image-20200517173600279](assets/image-20200517173600279.png)

**hash算法**

![image-20200517174032754](assets/image-20200517174032754.png)

![image-20200517174158621](assets/image-20200517174158621.png)

**一致性hash**

![image-20200517174650408](assets/image-20200517174650408.png)

```
虚拟出来了个hash环， 首先将节点 通过hash计算 映射到 hash环上
存储数据的时候，使用相同的hash算法，进行计算出 数据在 hash环上的位置，然后再顺时针查找到的第一个节点就是 这个文件存储的节点，
当添加新的节点D的时候，C->D 之间的数据原本存储在A机器，现在 的计算结果应该存储在D上，由此导致缓存失效，而D->C 这部分区域的数据存储是可以正确的找到相应的存储位置的
```

**一致性hash的 hash倾斜问题**

![image-20200517175243410](assets/image-20200517175243410.png)

```
解决hash倾斜的问题，通过添加更多的节点就可以是 数据尽可能的分布；
解决的办法就是 每一个物理节点，虚拟出一批的虚拟节点，把这些虚拟节点也映射到 hash环上，从而使节点的数量增加；
数据的存储的过程，映射到虚拟节点的数据，存储到相应的物理节点上
```

### CRUSH算法

![image-20200517180023369](assets/image-20200517180023369.png)

```
PG 可以看做是 一致性hash的虚拟节点的功能，但是这个 虚拟节点是固定不变的，避免数据分布不均的问题
```

![image-20200517180754255](assets/image-20200517180754255.png)

![image-20200517181428821](assets/image-20200517181428821.png)

![image-20200517181616517](assets/image-20200517181616517.png)

```
磁盘的容量不同，则映射到 PG的权重相应的也不一样
```

![image-20200517181803701](assets/image-20200517181803701.png)

### PG(Placement Groups)

![image-20200517182022812](assets/image-20200517182022812.png)

![image-20200517182131075](assets/image-20200517182131075.png)

![image-20200517182255564](assets/image-20200517182255564.png)

![image-20200517182411175](assets/image-20200517182411175.png)

![image-20200517182421730](assets/image-20200517182421730.png)

![image-20200517182446628](assets/image-20200517182446628.png)

```
cp 是osd pool的名字
```

**PG和PGP的区别**

- PG是指定存储池存储对象的目录有多少个，PGP是存储池PG的OSD分布组合个数

- PG的增加会引起PG内的数据进行分裂，分裂到相同的OSD上新生成的PG当中

- PGP的增加会引起部分PG的分布进行变化，但是不会引起PG内对象的变动

  参考博文：https://www.cnblogs.com/wangmo/p/11393544.html

  

![image-20200517182538116](assets/image-20200517182538116.png)

```
PG 在 同 pool下只增不减，目的是 避免PG的减少，数据乱掉，映射规则变化
```

![image-20200517182827580](assets/image-20200517182827580.png)

```
[1,2,0] 是osd的活跃组
```

![image-20200517183050752](assets/image-20200517183050752.png)

![image-20200517183850464](assets/image-20200517183850464.png)

```
cp  是 osd pool
```

![image-20200517184115944](assets/image-20200517184115944.png)

![image-20200517184357273](assets/image-20200517184357273.png)

![image-20200517184421032](assets/image-20200517184421032.png)

![image-20200517184552426](assets/image-20200517184552426.png)

### filejournal的意义

![image-20200517184810582](assets/image-20200517184810582.png)

### Ceph与OpenStack的基础

![image-20200517185006009](assets/image-20200517185006009.png)

![image-20200517185044195](assets/image-20200517185044195.png)

![image-20200517185141994](assets/image-20200517185141994.png)

![image-20200517185255095](assets/image-20200517185255095.png)

![image-20200517185436994](assets/image-20200517185436994.png)

**setting.conf 文件配置**

![image-20200517185725291](assets/image-20200517185725291.png)

![image-20200517185825859](assets/image-20200517185825859.png)

```
走的ceph 的网络，方便与侧胖进行集成
```

![image-20200517185851652](assets/image-20200517185851652.png)

```
走的外网，连接互联网
```

![image-20200517190028407](assets/image-20200517190028407.png)

![image-20200517190107788](assets/image-20200517190107788.png)

![image-20200517190126848](assets/image-20200517190126848.png)

![image-20200517190300870](assets/image-20200517190300870.png)

![image-20200517190341880](assets/image-20200517190341880.png)

![image-20200517190539191](assets/image-20200517190539191.png)

![image-20200517190732110](assets/image-20200517190732110.png)

![image-20200517190902313](assets/image-20200517190902313.png)

### 命令行创建虚拟机实例

![image-20200517191114857](assets/image-20200517191114857.png)

![image-20200517191414313](assets/image-20200517191414313.png)

![image-20200517191510994](assets/image-20200517191510994.png)

```
虚拟机的规格
使用 --flavor 1 指定虚拟机的规格的编号
```

### Ceph与OpenStack的集成

![image-20200517191930152](assets/image-20200517191930152.png)

![image-20200517191948633](assets/image-20200517191948633.png)

![image-20200517192246175](assets/image-20200517192246175.png)

```
512 是设定的 PG数量
```

![image-20200517192928948](assets/image-20200517192928948.png)

![image-20200517193329169](assets/image-20200517193329169.png)

![image-20200517193426350](assets/image-20200517193426350.png)

![image-20200517193601494](assets/image-20200517193601494.png)

![image-20200517193743982](assets/image-20200517193743982.png)

```
cinder 快存储
```

![image-20200517194014529](assets/image-20200517194014529.png)

![image-20200517194037372](assets/image-20200517194037372.png)

![image-20200517194214489](assets/image-20200517194214489.png)

### Ceph性能的优化

#### 硬件选型优化

![image-20200517195001541](assets/image-20200517195001541.png)

![image-20200517204322076](assets/image-20200517204322076.png)

```
IDRAC/ILO 远程隔离卡
```

![image-20200517204659045](assets/image-20200517204659045.png)

```
新的存储架构 IB
传统的架构所有的IO 都是通过 PCI 总线进行的
```

![image-20200517205153980](assets/image-20200517205153980.png)

```
减少数据在 用户空间和内核空间的来回拷贝，节省CPU的性能
```

![image-20200517205516832](assets/image-20200517205516832.png)

```
这个库 主要来实现 对底层的 RDMA的功能
```

![image-20200517210813420](assets/image-20200517210813420.png)

![image-20200517210848460](assets/image-20200517210848460.png)

![image-20200517210945758](assets/image-20200517210945758.png)

![image-20200517211021179](assets/image-20200517211021179.png)

#### 系统优化

![image-20200517211221794](assets/image-20200517211221794.png)

![image-20200517211417750](assets/image-20200517211417750.png)

```
lscpu 查看NUMA
```

![image-20200517211502488](assets/image-20200517211502488.png)

```
两个node  都有自己的内存区域， 16核心的CPU 访问不同的 node 区域内存
cpu 跨区访问内存会影响性能
```

![image-20200517211729584](assets/image-20200517211729584.png)

```
关闭的 NUMA ，CPU访问都在一个node上
```

![image-20200517211840988](assets/image-20200517211840988.png)

![image-20200517211900313](assets/image-20200517211900313.png)

```
引导系统的 grub.cfg 的引导参数配置中，设定 numa=off 进行关闭
```

![image-20200517212027728](assets/image-20200517212027728.png)

```
把 进程 绑定到 某个CPU运行
```

![image-20200517212333921](assets/image-20200517212333921.png)

![image-20200517212719800](assets/image-20200517212719800.png)

```
virtio scsi：虚拟磁盘的多队列支持
```

![image-20200517213037078](assets/image-20200517213037078.png)

#### Ceph的参数的优化

![image-20200517213247310](assets/image-20200517213247310.png)

![image-20200517213621919](assets/image-20200517213621919.png)

![image-20200517213849577](assets/image-20200517213849577.png)

```
使用 ceph daemon osd.0 config show 查看ceph系统的配置参数
```

![image-20200517214049263](assets/image-20200517214049263.png)

![image-20200517214402613](assets/image-20200517214402613.png)

![image-20200517214601462](assets/image-20200517214601462.png)

![image-20200517214711765](assets/image-20200517214711765.png)

![image-20200517214758431](assets/image-20200517214758431.png)

```
RAID 0 是典型的条带（stripe）设计
```

![image-20200517215136093](assets/image-20200517215136093.png)

![image-20200517215251095](assets/image-20200517215251095.png)

![image-20200517215410021](assets/image-20200517215410021.png)

```
HDD+Flashcache： 通过 Flashcache 把SSD的硬盘指定给HDD，作为其缓存
RBD+Flashcache: 通过 Flashcache 把SSD的硬盘指定给RBD，作为其缓存
SSD+Journal: ceph的日志使用 SSD存储
HDD+SSD: 可以通过 crushmap 设置策略进行混合使用

```

![image-20200517215718995](assets/image-20200517215718995.png)

```
通过设置 Primary-Affinity 来设置SSD成为PG的 primary
```

![image-20200517215954418](assets/image-20200517215954418.png)

![image-20200517220212925](assets/image-20200517220212925.png)

### 性能测试

![image-20200517220422317](assets/image-20200517220422317.png)

```
-b: 指定 块的大小， 不指定的话 默认每个块为4M
60 为测试时间 60s
-t 32: 并发线程数 32
--no-cleanup：写的测试数据是否会被清除
```

![image-20200517220830771](assets/image-20200517220830771.png)

```
对ceph集群做写入的测试
```

![image-20200517220941402](assets/image-20200517220941402.png)

![image-20200517221058968](assets/image-20200517221058968.png)

```
查看写入的数据
```

![image-20200517221212656](assets/image-20200517221212656.png)

![image-20200517221226505](assets/image-20200517221226505.png)

```
seq: 进行数据的顺序读取的测试
```

![image-20200517221258446](assets/image-20200517221258446.png)

![image-20200517221333961](assets/image-20200517221333961.png)

```
rand： 进行数据的随机的读的测试
```

![image-20200517221454593](assets/image-20200517221454593.png)

![image-20200517221554680](assets/image-20200517221554680.png)

```
删除测试的数据，指定前缀的信息
```

![image-20200517221838977](assets/image-20200517221838977.png)

![image-20200517223745432](assets/image-20200517223745432.png)