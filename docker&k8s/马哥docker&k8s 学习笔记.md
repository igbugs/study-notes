## 马哥docker 学习笔记

### 容器的概念

#### 虚拟化&容器化

![1562474014517](assets/1562474014517.png)

##### 虚拟化实现的技术形式

1. 主机级的虚拟化

   - type-I: 
     - 直接在硬件平台上安装虚拟机管理器（Hypervisor) 不用安装 HOST OS，在Hypervisor 之上安装虚拟机
   - type-II:  VMware/workstation/virtualbox
     - 首先有宿主机（物理机），在物理机上安装宿主机操作系统HOST OS，在宿主机上安装 VMM（virtual machine manage），在VMM 的基础上创建使用虚拟机。
   - 其他：KVM/ZEN

   ```
   VMM给用户虚拟出来的是一个独立的硬件平台，用户需要使用虚拟机，需要部署完整意义的操作系统。
   但是运行内核不是我们的主要的目的，内核的主要的目的在于资源分配和任务管理，真正在用户空间的 应用进程才是能产生生产力的，而不是出于通用目的而产生的资源管理平台（内核）。
   但是内核又不得不存在，因为现在的软件都是针对于内核的系统调用和库调用，并且多个应用进程的协调也需要内核进行统一管理。
   一个在虚拟机中的进程想要运行则需要二级调度，自己虚拟机的内存虚拟化，CPU调度以及IO调度，真正的虚拟机进程又是被宿主机管理的进程或抽象层。
   ```

2. 容器级的虚拟化

   ```
   为了提高虚拟机虚拟化的效率，抽除掉虚拟机的内核层，直接进行用户进程之间的隔离。通过在宿主机上通过 一个用户空间的管理器 隔离不同的用户进程，用户进程运行在隔离起来的用户空间中，用户进程看到的是用户空间的边界，这就是容器技术的本质。
   
   容器技术最早出现在freeBSD 中，名字叫jail（监狱），最初出现jail 的目的是安全，程序运行在沙盒之中，进行隔离，避免程序出现安全漏洞而引起整个系统出现问题。
   后来吸收jail的理念，Linux 平台的 vserver(chroot)来实现容器技术。
   
   一个进程的运行无非就两棵树，进程树和文件系统树。
   
   容器的隔离需要进行：
   UTS（主机名和域名）
   Mount（文件系统挂载树）
   IPC（进程间通信）
   PID（进程号）每个隔离的用户空间必须要有一个 伪装成类似于init 的进程
   Uers（用户）对于在用户空间内行为可能类似于root，但在系统级别只是一个普通的用户
   Network（网络）每一个用户空间有自己专有的TCP/IP 协议栈
   ```

   ![1562504138412](assets/1562504138412.png)

   

![1562504618445](assets/1562504618445.png)

​	

​			

```
Control Groups(CGroups)：把系统级的资源分为多个组，把每一个的组内的资源的量指派分配到特定的用户空间的进程中去。
划分为不同的组之后，进行系统资源的分配。一个组内还可以进行细化为子组，把一个资源分配给一个组之后，这个组内的子组自动的拥有使用资源的权限。
如果把一个用户空间当做一个组，把资源分配给这个组，就可以限制这个用户空间的资源使用。
把一个资源分配一个用户空间，这个用户空间就自动的拥有了使用这个资源的能力。
```

容器技术由 Chroot，namespaces , CGroups 三种技术作为支撑的。

#### LXC（LinuX Container）

```
LXC 是最早把完整的容器技术，用一组简易使用的工具和模板来极大的简化容器使用的方案。
```



## 马哥 k8s 学习笔记

### DevOPS 核心要点及架构概述

```
Ansible:
	应用编排的工具，安装配置服务启动，甚至按照所定义的playbook 对多种的应用程序在有依赖关系的时候进行编排处理，把运维手动的处理运维任务 进行流程化，可编程化。

Docker:
	以往手工管理的对象是直接部署在操作系统上的应用程序，但是有了docker 之后，应用程序的容器化，各种的应用程序都封装在容器中运行，当在使用ansible这类的编排工具发现对象已经发生了变化，不能再像操作应用程序一样操作docker，所以docker 时代就需要面向容器化的编排的工具
	docker-compose: 更适合于单机的容器编排，只能面向一个docker host进行操作。
	docker-swarm: 可以将多个dockerhost 上运行的docker 容器，进行在同一平台的调度 编排。
	docker-machine: 将一个主机处理为加入docker swarm 集群的预处理工具。
	
	mesos: 是一个IDC的操作系统，能将一个IDC提供的硬件资源统一的调度与分配，他所面向的不是容器的接口，而是资源的分配工具。所以在此基础上需要一个面向容器的可编排的框架 marathon
	
	kubernetes:

DevOps:
	通过利用一些CI/CD（delivery, deployment） 工具，将开发，构建，测试，代码交付，运维部署的 过程自动化的完成，降低开发测试运维沟通成本，打通了开发和运维的边界，就是devops 的理念。
	容器技术的出现，使devops 完全成为了可能。devops 不是一种技术，是一种文化，一种运动。
	
	面对成千上万的容器，想要传统一样去管理监控处理存在故障的容器，基本不可能。所以需要容器编排的工具去进行管理。
```

