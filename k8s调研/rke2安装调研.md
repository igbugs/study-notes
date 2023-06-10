## rke2安装调研

### rke2 server安装

```
curl -sfL http://rancher-mirror.rancher.cn/rke2/install.sh | INSTALL_RKE2_MIRROR=cn sh -

systemctl enable rke2-server.service
systemctl start rke2-server.service    ## 可能时间比较长，需要拉取所需的镜像
```

```
[root@node1 ~]# ls -l /var/lib/rancher/rke2/bin/    ## rke2提供的命令
-rwxr-xr-x 1 root root  54120392 5月  18 16:49 containerd
-rwxr-xr-x 1 root root   7369488 5月  18 16:49 containerd-shim
-rwxr-xr-x 1 root root  11527464 5月  18 16:49 containerd-shim-runc-v1
-rwxr-xr-x 1 root root  11539944 5月  18 16:49 containerd-shim-runc-v2
-rwxr-xr-x 1 root root  34985144 5月  18 16:49 crictl
-rwxr-xr-x 1 root root  20463560 5月  18 16:49 ctr
-rwxr-xr-x 1 root root  48746480 5月  18 16:49 kubectl
-rwxr-xr-x 1 root root 119735752 5月  18 16:49 kubelet
-rwxr-xr-x 1 root root  11068888 5月  18 16:50 runc

ln -s /var/lib/rancher/rke2/bin/kubectl  /usr/bin/kubectl
ln -s /var/lib/rancher/rke2/bin/ctr /usr/bin/ctr
ln -s /var/lib/rancher/rke2/bin/crictl /usr/bin/crictl
```

![image-20220518174648639](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220518174648639.png)

rke2 server端所需要的镜像

```
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml       ## 配置KUBECONFIG

或
mkdir -p ~/.kube/
cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
```

![image-20220518174730855](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220518174730855.png)

server端启动之后启动的pod

**配置rke2 server config.yaml**

获取节点token

![image-20220518180719006](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220518180719006.png)

![image-20220518183951852](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220518183951852.png)

```
# cat /etc/rancher/rke2/config.yaml   ## 创建此文件
server: https://my.edoc2.com:9345
token: K1099b7ea2afe40c86451a776bb56f7fda9af6c22150ea3d0dab2bb164e112035f1::server:15964c9f06185479c93af4adc36c28e8
tls-san:
  - my.edoc2.com
  - my.edoc3.com # 都是集群的别名，是tls证书所认证的别名或域名，需要认证的别名罗列在这里就可以被tls认证
node-name: "node1"
#node-taint:
#  - "CriticalAddonsOnly=true:NoExecute"
node-label:
  - "node=Master"
  - "node-name=node1"
```

重启 rke2-server 服务

```
# systemctl restart rke2-server.service 
# /var/lib/rancher/rke2/bin/kubectl get node
NAME    STATUS   ROLES                       AGE   VERSION
node1   Ready    control-plane,etcd,master   49m   v1.22.9+rke2r2
```

此时一个节点的rke2 安装完成

### 添加rke2 server节点

配置hosts解析

```
192.168.251.244 node1 my.edoc2.com my.edoc3.com
192.168.251.98 node2
192.168.251.249 node3
192.168.20.223 node4
```

第二个节点同样需要配置 config.yaml 文件（**这个文件需要在第二节点部署之前就创建完成**）

![image-20220518184119132](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220518184119132.png)

```
mkdir -p /etc/rancher/rke2
# cat /etc/rancher/rke2/config.yaml
server: https://my.edoc2.com:9345     ## 指定第一个server地址
token: K1099b7ea2afe40c86451a776bb56f7fda9af6c22150ea3d0dab2bb164e112035f1::server:15964c9f06185479c93af4adc36c28e8    ## 第一个server的token
tls-san:
  - my.edoc2.com
  - my.edoc3.com
node-name: "node2"
#node-taint:
#  - "CriticalAddonsOnly=true:NoExecute"
node-label:
  - "node=Master"
  - "node-name=node2"
```

```
## 进行第二个节点的安装
curl -sfL http://rancher-mirror.rancher.cn/rke2/install.sh | INSTALL_RKE2_MIRROR=cn sh -

systemctl enable rke2-server.service
systemctl start rke2-server.service    ## 可能时间比较长，需要拉取所需的镜像
```

