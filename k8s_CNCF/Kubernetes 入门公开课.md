## Kubernetes 入门公开课

### 第一堂云原生课

![image-20200520191256358](assets/image-20200520191256358.png)

![image-20200520191358716](assets/image-20200520191358716.png)

![image-20200520191450032](assets/image-20200520191450032.png)

![image-20200520191459929](assets/image-20200520191459929.png)

![image-20200520191713283](assets/image-20200520191713283.png)

![image-20200520191724964](assets/image-20200520191724964.png)

![image-20200520191903450](assets/image-20200520191903450.png)

![image-20200520191950246](assets/image-20200520191950246.png)

![image-20200520192118500](assets/image-20200520192118500.png)

![image-20200520192233110](assets/image-20200520192233110.png)

![image-20200520192342027](assets/image-20200520192342027.png)

![image-20200520192616871](assets/image-20200520192616871.png)

![image-20200520192702446](assets/image-20200520192702446.png)

### 容器的基本概念

![image-20200520192840055](assets/image-20200520192840055.png)

![image-20200520192925454](assets/image-20200520192925454.png)

![image-20200520193155732](assets/image-20200520193155732.png)

![image-20200520193310822](assets/image-20200520193310822.png)

![image-20200520193539870](assets/image-20200520193539870.png)

![image-20200520193743834](assets/image-20200520193743834.png)

![image-20200520194010263](assets/image-20200520194010263.png)

![image-20200520194058223](assets/image-20200520194058223.png)

![image-20200520194237359](assets/image-20200520194237359.png)

![image-20200520194545935](assets/image-20200520194545935.png)

```
containerd： 容器的运行时管理引擎，独立于moby daemon，提供容器及镜像的相关管理
containerd-shim: 这个模块也是一个守护进程，他会去管理容器的生命周期，提供了插件化的管理机制，接入其他的容器运行时；这种插件化是可以被containerd动态接管的，如果对 moby或containerd进行升级，可以在不影响现有运行的容器的情况下进行
```

![image-20200520195358346](assets/image-20200520195358346.png)

![image-20200520195552144](assets/image-20200520195552144.png)

### Kubernets核心概念与API原语

![image-20200520195758773](assets/image-20200520195758773.png)

![image-20200520195848505](assets/image-20200520195848505.png)

![image-20200520195938524](assets/image-20200520195938524.png)

![image-20200520200012200](assets/image-20200520200012200.png)

```
kubernets 可以把用户提交的容器放到 kubernets 管理集群的某一台主机上，k8s 的调度器是执行这项能力的组件，会根据 所调度的容器的大小规格 调度到合适的机器上，进行一次 placement （放置的操作）
```

![image-20200520200247827](assets/image-20200520200247827.png)

![image-20200520200312769](assets/image-20200520200312769.png)

```
黄颜色的容器 检测到过于繁忙，就可以进行扩展到 三台的节点上，把负载流量打到三个节点上
```

![image-20200520200415085](assets/image-20200520200415085.png)

![image-20200520200440272](assets/image-20200520200440272.png)

```
API server： 进行API操作的，k8s 的所有组件都会和API进行操作
Controller: 控制器用来对集群的状态的管理，比如容器的自动修复，自动的水平扩容就是 controller能力
Scheduler: 把用户提交的container 根据资源需求，找一台合适的节点进行 放置
etcd： 分布式的存储系统，API server 所需的元数据的信息都放置在etcd 中

API server：在部署结构上是一个可以水平扩展的组件
Controller： 可以进行热备的部署组件，只有一个active
Scheduler：可以进行热备部署，只有一个active
```

![image-20200520200928778](assets/image-20200520200928778.png)

```
kubelet: 接收APIserver 关于pod的运行状态，提交到container runtime的组件中，在OS进行pod的创建
kubernets 并不会直接对网络进行操作，会通过 Storage Plugin 和Network Plugin对网络进行操作
kube-proxy: 真正的完成service组网的组件，利用iptables、ipvs的能力
kubelet 不会直接和user进行交互，而是通过master进行操作
```

![image-20200520204126578](assets/image-20200520204126578.png)

```
1. 用户通过UI或CLI提交一个pod给kubernets进行部署
2. pod的请求会首先通过UI或CLI提交给APIserver，API server会把这个信息写入到etcd
3. 之后，Scheduler会通过 watch或notify机制得到这个信息有一个pod需要被调度
4. Scheduler 会根据一系列的调度选择算法进行一次的调度决策
5. 之后会告诉api server 它会被调度到哪个节点， api server将调度的 决策结果写入到etcd中
6. kubelet watch 到API server 有本节点的pod的创建，拉取信息进行创建
```

![image-20200520211204019](assets/image-20200520211204019.png)

![image-20200520211406962](assets/image-20200520211406962.png)

![image-20200520211504770](assets/image-20200520211504770.png)

![image-20200520211555276](assets/image-20200520211555276.png)

![image-20200520211834104](assets/image-20200520211834104.png)

![image-20200520211930960](assets/image-20200520211930960.png)

![image-20200520213210008](assets/image-20200520213210008.png)

![image-20200520213336756](assets/image-20200520213336756.png)

![image-20200520213437284](assets/image-20200520213437284.png)

### 理解pod与容器设计模式

![image-20200520213835208](assets/image-20200520213835208.png)

![image-20200520213939493](assets/image-20200520213939493.png)

![image-20200520214116584](assets/image-20200520214116584.png)

![image-20200520214203200](assets/image-20200520214203200.png)

![image-20200520214317489](assets/image-20200520214317489.png)

![image-20200520214519357](assets/image-20200520214519357.png)

![image-20200520214634600](assets/image-20200520214634600.png)

![image-20200520214842308](assets/image-20200520214842308.png)

![image-20200520215056530](assets/image-20200520215056530.png)