**kubernetes简介**

```
kubernetes: 舵手
	kubernetes 的开发 深受Google 内部的 Borg系统的影响，Borg 是谷歌内部久负盛名的 容器管理工具。
	官方介绍的特性：
		1. 自动装箱，基于资源依赖及其约束能自动的完成容器的部署，不影响其可用性。
		2. 自我修复，由于容器非常轻量的特点，可以在1s内启动，有了k8s 这样的平台，运维更多的是关注的平台而非个体，一个个体的故障，会被重新销毁，重新分配。
		3. 水平扩展，一个容器不够，在启动多个
		4. 服务的发现和服务的负载均衡。
		5. 自动的实现发布和回滚
		6. 密钥和配置管理(之前的容器实现是 在容器	启动的时候 传入配置的环境变量值，获取一些配置)，k8s 会有配置对象，启动时候像从配置中心一样加载配置
		7. 存储编排
		8. 批量处理执行
	
	Redhat 的 openshift 可以看做为 kubernetes 的发行版，kubernetes 做的东西比较的底层。openshift 继承了 PAAS 平台以及devops 的环境。
```

**kubenetes 的环境架构和术语**

```
kubernetes 是一个集群，统一整合多个主机的资源，形成一个大的资源池，并对外提供计算存储能力的集群。

kubernetes 是一个 master/nodes(workers) 的架构的应用
	master 有一个或一组节点为主节点，一般为三个。彼此之间为了做高可用。
		API server：接受用户的请求
		scheduler：调度容器创建端请求
		controller-manager：确保控制器健康，而 controller 优势确保容器的健康。
	nodes 每一个都是为了贡献计算和存储资源，是运行容器的结点。
		kubelet: 创建删除管理pod
		docker engine：提供容器的运行基础环境
		kube-proxy: 时刻监听API server 的相关事件，一旦发现 某一个service关联的pod 的地址发生改变，对应的有kube-porxy 在本地的反应在 iptables或ipvs 上，service的管理需要 kube-proxy 来进行
	kubernetes进群所有信息的存储：
		etcd
	kubernetes 域名服务：
		core-dns
	
	用户如何在集群中运行容器：
		客户端的请求先发送给master ，由 api server 处理，分析用户请求的资源后，通过schedule 进行资源的分析调度到响应的结点，node 上的kubelet 在收到scheduler 的调度后，通过本机的容器引擎 启动容器，检查本机是否有响应的容器，没有的话 向docker registry 请求镜像。
		
		scheduler 提供了两级调度的算法，首先评估下 所有节点几个服务容器的运行需求，再从选出的节点优选出最佳（取决于调度算法的优选算法）。
		node  节点安装的kubelet 会对节点上的容器做 健康的检测
		controller 负责去监控管理的每个容器是否是健康的，一旦发现不健康，控制器向API server 发送请求，进行容器在其他节点的重建（scheduler调度进行）。控制器在本地不停的loop，持续性的探测管理的容器是否健康。一旦不符合用户定义的目标，使实际的结果不断的 吻合到用户定义资源的状态。
		master 上的 controller-manager 管理监控所有的控制器的健康。controller-manager 在master 做了高可用
	
	kubernetes 并不直接的调度容器，而是调度pod，pod是容器的集合抽象层（逻辑组件），pod内的容器有相同的网络命名空间（nets，UTS， IPC共享，user，MNT，PID藿香隔离）和存储卷。
	
在创建pod 的时候，会给pod 添加一些 metadata 数据，如：label，方便进行pod 的筛选和归类管理，这些标签是一些 kv 对，k8s 会通过 selector 标签选择管理器，进行pod 的操作。

```

### kubernetes 基本概念