![image-20220519171343658](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519171343658.png)

**同样的方法添加第三个节点**



**重启第二个节点，如果启动不了，出现以下报错**

![image-20220518192747051](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220518192747051.png)

```
这个是因为，进行 start rke2-server的时候，没有提前准备好 /etc/rancher/rke2/config.yaml（去配置第一个server节点的信息），启动的时候作为了初始化节点；
先进行了start rke2-server,后续添加config.yaml文件,在进行重启rke2-server，就会导致出现以上报错
```

### 添加rke2 agent 节点

```
curl -sfL http://rancher-mirror.rancher.cn/rke2/install.sh | INSTALL_RKE2_MIRROR=cn INSTALL_RKE2_TYPE="agent"  sh -
```

```
systemctl enable rke2-agent.service
```

配置hosts解析

```
192.168.251.244 node1 my.edoc2.com my.edoc3.com
192.168.251.98 node2
192.168.251.249 node3
192.168.20.223 node4
```

配置 config.yml 文件

```
[root@node4 ~]# cat /etc/rancher/rke2/config.yaml 
server: https://my.edoc2.com:9345
token: K1099b7ea2afe40c86451a776bb56f7fda9af6c22150ea3d0dab2bb164e112035f1::server:15964c9f06185479c93af4adc36c28e8
node-name: "node4"
node-label:
  - "node=worker"
  - "node-name=node4"
```

启动 rke2-agent

```
systemctl start rke2-agent.service     ## 注意启动的agent服务
```

### 部署应用测试

![image-20220520092722978](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220520092722978.png)

![image-20220520092738975](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220520092738975.png)

### 外部访问集群高可用配置

Apiserver统一入口（可选），为了方便外部访问集群，需要在集群实现统一入口，可以通过L4负载均衡器或vip地址或智能轮询DNS。集群内部已经通过rke2-agent实现了worker访问api-server的多入口反向代理

nginx配置示例：

```
events {
  worker_connections  1024;  ## Default: 1024
} 
stream {
    upstream kube-apiserver {
        server node1:6443     max_fails=3 fail_timeout=30s;
        server node2:6443     max_fails=3 fail_timeout=30s;
        server node3:6443     max_fails=3 fail_timeout=30s;
    }
    upstream rke2 {
        server node1:9345     max_fails=3 fail_timeout=30s;
        server node2:9345     max_fails=3 fail_timeout=30s;
        server node3:9345     max_fails=3 fail_timeout=30s;
    }
    server {
        listen 6443;
        proxy_connect_timeout 2s;
        proxy_timeout 900s;
        proxy_pass kube-apiserver;
    }
    server {
        listen 9345;
        proxy_connect_timeout 2s;
        proxy_timeout 900s;
        proxy_pass rke2;
    }
}
```

server端的 tls-san：

```
tls-san:
  - xxx.xxx.xxx.xxx   ## IP
  - www.xxx.com		  ## 域名
## 此处填写LB的统一入口ip地址或域名
```

kubeconfig配置：

![image-20220520093707416](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220520093707416.png)

### RKE2内部高可用实现

k8s集群的高可用针对：

- etcd：通过本身的 Raft 算法 Leader 选主机制，组成ETCD集群，实现 etcd 高可用。
- controller manager：leader election 选举竞争锁的机制来保证高可用
- scheduler：leader election 选举竞争锁的机制来保证高可用。
- apiserver：无状态，通过前端负载均衡实现高可用。

rke2集群中，containerd、kubelet组件集成到了rke2服务中，这点和k3s非常相式，同时在rke2服务中还集成了nginx服务，主要用于做为kubelet连接api-server的方向代理，RKE2 会帮助其他组件自动做HA。

当api-server有统一入口，所有请求走LB连接到api-server；

如果api-server没有统一入口，kubelet和rke2-agent去连接rke2-server时，会用一个server地址去注册即可，然后agent会获取 所有rke2 server 的地址，然后存储到 /var/lib/rancher/rke2/agent/etc/rke2-api-server-agent-load-balancer.json中，生成nginx反向代理配置