![image-20200520215230847](assets/image-20200520215230847.png)

![image-20200520215359252](assets/image-20200520215359252.png)

![image-20200520215554069](assets/image-20200520215554069.png)

![image-20200520221243344](assets/image-20200520221243344.png)

![image-20200520221521107](assets/image-20200520221521107.png)

![image-20200520232711364](assets/image-20200520232711364.png)

![image-20200520232845322](assets/image-20200520232845322.png)

![image-20200520232931383](assets/image-20200520232931383.png)

![image-20200520233100170](assets/image-20200520233100170.png)

```
Monitoring Adapter： 将 /metrics 的容器的接口，转换为 /healthz 接口
```

![image-20200520233356723](assets/image-20200520233356723.png)

### 应用编排与管理核心原理

![image-20200520233454298](assets/image-20200520233454298.png)

![image-20200520233524600](assets/image-20200520233524600.png)

```
Labels: 资源的标签
Annotations: 用来描述资源的注解
OwnerRefernce: 描述多个资源之间相互关系的
```

![image-20200520233833572](assets/image-20200520233833572.png)

```
标签可以添加域名，用来标识打标签的组织
```

![image-20200520234005344](assets/image-20200520234005344.png)

![image-20200520234042221](assets/image-20200520234042221.png)

```
逻辑与
```

![image-20200520234114392](assets/image-20200520234114392.png)

![image-20200520234154711](assets/image-20200520234154711.png)

![image-20200520234421973](assets/image-20200520234421973.png)

```
replicaset 和pod 存在级联关系
```

![image-20200520235036799](assets/image-20200520235036799.png)

![image-20200520235134648](assets/image-20200520235134648.png)

![image-20200520235111095](assets/image-20200520235111095.png)

![image-20200520235253393](assets/image-20200520235253393.png)

```
replicaset 的 资源
```

![image-20200520235412446](assets/image-20200520235412446.png)

```
可以看到 pod 的引用 为 replicaset
```

![image-20200520235503049](assets/image-20200520235503049.png)

![image-20200520235547367](assets/image-20200520235547367.png)

![image-20200520235716694](assets/image-20200520235716694.png)

![image-20200520235754758](assets/image-20200520235754758.png)

![image-20200520235905774](assets/image-20200520235905774.png)

![image-20200520235946933](assets/image-20200520235946933.png)

![image-20200521000056996](assets/image-20200521000056996.png)

![image-20200521000245294](assets/image-20200521000245294.png)

### 应用编排和管理 - Deployment

![image-20200521214153433](assets/image-20200521214153433.png)

![image-20200521214224074](assets/image-20200521214224074.png)

![image-20200521214358792](assets/image-20200521214358792.png)

![image-20200521214526548](assets/image-20200521214526548.png)

![image-20200521214752863](assets/image-20200521214752863.png)

![image-20200521214847886](assets/image-20200521214847886.png)

![image-20200521214933917](assets/image-20200521214933917.png)

![image-20200521215043187](assets/image-20200521215043187.png)

![image-20200521215124193](assets/image-20200521215124193.png)

![image-20200521215246465](assets/image-20200521215246465.png)

![image-20200521215716164](assets/image-20200521215716164.png)

![image-20200521215902224](assets/image-20200521215902224.png)

![image-20200521220122260](assets/image-20200521220122260.png)

![image-20200521220254788](assets/image-20200521220254788.png)

![image-20200521221554728](assets/image-20200521221554728.png)

![image-20200521221650976](assets/image-20200521221650976.png)

![image-20200521221916561](assets/image-20200521221916561.png)

![image-20200521222031594](assets/image-20200521222031594.png)

### 应用编排和管理 - Job和DaemonSet

![image-20200521222243086](assets/image-20200521222243086.png)

![image-20200521222321345](assets/image-20200521222321345.png)

![image-20200521222512792](assets/image-20200521222512792.png)

![image-20200521222554044](assets/image-20200521222554044.png)

![image-20200521222644091](assets/image-20200521222644091.png)

![image-20200521222808013](assets/image-20200521222808013.png)

![image-20200521222916104](assets/image-20200521222916104.png)

```
执行8次，每次两个pod，四个批次
```

![image-20200521223114130](assets/image-20200521223114130.png)

![image-20200521223315723](assets/image-20200521223315723.png)

![image-20200521223727286](assets/image-20200521223727286.png)

![image-20200521223914782](assets/image-20200521223914782.png)

![image-20200521224008002](assets/image-20200521224008002.png)

![image-20200521224102223](assets/image-20200521224102223.png)

![image-20200521224228825](assets/image-20200521224228825.png)

![image-20200521224338704](assets/image-20200521224338704.png)

![image-20200521224514072](assets/image-20200521224514072.png)

![image-20200521224727072](assets/image-20200521224727072.png)

![image-20200521224827498](assets/image-20200521224827498.png)

### 应用配置管理

![image-20200521224929570](assets/image-20200521224929570.png)

![image-20200521225029380](assets/image-20200521225029380.png)

![image-20200521225219458](assets/image-20200521225219458.png)

![image-20200521225309556](assets/image-20200521225309556.png)

![image-20200521225736562](assets/image-20200521225736562.png)

![image-20200521225959747](assets/image-20200521225959747.png)

![image-20200521230246971](assets/image-20200521230246971.png)

![image-20200521230553926](assets/image-20200521230553926.png)

![image-20200521230802154](assets/image-20200521230802154.png)

![image-20200521231123007](assets/image-20200521231123007.png)

![image-20200521231347617](assets/image-20200521231347617.png)

![image-20200521231518962](assets/image-20200521231518962.png)

![image-20200521231708978](assets/image-20200521231708978.png)

![image-20200521232035644](assets/image-20200521232035644.png)

![image-20200521232205606](assets/image-20200521232205606.png)

