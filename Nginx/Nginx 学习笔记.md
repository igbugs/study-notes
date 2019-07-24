# Nginx 学习笔记

## 第一章 初识Nginx

### Nginx的主要应用场景

![1560318007614](assets/1560318007614.png)

### Nginx出现原因

![1560318131934](assets/1560318131934.png)

### Nginx 的优点

![1560318195780](assets/1560318195780.png)

### Nginx 的组成

![1560318317942](assets/1560318317942.png)

### Nginx的版本发布

![1560318494065](assets/1560318494065.png)

### Nginx源码编译

```
源码目录结构：
[root@localhost nginx-1.16.0]# ls
auto  CHANGES  CHANGES.ru  conf  configure  contrib  html  LICENSE  man  README  src
[root@localhost auto]# ls	## 此目录主要是辅助编译的脚本	
## cc 编译使用的目录
## os 用于操作系统的判断使用
cc      endianness  have          headers  init     lib   module   nohave   os       stubs    threads  unix
define  feature     have_headers  include  install  make  modules  options  sources  summary  types

[root@localhost vim]# pwd
/usr/local/src/nginx-1.16.0/contrib/vim		## 主要用于配置文件vim打开的时候 颜色显示
[root@localhost vim]# ls
ftdetect  ftplugin  indent  syntax

[root@localhost src]# ls	## nginx 的源码目录
core  event  http  mail  misc  os  stream
```

```
查看nginx 的configure 支持哪些编译参数
[root@localhost nginx-1.16.0]# ./configure --help

  --help                             print this message
## 此类事指定安装目录，第三方模块目录，配置文件目录，pid,nginx.lock 目录等
  --prefix=PATH                      set installation prefix
  --sbin-path=PATH                   set nginx binary pathname
  --modules-path=PATH                set modules path
  --conf-path=PATH                   set nginx.conf pathname
  --error-log-path=PATH              set error log pathname
  --pid-path=PATH                    set nginx.pid pathname
  --lock-path=PATH                   set nginx.lock pathname

  --user=USER                        set non-privileged user for
                                     worker processes
  --group=GROUP                      set non-privileged group for
                                     worker processes

  --build=NAME                       set build name
  --builddir=DIR                     set build directory

## --with 模块打头的表示默认的不会编译进nginx，默认不开启
  --with-select_module               enable select module
  --without-select_module            disable select module
  --with-poll_module                 enable poll module
  --without-poll_module              disable poll module

  --with-threads                     enable thread pool support

  --with-file-aio                    enable file AIO support

  --with-http_ssl_module             enable ngx_http_ssl_module
  --with-http_v2_module              enable ngx_http_v2_module
  --with-http_realip_module          enable ngx_http_realip_module
  --with-http_addition_module        enable ngx_http_addition_module
  --with-http_xslt_module            enable ngx_http_xslt_module
  --with-http_xslt_module=dynamic    enable dynamic ngx_http_xslt_module
  --with-http_image_filter_module    enable ngx_http_image_filter_module
  --with-http_image_filter_module=dynamic
                                     enable dynamic ngx_http_image_filter_module
  --with-http_geoip_module           enable ngx_http_geoip_module
  --with-http_geoip_module=dynamic   enable dynamic ngx_http_geoip_module
  --with-http_sub_module             enable ngx_http_sub_module
  --with-http_dav_module             enable ngx_http_dav_module
  --with-http_flv_module             enable ngx_http_flv_module
  --with-http_mp4_module             enable ngx_http_mp4_module
  --with-http_gunzip_module          enable ngx_http_gunzip_module
  --with-http_gzip_static_module     enable ngx_http_gzip_static_module
  --with-http_auth_request_module    enable ngx_http_auth_request_module
  --with-http_random_index_module    enable ngx_http_random_index_module
  --with-http_secure_link_module     enable ngx_http_secure_link_module
  --with-http_degradation_module     enable ngx_http_degradation_module
  --with-http_slice_module           enable ngx_http_slice_module
  --with-http_stub_status_module     enable ngx_http_stub_status_module

## --without 用于disable 一些模块，不进行编译
  --without-http_charset_module      disable ngx_http_charset_module
  --without-http_gzip_module         disable ngx_http_gzip_module
  --without-http_ssi_module          disable ngx_http_ssi_module
  --without-http_userid_module       disable ngx_http_userid_module
  --without-http_access_module       disable ngx_http_access_module
  --without-http_auth_basic_module   disable ngx_http_auth_basic_module
  --without-http_mirror_module       disable ngx_http_mirror_module
  --without-http_autoindex_module    disable ngx_http_autoindex_module
  --without-http_geo_module          disable ngx_http_geo_module
  --without-http_map_module          disable ngx_http_map_module
  --without-http_split_clients_module disable ngx_http_split_clients_module
  --without-http_referer_module      disable ngx_http_referer_module
  --without-http_rewrite_module      disable ngx_http_rewrite_module
  --without-http_proxy_module        disable ngx_http_proxy_module
  --without-http_fastcgi_module      disable ngx_http_fastcgi_module
  --without-http_uwsgi_module        disable ngx_http_uwsgi_module
  --without-http_scgi_module         disable ngx_http_scgi_module
  --without-http_grpc_module         disable ngx_http_grpc_module
  --without-http_memcached_module    disable ngx_http_memcached_module
  --without-http_limit_conn_module   disable ngx_http_limit_conn_module
  --without-http_limit_req_module    disable ngx_http_limit_req_module
  --without-http_empty_gif_module    disable ngx_http_empty_gif_module
  --without-http_browser_module      disable ngx_http_browser_module
  --without-http_upstream_hash_module
                                     disable ngx_http_upstream_hash_module
  --without-http_upstream_ip_hash_module
                                     disable ngx_http_upstream_ip_hash_module
  --without-http_upstream_least_conn_module
                                     disable ngx_http_upstream_least_conn_module
  --without-http_upstream_random_module
                                     disable ngx_http_upstream_random_module
  --without-http_upstream_keepalive_module
                                     disable ngx_http_upstream_keepalive_module
  --without-http_upstream_zone_module
                                     disable ngx_http_upstream_zone_module

  --with-http_perl_module            enable ngx_http_perl_module
  --with-http_perl_module=dynamic    enable dynamic ngx_http_perl_module
  --with-perl_modules_path=PATH      set Perl modules path
  --with-perl=PATH                   set perl binary pathname

  --http-log-path=PATH               set http access log pathname
  --http-client-body-temp-path=PATH  set path to store
                                     http client request body temporary files
  --http-proxy-temp-path=PATH        set path to store
                                     http proxy temporary files
  --http-fastcgi-temp-path=PATH      set path to store
                                     http fastcgi temporary files
  --http-uwsgi-temp-path=PATH        set path to store
                                     http uwsgi temporary files
  --http-scgi-temp-path=PATH         set path to store
                                     http scgi temporary files

  --without-http                     disable HTTP server
  --without-http-cache               disable HTTP cache

  --with-mail                        enable POP3/IMAP4/SMTP proxy module
  --with-mail=dynamic                enable dynamic POP3/IMAP4/SMTP proxy module
  --with-mail_ssl_module             enable ngx_mail_ssl_module
  --without-mail_pop3_module         disable ngx_mail_pop3_module
  --without-mail_imap_module         disable ngx_mail_imap_module
  --without-mail_smtp_module         disable ngx_mail_smtp_module

  --with-stream                      enable TCP/UDP proxy module
  --with-stream=dynamic              enable dynamic TCP/UDP proxy module
  --with-stream_ssl_module           enable ngx_stream_ssl_module
  --with-stream_realip_module        enable ngx_stream_realip_module
  --with-stream_geoip_module         enable ngx_stream_geoip_module
  --with-stream_geoip_module=dynamic enable dynamic ngx_stream_geoip_module
  --with-stream_ssl_preread_module   enable ngx_stream_ssl_preread_module
  --without-stream_limit_conn_module disable ngx_stream_limit_conn_module
  --without-stream_access_module     disable ngx_stream_access_module
  --without-stream_geo_module        disable ngx_stream_geo_module
  --without-stream_map_module        disable ngx_stream_map_module
  --without-stream_split_clients_module
                                     disable ngx_stream_split_clients_module
  --without-stream_return_module     disable ngx_stream_return_module
  --without-stream_upstream_hash_module
                                     disable ngx_stream_upstream_hash_module
  --without-stream_upstream_least_conn_module
                                     disable ngx_stream_upstream_least_conn_module
  --without-stream_upstream_random_module
                                     disable ngx_stream_upstream_random_module
  --without-stream_upstream_zone_module
                                     disable ngx_stream_upstream_zone_module

  --with-google_perftools_module     enable ngx_google_perftools_module
  --with-cpp_test_module             enable ngx_cpp_test_module

  --add-module=PATH                  enable external module
  --add-dynamic-module=PATH          enable dynamic external module

  --with-compat                      dynamic modules compatibility

  --with-cc=PATH                     set C compiler pathname
  --with-cpp=PATH                    set C preprocessor pathname
  --with-cc-opt=OPTIONS              set additional C compiler options
  --with-ld-opt=OPTIONS              set additional linker options
  --with-cpu-opt=CPU                 build for the specified CPU, valid values:
                                     pentium, pentiumpro, pentium3, pentium4,
                                     athlon, opteron, sparc32, sparc64, ppc64

  --without-pcre                     disable PCRE library usage
  --with-pcre                        force PCRE library usage
  --with-pcre=DIR                    set path to PCRE library sources
  --with-pcre-opt=OPTIONS            set additional build options for PCRE
  --with-pcre-jit                    build PCRE with JIT compilation support

  --with-zlib=DIR                    set path to zlib library sources
  --with-zlib-opt=OPTIONS            set additional build options for zlib
  --with-zlib-asm=CPU                use zlib assembler sources optimized
                                     for the specified CPU, valid values:
                                     pentium, pentiumpro

  --with-libatomic                   force libatomic_ops library usage
  --with-libatomic=DIR               set path to libatomic_ops library sources

  --with-openssl=DIR                 set path to OpenSSL library sources
  --with-openssl-opt=OPTIONS         set additional build options for OpenSSL

  --with-debug                       enable debug logging

## 进行编译
[root@localhost nginx-1.16.0]# ./configure --prefix=/usr/local/nginx
…………
编译完成
Configuration summary
  + using system PCRE library
  + OpenSSL library is not used
  + using system zlib library

  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"
  
## 编译过程中会生成 objs 中间文件目录
[root@localhost nginx-1.16.0]# cd objs/
[root@localhost objs]# ls
autoconf.err  Makefile  ngx_auto_config.h  ngx_auto_headers.h  ngx_modules.c  src
## ngx_modules.c 是编译进nginx的模块

## 执行make 编译
[root@localhost nginx-1.16.0]# make

[root@localhost objs]# pwd
/usr/local/src/nginx-1.16.0/objs
[root@localhost objs]# ls		## 动态的模块存在 objs 目录下
autoconf.err  Makefile  nginx  nginx.8  ngx_auto_config.h  ngx_auto_headers.h  ngx_modules.c  ngx_modules.o  src
[root@localhost objs]# ls src/	## 编译生成的.o 文件放在objs/src 目录下
core  event  http  mail  misc  os  stream

## 执行编译后的安装
[root@localhost nginx-1.16.0]# make install 
## 安装完成后
[root@localhost nginx]# pwd 
/usr/local/nginx
[root@localhost nginx]# ls
conf  html  logs  sbin
```

### Nginx的配置语法

![1560321631504](assets/1560321631504.png)

![1560322123607](assets/1560322123607.png)

![1560322088997](assets/1560322088997.png)

![1560322196688](assets/1560322196688.png)

![1560322398844](assets/1560322398844.png)

### Nginx命令行

![1560322491699](assets/1560322491699.png)

### Nginx的版本热更新

```
## 备份老的nginx
[root@localhost sbin]# pwd
/usr/local/nginx/sbin
[root@localhost sbin]# cp nginx nginx.old

## 编译新的nginx
[root@localhost nginx-1.16.0]# ./configure --prefix=/usr/local/nginx
[root@localhost nginx-1.16.0]# make && make install 

## 拷贝新的nginx 到目录下
[root@localhost sbin]# ./nginx -V
nginx version: nginx/1.16.0
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) 
configure arguments: --prefix=/usr/local/nginx
[root@localhost sbin]# ./nginx.old -V
nginx version: nginx/1.14.2
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) 
configure arguments: --prefix=/usr/local/nginx

## 给正在运行的nginx进程发送 USR2 信号，告诉开始进行热部署
[root@localhost sbin]# ps -ef | grep nginx 
root      21237      1  0 20:53 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nobody    21238  21237  0 20:53 ?        00:00:00 nginx: worker process
root      23817  10111  0 20:55 pts/0    00:00:00 grep --color=auto nginx
[root@localhost sbin]# kill -USR2 21237
[root@localhost sbin]# ps -ef | grep nginx ## 此时nginx启动了两个master进程
root      21237      1  0 20:53 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nobody    21238  21237  0 20:53 ?        00:00:00 nginx: worker process
root      23818  21237  0 20:56 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nobody    23819  23818  0 20:56 ?        00:00:00 nginx: worker process
root      23821  10111  0 20:56 pts/0    00:00:00 grep --color=auto nginx

## 关闭老的nginx进程下的worker进程，老的master进程不退出
[root@localhost sbin]# kill -WINCH 21237
[root@localhost sbin]# ps -ef | grep nginx 
root      21237      1  0 20:53 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
root      23818  21237  0 20:56 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nobody    23819  23818  0 20:56 ?        00:00:00 nginx: worker process

## 进行老版本的回退，老的重新拉起worker进程
[root@localhost sbin]# kill -HUP 21237
[root@localhost sbin]# ps -ef | grep nginx 
root      21237      1  0 20:53 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
root      23818  21237  0 20:56 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nobody    23819  23818  0 20:56 ?        00:00:00 nginx: worker process
nobody    23857  21237  0 21:03 ?        00:00:00 nginx: worker process

## 升级完成后可以kill 掉老的master进程
```

### Nginx的日志切割

```
./nginx -s reopen
或
kill -USR1 nginxpid
```

### Nginx 配置静态的资源服务器

```
 root 与alias 的区别：
 location /website/ {
        root /var/lib/www;
        autoindex on;
    }
上面的配置浏览http://localhost/website/会显示404错误，因为**root属性指定的值是要加入到最终路径的**，所以访问的位置变成了/var/lib/www/website/。而我不想把访问的URI加入到路径中。所以就需要使用alias属性，其会抛弃URI，直接访问alias指定的位置, 所以最终路径变成/var/lib/www/。（最后需要加斜线）

    location /website/ {
        alias /var/lib/www;
        autoindex on;
    }
```

### **启用gzip压缩**

![1560326433306](assets/1560326433306.png)

```
gzip_min_length 1; 表示小于1字节的就不进行压缩了
gzip_comp_level 2; 压缩级别
gzip_types 针对某些文件进行压缩
```

### **设置访问大文件访问速率限制**

![1560326671023](assets/1560326671023.png)

![1560326799400](assets/1560326799400.png)

```
set $limit_rate 1k; 每秒限制1kB大小的速度到浏览器中
```

### Nginx具有缓存功能的反向代理

![1560327256844](assets/1560327256844.png)

```
使用反向代理之后需要使用：
proxy_set_header 等对一些使用的内置变量进行重写
```

![1560327579973](assets/1560327579973.png)

```
proxy_cache_path 设置缓存的路径
/tmp/nginxcache 设置缓存的路径
keys_zone=my_cache:10m 开辟了10m 的共享内存的空间，用于存放keys 关键字
```

