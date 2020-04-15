## LVS学习笔记

[TOC]

**参考博客：**

1. http://www.zsythink.net/archives/2134
2. https://www.cnblogs.com/wdliu/archive/2019/01/16/10279091.html



## 一、LVS介绍

### 简介



  LVS是Linux Virtual Server的简称，即Linux虚拟服务器，创始人前阿里云首席科学家章文嵩博士(现已经在滴滴)，官方网站：[www.linuxvirtualserver.org](http://www.linuxvirtualserver.org/)。从内核版本2.4开始，已经完全内置了LVS的各个功能模块，无需给内核打任何补丁，可以直接使用LVS提供的各种功能。通过LVS提供的负载均衡技术和Linux操作系统可实现一个高性能、高可用的服务器群集，它具有良好可靠性、可扩展性和可操作性，以低廉的成本实现最优的服务性能。

 

### 通用体系结构

　　LVS集群采用IP负载均衡技术和基于内容请求分发技术。调度器具有很好的吞吐率，将请求均衡地转移到不同的服务器上执行，且调度器自动屏蔽掉服 务器的故障，从而将一组服务器构成一个高性能的、高可用的虚拟服务器。整个服务器集群的结构对客户是透明的，而且无需修改客户端和服务器端的程序，以下是体系结构图（来源http://www.linuxvirtualserver.org/architecture.html）：

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116185753682-439203785.png)

 



- 负载调度器（load balancer），它是整个集群对外面的前端机，负责将客户的请求发送到一组服务器上执行。
- 服务器池（server pool），是一组真正执行客户请求的服务器，可以是WEB、MAIL、FTP和DNS服务器等。
- 共享存储（shared storage），它为服务器池提供一个共享的存储区，这样很容易使得服务器池拥有相同的内容，提供相同的服务，例如数据库、分布式文件系统、网络存储等。

###  优缺点

- 高并发连接：LVS基于内核网络层面工作，有超强的承载能力和并发处理能力。单台LVS负载均衡器，可支持上万并发连接。稳定性强：是工作在网络4层之上仅作分发之用，这个特点也决定了它在负载均衡软件里的性能最强，稳定性最好，对内存和cpu资源消耗极低。
- 成本低廉：硬件负载均衡器少则十几万，多则几十万上百万，LVS只需一台服务器和就能免费部署使用，性价比极高。
- 配置简单：LVS配置非常简单，仅需几行命令即可完成配置，也可写成脚本进行管理。
- 支持多种算法：支持8种负载均衡算法，可根据业务场景灵活调配进行使用。
- 支持多种工作模型：可根据业务场景，使用不同的工作模式来解决生产环境请求处理问题。
- 应用范围广：因为LVS工作在4层，所以它几乎可以对所有应用做负载均衡，包括http、数据库、DNS、ftp服务等等。
- 缺点：工作在4层，不支持7层规则修改，机制过于庞大，不适合小规模应用。

### 组件和专业术语



组件：

- ipvsadm：用户空间的客户端工具，用于管理集群服务及集群服务上的RS等；
- ipvs：工作于内核上的netfilter INPUT钩子之上的程序，可根据用户定义的集群实现请求转发；

专业术语：

- VS：Virtual Server ，虚拟服务
- Director： Balancer ，也叫DS(Director Server)负载均衡器、分发器
- RS：Real Server ，后端请求处理服务器，真实服务器
- CIP: Client IP ，客户端IP
- VIP：Director Virtual IP ，负载均衡器虚拟IP
- DIP：Director IP ，负载均衡器IP
- RIP：Real Server IP ，后端请求处理的服务器IP

### 工作模型　　

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116190051164-475893235.png)



LVS工作在内核空间，基于内核包处理框架Netfilter实现的一种负责均衡技术，其在工作模式如上图,大致过程：

1. 当客户端的请求到达负载均衡器的内核空间时，首先会到达PREROUTING链。
2. 当内核发现请求**数据包的目的地址是本机时，将数据包送往INPUT链**。
3. LVS由用户空间的ipvsadm和内核空间的IPVS组成，**ipvsadm用来定义规则**，IPVS利用ipvsadm定义的规则工作，**IPVS工作在INPUT链上,当数据包到达INPUT链时，首先会被IPVS检查**，如果数据包里面的目的地址及端口没有在规则里面，那么这条数据包将被放行至用户空间。
4. 如果数据包里面的**目的地址及端口在规则里面**，那么这条数据报文将被修改目的地址为事先定义好的**后端服务器，并送往POSTROUTING链。**
5. 最后经由POSTROUTING链发往后端服务器。

## 二、负载均衡模式

### LVS-NAT模式

简介