```
Pod:
	1. 自主式pod，自我管理的pod，调用api server，由 scheduler 进行调度到节点，kubelet 创建容器，如果容器故障，kubelet 重新再节点创建，如果节点故障，容器则会消失。无法实现全局的调度
	2. 控制器管理的pod
		ReplicationController: 当pod 的数量不满足预期定义的个数的时候，由此控制器进行控制pod 的创建或销毁多余的副本
		ReplicaSet：此控制器不直接使用，需要 ReplicationController为基础
		Deployment: 声明式更新的控制器，只能管理无状态的应用
		StatefulSet: 有状态的控制器
		DaemonSet：没一个节点上只能运行一个副本，不能随意的运行
		Job：运行作业，不需要一直处于运行状态
		CrondJob: 周期性的计划作业
		HPA（HorizontalPodAutoscaler）：自动的根据pod的负载，资源使用情况进行pod 的创建或减小
```

![1564640298609](assets/1564640298609.png)

```
service 的作用：
	由于pod的创建 销毁可能随时的进行，所以不能采用传统的访问pod IP的方式去直接访问pod内容器的应用，抽离出一个service 层，相当于一个VIP的作用，这个VIP在serveice 创建后不在进行变化，后端的pod 新增或销毁不影响服务的访问，只是添加新的iptables/ipvs 规则就行了，service是通过集群内部的DNS动态的添加解析到service ip，实现访问的。
	
kubernetes的三种网络：
	1. 节点网络，物理主机的网络
	2. service 网络，由iptables/ipvs 产生的虚拟的网络
	3. pod 的网络

kubernetes 中容器间的三种通信：
	1. 同一pod内的多个容器之间的通信: lo (网络名称空间相同)
	2. 各pod网络之间的通信（跨主机的话 使用overlay network 叠加网络）
	3. pod 与service 之间的通信（pod的网关配置为 本机的 docker0 的地址，网络包到达docker0后，由相应的iptables/ipvs进行转发，而集群中所有的iptables/ipvs的管理则由kube-proxy进行）
	
kubernetes 通过 CNI（容器网络接口）来接入第三方的网络插件，为kubernetes 集群提供网络支持。
	1. funnel：只支持网络的配置，是pod之间，pod和service 之间进行通信，不支持网络的策略的配置，纯粹的叠加网络实现
	2. calico: 即支持网络配置，又支持网络策略（使用BGP协议实现了直接路由通信），是一个三层的隧道网络
	3. canel: 结合 funnel 和calico
```

![1564642412326](assets/1564642412326.png)

### kubeadm 初始化kubernetes集群

![1564642656218](assets/1564642656218.png)

![1564642716655](assets/1564642716655.png)

```
service 网络有kube-proxy 管理
pod 网络 由 flannel 管理（10.244.0.0/16 flannel 默认的）
```

![1564644209035](assets/1564644209035.png)

**配置kubernetes 阿里云源**

![1564644725177](assets/1564644725177.png)

**安装基础的软件**

![1564644806771](assets/1564644806771.png)

**导入gpg密钥**

![1564644978820](assets/1564644978820.png)

**配置docker镜像代理服务**

![1564645158448](assets/1564645158448.png)

![1564645110610](assets/1564645110610.png)

![1564645207448](assets/1564645207448.png)

**确认桥接的 iptables 配置是否允许**

![1564645309671](assets/1564645309671.png)

**配置当开启 swap 的时候要不要报错**

![1564645777807](assets/1564645777807.png)

![1564645760780](assets/1564645760780.png)

**pause容器的作用**

![1564645931432](assets/1564645931432.png)

```
pause 是为了构建基础架构容器使用的，pause容器不启用，其他容器构建的时候加入复制这个容器网络和存储卷等提供功能。
pod 之所以能启动起来，是其他容器在pod内拥有相同的网络和存储，就是因为pod底层使用的是 pause 这个基础架构容器
```

![1564646316300](assets/1564646316300.png)

```
配置kubelet 连接kubernetes 集群的认证证书，以及向kubernetes 添加节点
```

**获取集群的组件状态信息**

![1564646457953](assets/1564646457953.png)

**查看节点的状态**

![1564646633936](assets/1564646633936.png)

```
之所以节点没有 ready ，因为集群的网络addon 没有安装好
```

**flannel 安装**

![1564646720333](assets/1564646720333.png)

**查看系统的k8s的镜像需要制定 kube-system 的名称空间**

![1564646815599](assets/1564646815599.png)

![1564646850077](assets/1564646850077.png)

**查看集群的各组件的信息**

![1564647320704](assets/1564647320704.png)

### kubernetes应用快速入门

![1564647672424](assets/1564647672424.png)

**创建pod**

![1564647840357](assets/1564647840357.png)

![1564648331057](assets/1564648331057.png)

```
dry-run 不会真正的执行
```

![1564648388731](assets/1564648388731.png)

```
deployment 展示的是用户期望的资源设定情况
```

![1564648447086](assets/1564648447086.png)

```
查看pod 的信息，及节点信息
```

![1564648495986](assets/1564648495986.png)