![image-20200521232404345](assets/image-20200521232404345.png)

![image-20200521232815492](assets/image-20200521232815492.png)

![image-20200521233038595](assets/image-20200521233038595.png)

### 应用存储和持久化数据卷 - 核心知识

![image-20200521233340430](assets/image-20200521233340430.png)

![image-20200521235231185](assets/image-20200521235231185.png)

![image-20200521235511936](assets/image-20200521235511936.png)

![image-20200521235649663](assets/image-20200521235649663.png)

![image-20200521235821469](assets/image-20200521235821469.png)

![image-20200522000048590](assets/image-20200522000048590.png)

![image-20200522000245398](assets/image-20200522000245398.png)

![image-20200522000414857](assets/image-20200522000414857.png)

![image-20200522000557626](assets/image-20200522000557626.png)

```
用户创建PVC的时候，需求的 存储大小和访问控制模式，和预先创建好的 PV的大小和访问的模式相同，则k8s 就会把它们 bound到一起
```

![image-20200522000836884](assets/image-20200522000836884.png)

![image-20200522000946886](assets/image-20200522000946886.png)

![image-20200522001401710](assets/image-20200522001401710.png)

![image-20200522001622909](assets/image-20200522001622909.png)

![image-20200522001728309](assets/image-20200522001728309.png)

![image-20200522001807926](assets/image-20200522001807926.png)

```
阿里云的 csi 的存储的插件
```

![image-20200522001916410](assets/image-20200522001916410.png)

![image-20200522002100645](assets/image-20200522002100645.png)

![image-20200522002652043](assets/image-20200522002652043.png)

![image-20200522002901581](assets/image-20200522002901581.png)

### 应用存储和持久化数据卷 - 存储快照与拓扑调度

![image-20200522074018763](assets/image-20200522074018763.png)

![image-20200522074114732](assets/image-20200522074114732.png)

![image-20200522074236372](assets/image-20200522074236372.png)

![image-20200522074435796](assets/image-20200522074435796.png)

![image-20200522074726417](assets/image-20200522074726417.png)

![image-20200522074909055](assets/image-20200522074909055.png)

![image-20200522075140249](assets/image-20200522075140249.png)

![image-20200522215629146](assets/image-20200522215629146.png)

![image-20200522220023651](assets/image-20200522220023651.png)

```
通过模板 VolumeSnapshotClass 进行定义Volume Plugin
VolumeSnapshot 执行 VSC 类型，以及快照来源的PVC

使用的PVC定义的时候，指定DataSource 为定义的disk-snapshots
```

![image-20200522220642709](assets/image-20200522220642709.png)

```
PVC 和 PV 的延时绑定
```

![image-20200522221517718](assets/image-20200522221517718.png)

![image-20200522221729678](assets/image-20200522221729678.png)

![image-20200522223253824](assets/image-20200522223253824.png)

![image-20200522223408470](assets/image-20200522223408470.png)

![image-20200522223504618](assets/image-20200522223504618.png)

```
pod 没有创建的话，则PVC一直处于pending的状态
```

![image-20200522223920982](assets/image-20200522223920982.png)

![image-20200522224324124](assets/image-20200522224324124.png)

### 可观测性 - 你的应用健康吗？

![image-20200522224659120](assets/image-20200522224659120.png)

![image-20200522224740925](assets/image-20200522224740925.png)

![image-20200522224832425](assets/image-20200522224832425.png)

![image-20200522224957433](assets/image-20200522224957433.png)

![image-20200522225147185](assets/image-20200522225147185.png)

![image-20200522225636051](assets/image-20200522225636051.png)

![image-20200522225830450](assets/image-20200522225830450.png)

![image-20200522230335151](assets/image-20200522230335151.png)

![image-20200522230623856](assets/image-20200522230623856.png)

![image-20200522230805769](assets/image-20200522230805769.png)

![image-20200522231049506](assets/image-20200522231049506.png)

![image-20200522231302716](assets/image-20200522231302716.png)

### 可观测性 - 监控与日志

![image-20200522231431826](assets/image-20200522231431826.png)

![image-20200522231544302](assets/image-20200522231544302.png)

![image-20200522231725800](assets/image-20200522231725800.png)

![image-20200522231908740](assets/image-20200522231908740.png)

![image-20200522232203573](assets/image-20200522232203573.png)

![image-20200522232336370](assets/image-20200522232336370.png)

![image-20200522232620889](assets/image-20200522232620889.png)

![image-20200522232650772](assets/image-20200522232650772.png)

![image-20200522232737323](assets/image-20200522232737323.png)

![image-20200522232905684](assets/image-20200522232905684.png)

![image-20200522233000857](assets/image-20200522233000857.png)

![image-20200522233040806](assets/image-20200522233040806.png)

![image-20200522233404497](assets/image-20200522233404497.png)

### kubernets网络概念及策略控制

![image-20200522233637124](assets/image-20200522233637124.png)

![image-20200522233901516](assets/image-20200522233901516.png)

![image-20200522234051748](assets/image-20200522234051748.png)

![image-20200522234249820](assets/image-20200522234249820.png)

![image-20200522234443557](assets/image-20200522234443557.png)

![image-20200522234624735](assets/image-20200522234624735.png)

![image-20200522234759089](assets/image-20200522234759089.png)

![image-20200522235115735](assets/image-20200522235115735.png)

![image-20200522235310437](assets/image-20200522235310437.png)

![image-20200522235346888](assets/image-20200522235346888.png)

### Kubernets Service

![image-20200522235512914](assets/image-20200522235512914.png)

![image-20200522235535192](assets/image-20200522235535192.png)

![image-20200522235718221](assets/image-20200522235718221.png)

![image-20200522235811162](assets/image-20200522235811162.png)

![image-20200522235918105](assets/image-20200522235918105.png)

