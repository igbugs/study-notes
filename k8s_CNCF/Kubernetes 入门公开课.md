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