```
node02 上的pod都是 flannel cni0 网卡的 10.244.2 的网络ip
```

![1564648586358](assets/1564648586358.png)

```
访问nginx的pod 地址，只能在kubernetes 集群的内部访问pod 的
```

![1564648802885](assets/1564648802885.png)

```
将原本在 node2 上的pod 删除了之后，由于nginx的pod 是由deployment 进行管理的，所以会在进行重新穿件，调度到了node01上了，此时的pod IP 变更为 10.244.1 了
```

![1564648985092](assets/1564648985092.png)

```
kubectl run 指定的 --port 是 pod 的port
kubectl expose 创建服务的时候，--port 指定的是service的port
```

![1564649106617](assets/1564649106617.png)

```
创建的service 的三种类型：
	ClusterIP：集群内部可以被访问
	NodePort: 会在每一个物理结点上创建映射端口，供集群外访问
	LoadBalancer:
```

![1564649333010](assets/1564649333010.png)

```
expose 暴露哪个 deployment的服务
```

![1564649385084](assets/1564649385084.png)

```
查看创建的service，为 10.96 的网络，类型为 ClusterIP，service 视为pod 提供 固定访问的端点的（endpoints）, ClusterIP 只能在集群内部的进行访问。
```

![1564649677435](assets/1564649677435.png)

```
创建新的pod 的时候，他的DNS 自动的指向 coreDNS 的地址
```

![1564650002829](assets/1564650002829.png)

```
service关联的后端的节点为 10.244.1.3:80 
selector: 的标签为 run=nginx-deploy
```

![1564650143373](assets/1564650143373.png)

```
10.244.1.3 这个pod 拥有 run=nginx-deploy 的标签，service通过这个标签来选择 nginx，通过这个标签来管理pod，监控pod的状态
```

![1564650465557](assets/1564650465557.png)

```
-w  watch ，一直监控着状态的变化
```

![1564650573615](assets/1564650573615.png)

**创建myapp service**

![1564650676248](assets/1564650676248.png)

![1564650652770](assets/1564650652770.png)

```
可以看到 两个副本，轮询访问
```

**持续进行pod 的访问**

![1564650760312](assets/1564650760312.png)

**扩展deployment 到5个**

![1564650811849](assets/1564650811849.png)

**升级容器镜像的版本**

![1564650989636](assets/1564650989636.png)

![1564651017407](assets/1564651017407.png)

```
先通过 kubectl describe pods  container_name   查看容器的名字
```

![1564651096246](assets/1564651096246.png)

```
升级镜像到 v2
```

![1564651137331](assets/1564651137331.png)

```
查看myapp 的升级的过程
```

![1564651226548](assets/1564651226548.png)

**回滚deployment 的更新**

![1564651271720](assets/1564651271720.png)

![1564651294350](assets/1564651294350.png)

**edit myapp 的service **

![1564651624849](assets/1564651624849.png)

![1564651609776](assets/1564651609776.png)

![1564651668799](assets/1564651668799.png)

![1564651694646](assets/1564651694646.png)

![1564651719042](assets/1564651719042.png)

### kubernetes 资源清单定义入门

#### kubernetes 常用的资源

```
资源实例化后为一个对象。
1. 工作负载型的资源对象（workload）: Pod, ReplicaSet, Deployment, StatefulSet, DaemonSet, Job, Cronjob
2. 服务发现及均衡：Service， Ingress
3. 配置与存储：Volume，CSI接口
	ConfigMap: 当做配置中心使用的资源
	Secret： 敏感数据的配置
	DownwardAPI： 外部的信息输出给容器
4. 集群级的资源：
	NameSpace，Node，Role，ClusterRole，RoleBinding，ClusterRoleBinding
5. 元数据型的资源
	HPA：水平pod收缩
	PodTemplate: 用于让控制器使用的模板
	LimiRange: 定义使用的资源的限制
```

#### **pod 的资源配置清单**

![1564662748549](assets/1564662748549.png)

```
apiVersion 的命名为 group/version, 当group 省略的时候，说明是core组的
kind 指定资源的类型
metadata 元数据
spec 资源的规格定义，定义自己创建的资源对象应该具有什么样的特性（目标期望状态）
```

![1564662946125](assets/1564662946125.png)

```
容忍度，容忍哪些污点
```

![1564667436108](assets/1564667436108.png)

```
status 显示当前资源的当前的状态
k8s 就是确保每一个资源定义完成后，从当前状态无限的向目标状态靠近，从而满足用户期望。
```

#### **创建资源的方法**

