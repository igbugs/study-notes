#### microk8s 问题

1. microk8s是Canonical 的k8s发行版，默认使用snap 进行安装，CentOS需要先安装 snap，CentOS7.6+才支持snap的安装，snap的安装依赖众多。

2. microk8s主要的定位是在本地开发、物联网和边缘计算上进行使用，

3. 使用snap安装microk8s时由于国内没有snap仓库，导致在线安装十分缓慢，使用离线方式安装需要安装两个snap包（microk8s.snap 和 core.snap 两个包总计 330M，还不包括依赖的k8s运行组件镜像）

4. microk8s整个集群的状态数据存储保存在dqlite中，而不是标准k8s的etcd中；服务以snap进行管理，使用自有的kubelite 对k8s 的标准服务进行类封装，增加了后期维护成本和难度。

   ![image-20220518141913249](C:\Users\XYB\Desktop\k8s调研\microk8s 问题.assets\image-20220518141913249.png)

   - snap熟悉学习成本
   - microk8s 自有的封装组件的原理熟悉及后续问题排错成本
   - 官方文档及社区不够完善

5. 使用microk8s v1.24/stable版本验证搭建集群，添加节点存在问题 cluster-agent这个25000端口不通，无法添加集群，文档没有找到解决方案

   ![image-20220518152402110](C:\Users\XYB\Desktop\k8s调研\microk8s 问题.assets\image-20220518152402110.png)

   ![image-20220518152521322](C:\Users\XYB\Desktop\k8s调研\microk8s 问题.assets\image-20220518152521322.png)

   ![image-20220518152535849](C:\Users\XYB\Desktop\k8s调研\microk8s 问题.assets\image-20220518152535849.png)

   