![1560327751742](assets/1560327751742.png)

```
proxy_cache my_cache;  指定刚刚开辟的共享内存空间
proxy_cache_key $host$uri$is_args$args;  对于同一主机来的相同的请求（以此为key），来进行缓存
proxy_cache_valid 用于指定哪些相应不进行缓存的返回
```

### GoAccess 实现可视化并实时监控access日志

启动goaccess 程序，实时的生成报表

![1560328267884](assets/1560328267884.png)

配置location 用于访问report.html 文件

![1560328371153](assets/1560328371153.png)

访问的页面

![1560328402301](assets/1560328402301.png)

### SSL安全协议

![1560328467817](assets/1560328467817.png)

![1560328536903](assets/1560328536903.png)

![1560328689644](assets/1560328689644.png)

![1560328773414](assets/1560328773414.png)

```
RC4 通过对明文与密钥进行 异或操作进行加密
```

![1560328844143](assets/1560328844143.png)

```
一个文件使用公钥进行加密，只能通过私钥进行解密；同样，一个文件通过私钥进行加密，则只能通过公钥进行解密。
```

### SSL证书的公信力如何保证

```
在多方通信的场景下，bob如何验证Alice的公钥就是Alice发来的，中间没有其他人进行挟持呢？
所以在多方通信的过程中必须要有一个公信机构，CA机构
```

**CA机构如何颁发证书以及证书过期**

![1560329265394](assets/1560329265394.png)

```
证书登记流程：
1. 证书订阅人需要提交 证书签名的申请，需要填写我是谁，我是什么组织，我的位置等信息
2. CA机构拿到CSR 请求后，会生成一个公钥和私钥，发给申请人，其中公钥会在CA机构保存一份
3. 部署证书到web服务器
4. 浏览器向web发送请求的时候，web端会发送公钥给浏览器，浏览器内置有CA机构颁发的公钥，用于验证web端给的公钥是否是CA机构颁发的证书
5. 浏览器通过 OCSP去查看证书是否过期，web nginx也可以主动的去查看证书是否过期
```

![1560329896888](assets/1560329896888.png)

![1560330040364](assets/1560330040364.png)

```
www.taohui.pub  为站点的主证书
Encryption Everywhere DV 为二级证书机构
DigiCert Global Root CA 为根证书（操作系统内置的证书，一般一年更新一次）

## nginx 在发送证书时，会想浏览器发送站点的住证书和二级证书
```

### TLS的通信过程

![1560330387506](assets/1560330387506.png)

```
1. 有浏览器想服务端发送 Client Hello（浏览器告诉服务端支持哪些加密算法）
2. Server Hello 主要是告诉浏览器自己支持的加密算法的列表以及倾向使用的安全套件；如果nginx 打开了session cache 则一天内断开的客户端不用再协商密码而是使用之前的密钥算法
3. Server Certificate 服务端发送自己的公钥证书，公钥证书包含证书链（浏览器可以找到自己的根证书库验证是否有效）；如果协商的算法是 椭圆曲线算法，则需要发送 椭圆曲线所要使用的公共参数；	
4. 服务器发送 Server Hello Done
5. 客户端根据 椭圆曲线算法的公共参数，生成自己的公钥和私钥，把公钥发送给服务端；而服务端也根据 椭圆曲线算法的公共参数，生成公私钥，把公钥发送给客户端；
6. 客户端和服务端 都根据自己的私钥和对方发送过来的公钥  进行 key generation；双方各自生成的key应该是相同的；
7. 通过生成的密钥进行数据加密
```

### 使用certbot部署nginx HTTPS站点

```
[root@localhost conf]# yum -y install python2-certbot-nginx 
```

![1560332206365](assets/1560332206365.png)

![1560332232378](assets/1560332232378.png)

```
ssl_dhparam 使用非对称加密的话的参数
```

**options-ssl-nginx.conf**

![1560332271579](assets/1560332271579.png)

![1560332509798](assets/1560332509798.png)

```
ssl_session_cache 开辟空间进行session cache 1m的大小，1m大约可以缓存4000个请求session
ssl_session_timeout 1440m; 1440min 为一天
ssl_ciphers 支持的安全套件
```

### OpenResty 安装及lua简单使用

```
[root@localhost src]# wget https://openresty.org/download/openresty-1.15.8.1.tar.gz --no-check-certificate

## configure
[root@localhost openresty-1.15.8.1]# ./configure --prefix=/usr/local/openresty
[root@localhost openresty-1.15.8.1]# make && make install 
```

```
        location /lua {
            default_type text/html;
            content_by_lua '
ngx.say("User-Agent: ", ngx.req.get_headers()["User-Agent"])
            ';
        }
```

![1560334502230](assets/1560334502230.png)

## 第二章 Nginx架构基础

### Nginx请求的处理流程

![1560334689167](assets/1560334689167.png)

```
传输层状态机：处理TCP、UDP的四层的状态机
HTTP 状态机：处理七层协议
MAIL状态机：处理邮件的

nginx使用非阻塞的时间驱动处理引擎（epoll），往往使用异步的处理需要使用状态机才能正确的处理和识别请求；使用线程池处理磁盘阻塞的调用
```

### Nginx的进程结构

![1560335065092](assets/1560335065092.png)

```
Cache manager 进行缓存的管理
Cache loader 进行缓存的载入
进程间的通信使用共享内存进行
worker进程建议配置为CPU合数相同，并且每个worker进行绑定到执行的cpu 上，便于利用CPU上的缓存。

nginx 的reload 命令会，将之前的worker进程停止后，重新启动新的worker进程；与-SIGHUP的信号相同
在使用-SIGTERM 对其中的一个 work进程发送退出的信号后，master会重新启动一个新的work进程
```

### 使用信号管理nginx的父子进程

![1560335637423](assets/1560335637423.png)

```
当work进程意外的终止的时候，会向master进程发送CHLD信号，这时master会重新拉起一个master；
TERM,INT 立即停止nginx进程
QUIT 优雅的停止nginx进程
HUP 重新载入配置文件
USR1 重新打开日志文件
USR2 重新启动一个 mater进程，监听同样的端口
WINCH 退出master管理下的 work进程
```

### reload配置文件的真相

![1560336098895](assets/1560336098895.png)

![1560336195100](assets/1560336195100.png)

### Nginx 热升级的完整流程

![1560336312650](assets/1560336312650.png)

![1560336470921](assets/1560336470921.png)

### worker进程优雅的关闭

![1560336582105](assets/1560336582105.png)

### 网络收发与Nginx事件间的对应关系

![1560336788861](assets/1560336788861.png)

![1560336860705](assets/1560336860705.png)

![1560336934773](assets/1560336934773.png)

**TCP层（传输层）：主要是进程与进程通信的port**

![1560337548604](assets/1560337548604.png)

**IP 层（网络层）：机器与机器之间的找到**

![1560337648568](assets/1560337648568.png)

**TCP的三次握手**

![1560337798664](assets/1560337798664.png)

### Nginx事件驱动模型

![1560337869964](assets/1560337869964.png)

```
wait for events on connections: 等待事件的到来，在epoll 中是 epoll_wait的方法
当操作系统处理了一个TCP三次握手的连接后，操作系统会通知epoll_wait 可以往下走了；同时环形nginx的work进程。
之后，就会从事件的队列中取出待处理的事件（比如建立连接的事件，TCP处理报文的事件）；
```

### epoll 的优劣及原理

![1560338478334](assets/1560338478334.png)

```
活跃链接是存放在rdllink 的链表中的
```

### Nginx请求切换

![1560338828170](assets/1560338828170.png)

```
传统的process 切换依靠的是操作系统分配不同的事件片进行切换；而nginx是在用户态自己进行切换，除非是nginx work使用的时间片到了，时间片的长度一般是5ms 到800ms，通过对nginx work的优先级提高，让操作系统优先分配时间片处理nginx的请求（往往配置 -19）。
```

### 同步、异步 & 阻塞、非阻塞的区别

![1560340319292](assets/1560340319292.png)

![1560340386301](assets/1560340386301.png)

​	

![1560340482455](assets/1560340482455.png)

### Nginx模块

![1560742490009](assets/1560742490009.png)

```
ngx_module_t 是每个模块必须定义的一个结构体，其中的type定义的是属于哪一类型的模块
```

### Nginx模块的分类

![1560742650612](assets/1560742650612.png)

### Nginx如何通过连接池处理网络请求

![1560743148466](assets/1560743148466.png)

```
每一个 worker进程都有一个ngx_cycle_t 的结构
其中 connections 对应的nginx 的配置 worker_connections 进行配置，默认为512（此配置不仅用于client的连接，也用于后端服务器的连接，所以upstream 的配置，会占用两个的连接）
```

![1560743430549](assets/1560743430549.png)

```
每个连接的结构体为 ngx_connection_s 的结构体，约占232字节；而每个连接对应的读写事件的结构体为 ngx_event_s 结构体 为96 字节，所以一个连接占用的内存大概为 232+96*2 = 424字节内存
```

### 内存池对性能的影响

![1563265481275](assets/1563265481275.png)

```
内存池进行内存的预分配，避免频繁的内存分配，减少内存碎片，提高性能。
分为 连接内存池：connection_pool_size 256|512; 单位字节
请求内存池：request_pool_size: 4k 默认
```

### 所有worker 进程协同的关键：共享内存

![1563265863060](assets/1563265863060.png)

```
nginx 进程间的通信主要有两种：
	信号 主要是在管理nginx master 与worker进程中的信号
	共享内存 进行数据的同步，所谓的共享内存就是打开了一块内存，所有的worker进程都可以进行访问。
由于有共享内存的存在，则引入了 锁的机制，nginx的锁主要是自旋锁（即一个worker进程拿到锁了之后，其他worker进程会一直不断的尝试去获取锁，而不是等待）
```

![1563266207622](assets/1563266207622.png)

```
rbtree: 红黑树
```

![1563266292467](assets/1563266292467.png)

```
lua_shared_dict 指令出现的时候，会进行共享内存的分配
lua_shared_dict dogs 10m; 则分配了 命名为dogs 为10m 的共享内存
```

### 共享内存的管理工具：Slab 管理器

![1563266531576](assets/1563266531576.png)

```
slab 内存管理，会把整块共享内存先切分很多的页面，每个页面为4k, 并且分为很多的slot，这些slot 以2 的倍数向上增长。比如：要使用 51k 的，放在 64k 的slot上。
```

![1563266656289](assets/1563266656289.png)

```
ngx_slab_stat Tengine 的一个模块，用来监控slab 的使用

把Tengine 的 slab_stat 模块编译进 openresty：
[root@localhost src]# wget http://tengine.taobao.org/download/tengine-2.3.1.tar.gz
[root@localhost src]# tar -xf tengine-2.3.1.tar.gz 
[root@localhost modules]# ls
ngx_backtrace_module           ngx_http_reqstat_module                   ngx_http_upstream_dynamic_module
ngx_debug_pool                 ngx_http_slice_module                     ngx_http_upstream_dyups_module
ngx_debug_timer                ngx_http_sysguard_module                  ngx_http_upstream_keepalive_module
ngx_http_concat_module         ngx_http_tfs_module                       ngx_http_upstream_session_sticky_module
ngx_http_footer_filter_module  ngx_http_trim_filter_module               ngx_http_user_agent_module
ngx_http_lua_module            ngx_http_upstream_check_module            ngx_slab_stat
ngx_http_proxy_connect_module  ngx_http_upstream_consistent_hash_module

[root@localhost openresty-1.15.8.1]# ls ../tengine-2.3.1/modules/ngx_slab_stat/
config  ngx_http_slab_stat_module.c  README.cn  README.md  slab_stat.patch  t

[root@localhost openresty-1.15.8.1]# ./configure --add-module=../tengine-2.3.1/modules/ngx_slab_stat/		## 编译添加 slab_stat
```

![1563268127397](assets/1563268127397.png)

![1563268160794](assets/1563268160794.png)

### 哈希表的max_size 和buket_size配置（Nginx 容器）

![1563268272031](assets/1563268272031.png)

```
nginx的6个容器：
	数组：ngx_array_t 是多块的连续内存，每块内存可以存放许多元素
	链表：ngx_list_t 
	队列：ngx_queue_t 
```

![1563269307176](assets/1563269307176.png)

![1563269843757](assets/1563269843757.png)

```
max size 控制了最大的hash 表的 bucket 的个数
bucket size 是 CPU的 cache line 的对齐问题
```

### nginx 最常用的容器：红黑树

![1563270136933](assets/1563270136933.png)

![1563270281103](assets/1563270281103.png)

![1563270315501](assets/1563270315501.png)

### 使用nginx的动态模块

![1563270395457](assets/1563270395457.png)

![1563270604239](assets/1563270604239.png)

![1563270711665](assets/1563270711665.png)

![1563270725212](assets/1563270725212.png)

```
image_filter 实时的压缩 图片的大小
```



## 第三章 详解HTTP模块

### 冲突的配置指令以谁为准？

![1563270922648](assets/1563270922648.png)

![1563270975084](assets/1563270975084.png)

![1563271011176](assets/1563271011176.png)

![1563271090187](assets/1563271090187.png)

![1563271184577](assets/1563271184577.png)

### Listen 指令的用法

![1563271353152](assets/1563271353152.png)

### 处理HTTP请求头部的流程

![1563271506631](assets/1563271506631.png)

![1563271722925](assets/1563271722925.png)

### nginx中的正则表达式

![1563271989641](assets/1563271989641.png)

![1563272049633](assets/1563272049633.png)

![1563272256215](assets/1563272256215.png)

### 如何找到处理请求的server指令快

![1563272366137](assets/1563272366137.png)

![1563272549887](assets/1563272549887.png)

```
将server_name_in_redirect 改为on，则请求 second.taohui.tech 会使用到 primary.taohui.tech进行拼接
```

![1563272639620](assets/1563272639620.png)

![1563272678457](assets/1563272678457.png)

![1563272788838](assets/1563272788838.png)

### 详解HTTP请求的11个阶段

###### ![1563272937240](assets/1563272937240.png)

### 11个阶段的顺序处理

![1563273248692](assets/1563273248692.png)

### postread阶段：获取客户端真是的IP模块 realip

![1563273413537](assets/1563273413537.png)

```
X-Rorwarded-For 可以添加多个的 请求途径的IP
X-Real-IP 只有真是的客户请求的IP
```

![1563273910155](assets/1563273910155.png)

![1563273949535](assets/1563273949535.png)

![1563273990817](assets/1563273990817.png)

```
set_real_ip_from 指定对于来源IP 是 哪些的，才进行 real_ip 的更改
real_ip_header IP是从哪个变量里去（从 X-Rorwarded-For 还是X-Real-IP）
real_ip_recursive 递归的查找最初的 real_ip
```

![1563274431494](assets/1563274431494.png)

![1563274473821](assets/1563274473821.png)

![1563274503038](assets/1563274503038.png)

![1563274522531](assets/1563274522531.png)

### rewrite阶段 rewrite 模块：return指令

![1563274648302](assets/1563274648302.png)

![1563274823576](assets/1563274823576.png)

![1563274914509](assets/1563274914509.png)

![1563275039481](assets/1563275039481.png)

![1563275060705](assets/1563275060705.png)

![1563275096898](assets/1563275096898.png)

![1563275109112](assets/1563275109112.png)

![1563275127948](assets/1563275127948.png)

![1563275150529](assets/1563275150529.png)

### rewrite阶段 rewrite 模块：rewrite指令(重写URL)