　　NAT模式称为全称Virtualserver via Network address translation(VS/NAT)，是通过**网络地址转换的方法**来实现调度的。首先调度器(Director)接收到客户的请求数据包时（**请求的目的IP为VIP**），根据调度算法决定将请求发送给**哪个后端的真实服务器（RS）**。然后调度就把客户端发送的请求数据包的**目标IP地址及端口改成后端真实服务器的IP地址（RIP）**,这样真实服务器（RS）就能够接收到客户的请求数据包了。真实服务器响应完请求后，查看默认路由（NAT模式下我们需要把RS的默认路由设置为DS服务器。）把响应后的数据包发送给DS,DS再接收到响应包后，把包的源地址改成虚拟地址（VIP）然后发送回给客户端。

具体工作流程：

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116190530411-604304966.png)

说明：



(1)当用户请求到达DirectorServer，此时请求的数据报文会先到**内核空间的PREROUTING链**。 此时报文的源IP为CIP，目标IP为VIP。

(2) PREROUTING检查发现数据包的**目标IP是本机，将数据包送至INPUT链**。

(3) IPVS比对数据包请求的服务**是否为集群服务**，若是，修改数据包的**目标IP地址为后端服务器IP**，然后将数据包发至POSTROUTING链。 此时报文的源IP为CIP，目标IP为RIP ，在这个过程完成了目标IP的转换（DNAT）。

(4) POSTROUTING链通过选路，将数据包发送给Real Server。

(5) Real Server比对发现目标为自己的IP，开始构建响应报文发回给Director Server。 此时报文的源IP为RIP，目标IP为CIP 。

(6) Director Server在响应客户端前，此时会将源IP地址修改为自己的VIP地址（SNAT），然后响应给客户端。 此时报文的源IP为VIP，目标IP为CIP。 

 

NAT模式优缺点：

1. NAT技术将**请求的报文和响应的报文都需要通过DS进行地址改写**，因此网站访问量比较大的时候DS负载均衡调度器有比较大的瓶颈，一般要求最多**只能10-20台节点**。
2. 节省IP，只需要在DS上配置一个公网IP地址就可以了。
3. 每台内部的节点服务器的网关地址必须是调度器LB的内网地址。
4. NAT模式支持对IP地址和端口进行转换。即用户请求的端口和真实服务器的端口可以不一致。 

 

地址变化过程：

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116190645847-258974484.png)

### LVS-DR模式

简介

　　全称：Virtual Server via Direct Routing(VS-DR)，也叫**直接路由模式**，用直接路由技术实现虚拟服务器｡**当参与集群的计算机和作为控制管理的计算机在同一个网段时可以用此方法**,控制管理的计算机接收到请求包时直接送到参与集群的节点｡直接路由模式比较特别，很难说和什么方面相似，前种模式基本上都是工作在网络层上（三层），而**直接路由模式则应该是工作在数据链路层上（二层）**。

 

工作原理 

　　**DS和RS都使用同一个IP对外服务。但只有DS对ARP请求进行响应**，所有**RS对本身这个IP的ARP请求保持静默（对ARP请求不做响应）**，也就是说，网关会把对这个服务IP的请求全部定向给DS，而DS收到数据包后根据调度算法，找出对应的 RS，**把目的MAC地址改为RS的MAC并发给这台RS**。这时RS收到这个数据包，则等于直接从客户端收到这个数据包无异，处理后直接返回给客户端。**由于DS要对二层包头进行改换，所以DS和RS之间必须在一个广播域，也可以简单的理解为在同一台交换机上**。

 

工作流程

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116191020152-1992506935.png)



说明：

1. 当用户请求到达Director Server，此时请求的数据报文会先到内核空间的PREROUTING链。 此时报文的源IP为CIP，目标IP为VIP；
2. PREROUTING检查发现数据包的目标IP是本机，将数据包送至INPUT链；
3. IPVS比对数据包请求的服务是否为集群服务，**若是，将请求报文中的源MAC地址修改为DIP的MAC地址，将目标MAC地址修改RIP的MAC地址**，然后将数据包发至POSTROUTING链。 此时的源IP和目的IP均未修改，仅修改了源MAC地址为DIP的MAC地址，目标MAC地址为RIP的MAC地址；
4. 由于DS和RS在同一个网络中，所以是通过**二层，数据链路层来传输**。POSTROUTING链检查目标MAC地址为RIP的MAC地址，那么此时数据包将会发至Real Server；
5. RS发现请求报文的MAC地址是自己的MAC地址，就接收此报文。处理完成之后，将响应报文通过lo接口传送给eth0网卡然后向外发出。 此时的源IP地址为VIP，目标IP为CIP；
6. 响应报文最终送达至客户端。