![image-20220520094822179](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220520094822179.png)

**rke2-agent Down:**

不会影响业务正常运行，因为containerd创建容器是通过containerd-shim-runc-v2调用runc创建，当containerd出现问题时containerd-shim-runc-v2会被init进程托管，不会导致退出影响现有业务POD。但需要注意的是**rke2-agent退出后kubelet也退出**了，对应的业务状态探测就没有了，在默认超时5分钟后，Controller-manager会将业务pod重建。

### 使用离线包安装

下载离线包

下载地址：https://github.com/rancher/rke2/releases

- rke2-images.linux-amd64.tar
- rke2.linux-amd64.tar.gz
- rke2-images-canal.linux-amd64.tar.gz（根据使用的网络插件）
- sha256sum-amd64.txt  （hash文件）

```
# mkdir /root/rke2_offline && cd /root/rke2_offline
curl -OLs https://github.com/rancher/rke2/releases/download/v1.21.5%2Brke2r2/rke2-images.linux-amd64.tar.zst
curl -OLs https://github.com/rancher/rke2/releases/download/v1.21.5%2Brke2r2/rke2.linux-amd64.tar.gz
curl -OLs https://github.com/rancher/rke2/releases/download/v1.21.5%2Brke2r2/sha256sum-amd64.txt
```

![image-20220519173055592](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519173055592.png)

下载安装脚本

```
curl -sfL https://get.rke2.io --output install.sh
```

进行安装

```
INSTALL_RKE2_ARTIFACT_PATH=/root/rke2_offline sh install.sh    # server端安装
INSTALL_RKE2_ARTIFACT_PATH=/root/rke2_offline INSTALL_RKE2_TYPE="agent" sh install.sh    # agent端安装
## 会把安装包放到相应的位置，配置好rke2 服务，并没有进行实际的安装
```

启动服务，进行安装

```
systemctl enable rke2-server.service 
systemctl start rke2-server.service 
```

### 配置自有仓库

配置registry.yaml 配置文件

```
mirrors:
  edoc2.com:
    endpoint:
      - "https://registry.edoc2.com:5000"
configs:
  "edoc2.com":
    auth:
      username: "ci"
      password: "1qaz@WSX"
#    tls:
#      cert_file: 
#      key_file: 
#      ca_file: 
#      insecure_skip_verify: true
```

### 升级

```
## 再次执行安装脚本，会升级到最新的稳定版本
curl -sfL http://rancher-mirror.rancher.cn/rke2/install.sh | INSTALL_RKE2_MIRROR=cn sh -

## 升级到指定版本
curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=vX.Y.Z-rc1 sh -
```

### 备份与恢复

**配置备份计划时间**

rke2会自动的进行快照的备份，默认每12小时生成一次快照。保存路径在：/var/lib/rancher/rke2/server/db/snapshots 下

更改rke2 的配置文件：（**所有master节点配置一致**）

```
[root@node1 ~]# cat /etc/rancher/rke2/config.yaml
server: https://my.edoc2.com:9345
token: K10d8ea6e640267b8a8019b43a8f4f19c39bf4a77d9880a4d4abdd058aa2db0a657::server:30b65290a2ab54ddd579282c40f82b9b
tls-san:
  - my.edoc2.com
  - my.edoc3.com
node-name: "node1"
#node-taint:
#  - "CriticalAddonsOnly=true:NoExecute"
node-label:
  - "node=Master"
  - "node-name=node1"
etcd-snapshot-retention: 2					## 快照的保存个数
etcd-snapshot-schedule-cron: "*/2 * * * *"	## 每两分钟备份一次
```

![image-20220519191459823](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519191459823.png)

![image-20220519192010357](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519192010357.png)

**进行恢复**

在进行集群恢复的时候mater节点需要停止所有的服务，worker节点只需要停掉rke2-agent服务

**第一个master节点操作：**

![image-20220519194101788](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519194101788.png)

```
使用rke2-killall.sh 停止所有服务
```

![image-20220519194451665](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519194451665.png)

```
rke2 server --cluster-reset --cluster-reset-restore-path=/var/lib/rancher/rke2/server/db/snapshots/etcd-snapshot-node1-1652960280
```