![1563275222599](assets/1563275222599.png)

![1563275399379](assets/1563275399379.png)

![1563275541845](assets/1563275541845.png)

![1563275559554](assets/1563275559554.png)

![1563275624602](assets/1563275624602.png)

![1563275671684](assets/1563275671684.png)

![1563275706710](assets/1563275706710.png)

![1563275770146](assets/1563275770146.png)

![1563275931502](assets/1563275931502.png)

![1563275962858](assets/1563275962858.png)

### rewrite阶段 rewrite 模块：条件判断

![1563328716814](assets/1563328716814.png)

![1563328751603](assets/1563328751603.png)

​	![1563328812370](assets/1563328812370.png)

### find_config 阶段：找到处理请求的location 指令块

![1563328978699](assets/1563328978699.png)

```
merge_slashes on 合并url中的斜杠，多个相邻的斜杠合并为 一个；当URL 中做了base64 编码的时候需要 进行关闭
```

![1563329106378](assets/1563329106378.png)

```
前缀字符串：
	常规：location /aa {...}
	= : location = /aa {...} 精确匹配 /aa 
	^~ : location ^~ /aa {...}  匹配到 /aa 后 不在进行 正则的匹配
```

![1563329343240](assets/1563329343240.png)

![1563329422610](assets/1563329422610.png)

```
首先 会遍历所有的前缀字符串的location
	1）如果 和 = 所对应的 URL 完全匹配后，则停止匹配，使用 = 的location
	2）再进行 ^~ 后的 URL进行匹配，匹配上 则停止下面的正则的匹配
	3）记住最长的 匹配的URL
		依次进行nginx.conf 书写顺序进行正则匹配，匹配不上进行下一条的 正则规则，匹配上则使用匹配的正则规则；如果都匹配不上，则使用 记住的最长的匹配的 URL
```

![1563330059482](assets/1563330059482.png)

![1563330107046](assets/1563330107046.png)

```
curl location.taohui.tech/Test1/  匹配的是 ^~ /Test1/ 最长匹配，而此后又终止 后续的正则匹配
```

![1563330572880](assets/1563330572880.png)

![1563330601054](assets/1563330601054.png)

```
因为 /Test1/Test2/ 最后有一个 / 结尾，而 ~* /Test1/(\w+)$ 最后没有 / ;所以 正则没有匹配上，使用的是最长的前缀字符进行匹配，及 /Test1/Test2
```

### preaccess 阶段：对连接进行限制的 limit_conn 模块

![1563330938172](assets/1563330938172.png)

```
limit_conn 使用了一个zone 指令，nginx 所有的zone指令都是基于共享内存的
```

![1563331101891](assets/1563331101891.png)

```
limit_conn_zone: key 设置一般为客户端的真实IP， zone=name:size 是开辟大小为size名字为name的共享内存
limit_conn: zone 指的是 开辟的共享内存的name，number 是限制的并发连接数是多少
```

![1563331143831](assets/1563331143831.png)

```
limit_conn_log_level: 在出现限制的时候打印一条日志
limit_conn_status 当触发限制的时候，返回给用户的状态码
```

![1563331439940](assets/1563331439940.png)

```
定义了一个 name为addr 的10m 空间的共享内存
$binary_remote_addr 是一个二进制格式的IP地址，在ipv4下只有 4字节，效率比较高
limit_conn_status 500 向用户返回 500 状态码
limit_conn addr 1  限制用户的并发连接数为1
limit_rate 50  限制用户每秒返回给用户的速度 50 字节（为了比较容易产生并发连接数为1 的限制）
```

![1563331839807](assets/1563331839807.png)

### preaccess 阶段：对请求进行限制的 limit_req 模块

![1563331959226](assets/1563331959226.png)

**leaky bucket 算法**

![1563332018763](assets/1563332018763.png)

```
bursty flow: 突发流量
leaky flow: 渗漏流量
fixed flow: 固定流量

当盆满的时候，用户再进行请求，就会返回错误。当盆没有满的时候，用户的请求会变慢，但是不会返回错误。
```

![1563337920897](assets/1563337920897.png)

```
limit_req_zone：zone 定义共享内存，可以是根据什么关键字限制请求的发送速度，rate 为设置每秒可以的请求数
limit_req: zone 是之前定义的共享内存，burst 为盆里可以容纳的请求数，nodelay 盆里的请求不做演示处理，也立刻返回错误
```

![1563338154009](assets/1563338154009.png)

```
limit_req_log_level: 发生限速的时候打印日志
```

![1563338211321](assets/1563338211321.png)

![1563338229287](assets/1563338229287.png)

```
limit_req 模块在 limit_conn 之前执行，如果limit_req 先向用户返回状态码，则 limit_conn 则不会再执行
```

### access阶段：对IP做限制的access模块

![1563338531496](assets/1563338531496.png)

![1563338564019](assets/1563338564019.png)

```
deny 和 allow 是顺序执行的，匹配其中的一条，则不会再往下匹配执行。
```

### access阶段：对用户名密码做限制的auth_basic模块

![1563338764185](assets/1563338764185.png)

```
客户端 访问nginx的时候，nginx 返回 401 给客户端，客户端收到之后，会弹出对话框，让用户进行用户名密码的输入，然后将用户名密码以明文的形式发送到nginx，如果采用https 则可以保证密文传输
```

![1563338953076](assets/1563338953076.png)

![1563338997573](assets/1563338997573.png)

![1563339166182](assets/1563339166182.png)

### access阶段：使用第三方作权限控制的auth_request模块

![1563339285125](assets/1563339285125.png)

```
auth_request: 请求到来后，生成子请求访问uri，根据子请求的结果决定是否放行
auth_request_set: 根据子请求的相关变量可以设置一些变量
```

![1563340712935](assets/1563340712935.png)

```
auth_request: 设定访问的uri 为 /test_auth
子请求反向代理到 8090的 /auth_upstream 
proxy_pass_request_body off: 关闭传递body，没有必要
```

![1563340890024](assets/1563340890024.png)

```
8090 的nginx的配置
```

![1563340919861](assets/1563340919861.png)

```
更改返回状态码为 403
```

### access阶段的statisfy 指令

![1563341069138](assets/1563341069138.png)

```
statisfy all: 必须access 阶段的 三个模块（access、auth_basic、auth_request）都放行才能进行到后续的模块
statisfy any: access 阶段中 单个模块中任意一个放行就可以
```

![1563341311688](assets/1563341311688.png)

![1563344275877](assets/1563344275877.png)

```
1. return执行 在 server rewrite 和rewrite阶段，都先于access阶段
2. 多个的access模块的执行顺序是有影响的。比如配置了 statisfy all; deny all; 则auth_basic 就没有机会执行了
3. 可以访问到密码 因为配置了any，则access阶段的access模块拒绝后，则进行auth_basic 模块的判断
4. 可以，对于放置的顺序没有要求
5. 没有机会输入密码，因为 allow 属于access 模块，已经先于 auth_basic执行了，后续不在判断
```

### precontent 阶段：按序访问资源的try_files 模块

![1563416578355](assets/1563416578355.png)

![1563416679463](assets/1563416679463.png)

![1563416732326](assets/1563416732326.png)

```
try_files 多使用在反向代理中，先访问到达到的nginx 的本地是否有需要的文件，没有的话则设定访问代理到其他的URL查找资源
```

### 实时拷贝流量：precontent阶段的mirror模块

```
mirror 模块可以创建一份镜像流量，将生产环境的请求同步拷贝一份到测试环境做处理
```

![1563417035175](assets/1563417035175.png)

```
mirror 模块，当请求到达nginx后，可以生成一个子请求，子请求可以通过反向代理去访问其他的环境（比如测试环境），对测试环境返回的内容是不进行处理的。
mirror uri; 把同步复制的请求访问到uri去
mirror_request_body on; 把请求的body 也转发到上游的服务中
```

**上游服务的nginx配置**

![1563417375509](assets/1563417375509.png)

**实际的用户处理请求的nginx**

![1563417432905](assets/1563417432905.png)

![1563417451450](assets/1563417451450.png)

```
打开了8001 端口，访问 / 的时候，拷贝一份流量到mirror去，internal 指定只是内部的请求，转发到10020 的nginx上
```

**到本机8001 的请求**

![1563417682522](assets/1563417682522.png)

**上游nginx的请求**

![1563417742642](assets/1563417742642.png)

### content阶段：root和alias 指令

![1563417896311](assets/1563417896311.png)

```
root和 alias指令属于static模块
```

![1563417874517](assets/1563417874517.png)

```
这两个指令都是把URL映射为文件路径，返回静态的文件内容；root会把完整的URL映射到文件路径中（把location后匹配的URL添加到 root path 之后），alias **不会**把location 后的URL映射到文件路径中去
```

![1563418205749](assets/1563418205749.png)

![1563418237309](assets/1563418237309.png)

**访问root**

![1563418274700](assets/1563418274700.png)

![1563418478748](assets/1563418478748.png)

```
访问 static.taohui.tech/root/ 匹配 的location 为location /root {root html}, 所以访问的文件应该为 html/root （加入了location的 root）这个文件，不存在这个文件

从日志可以看出，访问的是 html/root/index.html  ，添加了 index.html 是因为 访问的时候 最后又斜杠（static.taohui.tech/root/）
```

![1563418592326](assets/1563418592326.png)

![1563418606306](assets/1563418606306.png)

```
会在 html/first/1.txt 后面再添加 /root/1.txt
```

![1563418678635](assets/1563418678635.png)

**访问alias**

![1563418768412](assets/1563418768412.png)

```
访问 static.taohui.tech/alias/  访问的是 static.taohui.tech/alias/html/index.html
```

![1563418843020](assets/1563418843020.png)

![1563418921357](assets/1563418921357.png)

```
访问的是 static.taohui.tech/alias/html/first/1.txt
```

### static 模块提供的三个变量

![1563419042441](assets/1563419042441.png)

![1563419161268](assets/1563419161268.png)

![1563419192824](assets/1563419192824.png)

![1563419263685](assets/1563419263685.png)

```
$request_filename: 完整的URL路径
$document_root: 文件的文件夹路径（不进行软连接替换）
$realpath_root: 文件的文件夹实际路径
```

![1563419391687](assets/1563419391687.png)

```
types 指令，当读取磁盘中的文件时候，根据文件的扩展名做一次映射
default_type 在匹配不到相应的文件时，则使用默认的类型设置cotent-type
type_hash_bucket_size 为了提高types 的性能，做了hash
```

![1563419587957](assets/1563419587957.png)

```
将log_not_found 置为off，则可以取消找不到文件的日志，提高性能
```

### static模块对URL不以斜杠结尾 却访问目录的做法

![1563419883919](assets/1563419883919.png)

![1563420269533](assets/1563420269533.png)

![1563420429521](assets/1563420429521.png)

```
absolute_redirect 置为off
```

![1563420476090](assets/1563420476090.png)

```
访问 html 下的first 但是 URL 最后没有加 反斜杠，此时就发生了 301 的跳转，此时返回的 Location: /fitst/  没有 http 的头部的
```

![1563420599844](assets/1563420599844.png)

```
注释掉absolute_redirect 及 默认为on
```

![1563420634364](assets/1563420634364.png)

```
此时返回的 Location 带有http://localhost:8088
```

![1563420690404](assets/1563420690404.png)

**想用server_name中的域名返回到 Location中去**

![1563420750195](assets/1563420750195.png)

```
配置 server_name_in_redirect on 
```

![1563420793187](assets/1563420793187.png)

### content 阶段的index模块和auto_index模块

![1563420873226](assets/1563420873226.png)

```
index模块 先于 autho_index 模块执行的
```

![1563421002449](assets/1563421002449.png)

![1563421114837](assets/1563421114837.png)

![1563421211849](assets/1563421211849.png)

```
index 先于autoindex 执行，因 index 默认访问的index.html ,html 下存在 index.html,所以默认的会访问 index.html; 如果设置 index a.html, a.html 不存在，则autoindex 生效，返回html 下的目录内容
```

![1563421360200](assets/1563421360200.png)

```
autoindex_exact_size on 的话，会以字节显示文件的大小
```

### 提升多个小文件性能的concat模块

![1563421607785](assets/1563421607785.png)

![1563432768579](assets/1563432768579.png)

```
concat: 启用还是不启用
concat_delimiter: 定义返回的多个文件之前的分隔符
concat_types: 对那些文件的内容进行合并
concat_unique: 只对一种或多种的文件类型进行合并
concat_ignore_file_error: 发现有一些的文件存在错误，则进行忽略
concat_max_files: 最多的合并的文件的个数
```

**淘宝网的请求**

![1563433060607](assets/1563433060607.png)

```
再一次的请求中 使用 在URL后 添加 ?? 返回多个文件
```

![1563433143647](assets/1563433143647.png)

```
concat_max_files 设置最多返回20个文件
concat_delimiter 以 ::: 为分割
```

![1563433243294](assets/1563433243294.png)

![1563433317359](assets/1563433317359.png)

![1563433282031](assets/1563433282031.png)

```
访问返回的结果为1.txt 和 2.txt 的内容，内容用 ::: 进行分割

当使用 http1.0 或 1.1 时可以使用 concat模块提升效率
```

### access日志的详细的用法

```
static 之后进入到 log 阶段
```

![1563433465561](assets/1563433465561.png)

![1563433476960](assets/1563433476960.png)

![1563433519384](assets/1563433519384.png)

```
escape 定义日志的分隔符，以及是不是json 的格式
```

![1563433650525](assets/1563433650525.png)

```
当path路径中包含变量的时候，每一个请求，的变量都可能不同，意味着nginx在不停的打开关闭不同的日志文件，打开cache就是为了解决这个问题的
access_log [if=condition] : 只有当条件满足的时候记录日志
日志缓存 [buffer=size] [flush=time]: 当积累的日志的大小超出buffer的大小的时候，进行写入; 当到达flush时间的时候进行写入；
```

![1563434048993](assets/1563434048993.png)

```
当access_log 的日志写入路径中航含有变量的时候，使用open_log_file_cache 打开一个缓存，来使得含有变量的日志文件不会被经常的打开关闭。
```

### HTTP过滤模块的调用流程

![1563434240318](assets/1563434240318.png)

![1563434482418](assets/1563434482418.png)

```
copy_filter 会复制包体的内容，使用0拷贝技术，用户态的内存不经过nginx，直接发送给用户
write_filter 会调用系统的系统调用发送给客户端的响应
```

### 用过滤模块更改响应中的字符串：sub模块

![1563434765832](assets/1563434765832.png)

![1563434790120](assets/1563434790120.png)

```
sub_filter 把返回给用户的响应的字符串string，替换为replacement
sub_filter_last_modified on 因为修改了返回给用户的响应，还需要显示原先的last_modified 返回给用户
sub_filter_once 只修改一次
sub_filter_types 只针对什么样的类型的响应进行替换（可以设置为 *, 对所有的文件进行替换）
```

![1563435128795](assets/1563435128795.png)

```
返回的是nginx默认的 欢迎页面
```

![1563435178396](assets/1563435178396.png)

![1563435326237](assets/1563435326237.png)

```
这个模块是忽略大小写的
```

![1563435288492](assets/1563435288492.png)

```
因为设置了替换once, 只把a 标签内的nginx.org 替换了，而 显示的内容nginx.org 没有替换
```

![1563435731685](assets/1563435731685.png)

```
显示last_modified 这个HEAD 给客户
```

![1563435432045](assets/1563435432045.png)

### 用过滤模块在http响应的前后添加内容： addition 模块