![image-20200523000036751](assets/image-20200523000036751.png)

![image-20200523000317135](assets/image-20200523000317135.png)

![image-20200523000455965](assets/image-20200523000455965.png)

![image-20200523000628322](assets/image-20200523000628322.png)

![image-20200523001320322](assets/image-20200523001320322.png)

![image-20200523001505861](assets/image-20200523001505861.png)

### 深入剖析Linux容器

![image-20200523135200799](assets/image-20200523135200799.png)

![image-20200523135244566](assets/image-20200523135244566.png)

![image-20200523135314687](assets/image-20200523135314687.png)

```
有七种的 namespace，docker 容器实现的是 1-6中，第七种在 docker的 runc中实现
1. mount： 实现的是容器的文件视图是容器镜像提供的文件系统，和操作系统隔离
2. uts：隔离hostname和domain name 
3. pid：保证容器的init 进程是 1号进程启动的
4. network：除了容器使用 host网络之外，其他的网络模式都有自己的network namespace的文件
5. user: 这个namespace是控制用户的uid个gid容器内部和宿主机映射
6. ipc: 这个namespace是控制进程间通信东西，比如信号量
7. cgroup: 右边的两张图是开启和关闭 cgroup namespace，开启之后容器内部看到的namespace视图是以根的形式呈现的，和宿主机看到的namespace看到的视图方式是一样的，让容器内部使用cgroup更加安全
```

![image-20200523140408783](assets/image-20200523140408783.png)

```
容器内部的 namespace 都是使用unshare的系统调用创建的

下图创建的是一个pid的namespace，可以看到bash 的pid为 1
```

![image-20200523140629748](assets/image-20200523140629748.png)

```
device 和freezer这两个都是为了安全的
device控制你在容器中可以看到的设备
freezer：停止容器的时候使用，停止容器的时候，会把当前容器的所有的进程写入cgroup 把所有进程都（冻结掉 freezer）， 放置在停止的时候存在进程做 fork 逃逸到宿主机上device 和freezer这两个都是为了安全的
device控制你在容器中可以看到的设备
freezer：停止容器的时候使用，停止容器的时候，会把当前容器的所有的进程写入cgroup 把所有进程都（冻结掉 freezer）， 放置在停止的时候存在进程做 fork 逃逸到宿主机上

blkio: 用于限制容器使用到的磁盘iops和bps的速率限制
pid：限制的是容器里面使用的最大的进程数量

右边的docker中不常使用的cgroup，对于runc来说，所有的cgroup（除了rdma），在runc都是支持的，docker并没有开启这部分的支持
```

![image-20200523141439623](assets/image-20200523141439623.png)

![image-20200523141708305](assets/image-20200523141708305.png)

![image-20200523142000260](assets/image-20200523142000260.png)

![image-20200523142043438](assets/image-20200523142043438.png)

![image-20200523143451703](assets/image-20200523143451703.png)

![image-20200523143713007](assets/image-20200523143713007.png)

```
容器 start 是需要创建相应的namespace的，而exec则只是加入到已有的namespace中去
```

### 深入理解etcd - 基本原理解析

![image-20200523144018991](assets/image-20200523144018991.png)

![image-20200523174804628](assets/image-20200523174804628.png)

![image-20200523175033847](assets/image-20200523175033847.png)

![image-20200523175128563](assets/image-20200523175128563.png)

![image-20200523175143388](assets/image-20200523175143388.png)

```
Transactions： etcd 提供的事务操作
```

![image-20200523175340853](assets/image-20200523175340853.png)

```
term: 整个集群的leader 的任期，leader切换的时候对应的term值都会加一
revison：全局的数据的版本，当数据发生变更，创建删除修改的时候revison的版本都会加一，revison的存在使得etcd可以支持MVCC和数据的watch

KeyValue: 对于每一个keyvalue etcd记录了三个的版本的信息
	create_revison: 当前的kv在创建的时候，操作对应的版本号
	mod_revison: 数据被修改的时候其操作对应的版本号
	verson: 计数器，记录该kv被修改了多少次
```

![image-20200523175938178](assets/image-20200523175938178.png)

![image-20200523180231635](assets/image-20200523180231635.png)

```
etcd 中所有的数据存储在B+tree 中，这个B+tree 保存在磁盘中，并通过map的方式映射到内存来加速查询操作

灰色的B+tree 存储着revison到value的映射关系
蓝色的B+tree 管理者 key到revison的映射关系
查询数据的时候，通过蓝色的B+tree 把key翻译成revisons，在通过灰色的B+tree 通过revison获取对应的value
```

![image-20200523180917312](assets/image-20200523180917312.png)

```
etcd的事务机制
if的条件满足则，执行then，否则执行 else
k9s API server就是通过 etcd的事务性来实现多个api server的操作数据的一致性
```

![image-20200523181101575](assets/image-20200523181101575.png)

```
lease（租赁） 是分布式系统中的一个常见的概念，用来代表一个租约，在分布式系统中检测一个节点是否存活的时候需要这个租约的机制。

上图中首先创建了一个 10s的租约，如果创建这个租约什么也不做，则10s后这个租约就会过期。
接着讲key1和key2 绑定到了这个租约之上，当这个租约过期的时候，etcd就会自动的气力到key1和key2的值。

如果我们希望这个租约永不过期，需要检测分布式系统中一个进程是否存活，在这个分布式系统中访问etcd创建一个租约，同时在这个进程中调用keepalive的方法，去etcd保持这个租约不断的续约的过程，事项如果这个进程挂掉之后，就不会到etcd进行续约，租约到期会就会被etcd清理掉，一次来判定节点是否存活

etcd 允许将多个的key关联到一个 lease上，这个设计很巧妙，将多个key保存在lease上，可以减少lease对象的刷新时间，减少大量key去刷新租约带来的性能问题，提升etcd的性能
```