地址变化过程

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116191229643-86150902.png)

 

 DR模式特点以及注意事项：



1. 在前端路由器做静态地址路由绑定，将对于VIP的地址仅路由到Director Server
2. 在arp的层次上实现在ARP解析时做防火墙规则，过滤RS响应ARP请求。**修改RS上内核参数（arp_ignore和arp_announce）将RS上的VIP配置在网卡接口的别名上，并限制其不能响应对VIP地址解析请求**。
3. RS可以使用私有地址；但也可以使用公网地址，此时可以直接通过互联网连入RS以实现配置、监控等；
4. **RS的网关一定不能指向DIP**；
5. 因为DR模式是通过MAC地址改写机制实现转发,RS跟Dirctor要在同一物理网络内（不能由路由器分隔）；
6. 请求报文经过Director，**但响应报文一定不经过Director**
7. 不支持端口映射；
8. RS可以使用大多数的操作系统；
9. RS上的lo接口配置VIP的IP地址; 

 

### LVS- TUN模式

介绍



  在LVS/NAT 的集群系统中，请求和响应的数据报文都需要通过负载调度器，当真实服务器的数目在10台和20台之间时，负载调度器将成为整个集群系统的新瓶颈。大多数 Internet服务都有这样的特点：请求报文较短而响应报文往往包含大量的数据。如果能将请求和响应分开处理，即在负载调度器中只负责调度请求而响应直 接返回给客户，将极大地提高整个集群系统的吞吐量。

   IP隧道（IP tunneling）是**将一个IP报文封装在另一个IP报文的技术，这可以使得目标为一个IP地址的数据报文能被封装和转发到另一个IP地址。IP隧道技 术亦称为IP封装技术（IP encapsulation）**。IP隧道主要用于移动主机和虚拟私有网络（Virtual Private Network），在其中**隧道都是静态建立的，隧道一端有一个IP地址，另一端也有唯一的IP地址**。

  在TUN模式下，利用IP隧道技术将**请求报文封装转发给后端服务器，响应报文能从后端服务器直接返回给客户**。但在这里，后端服务器有一组而非一个，所以我们不可能静态地建立一一对应的隧道，而是**动态地选择 一台服务器，将请求报文封装和转发给选出的服务器**。

 

工作流程

1. 客户端将请求发往前端的负载均衡器，请求报文源地址是CIP，目标地址为VIP。
2. 负载均衡器收到报文后，发现请求的是在规则里面存在的地址，那么它将在**客户端请求报文的首部再封装一层IP报文,将源地址改为DIP，目标地址改为RIP,并将此包发送给RS。**
3. RS收到请求报文后，会首先**拆开第一层封装,然后发现里面还有一层IP首部的目标地址是自己lo接口上的VIP，所以会处理次请求报文，并将响应报文通过lo接口送给eth0网卡直接发送给客户端**。注意：需要**设置lo接口的VIP不能在公网上出现**

地址变化过程

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116191747646-1610469180.png)

 

 

### FULL-NAT模式

　　

介绍

  FULL-NAT模式可以实际上是根据**LVS-NAT模式的一种扩展**。在NAT模式下DS需要先对请求进行目的地址转换(DNAT)，然后对响应包进行源地址转换（SNAT），先后进行**两次NAT**，而 FULL-NAT则**分别对请求进行和响应进行DNAT和SNAT，进行4次NAT**，当然这样多次数的NAT会对性能大大削减，但是由于对请求报文的目的地址和源地址都进行了转换，**后端的RS可以不在同一个VLAN下**。 

 

工作流程

