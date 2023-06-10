## openssl自签证书

#### 1. 创建根证书

创建密钥

```
openssl genrsa -out LocalRootCA.key 2048
```

生成证书并自签名，nodes是不用密码

```
openssl req -sha256 -new -nodes -x509 -days 3650 -key LocalRootCA.key -out LocalRootCA.crt -subj "/CN=LocalRootCA"
```

#### 2. 创建域名证书

创建密钥

```
openssl genrsa -out aa.com.key 2048
```

创建请求文件（这是单个域的申请，多个域需要用下面说明的配置文件方式）

```
openssl req -new -sha256 -key aa.com.key -out aa.com.csr -subj "/CN=*.aa.com"
```

生成证书并用根证书签名

```
openssl x509 -req -in aa.com.csr -CA LocalRootCA.crt -CAkey LocalRootCA.key -CAcreateserial -days 3560 -out aa.com.crt -extfile aa.com.conf -extensions req_ext
```

（这里后面的参数 -extfile aa.com.ini -extensions req_ext 是指调用下面所讲的配置文件，那个文件名称为aa.com.conf）

如果需要导出pfx,请输入密码

```
openssl pkcs12 -export -out aa.com.pfx -inkey aa.com.key -in aa.com.crt
```

#### 3. 使用配置文件，多域名签发证书

多域名配置列表，有时候我们需要这个证书可以在多个服务器上用，就需要用文件的方式给列出来，文件内容：

```
[req]
default_bits = 2048
default_keyfile = cylk.com.pem
distinguished_name = req_distinguished_name
encrypt_key = no
default_md  = sha256
req_extensions = req_ext

[req_distinguished_name]
commonName_default = www.cylk.com
commonName_max = 64
organizationName_default = cylk Technology Co.,Ltd.
organizationalUnitName_default = IT Support Dept
localityName_default = Beijing
stateOrProvinceName_default = Beijing
countryName_default = CN

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = cylk.com
DNS.2 = *.cylk.com
DNS.3 = www.cylk.com
IP.1 = 10.43.1.60
```

其中：
commonName_default： 证书的主域名
organizationName_default： 企业/单位名称
organizationalUnitName_default：企业部门
localityName_default： 城市
stateOrProvinceName_default： 省份
countryName_default： 国家代码，一般都是CN(大写)
[alt_names]： 后面为备用名称列表，可以是域名、泛域名、IP地址



配置好该文件后，保存为cylk.conf，然后运行下面命令：

```
openssl req -new -nodes -out cylk.com.csr -config cylk.conf -subj "/" -batch
```

最后CSR文件在cylk.com.csr中，私钥在cylk.com.pem中，这样4个域名的CSR 就产生了。下面用根证书签发：

```
openssl x509 -req -in cylk.com.csr -CA LocalRootCA.crt -CAkey LocalRootCA.key -CAcreateserial -days 3560 -out cylk.com.crt -extfile cylk.conf -extensions req_ext
```

**生成的cylk.com.crt 为证书，cylk.com.perm为密钥。**



**单步，一步步生成证书：**

https://learn.microsoft.com/zh-cn/azure/application-gateway/self-signed-certificates