```
api server： 仅接受Json 格式的资源的定义，当使用 kubectl run 创建deployment的时候，会自动的把命令行的命令转换为json 的格式发送给 api server 进行资源的创建
yaml格式的配置清单，api server 可以自动的将其转换为json 格式，而后再提交执行。

大部分核心资源的配置清单组成：
	apiVersion: 指定创建的资源属于哪个api 组
	kind: 资源的类别（一般为内建的，但也支持自定义）
	metadata：元数据
		name: 同一类别中的name 必须唯一的，（实例化具体的对象了）
		namespace：这个对象属于哪个名称空间, 这个是kubernetes级别的概念，不是操作系统的namespace
		labels: 标签，每种类型的数据都可以有标签，键值数据
		annotations: 资源注解
	spec: 用户期望的状态，desired state 
	status: 当前的资源状态，current state，右kubernetes集群维护，用户不能自定义
		
清单定义的是声明式的api调用；
kubectl run 定义的是 命令式的api调用。
```

**k8s 的api 组**

![1564670605066](assets/1564670605066.png)

```
pod 属于最核心的资源，所以属于 core/v1 群组
controller，deployment，RealicaSet 属于 apps/ 群组  （alpha 内测版本，beta 公测版本）
```

**K8S 中资源的引用**

![1564671248507](assets/1564671248507.png)

```
每个资源的引用的PATH
	/api/GROUP/VERSION/namespaces/NAMESPACE/KIND/NAME
```

#### **查看pods 资源的定义方式**

![1564671696032](assets/1564671696032.png)

![1564671716243](assets/1564671716243.png)

```
其中 为Object 的 可以在进行字段的嵌套
```

**查看metadata 定义方式**

![1564671776805](assets/1564671776805.png)

![1564671795989](assets/1564671795989.png)

![1564671841710](assets/1564671841710.png)

```
map 是 KV组成的json数组
[]Object 定义为一个 对象数组
```

![1564672019367](assets/1564672019367.png)

```
一级级的查看资源的定义方式
```

#### **定义资源清单的yaml文件**

![1564672217721](assets/1564672217721.png)

```
labels 需要的是一个字典，（json的数组），可以使用上面的红框中的{} 进行定义，也可以使用app,tier 并行的方式进行定义（这里是映射的kv值）。注意: 这里app 前面没有 - ，加了 - 的为一个数组（列表）中的相同的类型的元素，所有的map 的可以使用 {} 进行定义，所有的 列表的可以使用 [] 进行定义。
```

![1564672590683](assets/1564672590683.png)

```
containers; 字段定义为一个列表，使用 - 打头，
command 后面跟的也为 列表，也可以使用两种方式进行定义
```

#### **最终的定义的demo 的资源清单**

![1564672730525](assets/1564672730525.png)

```
会创建两个容器在同一个pod内
```

#### **demo pod 的创建**

![1564672824316](assets/1564672824316.png)

![1564672895298](assets/1564672895298.png)

#### **查看pod 的日志**

![1564672966723](assets/1564672966723.png)

![1564673010428](assets/1564673010428.png)

```
启动的busybox 容器报错
```

#### **进入到容器中**

![1564673219674](assets/1564673219674.png)

#### **根据清单删除pod**

![1564673348464](assets/1564673348464.png)

### kubernetes Pod 控制器应用进阶

![1564707521121](assets/1564707521121.png)

![1564705874801](assets/1564705874801.png)

```
当拉取得镜像为 lastest 的时候，默认的拉取策略是always，可以设定为IfNotPresent 本地没有的话才进行拉取
```

![1564706025580](assets/1564706025580.png)

```
args: 如果没有定义args，则默认使用docker镜像中 CMD 后面的参数，如果使用变量 引用 方式为 $(var_name) 或 逃逸转义 使用 $$(var_name)

command: 如果没有提供这个选项，则使用docker 自己的entrypoint， 这个参数不会提供 shell 环境，需要在shell 中运行 将 "/bin/sh" 作为command 的列表传入

如果只定义了command 则docker中的 entrypoint 和 CMD 都不会生效
```

![1564706396679](assets/1564706396679.png)

![1564706566680](assets/1564706566680.png)

#### pod 标签过滤

![1564707120869](assets/1564707120869.png)

![1564707215577](assets/1564707215577.png)

```
-l 指定标签选择器，过滤pod
-L 根据指定的标签，显示出其含有的 值
```

![1564707254209](assets/1564707254209.png)

#### 给pod 打标签

![1564707348924](assets/1564707348924.png)

![1564707401684](assets/1564707401684.png)

```
标签已经存在 使用 --overwrite
```

#### 复杂的标签选择

