## k8s环境收集宿主机pod日志到apm

### 1. k8s宿主机安装filebeat

```
# 下载filebeat安装包
cd /usr/local/
wget http://download.edoc2.com:5999/apm/k8s/filebeat.tar.gz
tar -xf filebeat.tar.gz
wget -O /usr/lib/systemd/system/filebeat.service http://download.edoc2.com:5999/apm/k8s/filebeat.service
```

```
systemd daemon-reload
systemd enable filebeat
```

### 2. 更新 logstash 镜像

```
wget http://download.edoc2.com:5999/apm/k8s/logstash-ningdeshidai-v6.7.1.15.tar.xz
tar -xf logstash-ningdeshidai-v6.7.1.15.tar.xz
docker load -i logstash-ningdeshidai-v6.7.1.15.tar
```

k8s 环境导出logstash 5044/tcp 端口 为 NodePort 类型，保证各宿主机能够访问到 logstash 5044 端口

![image-20221112150031720](C:\Users\XYB\Desktop\k8s调研\assets\image-20221112150031720.png)

配置 logstash 环境变量

```
CONTAINER_PLATFORM=kubernetes
ELASTICSEARCH_HOSTS=http://192.168.20.125:30003    // 可配置单独的es地址
```

配置 宿主机 host 解析

```
192.168.20.77 logserver         // logserver 解析到宿主机IP
```