![1563436778589](assets/1563436778589.png)

![1563436814794](assets/1563436814794.png)

```
add_before_body 在body之前添加一些内容，根据 uri 这个子请求返回的内容，添加到body之前
addition_types 指定怎样的context 内容使用addition 模块
```

![1563437023950](assets/1563437023950.png)

**不添加addition模块指令**

![1563437075447](assets/1563437075447.png)

![1563437090440](assets/1563437090440.png)

```
打开addition模块的注释
会在内容的前后添加响应的内容
```

![1563437135190](assets/1563437135190.png)

### Nginx变量的运行原理

![1563437263942](assets/1563437263942.png)

```
左边为提供变量的模块，右边为使用变量的模块，提供变量的模块如果提供这个变量呢？

启动nginx，nginx发现这是一个http模块，http模块有一个preconfiguretion的方法，在还没有读取nginx.conf 之前添加新变量（其实就是定义了一个变量名和解析出这个变量的方法（即给出输入http head,通过定义解析http head 中取出Host: 的对应字段，作为 nginx的host变量的值）），这个时候请求还没有进来，只是定义了变量的提取规则。

使用变量的模块，通过读取nginx.conf 文件确定使用了哪些的变量，当真正的http请求到来的时候，处理请求时通过变量名去找寻变量的解析方法，从而解析出变量的值
```

![1563437453159](assets/1563437453159.png)

```
使用变量的模块，只有在http请求到来的时候，才进行解析取值。
```

![1563437505251](assets/1563437505251.png)

```
variable_hash_bucket_size 变量名如果起的过长，可以考虑增大这个size
variable_hash_max_size 如果变量比较多的话可以增大这个值
```

### HTTP框架提供的请求相关的变量

**var.conf 的配置**

![1563438665303](assets/1563438665303.png)

![1563438711594](assets/1563438711594.png)

![1563438611634](assets/1563438611634.png)

```
arg_a: 为a 的值；arg_b: 为b 的值；args: 为URL参数
connection： 为连接的序号； connection——requests: 一共是执行了1个请求
cookie_a: 是cookie a=1 的值
host: localhost, server_name: var.taohui.tech, http_host: localhost:9090
```

![1563439064685](assets/1563439064685.png)

```
body_bytes_sent: 在http head 解析阶段没有值，在日志中是有值的
```

![1563439132149](assets/1563439132149.png)

![1563439181515](assets/1563439181515.png)

![1563439537551](assets/1563439537551.png)

```
uri 是资源定位，不包含 ? 后面的参数
document_uri 与uri 完全相同，只是因为历史原因而存在 
```

![1563439691537](assets/1563439691537.png)

![1563439759351](assets/1563439759351.png)

![1563439802914](assets/1563439802914.png)

```
特殊的6种nginx会做一些微小的处理，而其他的则 从http head 中原封不动的提取
```

### HTTP 框架提供的其他的变量

![1563440002870](assets/1563440002870.png)

```
connection_requests: 这个TCP连接上执行的请求数
proxy_protocol 是为了解决像realip 协议经过多层的 反向代理去的用户真实的IP而设置的，http 协议可以通过 X-Real-Ip 或 X-Rorwarded-For 去的客户的真实IP，而TCP协议没有这样的头部解决方案；proxy_protocol 在TCP层新增了一个协议头保存原始用户的头部
```

![1563440169250](assets/1563440169250.png)

```
TCP_INFO 包含tcp内核中的很多参数
```

![1563440660385](assets/1563440660385.png)

![1563440707959](assets/1563440707959.png)

![1563440738796](assets/1563440738796.png)

![1563440819315](assets/1563440819315.png)

### 使用变量防盗链的referer模块

![1563440918556](assets/1563440918556.png)

![1563441047282](assets/1563441047282.png)

![1563441235311](assets/1563441235311.png)

```
block 允许有referer 头部，但没有对应的值，可能是由于反向代理或防火墙配置不当导致
```

![1563441457797](assets/1563441457797.png)

![1563441582591](assets/1563441582591.png)

![1563441768769](assets/1563441768769.png)

```
referer: http://www.taohui.org.cn/ttt 没有匹配的项，只有个 http://www.taohui.org.cn/nginx/
```

![1563441849937](assets/1563441849937.png)

```
因为 *.taohui.pub 的泛域名的存在
```

![1563441903963](assets/1563441903963.png)

```
相当于匹配到了 block 选项，存在referer，但值为空
```

![1563441954944](assets/1563441954944.png)

```
相当于匹配 none
```

![1563441980703](assets/1563441980703.png)

```
没有任何的www.taohui.tech ,虽然有 server_names 但server_name 为 referer.taohui.tech
```

![1563442105938](assets/1563442105938.png)

```
匹配的是server_names
```

![1563442138765](assets/1563442138765.png)

```
没有百度的
```

![1563442174595](assets/1563442174595.png)

```
google 通过正则表达式进行了匹配
```

### 使用变量实现防盗链功能实践：secure_link 模块

![1563442279828](assets/1563442279828.png)

![1563442781671](assets/1563442781671.png)

![1563442862378](assets/1563442862378.png)

![1563442897043](assets/1563442897043.png)

![1563443021775](assets/1563443021775.png)

![1563443240528](assets/1563443240528.png)

```
curl 请求返回的 1（表示验证通过） 是secure_link 的变量值
openssl 生成的md5 需要按照 '时间戳 uri remote_ip 密钥'  生成
secure_link_md5 设置 MD5 的生成顺序
secure_link 设置请求的参数配置
```

![1563443554287](assets/1563443554287.png)

![1563443569727](assets/1563443569727.png)

![1563443618116](assets/1563443618116.png)

![1563443690307](assets/1563443690307.png)

```
secure_link_secret 设置使用的密钥
$secure_link 为空，则验证不通过，通过的话则 rewrite 到 原先实际的链接
```

![1563443892201](assets/1563443892201.png)

```
生成md5 位置的字符串		
```

![1563444081845](assets/1563444081845.png)

### 为复杂的业务生成新的变量：map模块

![1563444288123](assets/1563444288123.png)

![1563444407590](assets/1563444407590.png)

```
map string $variable { case ... default ...}
原始变量的值或字符串： string
$variable: case 选中的情况下，把后面的值放入到 variable 变量中去
```

![1563444637229](assets/1563444637229.png)

![1563444754564](assets/1563444754564.png)

```
map $http_user_agent $mobile {
	default 0;		
	"~Opera Mini" 1;
}
当 $http_user_agent 匹配到 "~Opera Mini"时，把 mobile 改为1；默认为0。
```

![1563444938107](assets/1563444938107.png)

![1563445245573](assets/1563445245573.png)

```
泛域名优先于正则表达式，泛域名中 前缀有限与后缀；所以匹配的是 *.taohui.org.cn	
```

![1563445411103](assets/1563445411103.png)

```
只有正则表达式匹配上
```

![1563445448326](assets/1563445448326.png)

```
完全匹配的优先级最高
```

### 通过变量指定少数用户实现AB测试：split_client模块

```
此模块可以根据变量的值，根据百分比的形式生成新的变量

产品推出了多个版本的功能，让某个百分比的用户尝试不同的版本，进行不同版本的反馈
```

![1563445622130](assets/1563445622130.png)

![1563445830240](assets/1563445830240.png)

![1563445901464](assets/1563445901464.png)

![1563446031728](assets/1563446031728.png)

```
通过头部传入的testcli 参数落的 范围，进行复制 variant；后续可以根据 variant 变量判断，将请求导入到不同的版本
```

### 根据IP地址的范围的匹配生成新的变量：geo模块

![1563446331666](assets/1563446331666.png)

![1563448502790](assets/1563448502790.png)

![1563448940948](assets/1563448940948.png)

![1563448982935](assets/1563448982935.png)

```
address 默认从 remote ip 取出IP
指定了proxy 后，从 X-Forward-For 取出IP地址
```

![1563449191809](assets/1563449191809.png)

```
取的address 为 192.168.1.123 则 返回的变量为UK
```

![1563449268105](assets/1563449268105.png)

```
address 为 10.1.0.0 ，则取RU
```

![1563449318519](assets/1563449318519.png)

```
取到127.0.0.1 则匹配子网掩码的规则（127.0.0.1/32），为RU
```

### 使用变量获取用户的地理位置：geoip模块

![1563449857708](assets/1563449857708.png)

![1563450683860](assets/1563450683860.png)

```
geoip_country 指定maxmind 中的国家类的IP地址文件
geoip_proxy 提供了一个可信地址
```

![1563450868283](assets/1563450868283.png)

```
geoip_city 是 geoip_country的超集
```

![1563450936279](assets/1563450936279.png)

![1563451086506](assets/1563451086506.png)

```
编译生成GeoIP.dat 的数据库
```

![1563451151576](assets/1563451151576.png)

```
加入了geoip_proxy 后，可以取得http 头部的 x-forwarded-for 的地址
```

![1563451265607](assets/1563451265607.png)

![1563451299584](assets/1563451299584.png)

### 客户端使用keepalive 提升连接效率

![1563451378927](assets/1563451378927.png)

![1563451655360](assets/1563451655360.png)

```
keepalive_disable 针对什么浏览器禁用keepalive
keepalive_requests 一个TCP连接上最多执行多少个请求
keepalive_timeout 第一个timeout 是一个TCP连接之后，最多这个连接保持的时间，第二个timeout是 服务端设置的 Keep-Alive 头部的值，告诉客户端至少保持n秒
```

## 第四章 反向代理与负载均衡

### 反向代理与负载均衡原理

![1563452551683](assets/1563452551683.png)

![1563452602026](assets/1563452602026.png)

```
X 轴扩展（水平扩展）：服务是无状态的，不论起多少个服务，同等的为客户提供服务；round-robin 和 least-connected 是标准的基于水平扩展的算法；水平扩展不能解决数据量大的问题，单台的数据量过大，无论扩展多少台，依旧数据量很大。
Y 轴扩展（垂直扩展）：基于功能上进行拆分，原先基于一台应用服务处理的功能，拆分为多个应用服务分别处理不同的API接口（基于location 匹配不同的URL分发到不同的集群）
Z 轴扩展：基于用户的信息进行扩展，根据用户名、IP等信息 引流到固定的集群,nginx 提供了较多的hash的算法来实现Z轴扩展
```

![1563453246803](assets/1563453246803.png)

```
七层的HTTP协议可以转换为上游的多种不同的协议
```

![1563453376805](assets/1563453376805.png)

```
基于时间的缓存：
	第一个用户请求index.html 时，nginx本地没有，向上游服务器获取后，发给用户的同时，缓存一份到nginx的本地。第二个用户同样请求index.html nginx 直接从nginx的缓存中发送
基于空间的缓存：
	nginx 会预先拉去后端的资源到nginx的服务器
```

### 负载均衡策略：round-robin

```
round-robin 是所有的负载均衡算法的基础，如果指定的其他的算法不生效，则退化为round-robin 算法
```

![1563453675601](assets/1563453675601.png)

```
upstream 会定义一个名字给后面的 反向代理模块使用
server 是具体的处理业务的服务器
```

![1563453759951](assets/1563453759951.png)

![1563454007096](assets/1563454007096.png)

![1563454221120](assets/1563454221120.png)

```
proxy_http_version 1.1; 防止 下游请求使用的 1.0 的版本
proxy_set_header Connection ""; 重新设置 keepalive 属性
```

![1563455089480](assets/1563455089480.png)

![1563455146444](assets/1563455146444.png)

```
当使用域名去访问上游的服务的时候，可以使用resolver 指定一个自己的DNS服务
```

**上游服务器的配置**

![1563455251302](assets/1563455251302.png)

**负载均衡的nginx**

![1563455320608](assets/1563455320608.png)

```
8011 的权重为2,8012 默认为1
keepalive 32; 最多缓存32 个连接
```

![1563455418530](assets/1563455418530.png)

![1563455562049](assets/1563455562049.png)

```
两次的请求共用一个的TCP连接，没有出现FIN断开连接
```

### 负载均衡hash算法：ip_hash与hash模块

![1563455778459](assets/1563455778459.png)

![1563455904506](assets/1563455904506.png)

![1563456002331](assets/1563456002331.png)

```
upstream 块 虽然指定了weight 但是不生效，会根据IP来做负载
set_real_ip_from 设置代理服务的IP
```

![1563456461919](assets/1563456461919.png)

![1563456570060](assets/1563456570060.png)

```
同一个来源的IP访问同一个后端，即使服务宕机了也访问这台服务
```

![1563456676623](assets/1563456676623.png)

**自己构造字符串的hash模块**

![1563456717383](assets/1563456717383.png)

![1563456805102](assets/1563456805102.png)

![1563456836704](assets/1563456836704.png)

### 一致性hash算法：hash模块

```
之前的hash 当服务器的数量发生变化的时候，会造成大量的服务路由信息失效，而一致性hash算法可以缓解这个问题
```

![1563457043200](assets/1563457043200.png)

![1563457121663](assets/1563457121663.png)

```
服务宕机或扩容的时候，路由的变更，会导致大量的缓存失效
```

![1563457215550](assets/1563457215550.png)

```
首先有一个 0 到 2^32 次方的 数字环，四个节点均匀的散落在环上；如，当键计算hash 散落在1/4（node3） 到 2/4(node4) 之间则由临近他的逆时针方向的node3 进行处理, 落到其他区间的类推
```

![1563457334280](assets/1563457334280.png)

```
当添加节点node5 时，之后影响node5到node2 之间的key的访问到node5上,减少了影响的范围
```

![1563458017082](assets/1563458017082.png)

```
在配置hash 的时候 指定 consistent 就可以设置一致性hash环
```

### 最少连接算法以及如何跨worker进程生效

![1563460288015](assets/1563460288015.png)

![1563460376565](assets/1563460376565.png)

![1563460687616](assets/1563460687616.png)

### http upstream模块提供的变量

![1563460883911](assets/1563460883911.png)

![1563460946856](assets/1563460946856.png)

### http 反向代理proxy处理请求的流程

![1563461115470](assets/1563461115470.png)

```
proxy_buffering: 开启之后，会把 请求的包体读取完毕之后缓存之后发送到上游，关闭的话，则边读取边发送
```

### proxy模块的proxy_pass 指令

![1563461533478](assets/1563461533478.png)

![1563461564278](assets/1563461564278.png)

**上游的服务器**

![1563461926861](assets/1563461926861.png)

![1563462011906](assets/1563462011906.png)

```
不添加URI，上游收到的uri 为原封不动的
```

![1563462083310](assets/1563462083310.png)

```
得到的仍是 /a/b/c
```

![1563462160061](assets/1563462160061.png)

```
请求的 uri /a/b/c 中的a 被proxy_pass 的www 进行了替换
```

### 根据指令更改发往上游的请求

![1563462311783](assets/1563462311783.png)

```
更改上游的 请求方法和http版本的头部信息
```

![1563462405906](assets/1563462405906.png)

```
proxy_set_header 修改或添加新的头部；需要注意默认的两个值 Connection 和 Host，如果 $proxy_host 的值为空，则默认的不会发送这条head Host的值，而不是 Host: ""

proxy_pass_request_headers 是否要把用户请求的头部发送到上游
```

![1563462763999](assets/1563462763999.png)

```
proxy_pass_request_body 是否要把用户请求的body发送到上游
proxy_set_body 是否自定义设置body
```

**上游服务器配置**

![1563462897429](assets/1563462897429.png)

**nginx配置**

![1563463854726](assets/1563463854726.png)

