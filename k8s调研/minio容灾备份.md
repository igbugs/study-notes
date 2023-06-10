## minio 容灾备份

### Bucket Replication桶复制

#### 两个集群单向复制

##### 部署环境说明

| 节点IP          | 角色        | 备注                    |
| --------------- | ----------- | ----------------------- |
| 192.168.251.133 | 主minio站点 | 桶edoc2向备站点单向同步 |
| 192.168.251.88  | 备minio站点 |                         |

```
[root@node1 minio]# cat run.sh
#!/bin/bash

export MINIO_ROOT_USER=admin 
export MINIO_ROOT_PASSWORD=edoc2@edoc2

/opt/minio/minio server --config-dir /opt/minio/config/ --console-address ":30000"\
    http://192.168.251.133/data{1..2}/drive{1..2}
```

##### 配置mc客户端

添加两个站点的连接配置（主备站点都操作）

```
wget https://dl.min.io/client/mc/release/linux-amd64/mc
```

```
## 主站点
# mc config host add node1 http://192.168.251.133:9000 admin edoc2@edoc2 --api s3v4

## 备站点
# mc config host add node2 http://192.168.251.88:9000 admin edoc2@edoc2 --api s3v4
```

创建同步的bucket（主备站点都创建）

```
# mc mb node1/edoc2
# mc mb node2/edoc2
```

##### 配置主站点复制所需权限

下载主站点权限配置文件

```
wget --no-check-certificate https://docs.min.io/minio/baremetal/examples/ReplicationAdminPolicy.json 


## 该"EnableRemoteBucketConfiguration"语句授予创建远程目标以支持复制的权限。
## 该"EnableReplicationRuleConfiguration"语句授予在存储桶上创建复制规则的权限。该"arn:aws:s3:::*资源将复制权限应用于源部署上的任何存储桶。您可以根据需要将用户策略限制到特定的存储桶。
```

添加 ReplicationAdminPolicy 策略

```
# cat ReplicationAdminPolicy.json | mc admin policy add node1 ReplicationAdminPolicy /dev/stdin
Added policy `ReplicationAdminPolicy` successfully.
```

创建用户及为用户绑定策略

```
# mc admin user add node1 replAdmin 1qaz2wsx3edc
Added user `replAdmin` successfully.

# mc admin policy set node1 ReplicationAdminPolicy user=replAdmin
Policy `ReplicationAdminPolicy` is set on user `replAdmin`
```

##### 配置备站点复制所需权限

下载备战点权限配置文件

```
# wget --no-check-certificate https://docs.min.io/minio/baremetal/examples/ReplicationRemoteUserPolicy.json 

## 该"EnableReplicationOnBucket"语句授予远程目标检索存储桶级配置的权限，以支持MinIO 部署中所有存储桶上的复制操作。要将策略限制为特定存储桶，请将这些存储桶指定为Resource数组中类似于的元素"arn:aws:s3:::bucketName"。
## 该"EnableReplicatingDataIntoBucket"语句授予远程目标将数据同步到MinIO 部署中的任何存储桶的权限。要将策略限制为特定存储桶，请将这些存储桶指定为Resource数组中类似于的元素"arn:aws:s3:::bucketName/*"。
```

备站点添加远程用户策略 ReplicationRemoteUserPolicy

```
# cat ReplicationRemoteUserPolicy.json | mc admin policy add node2 ReplicationRemoteUserPolicy /dev/stdin
Added policy `ReplicationRemoteUserPolicy` successfully.
```

配置访问备站点的远程用户replRemote为其并设置策略

```
# mc admin user add node2 replReomte 1qaz2wsx3edc
Added user `replReomte` successfully.

# mc admin policy set node2 ReplicationRemoteUserPolicy user=replReomte
Policy `ReplicationRemoteUserPolicy` is set on user `replReomte`
```

##### 其他的必须要求

