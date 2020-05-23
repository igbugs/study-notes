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