![1563463929612](assets/1563463929612.png)

```
不设置proxy配置的参数
```

![1563464029856](assets/1563464029856.png)

```
改动方法名为POST， version 改为1.1 ， request_header 不进行传递
```

![1563464102305](assets/1563464102305.png)

```
可以看到 method 为post 协议为1.1  http_name 不能取到 值了
```

![1563464278188](assets/1563464278188.png)

```
proxy_set_body 设置body为 "hello world!"
```

![1563464545909](assets/1563464545909.png)

![1563464421497](assets/1563464421497.png)

```
查看到8012的请求 的body 
```

### 接受用户请求包体的方式

![1563464642293](assets/1563464642293.png)

![1563464710533](assets/1563464710533.png)

```
在接受head时 可能接受到了一部分的body，如果body比较小，是全部的包体了，则不需要分配client_body_buffer_size 的内存；
剩余待接收的包体长度(content-length的大小 - 已接受的)小于 client_body_buffer_size的大小，分配所需的大小的内存；
其余的按照 client_body_buffer_size 设置的大小，一点点的读取body，如果存在proxy_buffering on;则缓存再发送，off 则立即发送到上游

client_body_in_single_buffer 开启的话则，request_buffer 的变量可以使用了	 
```

![1563464883526](assets/1563464883526.png)

![1563465871011](assets/1563465871011.png)

```
client_body_temp_path 定义body 的缓存目录，level1 level2 是指定缓存目录的目录级别
client_body_in_file_only： on 所有的body缓存到文件中在请求完成之后也不删除，clean 用户请求body必须缓存到文件，请求处理完成之后就会删除， off 请求body小于buffer则不会缓存到文件，大于buffer的缓存会在请求之后删除body缓存
```

![1563466706277](assets/1563466706277.png)

### 与上游服务建立连接

![1563466895299](assets/1563466895299.png)

```
proxy_connect_timeout 默认 60s, 当nginx 与上游的服务在60s内没有建立连接的话，nginx 会返回自己的502状态码

proxy_next_upstream http_502: 当nginx 产生502 的请求码之后，可以更换一个上游的服务器继续处理这个请求
```

![1563467316685](assets/1563467316685.png)

```
TCP 层的keepalive 是在数据停止发送一个定时器的时长之后，会发送一个探测包，探测这个连接是否还继续维持，这个是操作系统维持的长连接
```

![1563467572040](assets/1563467572040.png)

![1563467614406](assets/1563467614406.png)

```
proxy_bind 的两类用途：
	1. 当nginx的上游有多个的IP地址时（内网或外网），不适用系统帮我们选择的IP地址，而主动指定一个IP地址
	2. 很可能为了传递一个IP地址（透传IP地址的策略）即：proxy_bind $remote_addr ，如果指定的IP地址不属于所在的机器的IP地址，则需要添加 transparant

原理: 更改TCP头的 source IP Address，上游收到的IP地址就位更改后的IP地址
```

![1563467719420](assets/1563467719420.png)

```
如果 设置为on，则可能客户端与nginx的连接已经关闭，但是nginx与上游的服务器的连接还进行维持
```

![1563468278553](assets/1563468278553.png)

### 接受上游的响应

![1563521753694](assets/1563521753694.png)

```
error log 中的upstream sent too big header 是因为 proxy_buffer_size 太小导致的，上游的response head 头部太大
```

![1563521940169](assets/1563521940169.png)

```
接受响应的头部 是nginx的框架upstream进行的，而处理响应头部是 由各个的反向代理的模块（grpc, fastcgi, uwsgi, http proxy）进行的

proxy_buffering 控制是否 接受完整的包体后 发送，还是 实时的边接收边发送
```

![1563522520985](assets/1563522520985.png)

```
及时开启了 proxy_buffering 也不一定写入到 缓存文件，当包体 较小的时候；因为有proxy_buffers 的存在直接缓存在内存中，（32k 或 64k），大于设置的proxy_buffers 之后才可能缓存到磁盘。
```

![1563522866789](assets/1563522866789.png)

```
proxy_buffering 默认开启，会尽快的断开上游的服务器的连接
X-Accel-Buffering 这个是只有nginx才会识别的head， 上游的服务置为yes的话，要求nginx先接受完上游的服务的body 后再向客户端进行发送。

proxy_max_temp_file_size 最大的写入的缓存文件的大小
proxy_temp_file_write_size 每次写入缓存文件的大小
proxy_temp_path 设置缓存文件袋嗯路径，以及使用多少层级的目录
```

![1563524115584](assets/1563524115584.png)

```
目的是更及时的响应客户端的请求，比如接受到 1G的文件，在接受到8k 的时候就先向客户端反馈
```

![1563524227825](assets/1563524227825.png)

```
proxy_read_timeout 是两次的读取时候的超时（TCP层的概念）
proxy_limit_rate 限制的是读取上游的服务的响应
```

![1563524339846](assets/1563524339846.png)

```
上游的包体发送过来之后，可能是完整的文件，nginx 可能需要把它存储下来。
proxy_store_access 包临时的包体存储时的权限的方法
proxy_store 配置on时，会使用root指令把 临时目录 到 root下，string 可以使用变量的方式，指定存储到的位置
```

![1563524614631](assets/1563524614631.png)

```
root 为/tmp
再向proxyups 发送请求的响应，proxy_store on，会把返回的包体缓存到 root(/tmp 下)
配置 目录的权限为 user:rw group:rw all:r
```

**上游的服务的配置**

![1563524768387](assets/1563524768387.png)

![1563524799523](assets/1563524799523.png)

**访问之前nginx的 /tmp 下没有a.txt**

![1563524834864](assets/1563524834864.png)

**发送一次的访问后**

![1563524871232](assets/1563524871232.png)

### 处理上游的响应头部

**HTTP的过滤模块**

![1563524967263](assets/1563524967263.png)

```
生成的响应的内容向客户端发送的时候，必须经理过滤模块的处理，nginx 上游服务返回的内容同样会被这些过滤的模块所处理。
比如：not_modified_filter 模块，根据上游服务返回的cache_controll 修改我们到底是发送 200 还是 304 响应码给客户端，所以上游的返回响应的内容会改变nginx的行为。
```

![1563525926815](assets/1563525926815.png)

![1563526017596](assets/1563526017596.png)

![1563526103002](assets/1563526103002.png)

```
proxy_cookie_domain 修改域名
proxy_cookie_path 对path 中进行替换
```

![1563526198839](assets/1563526198839.png)

```
proxy_redirect 对location 的头部进行替换
```

![1563526255193](assets/1563526255193.png)

**上游服务**

![1563526285460](assets/1563526285460.png)

![1563526304977](assets/1563526304977.png)

**使用反向代理访问，可以看到aaa 的kv**

![1563526345436](assets/1563526345436.png)

**禁止上游的header**

![1563526371086](assets/1563526371086.png)

![1563526399173](assets/1563526399173.png)

**上游的server 为nginx，反向代理的server 为 openresty**

![1563526467053](assets/1563526467053.png)

![1563526485300](assets/1563526485300.png)

**上游的nginx进行了限速**

![1563526521714](assets/1563526521714.png)

**此时进行访问发现速度很慢**

![1563526598456](assets/1563526598456.png)

![1563526619569](assets/1563526619569.png)

```
使用 proxy_ignore_headers X-Accel-Limit-Rate 忽略上游的这个参数
```

![1563526688381](assets/1563526688381.png)

```
此时的速度很快
```

### 上游出现失败时的容错方案

![1563526894466](assets/1563526894466.png)

```
当上游返回失败的时候，是有一些处理方法的。这个指令执行的前提是没有想客户端发送一个字节，如果存在发送则不能使用。

error 当出现错误的时候，就执行这个指令，这个错误指的是网络的错误。
invalid_header 上游的http header不合法
http_状态码  当出现一些指定的状态码的时候，可以在此指定一个新的上游服务进行处理
```

![1563527181002](assets/1563527181002.png)

**反向代理的配置，此时没有更改proxy_next_upstream off**

![1563527279672](assets/1563527279672.png)

![1563527318715](assets/1563527318715.png)

**上游的服务**

![1563527362694](assets/1563527362694.png)

![1563527529832](assets/1563527529832.png)

```
正常情况下，轮询访问 8011 和8013
```

**更改上游的nginx的端口为8014**

![1563534076983](assets/1563534076983.png)

**此时轮询到8014时，报错**

![1563537980428](assets/1563537980428.png)

**配置 /error 开启proxy_next_upstream error**

![1563538068529](assets/1563538068529.png)

```
会在报错的时候 进行next upstream 转发
```

![1563538178527](assets/1563538178527.png)

```
此时都转发请求到 8011 上了
```

**恢复改动正常的访问8011 和 8013**

![1563538295244](assets/1563538295244.png)

```
8013 返回的是500 的状态码
```

![1563538355191](assets/1563538355191.png)

![1563538378026](assets/1563538378026.png)

```
访问到8013 的时候 因为返回 500 ，则重新选择 8011 的上游服务
```

![1563538426874](assets/1563538426874.png)

```
当proxy_intercept_errors off 时，当上游的服务返回 404时， 配置的error_page 404 是不生效的。
```

![1563538554533](assets/1563538554533.png)

![1563538578715](assets/1563538578715.png)

![1563538618098](assets/1563538618098.png)

![1563538662154](assets/1563538662154.png)

### 对上游使用SSL连接

![1563538791454](assets/1563538791454.png)

![1563538881088](assets/1563538881088.png)

```
这两个指令的上下文是没有 location的
```

![1563538932337](assets/1563538932337.png)

![1563538957927](assets/1563538957927.png)

![1563539003046](assets/1563539003046.png)

![1563539201551](assets/1563539201551.png)

![1563539306915](assets/1563539306915.png)

![1563539999148](assets/1563539999148.png)

![1563540048368](assets/1563540048368.png)

![1563540076659](assets/1563540076659.png)

```
分别生成 根证书的 公私钥
```

**生成 a 证书，供上游的服务使用**

![1563540542608](assets/1563540542608.png)

![1563540509734](assets/1563540509734.png)

```
a.pem 公钥 a.key 私钥
a.csr 使用公钥 发起签发请求
```

![1563540708863](assets/1563540708863.png)

```
使用 a 的签发请求 a.csr, 和根证书的公（ca.crt）私(ca.key)钥，生成 a.crt 的a 证书
```

![1563540824444](assets/1563540824444.png)

```
验证是否签发成功
```

**同样的方法生成b证书**

![1563540891107](assets/1563540891107.png)

**配置上游服务**

![1563540932343](assets/1563540932343.png)

![1563540952340](assets/1563540952340.png)

![1563542796534](assets/1563542796534.png)

```
ssl_certificate : 是自己作为服务端使用的证书 a.crt
ssl_certificate_key: 服务端使用的私钥 a.key

下游反向代理的nginx 需要校验 使用ssl_verify_client optional(只要发来就校验); ssl_verify_depth 2;校验的深度。 

ssl_client_certificate 配置验证的 签发机构的证书，因为b.crt 也是ca.crt 签发的
```

**代理服务的配置**

![1563543345955](assets/1563543345955.png)

```
proxy_ssl_certificate 配置连接上游的服务的使用的证书
proxy_ssl_server_name 验证server name 
上游的服务使用的是 a 证书，所以 proxy_ssl_name 为a
```

![1563543848395](assets/1563543848395.png)

### 用好浏览器的缓存

![1563544107772](assets/1563544107772.png)

![1563677951867](assets/1563677951867.png)

```
ETag 用于标识 资源的版本，相当于资源的指纹
```

![1563693121498](assets/1563693121498.png)

![1563693176957](assets/1563693176957.png)

```
浏览器 通过 if-None-Match 的头部的值填写 ETag 的值，nginx 收到 If-None-Match 的时候做比较，当浏览器的ETag 和 nginx的 ETag 没有相匹配的时候 返回 200 ，否则返回 304 没有改变
```

![1563693855800](assets/1563693855800.png)

![1563693893512](assets/1563693893512.png)

```
IF-Modified-Since 是根据时间进行判断的，服务器 在所请求的资源在给定的日期之后 对内容修改了，才将资源返回，返回200
```

![1563677915387](assets/1563677915387.png)

```
先判断 ETag 后判断 last-Modified 
```

![1563694209572](assets/1563694209572.png)

```
存在缓存的话，资源会from disk cache 的
```

### Nginx 决策浏览器过期缓存是否有效

![1563694349915](assets/1563694349915.png)

```
max 标识缓存的永久有效（Expires: 绝对时间，这个时间内都一有效  Cache-Control: 最大的缓存时间 10年）
epoch 表示不使用这个缓存，此时的缓存过期时间是非常小的
time 跟的为具体的时间：
	正数：根据当前时间与设定的时间 算出 Expires 时间
	负数：Cache-Control: no-cache
	@: 指定具体的某个时刻的值
```

![1563694835873](assets/1563694835873.png)

![1563694882909](assets/1563694882909.png)

![1563694901896](assets/1563694901896.png)

![1563694941278](assets/1563694941278.png)

![1563694966557](assets/1563694966557.png)

![1563695014036](assets/1563695014036.png)

![1563695179823](assets/1563695179823.png)

![1563695229160](assets/1563695229160.png)

![1563695269701](assets/1563695269701.png)

![1563695313132](assets/1563695313132.png)

![1563695362849](assets/1563695362849.png)

![1563695654590](assets/1563695654590.png)

![1563695690401](assets/1563695690401.png)

```
If-MOdified-Since 的值，和第一次请求的值是一样的， ETag 的值也是一样的
```

**修改ETag 的值后 重新获得资源，返回200**

![1563695804892](assets/1563695804892.png)

### 缓存的基本的使用方法

![1563696146543](assets/1563696146543.png)

```
proxy_cache zone可以指定使用哪一个第一好的共享内存来使用
proxy_cache_path 定义共享内存  
path 定义缓存文件的存放位置
keys_zone 中的name 是共享内存中的名字 size 为共享内存的大小
levels 定义缓存目录的层级，最多3级，每层目录的长度为1 或 2个字节
```

![1563696355462](assets/1563696355462.png)

![1563696519997](assets/1563696519997.png)

![1563696604752](assets/1563696604752.png)

![1563696621598](assets/1563696621598.png)

![1563696708367](assets/1563696708367.png)

![1563696779130](assets/1563696779130.png)

![1563696792127](assets/1563696792127.png)

**nginx 的配置**

![1563696872306](assets/1563696872306.png)

**上游服务的配置**

![1563696964989](assets/1563696964989.png)

**首次访问，MISS**

![1563697001181](assets/1563697001181.png)

**再次访问，HIT**

![1563697047983](assets/1563697047983.png)

**文件的存放的位置**

![1563697131542](assets/1563697131542.png)

**上游的服务配置 3s 过期**

![1563697189248](assets/1563697189248.png)

```
nginx 中配置的是 1m 中过期
```

![1563697254475](assets/1563697254475.png)

```
上游控制的 3s 过期，而 nginx 配置的是 1m 中过期，所以只要 1m内都为 EXPIRED
```

![1563697342085](assets/1563697342085.png)

```
add_header Vary * ; 不进行缓存
```

![1563697433193](assets/1563697433193.png)

![1563697475202](assets/1563697475202.png)

```
上游添加 Cache-Control 一样是不会进行缓存的 和 Vary * 效果一样
```

![1563697540977](assets/1563697540977.png)

### 对客户端请求的处理缓存的处理流程

![1563697634870](assets/1563697634870.png)

```
左边的部分是在判断用户的请求是否可以使用缓存

proxy_key 默认使用的是 schame host url 生成key
```