![image-20200523182303246](assets/image-20200523182303246.png)

![image-20200523182334479](assets/image-20200523182334479.png)

![image-20200523182402009](assets/image-20200523182402009.png)

```
安装范围查询
```

![image-20200523182420677](assets/image-20200523182420677.png)

```
前缀查询
```

![image-20200523182516770](assets/image-20200523182516770.png)

```
header 消息头是全局的信息
```

![image-20200523182641650](assets/image-20200523182641650.png)

```
新增一条数据发现当前的 全局的revison 为13，版本增加了 1，raft_term 值不变
```

![image-20200523182832608](assets/image-20200523182832608.png)

```
对key5的值进行了修改，则mod_revison 会更改为，当前系统的全局的版本号
做了一次的修改，则version的版本增加了1
```

![image-20200523183020277](assets/image-20200523183020277.png)

```
再次修改 key5，全局的revison改变为了 15，也是key5的 mod_revison的版本
version做了第三次的修改，version为3
```

![image-20200523183200954](assets/image-20200523183200954.png)

```
删除key5的时候，全局的revison变为了17
```

![image-20200523183246255](assets/image-20200523183246255.png)

```
重新创建key5之后，create_revison和mod_revison都是从17开始的
```

![image-20200523183428379](assets/image-20200523183428379.png)

```
停止etcd再尝试启动etcd，集群raft_term值已经从2 到3了
```

![image-20200523183649960](assets/image-20200523183649960.png)

![image-20200523184030723](assets/image-20200523184030723.png)

![image-20200523184122931](assets/image-20200523184122931.png)

```
kubernets 通过etcd存储了大量的状态数据，通过etcd进行状态的流转，大大的降低了系统设计的复杂性
```

![image-20200523184341495](assets/image-20200523184341495.png)

![image-20200523184824307](assets/image-20200523184824307.png)

```
避免 master节点的单点，使用etcd进行master故障后的master的选主工作
```

![image-20200523185111868](assets/image-20200523185111868.png)

```
可以防止进程的并发执行，可以依次的调度进程的执行，
当进程执行到一半死掉之后，可以提出故障节点，分发未执行完成的任务到存活的节点上
```

![image-20200523185259463](assets/image-20200523185259463.png)

### 深入理解etcd - etcd的性能优化实践

![image-20200523185432075](assets/image-20200523185432075.png)

![image-20200523185537779](assets/image-20200523185537779.png)

![image-20200523185639686](assets/image-20200523185639686.png)

```
蓝色的为raft层
红色的为storage层：
	treeIndex层： 索引层
	boltdb：底层持久化存储kv层
```

![image-20200523185929084](assets/image-20200523185929084.png)

![image-20200523190043051](assets/image-20200523190043051.png)

![image-20200523190252980](assets/image-20200523190252980.png)

```
红色的为已经使用的，白色的已经不使用，可以进行回收的存储位置，之前在需要存储连续页面为三的存储位置的时候，需要，从头开始进行扫描，当key数量比较大的情况下，性能会急剧的下降。

优化的算法是：建立一个freemap的hashmap，记录连续存储的位置的信息，需要三个的存储的位置的时候，就通过查找hashmap，直接O(1)的复杂度，到具体的位置进行存储
```

![image-20200523190728335](assets/image-20200523190728335.png)

![image-20200523190913917](assets/image-20200523190913917.png)

![image-20200523190945765](assets/image-20200523190945765.png)

### Kubernets 的调度和资源管理

![image-20200523191100527](assets/image-20200523191100527.png)

![image-20200523195021931](assets/image-20200523195021931.png)

![image-20200523195119582](assets/image-20200523195119582.png)

```
requests: 是资源保底的需求
limits：是资源的限制

ephemeral-storage：短暂的，临时存储
CPU: 可以小数 如：0.25（250m）

extended-resource: 扩展资源必须是整数，比如GPU只可以是1个或2个等
```

![image-20200523195638290](assets/image-20200523195638290.png)

![image-20200523195937429](assets/image-20200523195937429.png)

![image-20200523195959121](assets/image-20200523195959121.png)

![image-20200523200027666](assets/image-20200523200027666.png)

![image-20200523203440760](assets/image-20200523203440760.png)

```
非整数的request cpu：会共享cpu2 到 cpu7 的CPU的使用

OOM的得分越高的话，在发生OOM的情况下会优先被 eviction（驱逐）
```

![image-20200523204024360](assets/image-20200523204024360.png)

```
当资源使用超出之后，在提交创建pod的请求的时候，会受到一个403的foridden的错误
```

![image-20200523205427085](assets/image-20200523205427085.png)

![image-20200523205517297](assets/image-20200523205517297.png)

```
必须调度到 k1=v1 标签的节点上
```

![image-20200523205728422](assets/image-20200523205728422.png)

![image-20200523205821853](assets/image-20200523205821853.png)

![image-20200523205959431](assets/image-20200523205959431.png)

![image-20200523210056568](assets/image-20200523210056568.png)

```
Gt/Lt: 数值比较的玩法
```

![image-20200523210358726](assets/image-20200523210358726.png)

```
NoExecute：这个行为不仅会evict所有的对这个节点没有 toleratioin的pod，还不会调度新的pod上来，这个行为比其他两个行为都严苛
```

![image-20200523210933592](assets/image-20200523210933592.png)

![image-20200523211001834](assets/image-20200523211001834.png)

![image-20200523211108616](assets/image-20200523211108616.png)

![image-20200523211211572](assets/image-20200523211211572.png)

```
低优先级的pod1（上图的蓝色），被驱逐，高优先级的pod2（下图黄色）持有了这两个CPU的使用
```

![image-20200523211512612](assets/image-20200523211512612.png)