![img](https://img2018.cnblogs.com/blog/1075473/201901/1075473-20190116191840240-469445708.png)

 

说明：

1. 首先client 发送请求package给VIP;
2. VIP 收到package后，会根据LVS设置的LB算法选择一个合适的RS，然后把package 的目地址修改为RS的ip地址，把源地址改成DS的ip地址；
3. RS收到这个package后发现目标地址是自己，就处理这个package ，处理完后把这个包发送给DS；
4. DS收到这个package 后把源地址改成VIP的IP，目的地址改成CIP(客户端ip)，然后发送给客户端；



优缺点：

1. RIP，DIP可以使用私有地址；
2. **RIP和DIP可以不再同一个网络中，且RIP的网关未必需要指向DIP**；
3. 支持端口映射；
4. RS的OS可以使用任意类型；
5. 请求报文经由Director，响应报文也经由Director；
6. FULL-NAT因为要经过4次NAT，所以性能比NAT还要低；
7. 由于做了源地址转换，RS无法获取到客户端的真实IP； 

 

### 各个模式的区别 



lvs-nat与lvs-fullnat：请求和响应报文都**经由Director**

  　　lvs-nat：**RIP的网关要指向DIP**

 　　 lvs-fullnat：**RIP和DIP未必在同一IP网络，但要能通信**

lvs-dr与lvs-tun：**请求报文要经由Director，但响应报文由RS直接发往Client**

 　　 lvs-dr：通过**封装新的MAC首部实现，通过MAC网络转发**

 　　 lvs-tun：通过在原IP报文**外封装新IP头实现转发，支持远距离通信**

 

## 三、调度算法 



LVS在内核中的负载均衡调度是以连接为粒度的。在HTTP协议（非持久）中，每个对象从WEB服务器上获取都需要建立一个TCP连接，同一用户 的不同请求会被调度到不同的服务器上，所以这种细粒度的调度在一定程度上可以避免单个用户访问的突发性引起服务器间的负载不平衡。在内核中的连接调度算法上，IPVS已实现了以下八种调度算法：

- 轮叫调度rr（Round-Robin Scheduling）
- 加权轮叫调度wrr（Weighted Round-Robin Scheduling）
- 最小连接调度lc（Least-Connection Scheduling）
- 加权最小连接调度wlc（Weighted Least-Connection Scheduling）
- 基于局部性的最少链接LBLC（Locality-Based Least Connections Scheduling）
- 带复制的基于局部性最少链接LBLCR（Locality-Based Least Connections with Replication Scheduling）
- 目标地址散列调度DH（Destination Hashing Scheduling）
- 源地址散列调度SH（Source Hashing Scheduling）



### rr（轮询）

　　轮询调度：这种是最简单的调度算法，调度器把用户请求按顺序1:1的分配到集群中的每个Real Server上，这种算法平等地对待每一台Real Server，而不管服务器的压力和负载状况。

### wrr（权重, 即加权轮询）

   加权轮叫调度（Weighted Round-Robin Scheduling）算法可以**解决服务器间性能不一的情况**，它用相应的权值表示服务器的处理性能，服务器的缺省权值为1。假设服务器A的权值为1，B的 权值为2，**则表示服务器B的处理性能是A的两倍**。加权轮叫调度算法是按权值的高低和轮叫方式分配请求到各服务器。权值高的服务器先收到的连接，权值高的服 务器比权值低的服务器处理更多的连接，相同权值的服务器处理相同数目的连接数

### sh（源地址哈希）

　　源地址散列：主要是实现将**此前的session（会话）绑定**。将此前客户的**源地址作为散列键**，从静态的散列表中找出对应的服务器，只要目标服务器是没有超负荷的就将请求发送过去。就是说某客户访问过A,现在这个客户又来了，所以客户请求会被发送到服务过他的A主机。

### dh（目的地址哈希）

　　目标地址散列调度（Destination Hashing Scheduling）算法也是针对**目标IP地址的负载均衡**，但它是一种静态映射算法，通过一个散列（Hash）函数将一个目标IP地址映射到一台服务器。

### lc（最少链接）

　　最小连接调度（Least-Connection Scheduling）**算法是把新的连接请求分配到当前连接数最小的服务器**。最小连接调度是一种动态调度算法，它通过服务器当前所活跃的连接数来估计服务 器的负载情况。调度器需要记录各个服务器已建立连接的数目，当一个请求被调度到某台服务器，其连接数加1；当连接中止或超时，其连接数减一。

### wlc（加权最少链接）LVS的理想算法

   加权最小连接调度（Weighted Least-Connection Scheduling）算法是最小连接调度的超集，**各个服务器用相应的权值表示其处理性能。服务器的缺省权值为1，系统管理员可以动态地设置服务器的权 值**。加权最小连接调度在调度新连接时尽可能使服务器的已建立连接数和其权值成比例。 

### LBLC（基于局部性的最少连接）

　　这个算法主要**用于Cache集群系统**，因为Cache集群的中客户请求报文的目标IP地址的变化，将相同的目标URL地址请求调度到同一台服务器，来提高服务器的**访问的局部性和Cache命中率**。从而调整整个集群的系统处理能力。但是，如果realserver的负载处于一半负载，就用最少链接算法，将请求发送给活动链接少的主机。 

### LBLCR（带复制的基于局部性的最少链接）

　　该算法首先是基于最少链接的，当一个新请求收到后，一定会将请求发给最少连接的那台主机的。但这样又破坏了cache命中率。但这个算法中，**集群服务是cache共享的，假设A的PHP跑了一遍，得到缓存。但其他realserver可以去A那里拿缓存，这是种缓存复制机制**。

 

## 四、管理工具ipvsadm使用

　　 ipvsadm是LVS的管理工具，ipvsadm工作在用户空间，用户通过ipvsadm命令编写负载均衡规则。

### 安装

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
yum install ipvsadm -y 
###文件说明
Unit 文件: ipvsadm.service
主程序：/usr/sbin/ipvsadm
规则保存工具：/usr/sbin/ipvsadm-save
规则重载工具：/usr/sbin/ipvsadm-restore
配置文件：/etc/sysconfig/ipvsadm-config
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### 用法以及参数

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
ipvsadm --help #查看使用方法及参数
命令：
-A, --add-service： #添加一个集群服务. 即为ipvs虚拟服务器添加一个虚拟服务，也就是添加一个需要被负载均衡的虚拟地址。虚拟地址需要是ip地址，端口号，协议的形式。
-E, --edit-service： #修改一个虚拟服务。
-D, --delete-service： #删除一个虚拟服务。即删除指定的集群服务;
-C, --clear： #清除所有虚拟服务。
-R, --restore： #从标准输入获取ipvsadm命令。一般结合下边的-S使用。
-S, --save： #从标准输出输出虚拟服务器的规则。可以将虚拟服务器的规则保存，在以后通过-R直接读入，以实现自动化配置。
-a, --add-server： #为虚拟服务添加一个real server（RS）
-e, --edit-server： #修改RS
-d, --delete-server： #删除
-L, -l, --list： #列出虚拟服务表中的所有虚拟服务。可以指定地址。添加-c显示连接表。
-Z, --zero： #将所有数据相关的记录清零。这些记录一般用于调度策略。
--set tcp tcpfin udp： #修改协议的超时时间。
--start-daemon state： #设置虚拟服务器的备服务器，用来实现主备服务器冗余。（注：该功能只支持ipv4）
--stop-daemon： #停止备服务器。

 
参数：
以下参数可以接在上边的命令后边。
-t, --tcp-service service-address： #指定虚拟服务为tcp服务。service-address要是host[:port]的形式。端口是0表示任意端口。如果需要将端口设置为0，还需要加上-p选项（持久连接）。
-u, --udp-service service-address： #使用udp服务，其他同上。
-f, --fwmark-service integer： #用firewall mark取代虚拟地址来指定要被负载均衡的数据包，可以通过这个命令实现把不同地址、端口的虚拟地址整合成一个虚拟服务，可以让虚拟服务器同时截获处理去往多个不同地址的数据包。fwmark可以通过iptables命令指定。如果用在ipv6需要加上-6。
-s, --scheduler scheduling-method： #指定调度算法,默认是wlc。调度算法可以指定以下8种：rr（轮询），wrr（权重），lc（最后连接），wlc（权重），lblc（本地最后连接），lblcr（带复制的本地最后连接），dh（目的地址哈希），sh（源地址哈希），sed（最小期望延迟），nq（永不排队）


-p, --persistent [timeout]： #设置持久连接，这个模式可以使来自客户的多个请求被送到同一个真实服务器，通常用于ftp或者ssl中。


-M, --netmask netmask： #指定客户地址的子网掩码。用于将同属一个子网的客户的请求转发到相同服务器。
-r, --real-server server-address： #为虚拟服务指定数据可以转发到的真实服务器的地址。可以添加端口号。如果没有指定端口号，则等效于使用虚拟地址的端口号。
[packet-forwarding-method]： #此选项指定某个真实服务器所使用的数据转发模式。需要对每个真实服务器分别指定模式。


-g, --gatewaying： ###使用网关（即直接路由），此模式是默认模式。###
-i, --ipip： ###使用ipip隧道模式。###
-m, --masquerading： ###使用NAT模式。###


-w, --weight weight:  #设置权重。权重是0~65535的整数。如果将某个真实服务器的权重设置为0，那么它不会收到新的连接，但是已有连接还会继续维持（这点和直接把某个真实服务器删除时不同的）。
-x, --u-threshold uthreshold： #设置一个服务器可以维持的连接上限。0~65535。设置为0表示没有上限。
-y, --l-threshold lthreshold： #设置一个服务器的连接下限。当服务器的连接数低于此值的时候服务器才可以重新接收连接。如果此值未设置，则当服务器的连接数连续三次低于uthreshold时服务器才可以接收到新的连接。
--mcast-interface interface： #指定使用备服务器时候的广播接口。
--syncid syncid：#指定syncid， 同样用于主备服务器的同步。
 
#以下选项用于list(-l)命令：
-c, --connection： #列出当前的IPVS连接。
--timeout： #列出超时
--stats： #状态信息
--rate： #传输速率
--thresholds： #列出阈值
--persistent-conn： #持久连接
--sor： #把列表排序
--nosort： #不排序
-n, --numeric： #不对ip地址进行dns查询
--exact： #单位
-6： 如#果fwmark用的是ipv6地址需要指定此选项。    
     
#如果使用IPv6地址，需要在地址两端加上"[]"。例如：ipvsadm -A -t [2001:db8::80]:80 -s rr
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### LVS集群管理示例

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
####管理LVS集群中的RealServer举例
1) 添加RS : -a
# ipvsadm -a -t|u|f service-address -r server-address [-g|i|m] [-w weight]
  
