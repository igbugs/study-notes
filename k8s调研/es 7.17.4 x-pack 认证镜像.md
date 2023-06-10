## es 7.17.4 x-pack 认证镜像

测试镜像版本：192.168.251.78/edoc2v5/elasticsearch:v7.17.4.1-0711

此版本单机和集群已经进行测试可以运行及生成相关认证用户。

### 主要变更

1. elasticsearch.yml 添加了 xpack相关安全配置，集群之间开启了ssl连接（开启xpack后集群必须要开启ssl）

```
xpack.security.enabled: true
xpack.security.authc.accept_default_password: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.keystore.path: certs/elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: certs/elastic-certificates.p12
```

2. config目录下添加了 certs目录，配置了默认的证书：

![image-20220711163624209](C:\Users\XYB\Desktop\k8s调研\es 7.17.4 x-pack 认证镜像.assets\image-20220711163624209.png)

3. 启动流程变更，elasticsearch-start.sh脚本开启子shell 初始化认证用户

   ```
   ………………
   
   {
       if [ $(hostname) == "es" ];then
           if [ -f "/esdata/.espass.enc" ];then
               echo "elastic auth user already init.."  
           else
               while true;do 
                   status=$(curl -sIL -w "%{http_code}\n" -o /dev/null es:9200) 
                   if [ "$status" == "401" ];then
                       yes y | ./bin/elasticsearch-setup-passwords auto > /esdata/.espass
                       espass=$(cat /esdata/.espass | awk '/elastic =/{print $NF}')
                       curl -u elastic:"${espass}" -H "Content-Type: application/json" -XPUT http://es:9200/_security/role/edoc2Role -d '
                       {
                           "indices": [
                               {
                                 "names": [
                                   "*"
                                 ],
                                 "privileges": [
                                   "all"
                                 ]
                               }
                             ]
                       }'
                       curl -u elastic:"${espass}" -H "Content-Type: application/json" -XPOST http://es:9200/_security/user/edoc2 -d '
                       {
                         "password" : "1qaz2WSX",
                         "roles" : ["edoc2Role","elastic_admin"]
                       }'
   
                       openssl enc -e -aes256 -pbkdf2 -in /esdata/.espass -out /esdata/.espass.enc -a -pass pass:edoc2@edoc2
                       rm -f /esdata/.espass
                       break
                   fi  
                   echo "elasticsearch No startup completed, wite for 5s.. "
                   sleep 5
               done
           fi
       fi
   } &
   
   su elasticsearch -c "./bin/elasticsearch"
   ```

   1） 后台启动子shell 等待 es启动完成

   2）判断启动节点hostname是否为es，其作为初始化认证用户节点

   3）初始化后的集群，会在es数据目录生成 /esdata/.espass.enc es默认系统用户的加密文件，判断此文件是否存在决定是否进行认证用户的初始化

   4）通过请求es状态码 返回401 判断，es是否启动完成，启动完成则进行相应初始化

   5）调用 elasticsearch-setup-passwords 自动生成随机密码，并获取elastic管理员密码

   6）使用elastic管理用户创建 edoc2Role，创建edoc2用户绑定到edoc2Role，并设置其密码为 1qaz2WSX

​		7）对生成的随机明文密码 /esdata/.espass 文件进行对称加密，加密密码为 edoc2@edoc2 ，并删除明文密码

3. 管理员密码获取

   ```
   openssl enc -d -aes256 -pbkdf2 -in /esdata/.espass.enc -out ./es.txt -a -pass pass:edoc2@edoc2
   ```

   ![image-20220711165123424](C:\Users\XYB\Desktop\k8s调研\es 7.17.4 x-pack 认证镜像.assets\image-20220711165123424.png)

4. 查看集群状态信息需要有管理员权限

   ![image-20220711165310771](C:\Users\XYB\Desktop\k8s调研\es 7.17.4 x-pack 认证镜像.assets\image-20220711165310771.png)

5. 应用用户 edoc2赋予的索引操作相关的所有权限

   ![image-20220711165532229](C:\Users\XYB\Desktop\k8s调研\es 7.17.4 x-pack 认证镜像.assets\image-20220711165532229.png)

   ![image-20220711165608938](C:\Users\XYB\Desktop\k8s调研\es 7.17.4 x-pack 认证镜像.assets\image-20220711165608938.png)

6. es_single_backup.sh 单机备份脚本适配支持es认证