```
内置默认的优先级，没有进行优先级配置的话，则优先级为0
用户可配置最大的优先级为 10亿
系统可配置的最大的优先级为 20亿
```

![image-20200523211938012](assets/image-20200523211938012.png)

```
pod2和pod1 先后进入优先级调度队列
```

![image-20200523212025175](assets/image-20200523212025175.png)

```
出队列的时候，优先对高优先级的进行调度，把pod1 bind到node1上
```

![image-20200523212105560](assets/image-20200523212105560.png)

```
在对pod2这个低优先级的pod进行调度
```

![image-20200523212242712](assets/image-20200523212242712.png)

![image-20200523212405962](assets/image-20200523212405962.png)

![image-20200523212504437](assets/image-20200523212504437.png)

```
打破PDB最少：抢占的这个节点影响的服务最小
```

![image-20200523212817601](assets/image-20200523212817601.png)

### 调度器调度流程和算法介绍

![image-20200523212926901](assets/image-20200523212926901.png)

![image-20200523213110437](assets/image-20200523213110437.png)

```
reserve：预占用，储备
```

![image-20200523213759677](assets/image-20200523213759677.png)

![image-20200523214234034](assets/image-20200523214234034.png)

```
预选器：Predicates
```

![image-20200523214603925](assets/image-20200523214603925.png)

![image-20200523214810986](assets/image-20200523214810986.png)

```
skew: 倾斜的意思
ActualSkew = count[topo] - min(count[topo])
现在的三个zone的的pod 分别为 1,1,0；假设调度到了 zone1 上，则 单个zone的 值为 2,1,0； 则 ActualSkew = 2 - 0 = 2， 大于了 maxSkew=1的设定，所以只能调度到 zone3上

对于有容灾需求的可以设定 maxSkew 值，进行pod进行打散，设置maxSkew=1则在每个zone就是均衡的
```

![image-20200523215546476](assets/image-20200523215546476.png)

```
Prioritues: 优选器，打分算法
```

![image-20200523215738405](assets/image-20200523215738405.png)

![image-20200523215949366](assets/image-20200523215949366.png)

![image-20200523221501946](assets/image-20200523221501946.png)

![image-20200523221616095](assets/image-20200523221616095.png)

![image-20200523221715073](assets/image-20200523221715073.png)

![image-20200523221745384](assets/image-20200523221745384.png)

```
使用 --write-config-to 写入文件（默认的配置）
```

![image-20200523221901442](assets/image-20200523221901442.png)

![image-20200523222145700](assets/image-20200523222145700.png)

![image-20200523224112963](assets/image-20200523224112963.png)

![image-20200523224452632](assets/image-20200523224452632.png)

![image-20200523224741587](assets/image-20200523224741587.png)

![image-20200523224834816](assets/image-20200523224834816.png)

### GPU管理和Device Plugin工作机制

![image-20200523225105208](assets/image-20200523225105208.png)

![image-20200523225131918](assets/image-20200523225131918.png)

![image-20200523225301484](assets/image-20200523225301484.png)

![image-20200523225348377](assets/image-20200523225348377.png)

![image-20200523225421358](assets/image-20200523225421358.png)

![image-20200523225547837](assets/image-20200523225547837.png)

![image-20200523225640295](assets/image-20200523225640295.png)

![image-20200523225825722](assets/image-20200523225825722.png)

![image-20200523225934507](assets/image-20200523225934507.png)

![image-20200523230001480](assets/image-20200523230001480.png)

![image-20200523230045968](assets/image-20200523230045968.png)

![image-20200523230126423](assets/image-20200523230126423.png)

![image-20200523230249851](assets/image-20200523230249851.png)

![image-20200523230333543](assets/image-20200523230333543.png)

![image-20200523230437145](assets/image-20200523230437145.png)

![image-20200523230712456](assets/image-20200523230712456.png)

![image-20200523230835264](assets/image-20200523230835264.png)

![image-20200523230909307](assets/image-20200523230909307.png)

![image-20200523231029671](assets/image-20200523231029671.png)

### Kubernets存储架构及插件的使用

![image-20200523231118688](assets/image-20200523231118688.png)

![image-20200523231219727](assets/image-20200523231219727.png)

![image-20200523231417464](assets/image-20200523231417464.png)

![image-20200523231721583](assets/image-20200523231721583.png)

![image-20200523232040223](assets/image-20200523232040223.png)

![image-20200523232052052](assets/image-20200523232052052.png)

![image-20200523232539610](assets/image-20200523232539610.png)

![image-20200523232803348](assets/image-20200523232803348.png)

![image-20200523232817645](assets/image-20200523232817645.png)

![image-20200523233205048](assets/image-20200523233205048.png)

![image-20200523233537133](assets/image-20200523233537133.png)

![image-20200523233834649](assets/image-20200523233834649.png)

![image-20200523234339370](assets/image-20200523234339370.png)

![image-20200523234619338](assets/image-20200523234619338.png)

![image-20200523235131965](assets/image-20200523235131965.png)

![image-20200523235638322](assets/image-20200523235638322.png)

![image-20200523235759933](assets/image-20200523235759933.png)

![image-20200524000049611](assets/image-20200524000049611.png)

![image-20200524000322186](assets/image-20200524000322186.png)

![image-20200524000654557](assets/image-20200524000654557.png)

![image-20200524000957940](assets/image-20200524000957940.png)

![image-20200524001452365](assets/image-20200524001452365.png)

```
监听/var/lib/kubelet/plugin_registry/ 目录每添加一个sock文件，就注册一个plugin
```

![image-20200524001911086](assets/image-20200524001911086.png)

![image-20200524002111713](assets/image-20200524002111713.png)

![image-20200524002313917](assets/image-20200524002313917.png)

![image-20200524002339589](assets/image-20200524002339589.png)

![image-20200524002348544](assets/image-20200524002348544.png)