#举例1: 往VIP资源为10.1.210.58的集群服务里添加1个realserver
ipvsadm -a -t 10.1.210.58 -r 10.1.210.52 –g -w 5

  
2) 修改RS : -e
# ipvsadm -e -t|u|f service-address -r server-address [-g|i|m] [-w weight]
  
#举例2: 修改10.1.210.58集群服务里10.1.210.52这个realserver的权重为3
ipvsadm -e -t 10.1.210.58:80 -r 10.1.210.52 –g -w 3
  
3) 删除RS : -d
# ipvsadm -d -t|u|f service-address -r server-address
  
#举例3: 删除10.1.210.58集群服务里10.1.210.52这个realserver
ipvsadm -d -t 10.1.210.58:80 -r 10.1.210.52


4) 清除规则 (删除所有集群服务), 该命令与iptables的-F功能类似，执行后会清除所有规则:
# ipvsadm -C
  
5) 保存及读取规则：
# ipvsadm -S > /path/to/somefile
# ipvsadm-save > /path/to/somefile
# ipvsadm-restore < /path/to/somefile


####管理LVS集群服务的查看
# ipvsadm -L|l [options]
   options可以为：
   -n：数字格式显示
   --stats 统计信息
   --rate：统计速率
   --timeout：显示tcp、tcpinfo、udp的会话超时时长
   -c：连接客户端数量
  