1. 开启版本控制

   MinIO 依赖于[版本控制](https://docs.min.io/minio/baremetal/object-retention/bucket-versioning.html#minio-bucket-versioning)提供的不变性保护来支持复制和重新同步。

   ```
   # mc version info node1/edoc2      // 查看node1/edoc2 是否开启版本控制
   
   // 创建同步之前版本控制开启
   # mc version enable node1/edoc2
   # mc version enable node2/edoc2
   
   
   // 不开启会报错
   [root@node1 ~]# mc admin bucket remote add node1/edoc2 \
   >    http://replReomte:1qaz2wsx3edc@192.168.251.88:9000/edoc2 \
   >    --service "replication"
   mc: <ERROR> Unable to configure remote target. The replication source does not have versioning enabled.
   ```

2. 只支持两个minio部署的机器的同步，要配置任意 S3 兼容服务之间的复制，请使用.[`mc mirror`](https://docs.min.io/minio/baremetal/reference/minio-mc/mc-mirror.html#command-mc.mirror)

3. 如果开启了加密，两个集群都要开启相应的加密方式

##### 为bucket创建远程的复制目标

```
mc admin bucket remote add node1/edoc2 \
   http://replReomte:1qaz2wsx3edc@192.168.251.88:9000/edoc2 \
   --service "replication"
   [--sync]   ## 可选默认是异步的
   
   
[root@node1 ~]# mc admin bucket remote add node1/edoc2    http://replReomte:1qaz2wsx3edc@192.168.251.88:9000/edoc2    --service "replication"
Remote ARN = `arn:minio:replication::4eb0bf77-a13f-4174-bef7-f08945ed517d:edoc2`

// 返回ARN
```

##### 为bucket创建桶复制规则

```
mc replicate add node1/edoc2 \
   --remote-bucket 'arn:minio:replication::4eb0bf77-a13f-4174-bef7-f08945ed517d:edoc2' \
   --replicate "delete,delete-marker,existing-objects"
Replication configuration rule applied to node1/edoc2 successfully.
```

##### 测试复制配置

```
## 向node1上传文件可以同步到node2
[root@node1 ~]# mc ls node1/edoc2
[root@node1 ~]# mc cp ReplicationAdminPolicy.json node1/edoc2
...ionAdminPolicy.json:  848 B / 848 B ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 64.05 KiB/s 0s[root@node1 ~]# ░░░░░░░░░░░░░░░░░░░░▓┃
[root@node1 ~]# mc ls node1/edoc2
[2022-06-28 19:37:31 CST]   848B STANDARD ReplicationAdminPolicy.json
[root@node1 ~]# mc ls node2/edoc2
[2022-06-28 19:37:31 CST]   848B STANDARD ReplicationAdminPolicy.json

## 向node2 上传文件不能同步到node1
[root@node2 minio]# mc cp run.sh node2/edoc2
/opt/minio/run.sh:     684 B / 684 B ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 47.91 KiB/s 0s [root@node2 minio]# ░░░░░░░░░░░░▓┃
[root@node2 minio]# mc ls node1/edoc2
[2022-06-28 19:37:31 CST]   848B STANDARD ReplicationAdminPolicy.json
[root@node2 minio]# mc ls node2/edoc2
[2022-06-28 19:37:31 CST]   848B STANDARD ReplicationAdminPolicy.json
[2022-06-28 19:42:50 CST]   684B STANDARD run.sh
```

#### 两个集群的双向同步

双向同步应用程序既可以写主站点也可以写备站点，数据自动会向对方同步。

**配置方法与单向同步操作步骤一致，再配置个从node2 到 node1 的单向同步。**

![image-20220630192223128](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220630192223128.png)

单向同步，node2/edoc2 没有配置replicate

![image-20220630192327600](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220630192327600.png)

双向同步，各有一个复制任务同步到对方 bucket

##### 测试复制配置

![image-20220630192629967](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220630192629967.png)

![image-20220630192733580](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220630192733580.png)

#### 图形化配置操作

访问minio的管理节点，启动的时候制定console端口

![image-20220701090527785](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701090527785.png)

输入启动minio时候指定的root管理员的用户名密码

![image-20220701090645468](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701090645468.png)

##### 创建bucket（两个站点都创建）

![image-20220701091217091](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701091217091.png)

![image-20220701091243344](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701091243344.png)

##### 配置bucket replication

![image-20220701093843789](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701093843789.png)

![image-20220701093904836](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701093904836.png)

![image-20220701094139420](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701094139420.png)

```
需要注意的是：
1. 默认 Use TLS 是开启的，没有配置https，就需要把这个给关闭
2. Target URL： 同步到目标站点的地址，不需要添加协议，如：http://192.168.251.88:9000 (这个表单会自动根据Use TLS的值决定使用 http还是https)
```

**注意：bucket 的版本控制需要手动开启（两边都要开启）**

![image-20220701094500738](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701094500738.png)

![image-20220701094538970](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701094538970.png)

创建好后的同步规则

![image-20220701094737807](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701094737807.png)

在备站点进行相同的操作，即可进行备站点到主站点的同步。

##### 测试桶复制

主站点上传文件

![image-20220701095149887](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701095149887.png)

备站点查看

![image-20220701095209544](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701095209544.png)

备战点上传文件

![image-20220701095239354](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701095239354.png)

![image-20220701095313698](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701095313698.png)



### Site Replication站点复制

桶复制是在bucket级别的复制同步，而site replication 是在minio站点级别的复制同步，minoi 站点复制的包含有一下内容：

每个 MinIO 部署（“对等站点”）在其他对等站点之间同步以下更改：

- 桶和对象的创建、修改和删除，包括
  - 存储桶和对象配置
  - [政策](https://docs.min.io/minio/baremetal/security/minio-identity-management/policy-based-access-control.html#minio-policy)
  - [`mc tag set`](https://docs.min.io/minio/baremetal/reference/minio-mc/mc-tag-set.html#command-mc.tag.set)
  - [锁定](https://docs.min.io/minio/baremetal/object-retention/minio-object-locking.html#minio-object-locking)，包括保留和合法保留配置
  - [加密设置](https://docs.min.io/minio/baremetal/security/encryption-overview.html#minio-encryption-overview)
- 创建和删除 IAM 用户、组、策略以及到用户或组的策略映射（针对 LDAP 用户或组）
- `root`为可从本地凭证验证的会话令牌创建安全令牌服务 (STS)凭证
- 创建和删除[服务帐户](https://docs.min.io/minio/baremetal/reference/minio-mc-admin/mc-admin-user-svcacct.html#minio-mc-admin-user-svcacct)（用户拥有的除外`root`）
- 站点复制为所有复制站点上的所有新存储桶和现有存储桶启用[存储桶版本控制。](https://docs.min.io/minio/baremetal/object-retention/bucket-versioning.html#minio-bucket-versioning)

#### 站点复制配置

主站点进行配置

![image-20220701102052335](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701102052335.png)

![image-20220701102219152](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701102219152.png)

注意：站点同步需要ak和sk保持一致，填写对等站点的访问地址后保存

![image-20220701102336661](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701102336661.png)

![image-20220701102400440](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701102400440.png)

此时分别访问两个站点，站点的同步已经配置完成

#### 站点复制测试

默认两个站点双向同步所有的操作

**创建bucket**

![image-20220701103029522](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701103029522.png)

**上传文件**

![image-20220701103210211](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701103210211.png)

**删除文件**

![image-20220701103304425](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701103304425.png)

**添加用户**

![image-20220701103540559](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701103540559.png)

![image-20220701103616720](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701103616720.png)

### 差异重新同步

备站点down机后，在主站点上传的数据，并不会立即在备战点恢复后同步到备站点，但最终会达到同步一致。

停止备站点，上传了三个文件到 edoc2 bucket

![image-20220701105724879](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701105724879.png)

![image-20220701105628148](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701105628148.png)

![image-20220701105817294](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701105817294.png)

备站点没有上传的三个文件，但没有立即进行文件同步（测试过程中发现一段时间后会有文件同步，如何触发还不清楚）

![image-20220701110547021](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701110547021.png)

最终同步一致

![image-20220701111108042](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701111108042.png)

停止备站点后，主站点创建bucket，在上传一个文件

![image-20220701110119317](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701110119317.png)

备站点的 bucket 创建成功，但是没有进行立即文件同步。最终还是同步一致

![image-20220701111031430](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701111031430.png)



**文件的重新同步**

配置了站点同步后，每一个bucket都有一个桶的同步规则

![image-20220701110623513](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701110623513.png)

![image-20220701111135155](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701111135155.png)

停止node2 minio后，上传文件到 edoc2 , 重启 node2 minio，人为造成差异，立马进行差异的重新同步。

![image-20220701112044005](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701112044005.png)

![image-20220701113008085](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701113008085.png)

![image-20220701112157442](C:\Users\XYB\Desktop\k8s调研\minio容灾备份.assets\image-20220701112157442.png)

```
mc replicate resync start --remote-bucket "arn:minio:replication::10599c18-1a8f-44b1-ac30-e80177bb8c82:edoc2" node1/edoc2 && mc replicate resync status node1/edoc2

## ARN 使用 mc replicate ls node1/edoc2 --json 获取
```

**或 直接使用 mc mirror 进行同步**

```
mc mirror node1/edoc2 node2/edoc2
```