![image-20200524002518251](assets/image-20200524002518251.png)

![image-20200524002652424](assets/image-20200524002652424.png)

![image-20200524002730031](assets/image-20200524002730031.png)

### 有状态应用编排 StatefulSet

![image-20200524002930996](assets/image-20200524002930996.png)

![image-20200524003010830](assets/image-20200524003010830.png)

![image-20200524074504492](assets/image-20200524074504492.png)

![image-20200524074710144](assets/image-20200524074710144.png)

![image-20200524075005697](assets/image-20200524075005697.png)

```
为每一个nginx 申请PVC 挂载到 /usr/share/nginx/html 下
```

![image-20200524075038405](assets/image-20200524075038405.png)

![image-20200524075345067](assets/image-20200524075345067.png)

```
www-storage 为PVC的name
nginx-web: stateful name
从而达到不同的pod 绑定不同的pv的需求
```

![image-20200524075602569](assets/image-20200524075602569.png)

![image-20200524075650445](assets/image-20200524075650445.png)

![image-20200524075814429](assets/image-20200524075814429.png)

![image-20200524075946018](assets/image-20200524075946018.png)

```
三个nginx依次创建，pvc也依次创建绑定

stateful 在版本更新前后，会复用之前创建的 PVC的存储，以及网络资源，从而达到有状态应用的数据前后一致性的要求
```

![image-20200524080613346](assets/image-20200524080613346.png)

```
如果补丁已PVC的 template，则创建出来而pod就不会挂载独立的PV

statefulSet Owned 三个资源： controller revison，Pdd，PVC，但不同的是，statefulset 只会在 controller revison和pod中添加 ownref的信息，不会在PVC 添加owenref。

拥有ownref资源，他的管理资源在删除的情况下，会级联删除下属资源，默认情况下删除 statefulset的资源之后，不会删除PVC
```

![image-20200524081351289](assets/image-20200524081351289.png)

![image-20200524081524447](assets/image-20200524081524447.png)

![image-20200524081605552](assets/image-20200524081605552.png)

![image-20200524081757338](assets/image-20200524081757338.png)

![image-20200524081850785](assets/image-20200524081850785.png)

![image-20200524081946825](assets/image-20200524081946825.png)

![image-20200524082150692](assets/image-20200524082150692.png)

### Kubernets 的API编程范式

![image-20200524082330509](assets/image-20200524082330509.png)

![image-20200524082403922](assets/image-20200524082403922.png)

![image-20200524082458942](assets/image-20200524082458942.png)

![image-20200524082529966](assets/image-20200524082529966.png)

![image-20200524082748231](assets/image-20200524082748231.png)

![image-20200524082817570](assets/image-20200524082817570.png)

![image-20200524082944941](assets/image-20200524082944941.png)

![image-20200524083033000](assets/image-20200524083033000.png)

![image-20200524083119489](assets/image-20200524083119489.png)

![image-20200524083231868](assets/image-20200524083231868.png)

![image-20200524083327265](assets/image-20200524083327265.png)

### Operator 和 Operator Framwork

![image-20200524083501435](assets/image-20200524083501435.png)

![image-20200524083734386](assets/image-20200524083734386.png)

![image-20200524084028918](assets/image-20200524084028918.png)

![image-20200524084139560](assets/image-20200524084139560.png)

![image-20200524084313337](assets/image-20200524084313337.png)

![image-20200524084359058](assets/image-20200524084359058.png)

![image-20200524084549860](assets/image-20200524084549860.png)

![image-20200524084823216](assets/image-20200524084823216.png)

![image-20200524084916339](assets/image-20200524084916339.png)

![image-20200524085104358](assets/image-20200524085104358.png)

![image-20200524085136127](assets/image-20200524085136127.png)

```
蓝色的 为 上面三次的命令执行的生成文件
```

![image-20200524085343435](assets/image-20200524085343435.png)

![image-20200524085441159](assets/image-20200524085441159.png)

![image-20200524085634282](assets/image-20200524085634282.png)

![image-20200524085756697](assets/image-20200524085756697.png)

![image-20200524085913171](assets/image-20200524085913171.png)

```
可能使用 webhook 完成 业务的逻辑，而不使用controller
```

### Kubernets网络模型进阶

![image-20200524090109460](assets/image-20200524090109460.png)

![image-20200524090204355](assets/image-20200524090204355.png)

![image-20200524090344465](assets/image-20200524090344465.png)

![image-20200524090540379](assets/image-20200524090540379.png)

![image-20200524091247981](assets/image-20200524091247981.png)

```
如果不经由路由，可以使用 vxlan的隧道，填写对端的隧道号，把包发到对端
```

![image-20200524091713624](assets/image-20200524091713624.png)

![image-20200524092008354](assets/image-20200524092008354.png)

![image-20200524092431101](assets/image-20200524092431101.png)

![image-20200524092729105](assets/image-20200524092729105.png)

![image-20200524092931010](assets/image-20200524092931010.png)

### 理解CNI和CNI插件

![image-20200524093047368](assets/image-20200524093047368.png)

![image-20200524093109576](assets/image-20200524093109576.png)

![image-20200524093154377](assets/image-20200524093154377.png)

![image-20200524093314445](assets/image-20200524093314445.png)

![image-20200524093540903](assets/image-20200524093540903.png)

![image-20200524093651948](assets/image-20200524093651948.png)

```
Overlay：容器有独立于主机的ip段，跨主机通信的时候，在每个主机创建隧道的方式，把容器网络的包封装成底层物理机之间的包，好处是不依赖与底层的网络。
路由模式：容器独立于主机的网络，跨主机通信使用路由的方式，依赖底层网络的二层可达的能力
underlay： 容器和宿主机是同一层的网络
```

![image-20200524094930288](assets/image-20200524094930288.png)