#查看lvs集群转发情况
# ipvsadm -Ln

  
#查看lvs集群的连接状态
# ipvsadm -l --stats

  
说明：
Conns    (connections scheduled)  已经转发过的连接数
InPkts   (incoming packets)       入包个数
OutPkts  (outgoing packets)       出包个数
InBytes  (incoming bytes)         入流量（字节）
OutBytes (outgoing bytes)         出流量（字节）
  
#查看lvs集群的速率
ipvsadm -l --rate
  
说明：
CPS      (current connection rate)   每秒连接数
InPPS    (current in packet rate)    每秒的入包个数
OutPPS   (current out packet rate)   每秒的出包个数
InBPS    (current in byte rate)      每秒入流量（字节）
OutBPS   (current out byte rate)      每秒入流量（字节）
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

## 五、案例篇



### 环境

服务器系统：centos7.4

调度服务器DS：10.1.210.51

两台真实服务RS：10.1.210.52、10.1.210.53

VIP:10.1.210.58 

### LVS-DR模式案例

　　 centos7默认已经将ipvs编译进内核模块，名称为ip_vs,使用时候需要先加载该内核模块。

以下步骤需要在DS上进行：

1.加载ip_vs模块

```
modprobe ip_vs #加载ip_vs模块
cat /proc/net/ip_vs #查看是否加载成功
lsmod | grep ip_vs   #查看加载的模块
yum install ipvsadm # 安装管理工具
```

2.配置调度脚本dr.sh

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
#!/bin/bash

VIP=10.1.210.58  #虚拟IP
RIP1=10.1.210.52 #真实服务器IP1
RIP2=10.1.210.53 #真实服务器IP2
PORT=80 #端口
ifconfig ens192:1 $VIP broadcast $VIP netmask 255.255.255.255 up #添加VIP,注意网卡名称
echo 1 > /proc/sys/net/ipv4/ip_forward    #开启转发
 route add -host $VIP dev ens192:1    #添加VIP路由
/sbin/ipvsadm -C      #清空ipvs中的规则
/sbin/ipvsadm -A -t $VIP:80 -s wrr  #添加调度器
/sbin/ipvsadm -a -t $VIP:80 -r $RIP1 -g -w 1 #添加RS
/sbin/ipvsadm -a -t $VIP:80 -r $RIP2 -g -w 1 #添加RS
/sbin/ipvsadm -ln  #查看规则
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

3.执行脚本

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@app51 ~]# sh dr.sh
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  10.1.210.58:80 wrr
  -> 10.1.210.52:80               Route   1      0          0         
  -> 10.1.210.53:80               Route   1      0          0 
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

以下步骤需要在RS上执行：

1.真实服务RS配置脚本rs.sh

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
#!/bin/bash
VIP=10.1.210.58  #RS上VIP地址
#关闭内核arp响应，永久修改配置参数到/etc/sysctl.conf，目的是为了让rs顺利发送mac地址给客户端
 echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore     
 echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
 echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
 echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