```
kubernetes的标签选择器有两类：
	1. 基于等值关系的标签选择器
		==，= 表示相等
		!= 表示不相等
	2. 基于集合的标签选择器
		KEY in (VALUE1, VALUE2, VALUE3...)
		KEY notin (VALUE1, VALUE2, VALUE3...)
		KEY 存在此键
		!KEy 不存在此键
		
	3. 许多的资源支持内置字段定义其使用的标签选择器
		matchLables: 直接给定键值对
		matchExpressions: 
			基于给定的表达式来定义使用标签选择器，
			{key: "KEY", operator: "OPERATOR", values: [VAL1, VAL2, ...]}
			operator有：In, NotIn, Exists, NotExists
```

#### **等值类的选择**

![1564707612807](assets/1564707612807.png)

![1564707669991](assets/1564707669991.png)

![1564707691724](assets/1564707691724.png)

![1564707719198](assets/1564707719198.png)

#### **集合类的选择**

![1564707863181](assets/1564707863181.png)

#### 任何资源都可以使用标签

![1564708490608](assets/1564708490608.png)

```
nodes 节点的标签
```

#### **给node打标签**

![1564708555480](assets/1564708555480.png)

```
nodeSelector <map[string][string]>
	节点标签选择器
nodeName <string>
	运行在指定的节点上
```

#### **使用标签选择器**

![1564708738617](assets/1564708738617.png)

```
nodeSelector 是pod 的属性，所以与containers 属性为同一级别，这样这个pod就只会运行在 disktype=ssd的结点上了
```

![1564708953947](assets/1564708953947.png)

![1564708967004](assets/1564708967004.png)

```
运行在node1 节点上了
```

#### 资源注解annotations

```
annotations：
	与labels不同的地方在于，不能用于挑选资源对象，仅仅提供对象的元数据，它对字符串的长度（键长度和值长度限制）没有限制
```

**查看资源的注解**

![1564709211213](assets/1564709211213.png)

#### 添加注解

![1564709257576](assets/1564709257576.png)

![1564709293454](assets/1564709293454.png)

#### Pod 的生命周期

```
pod 的状态：
	pending：已经创建但是没有适合它运行的节点，调度尚未完成
	running：正常运行的状态
	failed: 失败
	succeeded: 成功
	unknown：未知状态，api server 获知的 pod 的状态信息是kubelet 提供的，如果 kubelet故障，则无法获取状态
```

![1564710951214](assets/1564710951214.png)

```
init container: 初始化的容器，可以存在多个，之间线性的执行
main container: 主容器，在init container 启动后执行，主容器可以做post start 启动后的钩子，和停止前的钩子，还可以在运行过程中做容器的健康性的检测（liveness probe, readiness probe）
	健康性探测：
		liveness probe: 存活性探测主要探测主容器是否存活
		readiness probe: 就绪性探测主要探测主容器是否准备就绪，并可以对外提供服务
	无论哪种probe 可以有三种探测行为：
		1. 执行自定义的命令 
		2. 向指定的tcp套接字发送请求 
		3. 向指定的http服务发送请求）

pod 生命周期的重要的行为：
	1. 初始化容器
	2. 容器探测
	3. post start/pre stop 钩子

lifecycle: 这个containers的下属配置项，定义生命周期定义启动前和启动后的钩子
```

#### Pod容器的重启策略

```
restartPolicy:
	1. Always   一旦挂了就重启（default）
	2. OnFailure  只有容器的状态为错误是才重启，正常停止的不重启
	3. Never   从不重启
第一次重启，终止后就立即重启，再出现错误，就会延时进行重启，终止后等10s再重启，第三次 等20s，第四次，等40s..., 300s 为最长的等待时间，之后都是等300s 进行重启

一旦一个pod 调度到某个节点之后，只要这个节点存活，发生错误时，这个pod就不会重新进行调度，只会进行重启，除非这个pod删除重新创建或节点挂了
```

#### Pod 的创建过程

```
创建pod:
	用户创建pod 的时候，请求交由api server，api server 保存定义的pod 期望状态的清单到etcd 中，api server之后会请求scheduler 进行调度，调度后的结果（调度到哪个节点，ip 等等信息）更新到etcd 中；此时相应的节点的 kubelet 通过api server获得到有pod创建的请求时，从etcd拿到创建的期望的清单，进行pod 的创建。再把创建的结果无论成功与失败发送给api server ,api server 再存储到etcd中。
```

#### Pod内的容器终止逻辑

```
pod一旦发成故障的时候应该进行平滑的迁移，侧能确保数据不会丢失
kubernetes 在提交删除pod 的操作时，不会直接kill掉 整个pod的容器，而是想pod内的每个容器发送 term(15) 的终止信号，让pod内的容器正常的进行终止，这个终止有个默认的宽限期（比如30s），如果宽限期内还没有终止，会重新发送kill信号
```

#### 主容器probe的配置