![image-20220519195800720](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519195800720.png)

恢复完成后，启动第一个节点

```
[root@node1 snapshots]# systemctl start rke2-server
```

第一个节点启动后会有以下状态

![image-20220519195938446](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519195938446.png)

**第二个master节点操作：**

第二个节点**备份db目录后，删除db数据目录**，重新从第一个节点恢复的数据同步最新数据

```
[root@node2 server]# pwd
/var/lib/rancher/rke2/server
[root@node2 server]# rm -rf db/          ## master 删除db目录
[root@node2 server]# systemctl start rke2-server   ## 重新启动server
```

第三个节点的操作和第二个节点操作相同

agent节点再master节点恢复后，重新启动 rke2-agent服务即可。

![image-20220520092046153](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220520092046153.png)

### 配置k8s组件参数

在/etc/rancher/rke2/config.yaml 文件中，按照对应组件，添加对应的参数，如apiserver对应为kube-apiserver-arg，组件对应参数为etcd-arg。kube-controller-manager-arg、kube-scheduler-arg、kubelet-arg、kube-proxy-arg

```
[root@node1 snapshots]# cat /etc/rancher/rke2/config.yaml
server: https://my.edoc2.com:9345
token: K10d8ea6e640267b8a8019b43a8f4f19c39bf4a77d9880a4d4abdd058aa2db0a657::server:30b65290a2ab54ddd579282c40f82b9b
tls-san:
  - my.edoc2.com
  - my.edoc3.com
node-name: "node1"
#node-taint:
#  - "CriticalAddonsOnly=true:NoExecute"
node-label:
  - "node=Master"
  - "node-name=node1"
etcd-snapshot-retention: 2
etcd-snapshot-schedule-cron: "*/2 * * * *"
kubelet-arg:
  - "eviction-hard=nodefs.available<1%,memory.available<10%"
  - "eviction-soft=nodefs.available<5%,imagefs.available<1%"
  - "eviction-soft-grace-period=nodefs.available=30s,imagefs.available=30s"
```

配置kubelet 进行pod驱逐的限制

重启rke2 server，查看kubelet进行参数

![image-20220519193149061](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519193149061.png)

### 停止服务及卸载

![image-20220519190436673](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519190436673.png)

```
执行以上命令即可
```



### 导出rke2安装所需要的镜像

安装配置 nerdctl 

```
# mkdir nerdctl && cd nerdctl
# wget https://github.com/containerd/nerdctl/releases/download/v0.20.0/nerdctl-0.20.0-linux-amd64.tar.gz
# tar -xf nerdctl-0.20.0-linux-amd64.tar.gz 
# cp nerdctl /usr/bin/
```

配置nerdctl 配置文件

![image-20220519100143523](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519100143523.png)

```
rke2 使用containerd指定的配置文件 /var/lib/rancher/rke2/agent/etc/containerd/config.toml启动
指定 -a /run/k3s/containerd/containerd.sock socket地址
```

![image-20220519100311665](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519100311665.png)

```
# mkdir /etc/nerdctl
cat > /etc/nerdctl/nerdctl.toml << 'EOF'
debug             = false
debug_full        = false
address           = "unix:///run/k3s/containerd/containerd.sock"
data_root         = "/var/lib/rancher/rke2/agent/containerd"
namespace         = "default"
snapshotter    	  = "overlayfs"
cgroup_manager 	  = "cgroupfs"
insecure_registry = true
EOF
```

**拉取镜像**

```
nerdctl pull busybox
```

![image-20220519184636083](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519184636083.png)

![image-20220519184712856](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519184712856.png)

使用nerdctl可以指定namespace去查看rke2的镜像，rke2的镜像在k8s.io名称空间

![image-20220519184440248](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519184440248.png)

**指定名称空间**

![image-20220519184807423](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519184807423.png)

**导出镜像到文件**

![image-20220519185216498](C:\Users\XYB\Desktop\k8s调研\rke2安装调研.assets\image-20220519185216498.png)



### 参考文档：

- https://mp.weixin.qq.com/s/GxrxKWaBUEx-bHWMgSvsmg
- https://blog.csdn.net/m0_49654228/article/details/120287498