![image-20200524095446788](assets/image-20200524095446788.png)

![image-20200524100002577](assets/image-20200524100002577.png)

```
给pod分配ip：
	一般会把pod的网段按node进行分段，这样视为了保证分配给pod的ip是不冲突的
```

![image-20200524100356645](assets/image-20200524100356645.png)

![image-20200524100706231](assets/image-20200524100706231.png)

### Kubernets安全之访问控制

![image-20200524100751641](assets/image-20200524100751641.png)

![image-20200524100820602](assets/image-20200524100820602.png)

![image-20200524100919932](assets/image-20200524100919932.png)

```
Authentication： 认证，是否为合法用户
Authorization: 鉴权，认证通过的用户是否 有权限访问
Admission Control: 访问的请求是否合规安全
```

![image-20200524101238283](assets/image-20200524101238283.png)

![image-20200524101433476](assets/image-20200524101433476.png)

![image-20200524101525992](assets/image-20200524101525992.png)

![image-20200524101643006](assets/image-20200524101643006.png)

![image-20200524101919020](assets/image-20200524101919020.png)

![image-20200524102108249](assets/image-20200524102108249.png)

![image-20200524102136498](assets/image-20200524102136498.png)

![image-20200524102225896](assets/image-20200524102225896.png)

![image-20200524102340961](assets/image-20200524102340961.png)

![image-20200524102454555](assets/image-20200524102454555.png)

![image-20200524102537254](assets/image-20200524102537254.png)

![image-20200524102654793](assets/image-20200524102654793.png)

```
RBAC是面对API级别的绑定，不能绑定到具体的实例对象
```

![image-20200524102854773](assets/image-20200524102854773.png)

![image-20200524103016274](assets/image-20200524103016274.png)

![image-20200524103113479](assets/image-20200524103113479.png)

![image-20200524104627233](assets/image-20200524104627233.png)

![image-20200524104710453](assets/image-20200524104710453.png)

![image-20200524104744562](assets/image-20200524104744562.png)

![image-20200524104801428](assets/image-20200524104801428.png)

![image-20200524104838442](assets/image-20200524104838442.png)

![image-20200524104930204](assets/image-20200524104930204.png)

![image-20200524105100986](assets/image-20200524105100986.png)

![image-20200524105210213](assets/image-20200524105210213.png)

![image-20200524105338818](assets/image-20200524105338818.png)

![image-20200524105609661](assets/image-20200524105609661.png)

![image-20200524105920808](assets/image-20200524105920808.png)

### 理解容器运行时接口 - CRI

![image-20200524105947062](assets/image-20200524105947062.png)

![image-20200524110045733](assets/image-20200524110045733.png)

![image-20200524110350286](assets/image-20200524110350286.png)

![image-20200524110449592](assets/image-20200524110449592.png)

![image-20200524110541519](assets/image-20200524110541519.png)

![image-20200524110630128](assets/image-20200524110630128.png)

![image-20200524110729299](assets/image-20200524110729299.png)

![image-20200524110821157](assets/image-20200524110821157.png)

![image-20200524110901939](assets/image-20200524110901939.png)

![image-20200524110959611](assets/image-20200524110959611.png)

![image-20200524111123999](assets/image-20200524111123999.png)

![image-20200524111154123](assets/image-20200524111154123.png)

![image-20200524111225617](assets/image-20200524111225617.png)

### 安全容器技术

![image-20200524111322946](assets/image-20200524111322946.png)

![image-20200524111338888](assets/image-20200524111338888.png)

![image-20200524111402588](assets/image-20200524111402588.png)

![image-20200524111639100](assets/image-20200524111639100.png)

![image-20200524111909815](assets/image-20200524111909815.png)

![image-20200524112103871](assets/image-20200524112103871.png)

![image-20200524112329176](assets/image-20200524112329176.png)

![image-20200524113818312](assets/image-20200524113818312.png)

![image-20200524114047640](assets/image-20200524114047640.png)

```
gVisor的做法是：对于不常用的系统调用直接在sentry里处理调用，只有大约20%的会进行Linux系统调用
Linux的攻击大都是通过open() 这个系统的调用进行，因为open()在Linux系统中可以做太多的事情了，gVisor 就把open() 做了一个专门的进程 Gofer来执行操作

sentry和 Gofer都是使用golang实现的，是一个内存安全性的语言，就少了攻击
```

![image-20200524114920020](assets/image-20200524114920020.png)

![image-20200524115200363](assets/image-20200524115200363.png)

### 理解RuntimeClass与使用多容器运行时

![image-20200524115302344](assets/image-20200524115302344.png)

![image-20200524115328972](assets/image-20200524115328972.png)

![image-20200524115431146](assets/image-20200524115431146.png)

![image-20200524115628588](assets/image-20200524115628588.png)

```
handler：代表的是真正的容器运行时
scheduling.nodeSelector.runtime: runv : 会根据节点的标签选择调度到runv使用的 运行时，然后handler： runv，则使用runv的运行时启动容器
```

![image-20200524120130868](assets/image-20200524120130868.png)

![image-20200524120249105](assets/image-20200524120249105.png)

![image-20200524120353347](assets/image-20200524120353347.png)

![image-20200524120531969](assets/image-20200524120531969.png)

![image-20200524120610047](assets/image-20200524120610047.png)

![image-20200524120745144](assets/image-20200524120745144.png)

![image-20200524121009689](assets/image-20200524121009689.png)

![image-20200524121144470](assets/image-20200524121144470.png)

![image-20200524121238392](assets/image-20200524121238392.png)

![image-20200524121307808](assets/image-20200524121307808.png)

![image-20200524121326974](assets/image-20200524121326974.png)

![image-20200524121415056](assets/image-20200524121415056.png)

![image-20200524121508603](assets/image-20200524121508603.png)