```
探针针对的是容器之上，是containers 的下属配置项
探针有三种的类型：
	ExecAction:
	TCPSocketAction:
	HTTPGetAction:


```

![1564712744438](assets/1564712744438.png)

![1564712884556](assets/1564712884556.png)

```
exec 探测命令执行的返回码 为0 则成功
```

**定义的探测示例**

![1564713119323](assets/1564713119323.png)

```
initalDelaySeconds 在容器启动多少秒之后再进行探测
periodSeconds 探测的周期
```

![1564713207022](assets/1564713207022.png)

![1564713293947](assets/1564713293947.png)

![1564713333223](assets/1564713333223.png)

![1564713388839](assets/1564713388839.png)

![1564713416176](assets/1564713416176.png)

**http get 探测**

![1564713578143](assets/1564713578143.png)

![1564713637701](assets/1564713637701.png)

**删除主页文件**

![1564713683678](assets/1564713683678.png)

![1564713723099](assets/1564713723099.png)

**可用性探测**

![1564714104691](assets/1564714104691.png)

![1564714128577](assets/1564714128577.png)

```
一旦就绪 READY 会变化
```

![1564714179995](assets/1564714179995.png)

#### lifecycle 钩子

![1564714234912](assets/1564714234912.png)

![1564714248925](assets/1564714248925.png)

![1564714293735](assets/1564714293735.png)

```
postStart 和preStop 同样也有三种的执行行为
```

**示例清单**

![1564714473634](assets/1564714473634.png)

```
lifecycle 在容器启动之后执行创建 httpd home 文件index.html
command 指定容器启动后执行的 httpd 服务
args 执行 httpd 启动的一些参数，-f 前台运行，-h 执行家目录位置
```

![1564714847174](assets/1564714847174.png)

```
上面的图片的配置是无法创建成功的，因为 容器的command 命令运行 httpd 服务的时候需要 /data/web/html 而此时 这个文件还没有创建，所以一直报错
```

#### Pod 控制器

```
RealicationController: 
ReplicaSet:	新一代的 RealicationController
	是用户创建的pod副本一直满足于用户的期望数量，支持扩缩容机制
Deployment： 
	工作在 ReplicaSet 之上，通过控制 ReplicaSet 控制pod, 比ReaplicaSet 有更多的功能，额外支持滚动更新，回滚
DaemonSet: 
	用于确保集群中的每一个的节点运行一个副本，比如日志收集的filebeat agnet 类的服务，通常为 系统级的后台任务，只要新增节点都会添加相应的DaemonSet 定义的pod
	只适用于无状态的应用, 
Job：
	只适用于只执行一次作用
CronJob:
	定时的执行任务
StatefulSet:
	有状态的，有数据的，不能随意启动一个副本替代的

TPR: Third Party Resources, 1.2+ - 1.7	第三方资源
CDR: Custom Defined Resources, 1.8+  用户自定义资源

Operator: 把运维技能灌输进来
```

**RC 与 RS**

![1564716909909](assets/1564716909909.png)

#### ReplicaSet 清单的创建

![1564718054056](assets/1564718054056.png)

```
ReplicaSet 通过 selector 去管理pod，查看pod 的数量，监控
template 下面定义的是 pod 的一些信息，其中 metadata 的labels 必须含有 RS 中 selector 的标签，要不然 RS 发现，没有相应的标签会一直进行创建。
```

![1564718249399](assets/1564718249399.png)

```
pod 的命名方式为 控制器 RS的名称，加上一个随机的字符串
```

![1564718337259](assets/1564718337259.png)

**直接编辑RS的资源**

![1564718726843](assets/1564718726843.png)

```
把replicas更改为5个
```

**更改容器的版本为v2**

![1564718816998](assets/1564718816998.png)

![1564718873710](assets/1564718873710.png)

```
此时的pod 的依然为v1， 只有在重建是才为 v2
```

![1564718932149](assets/1564718932149.png)

```
此时就可以人为的 手动的删除响应的pod，自动创建后为新版白的，进行金丝雀（灰度）的发布。

蓝绿部署：新建另一个RS部署完成后，再把service导入到部署完成后的服务
```

**deployment 实现的滚动发布**

![1564719478195](assets/1564719478195.png)

```
在v2 版本的所有pod 创建完成后 RS v1 并不会删除，便于回滚
```

![1564719711859](assets/1564719711859.png)

![1564719818558](assets/1564719818558.png)

```
一个Deployment 可以管理多个的 RS，只有一个RS 处于活跃的状态，默认保留10个 RS版本
Deployment 还可以控制更新的节奏和更新逻辑
```

#### Deployment 更新策略

![1564722756982](assets/1564722756982.png)