![1563697729936](assets/1563697729936.png)

```
设定对用户请求的方法 使用缓存
```

### nginx 接收到上游的响应的缓存的处理流程

![1563698071213](assets/1563698071213.png)

![1563698206687](assets/1563698206687.png)

![1563698310378](assets/1563698310378.png)

![1563698340320](assets/1563698340320.png)

### 如何减轻缓存失效的时候上游服务器的压力

```
如果nginx 宕机，重新启动的时候，这时候就会产生缓存穿透，大量失效的缓存，会重新请求上游的服务，造成上游服务器的压力
```

![1563698638591](assets/1563698638591.png)

```
假设 四个客户端 向客户端查询热点缓存，没有的话，会同时发送到上游的请求
使用proxy_cache_lock on; 将会使仅有第一个请求发向上游，其他的请求等待第一个请求缓存之后，使用缓存响应客户端
proxy_cache_lock_timeout 5s; 在等待第一个请求 5s 之后还没有获取到 上游的响应，2,3,4 客户端会同事向上游请求
proxy_cache_lock_age 5s; 在等待第一个请求 5s 之后还没有获取到 上游的响应, 一次放行2,3,4 向上游请求，间隔为5s 一个
```

![1563698988940](assets/1563698988940.png)

![1563699253754](assets/1563699253754.png)

```
Cache-Control: max-age=600,stale-while-revalidate=30 设置缓存的过期时间为 600s，但是在600 到 630 之间仍可以使用过期的缓存
```

![1563699552147](assets/1563699552147.png)

```
If-None-Match 后面跟 ETag
If-Modified-Since 后面跟的为 last modified time
```

![1563699638174](assets/1563699638174.png)

### 及时清理缓存

![1563699840885](assets/1563699840885.png)

![1563700009298](assets/1563700009298.png)

```
$scheme$1 与 $scheme$uri key 是一致的
proxy_cache_purge 指向的 共享内存 two 和 proxy_cache 使用的共享内存two 是一直的
```

**缓存的时间为 1m**

![1563700177091](assets/1563700177091.png)

**及时的清除掉缓存的内容**

![1563700230111](assets/1563700230111.png)

### uwsgi/fastcgi/scgi 指令的对照表

```
uwsgi/fastcgi/scgi  这些七层的应用层的反向代理是非常相似的面向下游使用的是HTTP协议，面向上游使用的是各自独立的协议。
```

![1563700431461](assets/1563700431461.png)

![1563700520590](assets/1563700520590.png)

![1563700570454](assets/1563700570454.png)

![1563700703420](assets/1563700703420.png)

![1563700752853](assets/1563700752853.png)

![1563700798488](assets/1563700798488.png)

![1563700848275](assets/1563700848275.png)

![1563700879843](assets/1563700879843.png)

### memcached 反向代理的用法

![1563700969142](assets/1563700969142.png)

![1563701058375](assets/1563701058375.png)

![1563701205415](assets/1563701205415.png)

![1563701151539](assets/1563701151539.png)

![1563701173269](assets/1563701173269.png)

### websocket 反向代理

![1563701405527](assets/1563701405527.png)

![1563701442610](assets/1563701442610.png)

```
HTTP 协议升级为 websocket 协议
1. 协议版本必须为 HTTP/1.1 
2. Connection: Upgrade     Upgrade: websocket 
```

![1563701563034](assets/1563701563034.png)

![1563701611706](assets/1563701611706.png)

![1563701707818](assets/1563701707818.png)

![1563701768470](assets/1563701768470.png)

![1563701826136](assets/1563701826136.png)

![1563702017772](assets/1563702017772.png)

![1563702116082](assets/1563702116082.png)

**服务器返回的内容**

![1563702177337](assets/1563702177337.png)

**发送的内容**

![1563702217578](assets/1563702217578.png)

### 用分片提升缓存的效率

![1563702313087](assets/1563702313087.png)

![1563702353830](assets/1563702353830.png)

```
nginx的缓存切分大小为 100，及 0-100,100-199， 200-299 等文件块
客户端发送 GET Range = 150-240 的请求
nginx 会分为两个请求 GET Range = 100-199 和 GET Range = 200-299 进行请求
之后会合成客户端请求的GET Range = 150-240 给客户端
```

**当访问一个大文件中的一部分内容时**

![1563702712376](assets/1563702712376.png)

**nginx获取的是整个文件的内容**

![1563702756319](assets/1563702756319.png)

```
这个是nginx 所做的一些优化，避免访问相同文件的其他不同内容，但是当并发的访问同一个文件时，就会造成问题
```

![1563702880784](assets/1563702880784.png)

```
slice  指定切分的大小
proxy_cache_key  需要把 slice_range 的变量加上，才能定位哪个range
proxy_set_header 设置range 的头部，指定这个文件在哪个range
```

![1563703034007](assets/1563703034007.png)

**此时上游返回的只有1m的大小**

![1563703062134](assets/1563703062134.png)

### open file cache 提升系统的性能

![1563703137439](assets/1563703137439.png)

```
max 最多在内存中 缓存多个文件，超过这个 max N 后就使用 LRU 链表进行淘汰 inactive 30 表示一个文件30s 内都不访问了则进行移除
```

![1563703282076](assets/1563703282076.png)

```
缓存的 信息
```

![1563703349313](assets/1563703349313.png)

```
open_file_cache_errors 对一些访问文件错误的信息是否进行缓存
open_file_cache_min_users 至少访问多少次才继续留在缓存中
open_file_cache_valid 60s 过60s 查看缓存是否有效，如果产生了更新则进行更新
```

**没有使用open file cache时**

![1563703761269](assets/1563703761269.png)

**追踪nginx的worker进程**

![1563703827025](assets/1563703827025.png)

```
没有访问时 nginx 等待在 epoll_wait 
```

![1563703875422](assets/1563703875422.png)

```
epoll_wait 返回
accept4 建立了一个新的TCP 连接
recvfrom 获取请求的内容
stat 查看首页是否存在不，获得612 字节
open 打开了文件获取文件句柄
sendfile 使用了零拷贝技术，传入文件句柄和偏移量，直接从内核态将磁盘文件内容发送到网卡（而不必文件从磁盘读到用户态再从用户态发送到内核态，然后再从网卡发送出去）
```

![1563704325013](assets/1563704325013.png)

**开启open file cache **

![1563704480002](assets/1563704480002.png)

```
第一次的请求依然调用了 open fstat
```

![1563704519383](assets/1563704519383.png)

```
第二次就没有open fstat 的调用
open_file_cache 岁nginx所有的文件类的操作都有效
```

### http2 协议的介绍

![1563704654074](assets/1563704654074.png)

![1563704716101](assets/1563704716101.png)

```
一个 connection 中可以含有多个stream（数据流），stream可以进行双向的通信，一个信息相当于 http1.0 的一个请求，一个信息可能比较小 也可能比较大，这个可以有多个 frame 进行组成
```

![1563704869096](assets/1563704869096.png)

```
http1.1 中的head 和body 会存放到 两个frame 中
http2.0 有个硬性的要求必须是在TLS协议之上的，必须使用 ssl全栈加密
```

![1563705028022](assets/1563705028022.png)

![1563705085113](assets/1563705085113.png)

![1563705113120](assets/1563705113120.png)

![1563705362305](assets/1563705362305.png)

```
当两个请求的头部 大多的内容是一样的，则只传输不同的部分，如：上面的path
```

![1563705472233](assets/1563705472233.png)

![1563705565755](assets/1563705565755.png)

### 搭建http2.0 服务，并推送资源

![1563705767598](assets/1563705767598.png)

![1563705808048](assets/1563705808048.png)

```
http2_push_preload 开启之后，nginx向客户端推送什么样的内容，是有nginx向客户端发送的一个header 决定的，head中含有的什么内容，就会向客户端推送什么的内容
如：上游服务中添加了 Link: style.css 的文件，nginx就会向客户端进行推送

http2_push 由nginx 直接配置向客户端推送资源，当访问指令所在位置时，就推送配置的资源
```

![1563706131942](assets/1563706131942.png)

```
支持http2 的测试工具 nghttp2
```

![1563706219587](assets/1563706219587.png)

![1563706285183](assets/1563706285183.png)

![1563706325437](assets/1563706325437.png)

**访问/test 时**

![1563706384562](assets/1563706384562.png)

![1563706397919](assets/1563706397919.png)

![1563706414748](assets/1563706414748.png)

```
idle_timeout 超过3m 没有请求来，也没有发送  关闭连接
```

![1563706427686](assets/1563706427686.png)

![1563706514992](assets/1563706514992.png)

![1563706533867](assets/1563706533867.png)

### grpc 反向代理

![1563706642675](assets/1563706642675.png)

![1563706662640](assets/1563706662640.png)

![1563706739129](assets/1563706739129.png)

**上游的服务**

![1563707014804](assets/1563707014804.png)

![1563707125061](assets/1563707125061.png)

![1563707150982](assets/1563707150982.png)

```
当收到客户端发送来的 request 后，响应 Hello，you
```

**nginx配置**

![1563706847203](assets/1563706847203.png)

**更改client 代码监听 4431**

![1563707212013](assets/1563707212013.png)

### stream 四层反向代理的七个阶段及常用变量

![1563707344918](assets/1563707344918.png)

![1563707480412](assets/1563707480412.png)

![1563707500413](assets/1563707500413.png)

![1563707530530](assets/1563707530530.png)

![1563707543504](assets/1563707543504.png)

![1563707582755](assets/1563707582755.png)

![1563707601991](assets/1563707601991.png)

![1563707640303](assets/1563707640303.png)

![1563707658947](assets/1563707658947.png)

![1563707720843](assets/1563707720843.png)

### proxy protocol 协议与 realip 模块

```
proxy protocol 在传输层的头部增加了内容，存放用户的真实的IP地址
```

![1563707909506](assets/1563707909506.png)

![1563708016712](assets/1563708016712.png)

![1563708032140](assets/1563708032140.png)

![1563708077211](assets/1563708077211.png)

![1563708163734](assets/1563708163734.png)

![1563708252110](assets/1563708252110.png)

```
测试的时候需要先 键入 PROXY TCP4 ..... 的内容
可以看到remote_addr 取到的是 nginx 本机的访问地址
```

![1563708333469](assets/1563708333469.png)

![1563708401912](assets/1563708401912.png)

```
可以看到已经取到了 remote addr 的地址
而 直接与 10004 建连 的本地（TCP四元组实际的存储）使用realip_remote_addr 取得 
```

### 限制并发连接数，限制IP，记录日志

![1563708623391](assets/1563708623391.png)

![1563708652441](assets/1563708652441.png)

![1563708689458](assets/1563708689458.png)

![1563708709748](assets/1563708709748.png)

![1563708723635](assets/1563708723635.png)

![1563708820096](assets/1563708820096.png)

**先取出 proxy protocol 协议**

![1563708956626](assets/1563708956626.png)

**此时访问被拒绝**

![1563708983033](assets/1563708983033.png)

```
因为只能202.112.144.236 进行访问
```

![1563709020860](assets/1563709020860.png)

![1563709056801](assets/1563709056801.png)

![1563709082758](assets/1563709082758.png)

![1563709099313](assets/1563709099313.png)

### stream四层反向代理处理SSL下游流量

![1563709327190](assets/1563709327190.png)

![1563709340823](assets/1563709340823.png)

![1563709361586](assets/1563709361586.png)

![1563709420352](assets/1563709420352.png)

![1563709442650](assets/1563709442650.png)

![1563709464778](assets/1563709464778.png)

![1563709511491](assets/1563709511491.png)

![1563709603615](assets/1563709603615.png)

**nginx 负载均衡的配置**

![1563709893147](assets/1563709893147.png)

```
这个server 是 stream模块下的 server
```

**上游的服务**

![1563709974500](assets/1563709974500.png)

**进行访问**

![1563710044076](assets/1563710044076.png)

**浏览器发送请求**

![1563710094493](assets/1563710094493.png)

```
stream 模块剥离了SSL 层的信息，将https 的请求在后端又使用http进行传输
```



### stream_preread 模块 取出SSL关键信息

![1563710337891](assets/1563710337891.png)

```
作用是解析下游的TLS证书中的信息，一变量的方式复制给其他的模块
使用ssl_preread 是不是同时使用 stream ssl模块的
```

![1563710570320](assets/1563710570320.png)

![1563710767484](assets/1563710767484.png)

**nginx的配置**

![1563710826862](assets/1563710826862.png)

```
stream 模块的 server
因为使用了 ssl_preread_server_name 的变量，则使用resolver 指定使用的DNS
```

![1563711235551](assets/1563711235551.png)

```
在进行 https://www.taohui.pub:4433 时， stream 模块取到了 域名 www.taohui.pub,并四层代理到www.taohui.pub:443。 
可以看到 没有发生重定向 到上游的 443 以上是 4433 端口
```

### stream proxy 四层反向代理的用法

![1563711541592](assets/1563711541592.png)

![1563711565920](assets/1563711565920.png)

```
目前的 stream 模块没有提供 图中黑色的线的限速，限制住红色的流，也就间接的限制了黑色的流量
```

![1563711663127](assets/1563711663127.png)

![1563711782115](assets/1563711782115.png)

![1563711853995](assets/1563711853995.png)

![1563711867426](assets/1563711867426.png)

**上游服务（http）**

![1563711972645](assets/1563711972645.png)

**反向代理的nginx**

![1563712129376](assets/1563712129376.png)

```
stream的 server 配置
```

**反向代理的nginx发送 http的请求**

![1563712192894](assets/1563712192894.png)

```
可以看到openresty 上游的返回， 反向代理的nginx自动加入了 proxy_protocol
```

![1563712276568](assets/1563712276568.png)

```
nginx 在四层的反向代理中自动加入的 proxy protocol
```

![1563712338577](assets/1563712338577.png)

```
注释掉 proxy_protocol 后
```

![1563712385147](assets/1563712385147.png)

```
这是后没有任何的返回，因为报错了，上游的openresty 要求 带有 proxy_protocol
```

![1563712455595](assets/1563712455595.png)

```
自己构造PROXY 进行访问
```

### UDP 的反向代理

![1563762447482](assets/1563762447482.png)

 ![1563762514923](assets/1563762514923.png)

**stream 代理UDP服务**

![1563762681013](assets/1563762681013.png)

```
配置 每来一个请求 两个响应 则 session 结束	，记录一条日志
```

**Python 测试脚本**

![1563762823700](assets/1563762823700.png)

```
进行了三次的请求
```

**打印了三条日志**

![1563762873726](assets/1563762873726.png)

![1563762924480](assets/1563762924480.png)

![1563763060087](assets/1563763060087.png)

```
更改为 三个请求 两个响应，就结束一个 session
```

![1563763206246](assets/1563763206246.png)

![1563763233206](assets/1563763233206.png)

```
可以看出是三个请求，记录了一条日志
```

![1563763275365](assets/1563763275365.png)

```
我先在的内容要做 6次响应，设置 一次 请求两次响应一个session ，就要有 3次session；
设置 3次请求，2次响应，一次就可以拿到全部内容
```

### 透传IP的三个方案

![1563763786638](assets/1563763786638.png)

```
第一种方案为 proxy_protocol 协议
第二种 修改IP报文
	修改IP报文中的 源地址，这样会导致上游的服务返回时，不会发送nginx；所以就需要修改上游服务的 路由规则，可以使上游的服务的报文可以传回给nginx
	方案细分为 两种：
		IP地址透传：上游返回的报文，还由nginx 在返回给客户端
		DSR：若上游直接有公网，则上游可以直接发送报文给客户端（仅针对UDP）
```

