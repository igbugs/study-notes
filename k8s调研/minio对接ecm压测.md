## minio对接ecm压测

### 压测环境说明

| IP              | 服务                       | 配置              |
| --------------- | -------------------------- | ----------------- |
| 192.168.251.102 | minio                      | 16C16G  2HDD* 80G |
| 192.168.251.88  | minio                      | 16C16G  2HDD* 80G |
| 192.168.251.98  | minio                      | 16C16G  2HDD* 80G |
| 192.168.251.126 | ECM 6.0                    | 8C12G  200G       |
| 192.168.251.153 | 压力机 ecm_stress:v6.0.0.3 | 16C16G            |

### minio集群

```
[root@node1 minio]# cat run.sh
#!/bin/bash

export MINIO_ROOT_USER=admin 
export MINIO_ROOT_PASSWORD=edoc2@edoc2

/opt/minio/minio server --config-dir /opt/minio/config/ --console-address ":30000"\
    http://node1:9000/data{1...2}/drive{1...2} \
    http://node2:9000/data{1...2}/drive{1...2} \
    http://node3:9000/data{1...2}/drive{1...2} 
```

![image-20220713132601348](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713132601348.png)

三个节点 12 drive

### 创建桶及ServiceAccounts账户

![image-20220713133053181](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713133053181.png)

![image-20220713132807914](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713132807914.png)

![image-20220713132920579](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713132920579.png)

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::edoc2/*"
            ]
        }
    ]
}
```

指定 AK： L4RZL1NKlcd7JU66  只对edoc2 这个桶有所有s3相关操作权限。

### ECM添加minio存储

![image-20220713133151642](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713133151642.png)

```
minio的s3访问地址：http://192.168.251.102:9000,http://192.168.251.88:9000,http://192.168.251.98:9000
公钥: 创建的 服务账户的ak
私钥：创建的 服务账户的sk
桶名: 服务账户有权限的bucket edoc2
api版本：4
```

### 压测方法

此环境配置不高，只做存储相关的功能性验证测试，不做性能测试；

分别对个人库，团队库和企业库的文件上传、文件下载、文件共享、文件外发、文件预览、新建文件夹以20并发持续100s进行测试。

#### 企业库压测结果

![image-20220713133828495](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713133828495.png)

![image-20220713133911721](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713133911721.png)

![image-20220713133927252](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713133927252.png)

![image-20220713133942208](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713133942208.png)

![image-20220713133959285](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713133959285.png)

![image-20220713134014033](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134014033.png)

#### 团队库压测结果

![image-20220713134309017](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134309017.png)

![image-20220713134322790](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134322790.png)

![image-20220713134335486](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134335486.png)

![image-20220713134348261](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134348261.png)

![image-20220713134401065](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134401065.png)

![image-20220713134415631](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134415631.png)

#### 个人库压测结果

![image-20220713134439685](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134439685.png)

![image-20220713134454029](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134454029.png)

![image-20220713134512536](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134512536.png)

![image-20220713134525399](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134525399.png)

![image-20220713134540410](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134540410.png)

![image-20220713134553699](C:\Users\XYB\Desktop\k8s调研\minio对接ecm压测.assets\image-20220713134553699.png)



上面的关于文件相关的压测没有出现报错。