![1564722825860](assets/1564722825860.png)

```
rollingUpdate: 
	maxSurge: 更新过程中，最多超出目标副本数几个，可以使用数量个 百分比
	maxUnavailable: 最多可以有多少个不可用
```

#### Deployment 清单配置

![1564723115382](assets/1564723115382.png)

![1564723171483](assets/1564723171483.png)

```
apply 是一种 声明式更新，既可以创建，也可以更新，可以执行多次，不像create 创建一次，在创建会报错
```

![1564723305650](assets/1564723305650.png)

```
deployment 的名称是在 配置清单中定义的
rs 由 deployment 创建，它的名字由 deployment的名字，加上 模板（template）清单的哈希值 进行定义
pods 的名字则由 rs 的名字，后面跟上随机的字符串
```

![1564723502032](assets/1564723502032.png)

```
更改副本为3个，可以看到 RS的名字的hash 值没有变化，因为 deployment中的 template 定义没有变化
```

![1564723657807](assets/1564723657807.png)

```
annotations 在每次的更新之后，会记录版本的变化
默认的更新策略为 RollingUpdate
```

#### **更改配置文件为v2**

![1564723821605](assets/1564723821605.png)

![1564723837729](assets/1564723837729.png)

```
重新apply 改动，进行更新
```

![1564723899927](assets/1564723899927.png)

```
创建新的 pod 进入到 pending 状态，可以看到RS的名字 改变了，因为 模板（template）进行了变动，hash值改变
```

![1564724096108](assets/1564724096108.png)

```
老版本的 RS 仍然还在，方便回滚
```

#### **查看Deployment myapp-deploy 的历史版本**

![1564724248709](assets/1564724248709.png)

#### 通过 patch 的方式更新

![1564724406013](assets/1564724406013.png)

![1564724614368](assets/1564724614368.png)

#### 使用pause 在更新一个后暂停更新

![1564724786088](assets/1564724786088.png)

![1564724831157](assets/1564724831157.png)

```
可以看到 在更新一个后，暂停更新，模拟了金丝雀发布。
```

![1564724916165](assets/1564724916165.png)

```
使用 rollout status 也可以查看 更新的状态
```

#### 使用 resume 更新其余的

![1564725078587](assets/1564725078587.png)

![1564725105155](assets/1564725105155.png)

![1564725007306](assets/1564725007306.png)

![1564725026436](assets/1564725026436.png)

```
看到 所有的都更新到了 v3 版本
```

#### rollout undo 进行版本的回滚

![1564725301324](assets/1564725301324.png)

```
回滚到第一版之后，在回滚则回滚到上一版则是 第三版本
```

![1564725358373](assets/1564725358373.png)

#### DaemonSet的清单配置

![1564725810812](assets/1564725810812.png)

```
kind 的类型为 DaemonSet 
使用的镜像为 filebeat，这个镜像需要存在环境变量 REDIS_HOST 和 REDIS_LOG_LEVEL
```

![1564725904281](assets/1564725904281.png)

```
可以看到创建了分割的 ds 的pod，因为 worker节点有两个，master节点允许创建pod
```

#### 多个相关联的pod 定义在一个资源清单文件中

![1564726091086](assets/1564726091086.png)

```
使用 --- 进行隔开
```

#### 对DaemonSet 资源进行更新

![1564726668576](assets/1564726668576.png)

### k8s 中的Service 资源

```
service的实现模式：
	1. userspace 在用户空间依靠kube-proxy 进程代为转发，淡然也依赖于iptables 规则，过于低效
	2. iptables  从用户空间转向讷河空间
	3. ipvs 1.11 版本后默认使用ipvs，
```

**开启ipvs 负载**

![1564727257689](assets/1564727257689.png)

```
service的四种类型：
	1. ClusterIP ：只能在集群的内部进行访问
	2. NodePort: 
		client -> NodeIP:NodePort -> ClusterIP:ServicePort -> PodIP:containerPort
		这种方式需要将流量接入到 集群的所有的NodeIP 上分散请求压力。在NodeIP 和NodePort 之前添加 负责局衡器。
	3. LoadBalancer: 只有在公有云上才能使用，并支持LBAAS,就可以利用底层的 api 创建负载均衡
	4. ExternalName： 把集群外部的服务映射进集群内部，当pod 需要访问集群外部的服务的时候
		FQDN 的名称：主机名或域名，通常是别名记录
			CNAME 记录 -> 真正的FQDN
			内部定义个内部的名称，经CoreDNS 解析后CNAME到 真正的外部服务的地址

No ClusterIP : Headless Service 
	会把servername 直接解析到 PodIP ,本来应该解析到，serviceIP 的。
```