![1563764510713](assets/1563764510713.png)

```
nginx 在向上游发送报文时 将源地址 由 B改为了A
上游服务响应时  由于配置了 网关为 B，所有的报文都先到 B的nginx上
nginx的机器看到 给的包围 目标地址为 A，是处理不了的，会直接抛弃的，所以还需要在nginx将源地址为C 的报文转发到 nginx的监听端口，之后nginx 转发报文返还给A客户端
```

![1563764929453](assets/1563764929453.png)

```
1. 把 报文的 源地址 B-> A 通过 proxy_bind $remote_addr transparent 实现
2. 上游服务的 网关设置为 nginx 主机地址
3. 添加iptables 转发报文到 80 端口
```

![1563777428784](assets/1563777428784.png)

![1563779529682](assets/1563779529682.png)

```
DSR 的两种的方案主要的区别是上游的服务有没有公网的IP
DSR 方案2 中，上游服务直接返回给客户端，必须把 包的地址改为nginx的地址 B，要不然客户端和上游服务直接一来一回的进行发包，绕过了nginx
```

![1563779580184](assets/1563779580184.png)

## 第五章 nginx 系统性能优化

### 性能优化的方法论

![1563780345895](assets/1563780345895.png)

```
nginx的优势是上下文的切换非常少，在保持这些优势的同时 要从软件层面上提升硬件的使用效率
	惊群：就是降低了CPU的利用率现象，活跃的进程就那么少，但是每次激活了大量的非活跃进程
```

### 如何高效的使用CPU

![1563780749327](assets/1563780749327.png)

```
nginx 不应该在繁忙的时候让出CPU资源：
	worker进程数量设置为CPU核数，避免worker进程之间争抢
	worker进程拒绝调用一些 API 让出CPU，主要是openresty 使用第三方模块的时候
```

![1563781011067](assets/1563781011067.png)

```
auto 自动的设置为 cpu 核数相等的
```

![1563781080186](assets/1563781080186.png)

![1563781663458](assets/1563781663458.png)

![1563781715432](assets/1563781715432.png)

```
减少被动切换，增大进程的优先级，获取更多的时间片
```

![1563781815766](assets/1563781815766.png)

![1563781850494](assets/1563781850494.png)

```
vmstat 中的 cs
dstat 中的 csw
pidstat -w -p pid  cswch/s 主动切换，nvcswch/s 被动切换
```

![1563782131806](assets/1563782131806.png)

```
PRI也还是比较好理解的，即进程的优先级，或者通俗点说就是程序被CPU执行的先后顺序，此值越小进程的优先级别越高。那NI呢？就是我们所要说的nice值了，其表示进程可被执行的优先级的修正数值。如前面所说，PRI值越小越快被执行，那么加入nice值后，将会使得PRI变为：PRI(new)=PRI(old)+nice。这样，**当nice值为负值的时候，那么该程序将会优先级值将变小，即其优先级会变高，则其越快被执行**。
```

![1563782304265](assets/1563782304265.png)

```
时间片的分配在 5ms 到800ms 之间
```

![1563782369301](assets/1563782369301.png)

```
默认是0 一般可以设置nginx 的Nice值为 -20，提高nginx的进程优先级（降低PR的值）
```

### 多核CPU之间的负载均衡

![1563782809855](assets/1563782809855.png)

```
早期的nginx有一个 accept_mutex 的参数，现在默认是关闭的, 打开是为了解决惊群问题。早期由于Linux的问题，导致一个报文到来之后，多个worker进程都去处理，在Nginx的层面加了一把互斥锁，为了保证同一时刻只有一个进程取得。
reuseport 是后续Linux内核（3.9内核后）层面提供的负载均衡的手段。
reuseport 相当于在kernel 层面让每一个的worker进程都进行listen，然后由内核做负载均衡
```

![1563783357342](assets/1563783357342.png)

```
RSS 需要网卡支持的特性，之前可能把网络报文的硬中断放到一个CPU上执行，有了这个RSS之后，在每个CPU上建立相应的队列，报文一开始就可以分发出来，使得多核CPU同时的并行处理报文
RFS 软中断
RPS 是基于 RFS又做了一层 负载均衡的策略
```

![1563783653218](assets/1563783653218.png)

```
worker进程绑定CPU 提升CPU的缓存命中率
CPU的缓存 L1(1ns) L2(3ns) L3(12ns) 三级缓存
```

![1563784105483](assets/1563784105483.png)

![1563784136357](assets/1563784136357.png)

```
cpumask 使用CPU的掩码 手动的绑定
也可以是用 auto 自动的根据worker进程的数量，自动的绑定CPU
```

![1563784225277](assets/1563784225277.png)

```
随着CPU核数的越来越多，就那么一个内存总线，这么多的核心并发的访问内存的时候导致冲突。
提出了一种解决方案，就提供了两条的 总线 连接CPU，左边的4个CPU 通过左边的总线访问 左边的 32G内存，右边的总线通过 右边的总线访问右边的32G内存。
```

![1563784551972](assets/1563784551972.png)

```
两颗 CPU 每个16核，每个CPU分类 64 G的内存
```

![1563784621374](assets/1563784621374.png)

```
查看numa 架构的 CPU 访问内存的命中率
```

### 控制TCP三次握手的参数

![1563784732573](assets/1563784732573.png)

![1563785079232](assets/1563785079232.png)

![1563785123876](assets/1563785123876.png)

![1563785151187](assets/1563785151187.png)

```
服务端 SYN_RCVD 最大的量为多少
tcp_synack_retries 在服务端回给客户端 SYN/ACK 的重试次数
```

![1563785389849](assets/1563785389849.png)

```
三次握手都是有 Linux的内核来实现的：
	1. 服务器端收到SYN的报文，然后插入到维护的SYN队列中去（半连接），这个队列由 rcp_max_syn_backlog控制队列的大小
	2. 服务器端在接受到SYN的报文的时候同时发出ACK+SYN的报文给客户端
	3. 当客户端在发送给我一个 ACK的报文后，后吧半连接从SYN队列取出，插入到 ACCEPT队列中去（backlog 配置这个队列的大小）
	4. nginx 通过一个C库的调用取到建立的accept 连接队列中的连接
```

### 建立TCP的优化

![1563785913488](assets/1563785913488.png)

![1563785978426](assets/1563785978426.png)

![1563786099814](assets/1563786099814.png)

```
worker_rlimit_nofile 限制一个worker进程打开的文件句柄数
```

![1563786245177](assets/1563786245177.png)

![1563786272336](assets/1563786272336.png)

![1563786367732](assets/1563786367732.png)

![1563786412113](assets/1563786412113.png)

```
ACCEPT 队列限制于系统级的 最大的队列，net.core.somaxconn
```

![1563786470206](assets/1563786470206.png)

​	 

```
正常的情况：在客户端向服务端 第三回复ACK的 过程中，直接就发起了HTTP的请求。第二次建立连接同样需要
而fast open: 第一次建立TCP连接服务端回复给客户端是会根据客户端的地址计算一个cookie 连同ack+syn发送给客户端，客户端收到之后回复服务端ack+http 请求，并保存cookie到本地，下次直接使用syn+cookie+http 给服务端，服务端收到之后,确认cookie是否过期，http直接向nginx请求取得数据，Linux 则回复给客户端syn+ack+data
```

![1563787071309](assets/1563787071309.png)

### 滑动窗口与缓冲区

```
滑动窗口会影响到所有的限速的指令，而且还会影响到我们如何调整TCP读写缓冲区的大小，通过调整缓冲区的大小,可以使内存更有效率或网络更有效率
```

![1563787323010](assets/1563787323010.png)

![1563787549454](assets/1563787549454.png)

```
window 就是tcp 报文中 告知client 或server 的接受串口大小的位
```

![1563787655472](assets/1563787655472.png)

```
比如nginx 将要向客户端发送 html 文件，所有的nginx待发送的内容都在 待发送的字符流中
1. nginx调用send 方法（内核）进行发送
2. 3. 4. 内核调用tcp_sendmsg 把用户态的内存复制到内核态
5. 当缓存不足的时候（缓存长度由 /proc/sys/net/core/wmem/default 指定），就会导致send的方法被阻塞（使用非阻塞的方法没有这关问题）
6. 有空闲缓存的时候  7. 进行复制剩下的发送字符
8. 执行tcp_push 发送报文
9. send 方法返回
10. nginx接受send 的返回
```

![1563787768098](assets/1563787768098.png)

```
TCP接受消息：
1. 网卡接受到了报文 s1-s2, 到receive队列
2. 网卡又接受到了 s3-s4 的报文，这个是失序的报文，会插入到out_of_order 的队列
3. 网卡接受到了 s2-s3 的报文，到receive队列
4. 遍历out_of_order 的队列，放入到 receive队列
5. nginx 调用recv 的方法， 6. 调用内核的tcp_revmsg 
7. 找到排好序的报文，8,9,10 复制报文到 用户态
12. 拷贝的字节数超过 最低的接受的阈值，并且backlog 不为空，则返回recv 方法
```

![1563787862246](assets/1563787862246.png)

```
4. 各队列中为空，则程序进行休眠
5. 接受的报文
6. 激活休眠进程
9. 检查报文是否超过TCP阈值，是否需要返回，还是休眠
```

![1563787919655](assets/1563787919655.png)

![1563787956801](assets/1563787956801.png)

![1563787990351](assets/1563787990351.png)

### 优化缓冲区和传输效率

![1563791878225](assets/1563791878225.png)

![1563791946038](assets/1563791946038.png)

```
这个会把上面配置的缓存分为两部分，应用缓存 另一部分给滑动窗口使用
```

![1563791983595](assets/1563791983595.png)

```
带宽：每秒传输的字节数
时延：从一台机器到另一台机器的延时，ping
BDP 带宽时延积： 在这个网络中有多少的 飞行的字节数
接受窗口：即为飞行中的字节数
吞吐量：窗口/时延
```

![1563792120018](assets/1563792120018.png)

```
nagle 算法会把 多个的小报文合并为一个报文发送，减少tcp建连的次数，提高系统的吞吐量
关闭nagle 算法后，会以低时延优先。
```

![1563792851005](assets/1563792851005.png)

```
当先待发送的不满 postpone_output 配置的字节的话，不进行发送，知道收集到 1460 字节才发送
```

![1563792983145](assets/1563792983145.png)

```
CORK 完全禁止小报文的发送，nginx中只有 开启零拷贝技术之后（sendfile on）才有效
```

### 慢启动与拥塞窗口

![1563793162069](assets/1563793162069.png)

```
通告窗口 只是解决了 点对点 的流量限制，没有解决整个网络的限制问题。
拥塞窗口：考虑到了当网络中所有的发送结点都安装滑动窗口对端的接受能力来的话，可能会导致整个网络的中间的各个路由器 满荷。
```

![1563793467932](assets/1563793467932.png)

![1563795335151](assets/1563795335151.png)

```
RTT：round trip time 时刻真实的round trip time，从报文的发送端到接受端一来一回的时间
```

### TCP中的keepalive 的功能

```
http中的keepalive 为了把短连接作为长连接进行复用。
TCP的keepalive 只是为了及时的释放TCP的资源
```

![1563795695572](assets/1563795695572.png)

![1563795713082](assets/1563795713082.png)

```
nginx中的 keepidle keepintvl keepcnt 一一对应于 Linux中的 上面的三个参数
```

### 减少关闭连接的time_wait端口数量

![1563796236254](assets/1563796236254.png)

```
TCP连接是一个双工的连接，我 发出了 FIN包只是我不在发送包了，而对方仍然可以发送报文给我。
```

![1563796389350](assets/1563796389350.png)

![1563796425216](assets/1563796425216.png)

![1563796478755](assets/1563796478755.png)

```
如果time wait 设置过短，则延迟的 SEQ=3 的报文，可能在延迟后，发送到服务端，不知道如何处理。
因为 SEQ=3 的在延迟是 又进行了重传，第二次连接的时候 SEQ=3 的报文到达到服务端
```

![1563796582443](assets/1563796582443.png)

```
客户端使用新链接时候 重用time wait 的端口

客户端发送FIN 后，服务端发送了FIN+ACK，客户端进入了 timewait状态，一直没有给服务端进行 ACK。
当重用time wait 端口的时候，发起 SYN 简历连接，服务端立即 重发了 上次没有发送ACK 的FIN+ACK报文，客户端此时发送RST 重置连接。
```

![1563796631674](assets/1563796631674.png)

```
tcp_tw_recycle = 1 开启后，服务器端和客户端都可以开启使用 time wait 的状态的端口，会不安全
```

### lingering_close 延迟关闭TCP连接

![1563849167831](assets/1563849167831.png)

```
当nginx 主动的调用FIN 准备关闭连接，表示nginx 不在想要接受新的消息了，如果客户端仍然再向我发送信息，服务器则发送 RST包关闭连接，客户端收到RST后忽略http 的response

延时关闭的意义就在于避免发送RST的包
```

![1563849438788](assets/1563849438788.png)

![1563849605025](assets/1563849605025.png)

```
读或写超时的时候，操作系统会立即发送 RST包关闭连接，释放端口 内存等资源
```

### 应用层协议的优化

![1563849791136](assets/1563849791136.png)

```
ssl_session_cache 不像tickets 存在副作用，但是只是基于一台nginx使用
off：会明确nginx在协议中告诉客户端session 缓存不被使用
none：不使用，但是没有告诉客户端不使用
builtin：使用openssl 的session cache 而不是 nginx自身实现的 基于共享内存的session cache
shared:name:size 定义共享内存
```

![1563850052884](assets/1563850052884.png)

```
nginx 将session 中的信息加密后作为 tickets 发送给客户端，客户端下次发起 TLS连接是带上，nginx解密验证后复用session 
会话票证 更易于在nginx的集群中使用，ssl_session_cache 只能基于一台nginx使用，因为会话票证 是基于密钥进行解密的，只要 同一的nginx集群的密钥相同 则可以解出 session的信息。
所以 必须频繁的更换 tickets 的密钥
```

![1563850387160](assets/1563850387160.png)

![1563850461021](assets/1563850461021.png)

![1563850478195](assets/1563850478195.png)

```
gzip_types 设定压缩的请求的类型
gzip_min_length 至少body大于 20 才会压缩
gzip_disable 不对哪些的 正则匹配的进行压缩
gzip_http_version 针对哪个http 版本才进行压缩
```

![1563850619895](assets/1563850619895.png)

```
expired/no-cache/no-store/private/no_last_modified/no_etag   这些都是因为 请求没有进行缓存 则进行压缩
```

![1563850782652](assets/1563850782652.png)

```
gzip_buffers 32 4k : 开辟多个缓冲区进行压缩
gzip_vary on: 开启之后则 会在给客户端的响应中 加一个 vary accept encoding 的头部

还提供了了一个变量 gzip_rtaio 告诉我们现在实时的压缩率
```

![1563850988720](assets/1563850988720.png)

### 磁盘IO的优化

![1563851041164](assets/1563851041164.png)

```
机械硬盘适合做 顺序读取，寻址比较慢。
顺序读写，比如一直写日志追加到末尾
BPS 顺序读写IO
IOPS 随机续写IO
IO测试工具 fio
```

![1563851205946](assets/1563851205946.png)

```
AIO 异步IO
proxy buffering 关闭的时候 写入在内存中，不写磁盘
syslog 走的出UDP 协议，替代了本地的IO
```