ifconfig lo:0 $VIP broadcast $VIP netmask 255.255.255.255 up  #绑定VIP到RS服务器上
/sbin/route add -host $VIP dev lo:0  #添加VIP路由
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

2.执行脚本

```
sh rs.sh
```

3.配置测试web服务（以一台为示例）

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
systemctl stop firewalld  #关闭防火墙
systemctl disable firewalld #禁止开机启动
yum install httpd #安装httpd


###RS1虚拟主机配置
vi /etc/httpd/conf/httpd.conf
ServerName 10.1.210.52:80
echo "RS 10.1.210.52" > /var/www/html/index.html

###RS2虚拟主机配置

vi /etc/httpd/conf/httpd.conf
ServerName 10.1.210.53:80
echo "RS 10.1.210.53" > /var/www/html/index.html

#启动httpd服务
systemctl start httpd
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)



测试

调度算法是轮训，所以结果是交替出现 。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@node1 ~]# for i in {1..10} ;do curl http://10.1.210.58 ;done
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### LVS-NAT案例

　　LVS-NAT模式和DR区别要做nat，并且请求和响应都要经过DS，所有需要将RS网关指向DS,由于之前测试过DR模式，在测试NAT模式时候需要将RS环境恢复，RS恢复步骤如下：

```
echo 0 >/proc/sys/net/ipv4/conf/lo/arp_ignore     
echo 0 >/proc/sys/net/ipv4/conf/lo/arp_announce
echo 0 >/proc/sys/net/ipv4/conf/all/arp_ignore
echo 0 >/proc/sys/net/ipv4/conf/all/arp_announce
ifconfig lo:0 down
```



调度服务DS配置

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
#!/bin/bash

VIP=10.1.210.58  #虚拟IP
RIP1=10.1.210.52 #真实服务器IP1
RIP2=10.1.210.53 #真实服务器IP2
PORT=80 #端口
ifconfig ens192:1 $VIP broadcast $VIP netmask 255.255.255.255 up #添加VIP
echo 1 > /proc/sys/net/ipv4/ip_forward    #开启转发
 route add -host $VIP dev ens192:1    #添加VIP路由
/sbin/ipvsadm -C      #清空ipvs中的规则
/sbin/ipvsadm -A -t $VIP:80 -s wlc  #添加调度器
/sbin/ipvsadm -a -t $VIP:80 -r $RIP1 -m -w 1 #添加RS
/sbin/ipvsadm -a -t $VIP:80 -r $RIP2 -m -w 1 #添加RS
/sbin/ipvsadm -ln  #查看规则
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

RS配置

　　nat模式RS配置很简单，只需要将RS路由指向DS

```
vi /etc/sysconfig/network-scripts/ifcfg-ens192 
GATEWAY=10.1.210.58 #修改网关至RS地址
systemctl restart network #重启网络
```

测试

　　 由于这里的环境DS和RS在同一个网段下，NAT模式下如果客户端是同网段情况下，RS响应的时候直接响应给同网段的服务器了并不经过DS，这样就导致客户端会丢弃该请求。如果想要同网段的想要访问到DS则需要添加路由，这里需要RS在响应同网段服务器时候网关指向DS，这样同网段就能访问到DS了，示例：

```
route add -net 10.1.210.0/24 gw 10.1.210.58
```

测试结果：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@app36 ~]# for i in {1..10} ; do curl http://10.1.210.58 ;done
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
RS 10.1.210.53
RS 10.1.210.52
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

## 六、持久连接

### 什么是持久连接

　　在LVS中，持久连接是为了用来保证当来自同一个用户的请求时能够定位到同一台服务器，目的是为了会话保持，而通常使用的会话保持技术手段就是cookie与session。

### cookie与session简述

　　 在Web服务通信中，**HTTP本身是无状态协议，不能标识用户来源**，当用户在访问A网页，再从A网页访问其他资源跳转到了B网页，**这对于服务器来说又是一个新的请求**，之前的登陆信息都没有了，怎么办？为了记录用户的身份信息，开发者在浏览器和服务器之间提供了cookie和session技术，**简单说来在你浏览网页时候，服务器建立session用于保存你的身份信息，并将与之对应的cookie信息发送给浏览器，浏览器保存cookie**，当你再次浏览该网页时候，服务器检查你的浏览器中的cookie并获取与之对应的session数据，这样一来你上次浏览网页的数据依然存在。

### 4层均衡负载导致的问题

