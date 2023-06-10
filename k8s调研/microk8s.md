## microk8s 安装

microk8s 是 Canonical  的k8s 发行版，默认使用snap 进行安装，CentOS需要先安装 snap。

### CentOS安装 snap

​	snap安装需要在CentOS 7.6 + 才支持

1. 更换国内yum源

   ```
   mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
   wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
   sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo 
   yum makecache
   ```

2. 关闭防火墙

   ```
   systemctl stop firewalld.service            
   systemctl disable firewalld.service
   ```

3. 关闭selinux

   ```
   setenforce 0
   [root@node1 ~]# cat /etc/selinux/config 
   SELINUX=disabled
   ```

4. 安装 snap

   ```
   $ yum install -y epel-release
   $ yum install -y snapd
   $ systemctl enable --now snapd.socket
   $ systemctl enable --now snapd.service
   $ snap install core
   core 16-2.52.1 from Canonical✓ installed
   $ ln -vfs /var/lib/snapd/snap /snap
   ```

5. 配置snap加速

   ```
   # 添加hosts解析
   91.189.91.43    darkbowser.canonical.com
   
   snap install snap-store-proxy
   snap install snap-store-proxy-client
   
   # systemctl edit snapd.service
   [Service]
   Environment="HTTP_PROXY=http://10.11.12.123:10240"
   Environment="HTTPS_PROXY=http://10.11.12.123:10240"
   Environment="NO_PROXY=localhost,127.0.0.1,192.168.0.0/24,*.domain.ltd"
   ```

### 安装microk8s

   ```
   snap install microk8s --classic
   
   [root@node1 ~]# cat /etc/hosts
   192.168.251.244 node1
   192.168.251.98 node2
   192.168.251.249 node3
   ```

   ### 下载被墙镜像

   ```
   curl -L "https://raw.githubusercontent.com/OpsDocker/pullk8s/main/pullk8s.sh" -o /usr/local/bin/pullk8s
   
   https://www.ucloud.cn/yun/33182.html
   
   docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
   docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
   docker save k8s.gcr.io/pause:3.1 -o pause.3.1.tar
   microk8s.ctr image import pause.3.1.tar
   
   docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.5.2
   docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.5.2 k8s.gcr.io/metrics-server/metrics-server:v0.5.2
   docker save k8s.gcr.io/metrics-server/metrics-server:v0.5.2 -o metrics-server.0.5.2.tar
   microk8s.ctr image import metrics-server.0.5.2.tar
   ```

###  启用RBAC

```
microk8s enable rbac
```

### 连接常用路径

```
$ ln -vsf /var/snap/microk8s/common/var/lib/kubelet /var/lib/
‘/var/lib/kubelet’ -> ‘/var/snap/microk8s/common/var/lib/kubelet’

$ ln -vsf /var/snap/microk8s/common/var/lib/containerd /var/lib/
‘/var/lib/containerd’ -> ‘/var/snap/microk8s/common/var/lib/containerd’
```

### 配置CLI

```
$ snap alias microk8s.kubectl kubectl
$ kubectl completion bash >/etc/bash_completion.d/kubectl
```

### 安装helm3

```
microk8s enable helm3

Fetching helm version v3.8.0.
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0 12.9M    0 81920    0     0    876      0  4:19:15  0:01:33  4:17:42     0
curl: (56) OpenSSL SSL_read: SSL_ERROR_SYSCALL, errno 104
## 网络问题出现以上报错

# vim /var/snap/microk8s/common/addons/core/addons/helm3/enable
#!/usr/bin/env bash

set -e

source $SNAP/actions/common/utils.sh

echo "Enabling Helm 3"

if [ ! -f "${SNAP_DATA}/bin/helm3" ]
then
  #SOURCE_URI="https://get.helm.sh"
  SOURCE_URI="https://mirrors.huaweicloud.com/helm/v3.8.0"   ## 改华为的镜像地址
  HELM_VERSION="v3.8.0"
  
```

### 配置dashboard

```
[root@node1 yaml]# cat admin.yml 
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: admin
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: admin
  namespace: kube-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: kube-system

[root@node1 yaml]# kubectl apply -f admin.yml    ## 创建sa  admin
```

![image-20220518105142989](C:\Users\XYB\Desktop\k8s调研\microk8s.assets\image-20220518105142989.png)

```
service type 改为 NodePort
```

```
[root@node1 yaml]# kubectl -n kube-system create token admin 
# 对 admin 创建token
```

### microk8s 问题

1. microk8s是Canonical 的k8s发行版，默认使用snap 进行安装，CentOS需要先安装 snap，CentOS7.6+才支持snap的安装，snap的安装依赖众多。

2. microk8s主要的定位是在本地开发、物联网和边缘计算上进行使用，

3. 使用snap安装microk8s时由于国内没有snap仓库，导致在线安装十分缓慢，使用离线方式安装需要安装两个snap包（microk8s.snap 和 core.snap 两个包总计 330M，还不包括依赖的k8s运行组件镜像）

4. microk8s整个集群的状态数据存储保存在dqlite中，而不是标准k8s的etcd中；服务以snap进行管理，使用自有的kubelite 对k8s 的标准服务进行类封装，增加了后期维护成本和难度。

   ![image-20220518141913249](C:\Users\XYB\Desktop\k8s调研\microk8s.assets\image-20220518141913249.png)

   - snap熟悉学习成本
   - microk8s 自有的封装组件的原理熟悉及后续问题排错成本
   - 官方文档及社区不够完善

5. 使用microk8s v1.24/stable版本验证搭建集群，添加节点存在问题 cluster-agent这个25000端口不通，无法添加集群，文档没有找到解决方案

   ![image-20220518152402110](C:\Users\XYB\Desktop\k8s调研\microk8s.assets\image-20220518152402110.png)

   ![image-20220518152521322](C:\Users\XYB\Desktop\k8s调研\microk8s.assets\image-20220518152521322.png)

   ![image-20220518152535849](C:\Users\XYB\Desktop\k8s调研\microk8s.assets\image-20220518152535849.png)

   