![1563851808108](assets/1563851808108.png)

```
没有开启直接IO：
	用户进程调用了read的方法，磁盘会先读到内核的缓冲区（也就是磁高速缓存），再会读取到用户空间的缓存，读取了两次，写入的时候也进行了两次的写入，写入到内核的缓冲区后，根据内核的参数 根据一些算法某一时刻写入到磁盘，所谓脏页的写回。

直接IO：
	直接IO 绕开了内核的高速缓存，直接从磁盘读到用户的缓冲区，写时直接从缓冲区写入到磁盘
	
传统的IO的好处是 读了一次磁盘到缓冲区，下次要读同样的内容是，命中了缓存后，就不用再读磁盘了，换出就是两次的拷贝。
```

![1563852345557](assets/1563852345557.png)

```
但磁盘中都是大文件的时候，不可能在内核的缓冲区 缓存的，就可以启用 直接IO，避免两次拷贝的消耗
```

![1563852443035](assets/1563852443035.png)

```
Linux 内核提供的原生的异步IO
传统IO的方式：
	用户进程调用read的方法的时候，用户空间的程序就会被阻塞住，就开始进行读磁盘，读完之后唤醒用户的进程，写的时候也会进行阻塞，但是写的嗯时候用户空间往往是高速缓存可能快点。
	
异步IO的方式：
	用户程序调用read的时候，用户的进程可以处理其他的任务，磁盘读取完成后再回来可以处理读到的内容
```

![1563852692591](assets/1563852692591.png)

```
aio_write 是因为程序写的时候，写入的是磁盘的高速的缓存，比较快，没有必要使用AIO，这个选项开启后，强制的使用AIO。
只有在 接受上游服务的响应的时候，开启了 proxy buffering 后，缓存请求到磁盘，才会aio_write 开启
```

![1563853095156](assets/1563853095156.png)

```
对于一些任务可能出现阻塞，就使用了线程池，使用了 生产者 消费者模型，通过一个 加锁的fifo队列，一堆任务来从这个队列中取任务
```

![1563853421847](assets/1563853421847.png)

```
使用线程池，只用于用作静态资源文件服务的时候，
max_queue fifo 的最大的长度 
threads 线程的个数
```

![1563853516002](assets/1563853516002.png)

### 减少磁盘的读写次数

![1563853578964](assets/1563853578964.png)

```
为了分析用户的行为，在内存中生成了一个1*1 的gif 的图片在用户访问的时候，由前端进行请求，nginx几轮access 日志，供作分析
```

![1563856763629](assets/1563856763629.png)

![1563856920944](assets/1563856920944.png)

```
8090 端口 记录 compressed.log 进行压缩
```

![1563856974375](assets/1563856974375.png)

```
compressed.log 日志是压缩的，使用zcat 进行查看	
```

![1563857029407](assets/1563857029407.png)

```
error_log memory:32m debug; 配置了32m 的内存进行error内存的写入，这段内存可以进行 环形写，写满之后，则重头开始写
```

![1563857254170](assets/1563857254170.png)

```
查看的方法执行上面的脚本
```

![1563857422314](assets/1563857422314.png)

![1563857490143](assets/1563857490143.png)

![1563857531543](assets/1563857531543.png)

**配置rsyslog**

![1563857567917](assets/1563857567917.png)

![1563857584560](assets/1563857584560.png)

**nginx的配置**

![1563857652813](assets/1563857652813.png)

**进行请求**

![1563858037835](assets/1563858037835.png)

**抓取报文**

![1563858061044](assets/1563858061044.png)

**访问日志**

![1563858121243](assets/1563858121243.png)

### 零拷贝技术与gzip_static 模块

```
当我们使用sendfile 的时候，又需要对磁盘中的内容做gzip压缩实际上又退化了，sendfile的功能就没有了，这时候可以使用 gzip_static 模块
```

![1563865182135](assets/1563865182135.png)

```
应用程序，比如nginx 作为一个静态资源的服务，需要从磁盘中读出一个文件，最后把这个文件通过网卡发送给客户端。nginx所需要做的操作是调用 read的方法，把磁盘中的内容读取到 应用程序缓冲区（先到内核的告诉缓存），写入的时候调用write方法到TCP 套接字的缓冲区，缓冲区在发送到网卡

sendfile 零拷贝：
	应用程序进行了一个sendfile的调用（告诉从哪个字节读，读多少个字节，把读出的字节发送到哪个文件句柄）
	内核把文件读到缓存中再到socket 的缓冲区，最会发送到网卡进行传输	 
```

![1563865819214](assets/1563865819214.png)

![1563865886854](assets/1563865886854.png)

```
预先对文件进行gzip的压缩，文件名 原始文件名.gz

always 不管客户端支持不支持 gzip
```

![1563866038962](assets/1563866038962.png)

### 使用tcmalloc优化内存分配

```
Linux 默认的glib分配内存的能力并不是很高，可以考虑Google的 tcmalloc 来进行优化
```

![1563866250177](assets/1563866250177.png)

![1563866417517](assets/1563866417517.png)

**编译安装后的位置**

![1563866467390](assets/1563866467390.png)

![1563866489751](assets/1563866489751.png)

```
编译的时候 需要 --with-ld-opt=-ltcmalloc 要不编译后的不会生效 使用 tcmalloc
```

### 使用Google PerfTools 分析nginx

![1563866998714](assets/1563866998714.png)

![1563867048797](assets/1563867048797.png)

![1563867350257](assets/1563867350257.png)

![1563867361681](assets/1563867361681.png)

```
以每次启动的进程号结尾
```

**读取文件**

![1563867408513](assets/1563867408513.png)

![1563867536497](assets/1563867536497.png)

### 使用stub_status 模块监控nginx的状态

![1563867721374](assets/1563867721374.png)

![1563867757918](assets/1563867757918.png)

![1563867801406](assets/1563867801406.png)

## 第六章 从源码视角深入使用nginx和openresty

### 第三方模块的源码阅读

**第三方模块的目录**

![1563868329363](assets/1563868329363.png)

![1563868301701](assets/1563868301701.png)

```
config： 这个必须要有的 在执行 configure 命令的时候 会加载这个配置
结构体 ngx_module_t :定义了nginx进程（master worker）启动的时候，或退出时的回调方法
ngx_command_t 这个数组为模块提供了哪些配置指令
```

![1563868660905](assets/1563868660905.png)

![1563868790936](assets/1563868790936.png)

```
会生成ngx_modules.c 及 makefile 文件
```

![1563868898814](assets/1563868898814.png)

```
summary 后的信息：
	使用了多线程  PCRE库 OpenSSL库等
nginx的路径的信息
```

### nginx的启动流程

![1563870108929](assets/1563870108929.png)

![1563870207394](assets/1563870207394.png)

![1563870266593](assets/1563870266593.png)

![1563870411489](assets/1563870411489.png)

![1563870424167](assets/1563870424167.png)

### HTTP第三方模块的初始化

![1563870507045](assets/1563870507045.png)

![1563870653217](assets/1563870653217.png)

![1563870769241](assets/1563870769241.png)

![1563870818699](assets/1563870818699.png)

![1563870905097](assets/1563870905097.png)

### if指令是邪恶的吗？

![1563871038049](assets/1563871038049.png)

![1563871053790](assets/1563871053790.png)

![1563871121946](assets/1563871121946.png)

![1563871174649](assets/1563871174649.png)

![1563871219476](assets/1563871219476.png)

```
左边的if 指令，只会添加X-Second 2 的head
当遇到第一个的if 的时候，会 加载 loc_conf 的配置
当遇到第二个的if 的时候，也会加载 loc_conf的配置，并且会一直生效，影响会面的配置
```

![1563871576690](assets/1563871576690.png)

![1563871611049](assets/1563871611049.png)

```
当前的rewrite 阶段顺序执行的时候，每次if 为真，都会替换为当前的请求的配置
```

![1563871690773](assets/1563871690773.png)

### 解读nginx的核心转储文件

![1563871838248](assets/1563871838248.png)

![1563871871669](assets/1563871871669.png)

![1563871946950](assets/1563871946950.png)

![1563871998205](assets/1563871998205.png)

```
对worker进程 产生 coredump文件
```

![1563872055287](assets/1563872055287.png)

```
需要制定 nginx的二进制文件
```

![1563872333599](assets/1563872333599.png)

```
查看堆栈的信
```

![1563872389887](assets/1563872389887.png)

```
查看所有线程的堆栈
```

![1563872450966](assets/1563872450966.png)

```
t 1 选中1号线程 主线程的信息
```

![1563872523461](assets/1563872523461.png)

```
到栈帧 1 即 ngx_epool_process_events 的函数
```

![1563872606935](assets/1563872606935.png)

```
查看cycle 指针变量的指向的结构体的内容
```

![1563872670883](assets/1563872670883.png)

```
查看 cycle 结构体的 modules的 内容  哪个modules
以及查看 第十个 modules
```

![1563872910741](assets/1563872910741.png)

```
第十个modules的 配置指令	
```

![1563872981956](assets/1563872981956.png)

```
nginx监听的端口
```

![1563873060722](assets/1563873060722.png)





![1563872243384](assets/1563872243384.png)

![1563872258300](assets/1563872258300.png)

### 通过debug 日志定位问题

![1563873123016](assets/1563873123016.png)

![1563873160681](assets/1563873160681.png)

![1563873246365](assets/1563873246365.png)

![1563873349850](assets/1563873349850.png)

![1563873385065](assets/1563873385065.png)

**向上游请求**

![1563873509856](assets/1563873509856.png)

### OpenResty 概述

![1563873628424](assets/1563873628424.png)

![1563873762839](assets/1563873762839.png)

```
不以lua-resty 开头的为 lua 模块，其他的为nginx的第三方模块
```

![1563873829801](assets/1563873829801.png)

```
使用openresty 会写三部分代码：
	1. nginx中加入lua 的指令
	2. 在 nginx的lua指令中 加入纯lua 的代码，调用操作nginx的SDK 来操作nginx
	
ngx_http_lua_module 作为nginx的第三方的http模块，嵌入到nginx，ngx_http_lua_module提供了嵌入lua代码的指令；ngx_http_lua_module 又提供了与nginx交互的SDK
```

![1563874135284](assets/1563874135284.png)

```
cosocket 通讯，使用lua在写 udp或tcp 进行通信的时候，实际是异步执行的，不会阻塞nginx执行
shared。DICT 可以跨worker进程通讯
定时器：延时执行或隔多久执行
```

![1563874355605](assets/1563874355605.png)

### openresty 中nginx模块与lua 模块

![1563874614055](assets/1563874614055.png)

![1563874676064](assets/1563874676064.png)

```
这些模块在 ngx_http_lua_module 还不成熟的时候提供的模块，比较老的模块，现在没有移出去openresty
```

![1563874924541](assets/1563874924541.png)

![1563875085168](assets/1563875085168.png)

![1563875166922](assets/1563875166922.png)

![1563875198080](assets/1563875198080.png)

![1563875214999](assets/1563875214999.png)

![1563875268623](assets/1563875268623.png)

![1563875309008](assets/1563875309008.png)

### 如何在openresty中嵌入lua代码

![1563875431028](assets/1563875431028.png)

![1563875518096](assets/1563875518096.png)

![1563875587299](assets/1563875587299.png)

![1563875732525](assets/1563875732525.png)

![1563875768847](assets/1563875768847.png)

![1563875824767](assets/1563875824767.png)

![1563875846986](assets/1563875846986.png)

![1563875861247](assets/1563875861247.png)

![1563875913956](assets/1563875913956.png)

### openresty 中lua 与C 交互的原理

![1563876025922](assets/1563876025922.png)

![1563876230427](assets/1563876230427.png)

![1563876287600](assets/1563876287600.png)

### 获取、修改与响应请求的SDK

![1563876465565](assets/1563876465565.png)

![1563876535020](assets/1563876535020.png)

![1563876595630](assets/1563876595630.png)

![1563876642173](assets/1563876642173.png)

![1563876741977](assets/1563876741977.png)

![1563876802739](assets/1563876802739.png)

![1563876817229](assets/1563876817229.png)

![1563876875958](assets/1563876875958.png)

![1563876925769](assets/1563876925769.png)

![1563876993499](assets/1563876993499.png)

![1563877022402](assets/1563877022402.png)

![1563877035279](assets/1563877035279.png)

![1563877082243](assets/1563877082243.png)![1563877082797](assets/1563877082797.png)

![1563877124456](assets/1563877124456.png)

![1563877138660](assets/1563877138660.png)

### 工具类型的SDK

![1563877251217](assets/1563877251217.png)

![1563877273942](assets/1563877273942.png)

![1563877326226](assets/1563877326226.png)

![1563877344214](assets/1563877344214.png)

![1563877376727](assets/1563877376727.png)

![1563877421558](assets/1563877421558.png)

![1563877445409](assets/1563877445409.png)

![1563877499394](assets/1563877499394.png)

![1563877550992](assets/1563877550992.png)

```
ngx.re.find 只是返回了索引，没有创建新的字符串，索引性能就较好
```

![1563877666232](assets/1563877666232.png)

![1563877680035](assets/1563877680035.png)

### 同步且非阻塞的底层SDK：cosocket

```
cosocket 以一种同步的方式，提供了非阻塞的可以使用nginx非阻塞事件的 方法
```

![1563877879981](assets/1563877879981.png)

![1563877960428](assets/1563877960428.png)

![1563878068905](assets/1563878068905.png)

![1563878173357](assets/1563878173357.png)

![1563878253055](assets/1563878253055.png)

```
左边的lua 的代码 看着一次向下执行的，
```

![1563878463454](assets/1563878463454.png)

```
图中的 sock:send 方法调用没有返回之前，就不会执行 下面的if 语句
对于lua的代码来说，调用send 不能阻塞 nginx的进程，在调用send 的时候，底层nginx send 的操作是非阻塞的，send 完后，通知lua，继续往下执行（看着像lua是同步执行的，需要等待）。
```

![1563878718497](assets/1563878718497.png)

![1563878806552](assets/1563878806552.png)

![1563878836736](assets/1563878836736.png)

### 基于协程的并发编程SDK

![1563878958994](assets/1563878958994.png)

![1563879037143](assets/1563879037143.png)

![1563879284141](assets/1563879284141.png)

```
通过create 创建协程，
resume 启用协程
之后yield 挂起协程
```

![1563879429883](assets/1563879429883.png)

![1563879518122](assets/1563879518122.png)

### 定时器及时间相关的SDK

![1563879865709](assets/1563879865709.png)

![1563879989171](assets/1563879989171.png)

![1563880080762](assets/1563880080762.png)

![1563880102054](assets/1563880102054.png)

![1563880121058](assets/1563880121058.png)

![1563880137034](assets/1563880137034.png)

### shared.DICT 基于共享内存的字典

![1563880290240](assets/1563880290240.png)

![1563880333198](assets/1563880333198.png)

![1563880544453](assets/1563880544453.png)

![1563880646533](assets/1563880646533.png)

![1563880704471](assets/1563880704471.png)

**定义共享内存**

![1563880994817](assets/1563880994817.png)

![1563880821205](assets/1563880821205.png)

![1563881051451](assets/1563881051451.png)

### 子请求的使用方法

![1563881135638](assets/1563881135638.png)

![1563881258080](assets/1563881258080.png)

```
不含有 请求的 lua 模块是没有办法 派生子请求的
```

![1563881505100](assets/1563881505100.png)

### 基于openresty 的WAF防火墙

![1563881759124](assets/1563881759124.png)