　　由于cookie和session技术是**基于应用层（七层）,而LVS工作在4层**，只能根据**IP地址和端口进行转发**，不能根据应用层信息进行转发，所以就存在了问题。比如LVS集群RS是三台，A用户登陆后请求在由第一台处理，而A用户跳转到了另一个页面请求经过DS转发到第二台服务器，**但是此时这台服务器上并没有session**，用户的信息就没有了，显然这是不能接受的。为了避免上述的问题，一般的解决方案有三种：

1. 将来自于**同一个用户的请求发往同一个服务器**(例如nginx的ip_hash算法)；
2. 将session信息在**服务器集群内共享，每个服务器都保存整个集群的session信息**；
3. 建立一个session存储池，所有session信息都保存到存储池中 ；

LVS会话保持实现方式就是通过将来**自于同一个用户的请求发往同一个服务器，具体实现分为sh算法和持久连接**：



sh算法：使用SH算法，SH算法在**内核中会自动维护一个哈希表，此哈希表中用每一个请求的源IP地址经过哈希计算得出的值作为键，把请求所到达的RS的地址作为值**。在后面的请求中，每一个请求会先经过此哈希表，如果请求在此哈希表中有键值，那么直接定向至特定RS，如没有，则会新生成一个键值，以便后续请求的定向。但是此种方法在时间的记录上比较模糊（依据TCP的连接时长计算），而且其是算法本身，所以无法与算法分离，并不是特别理想的方法。

 

 **持久连接：**此种方法实现了无论使用哪一种调度方法，**持久连接功能都能保证在指定时间范围之内**，来自于同一个IP的请求将始终被定向至同一个RS，还可以把多种服务绑定后统一进行调度。 

　　详细一点说来：当用户请求到达director时。无论使用什么调度方法，**都可以实现对同一个服务的请求在指定时间范围内始终定向为同一个RS**。在director内有一个**LVS持久连接模板，模板中记录了每一个请求的来源、调度至的RS、维护时长等等**，所以，在新的请求进入时，首先在此模板中检查是否有记录（有内置的时间限制，比如限制是300秒，当在到达300秒时依然有用户访问，那么**持久连接模板就会将时间增加两分钟，再计数**，依次类推，每次只延长2分钟），如果该记录未超时，则使用该记录所指向的RS，如果是超时记录或者是新请求，则会根据调度算法先调度至特定RS，再将调度的记录添加至此表中。这并不与SH算法冲突，lvs持久连接会在新请求达到时，检查后端RS的负载状况，**这就是比较精细的调度和会话保持方法**。

 

### LVS的三种持久连接方式



PCC：**每客户端持久**；将来自于**同一个客户端的所有请求统统定向至此前选定的RS**；也就是只要IP相同，分配的服务器始终相同。

 

PPC：**每端口持久**；将来**自于同一个客户端对同一个服务(端口)的请求**，始终定向至此前选定的RS。例如：来自同一个IP的用户第一次访问集群的80端口分配到A服务器，25号端口分配到B服务器。当之后这个用户继续访问80端口仍然分配到A服务器，25号端口仍然分配到B服务器。

 

PFMC：**持久防火墙标记连接**；将来自于同一客户端对指定服务(端口)的请求，始终定向至此选定的RS；**不过它可以将两个毫不相干的端口定义为一个集群服务**，例如：合并http的80端口和https的443端口定义为同一个集群服务，**当用户第一次访问80端口分配到A服务器，第二次访问443端口时仍然分配到A服务器。** 

### 示例

　　LVS的持久连接功能需要定义在集群服务上面，使用-p timeout选项。

PPC：

```
[root@localhost ~]# ipvsadm -At 10.1.210.58:80 -s rr -p 300
  #上面命令的意思是：添加一个集群服务为10.1.210.58:80，使用的调度算法为rr，持久连接的保持时间是300秒。当超过300秒都没有请求时，则清空LVS的持久连接模板。
```

PCC：

```
# ipvsadm -A -t 10.1.210.58:0 -s rr -p 600
# ipvsadm -a -t 10.1.210.58:0 -r 10.1.210.52 -g -w 2
# ipvsadm -a -t 10.1.210.58:0 -r 0.1.210.53 -g -w 1
```

PFMC：

```
###### PNMPP是通过路由前给数据包打标记来实现的
# iptables -t mangle -A PREROUTING -d 10.1.210.58 -ens192 -p tcp --dport 80 -j MARK --set-mark 3
# iptables -t mangle -A PREROUTING -d 10.1.210.58 -ens192 -p tcp --dport 443 -j MARK --set-mark 3
# ipvsadm -A -f 3 -s rr -p 600
# ipvsadm -a -f 3 -r 10.1.210.52 -g -w 2
# ipvsadm -a -f 3 -r 10.1.210.52 -g -w 2
```