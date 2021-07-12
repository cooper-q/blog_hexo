---
layout:     post
title:      "Nginx 配置Lets Encrypt 免费SSL证书"
date:       2017-9-11

categories:
    - Nginx
    - HTTPS
catalog:    true
tags:
    - HTTPS
    - Nginx
---
# Nginx 配置Lets Encrypt 免费SSL证书
[toc]

# 1.acme.**sh**【推荐使用】
## 1.安装环境
### 1.安装acme.**sh**
<!-- more -->
- 如缺少环境则安装相应的依赖即可
```
curl https://get.acme.sh | sh
****
[Fri 30 Dec 01:03:33 GMT 2016] OK
[Fri 30 Dec 01:03:33 GMT 2016] Install success!
```
### 2.安装Nginx
- Centos
```
yum install nginx -y
```
- Ubuntu&&Debian
```
apt install nginx -y
```

## 2.修改Nginx配置文件
- 默认路径/etc/nginx/nginx.conf
- http下添加下方内容
```
server {
    listen 80;
    # 下面填写要生成证书的名称
    server_name blog.mengxc.info *.mengxc.info;

    # 添加下方的代码
    location ~ /.well-known {
        allow all;
    }
}
```
## 3.使用acme.**sh** 生成证书
- 确保80端口没有被占用【Nginx不能打开】
- 替换下方命令中【mengxc.info】为自己的域名
- 确定nginx，域名dns解析都正常使用
- -k 表示密钥长度，后面的值可以是 ec-256 、ec-384、2048、3072、4096、8192，带有 ec 表示生成的是 ECC 证书，没有则是 RSA 证书。在安全性上 256 位的 ECC 证书等同于 3072 位的 RSA 证书。

### 1.普通证书
```
$ sudo ~/.acme.sh/acme.sh --issue -d mengxc.info --standalone -k ec-256
****
-----END CERTIFICATE-----
[Fri Dec 30 08:59:16 HKT 2016] Your cert is in  /root/.acme.sh/mengxc.info_ecc/mengxc.info.cer
[Fri Dec 30 08:59:16 HKT 2016] Your cert key is in  /root/.acme.sh/mengxc.info_ecc/mengxc.info.key
[Fri Dec 30 08:59:16 HKT 2016] The intermediate CA cert is in  /root/.acme.sh/mengxc.info_ecc/ca.cer
[Fri Dec 30 08:59:16 HKT 2016] And the full chain certs is there:  /root/.acme.sh/mengxc.info_ecc/fullchain.cer
```

### 2.通配符证书[dns api]
- 1.配置dns api key secret
```
## 首先要根据下面配置全局key或者其余内容
https://github.com/Neilpang/acme.sh/wiki/dnsapi

## 下面示例为Cloudflare
acme.sh --issue --dns dns_cf -d *.mengxc.info -d mengxc.info
```

- 2.生成证书
```
~/.acme.sh/acme.sh --issue -d *.example.com --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please

#### 会提示添加TXT解析，这里需要去域名解析添加TXT解析

[Wed Dec 16 16:04:49 CST 2020] Add the following TXT record:
[Wed Dec 16 16:04:49 CST 2020] Domain: '_acme-challenge.example.com'
[Wed Dec 16 16:04:49 CST 2020] TXT value: '-jEWdpI**************EVh01_a3ywrW426wmppjuDqXOs'
[Wed Dec 16 16:04:49 CST 2020] Please be aware that you prepend _acme-challenge. before your domain
[Wed Dec 16 16:04:49 CST 2020] so the resulting subdomain will be: _acme-challenge.devopsing.site
[Wed Dec 16 16:04:49 CST 2020] Please add the TXT records to the domains, and re-run with --renew.
[Wed Dec 16 16:04:49 CST 2020] Please add '--debug' or '--log' to check more details.
[Wed Dec 16 16:04:49 CST 2020] See: https://github.com/acmesh-official/acme.sh/wiki/How-to-debug-acme.sh
```

- 3.验证解析是否有效
```
nslookup -q=TXT _acme-challenge.example.com

# 返回

Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
_acme-challenge.devopsing.site	text = "-jEWdpI****************1_a3ywrW426wmppjuDqXOs"

Authoritative answers can be found from:
```

- 4.解析生效后重新生成证书 --renew
```
./acme.sh --renew -d *.example.com --yes-I-know-dns-manual-mode-enough-go-ahead-please
```

- 5.安装
```
./acme.sh --installcert -d *.example.com --fullchainpath /tmp/example.crt --keypath /tmp/example.key
```

## 3.安装证书和密钥
- 安装到/etc/nginx目录下（目录可更改）
- 证书安装完毕后重复上面的第四步骤（配置Nginx以使用签发的证书）即可
- ECC证书
```
~/.acme.sh/acme.sh --installcert -d mengxc.info --fullchainpath /etc/nginx/mengxc.info.crt --keypath /etc/nginx/mengxc.info.key --ecc
```

- RSA证书
```
sudo ~/.acme.sh/acme.sh --installcert -d mengxc.info --fullchainpath /etc/nginx/mengxc.info.crt --keypath /etc/nginx/mengxc.info.key
```

- 通配符
```
acme.sh --installcert -d *.mengxc.info --keypath /etc/nginx/mengxc.info.key --fullchainpath /etc/nginx/mengxc.info.crt
```

## 4.证书更新
- Let's Encrypt 的证书有效期只有 3 个月 需要使用一下命令手动更新
- 需要保证80不占用

- ECC证书
```
sudo ~/.acme.sh/acme.sh --renew -d mengxc.info --force --ecc
```

- RSA证书
```
sudo ~/.acme.sh/acme.sh --renew -d mengxc.info --force
```

- 通配符
```
acme.sh --renew -d mengxc.info -d '*.mengxc.info' --force
```

## 5.配置Nginx
- http下配置443【端口默认443，也可以用其他】
- 配置相应的ssl_certificate、ssl_certificate_key
- 配置自己需要配置的路由

```
server {
    listen 443 ssl;
    server_name blog.mengxc.info;
    root /root/project/deployment/local/remote;

    ssl_certificate /etc/nginx/mengxc.info.crt;
    ssl_certificate_key /etc/nginx/mengxc.info.key;
    location / {

    }
}
```

## 6.错误处理
- zsh: no matches found: *.mengxc.info
```
## .zshrc下增加
setopt no_nomatch
```
# 2.certbot
## 步骤概览
- 下载 certbot
- 配置 Nginx 以满足 WebRoot 验证方式的需要
- 使用 certbot 签发证书
- 配置 Nginx 以使用签发的证书
- 证书的自动续签
- 使用acme.sh脚本生成（终极大法）

## ~~1.下载 certbot【此方法参考】~~
- 下面的教程只提供参考，不作为实际使用
- 长时间未维护
```
wget https://dl.eff.org/certbot-auto -O /sbin/certbot-auto
chmod a+x /sbin/certbot-auto
```

## 2.配置Nginx以满足WebRoot验证方式的注意事项
- 在使用 certbot 之前，我们先要对 Nginx 进行配置，因为使用 webroot 方式，
  certbot 会在域名对应的根目录创建一个叫做 well-known 的隐藏文件夹，并且创建用于验证域名所有权的文件。
- 这个文件夹在证书签发的过程中，是需要被访问的。

### 1.修改nginx config
>假设我们我们要签发用于 blog.mengxc.info 这个域名的 SSL 证书，而这个域名的配置文件在
/usr/local/nginx/conf/blog.conf ，于是我们打开这个文件，并且在 server block 内加入下面的内容
```
// 配置文件路径 根据自身寻找 一般都在
// /usr/local/nginx/conf or /etc/nginx/conf.d

server {
    listen 80;
    server_name blog.mengxc.info;
    root /home/matt/project/ghost_blog;

    localtion / {
        ...............
    }
    //这里是新加入的

    location ~ /.well-known {
        allow all;
    }
}
```
- 保存后，重启nginx nginx -s reload
- 如果是403，可配置nginx user

## 3.使用Certbot签发证书
- 签发证书说明
```
配置完 Nginx 后，我们就可以开始使用 certbot 签发证书了。
现在依然假设我们要对 blog.mengxc.info 签发证书。
并且这个域名对应的 webroot 目录是 /root/project/deployment/local/remote
```

- 执行命令
```
/sbin/certbot-auto certonly --webroot -w /root/project/deployment/local/remote -d blog.mengxc.info
```

- /root/project/deployment/local/remote 该路径需要替换成自己的网站目录
- blog.mengxc.info 改域名需要改为自己的域名

- 生成完毕后会有四个文件
```
privkey.pem 证书私钥
cert.pem 证书公钥
chain.pem 中间证书链
fullchain.pem 证书公钥 + 中间证书链的合并
```

## 4.配置Nginx以使用签发的证书

### 1.修改Nginx网站配置文件

- 修改之前的文件并配置ssl以及443端口
```
server {
    listen 443;
    server_name blog.mengxc.info;
    root /root/project/deployment/local/remote;

    ssl_certificate /etc/letsencrypt/live/blog.mengxc.info/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/blog.mengxc.info/privkey.pem;

    localtion / {
        ...............
    }

    location ~ /.well-known {
        allow all;
    }
}
```

- 由于默认访问都是80，所以我们还需要增加对80端口跳转443端口的配置
```
server {
    listen 80;
    server_name blog.mengxc.info;
    return 301 https://$host$request_uri;
}

server {
    listen 443;
    server_name blog.mengxc.info;
    root /root/project/deployment/local/remote;

    ssl_certificate /etc/letsencrypt/live/blog.mengxc.info/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/blog.mengxc.info/privkey.pem;

    localtion / {
        ...............
    }

    location ~ /.well-known {
        allow all;
    }
}
```

- 重启nginx
```
nginx -s reload
```

- 备注
```
注意：在修改ssl_certificate（即公钥）时最好使用fullchain.pem而不是cert.pem。cert.pem中不包含中间
证书链的信息，某些客户端（比如Github使用的camo）在连接时可能会出现验证身份失败的情况。
```

# 2.不同扩展名代表的意思

- CRT - CRT应该是certificate的三个字母,其实还是证书的意思,常见于*NIX系统,有可能是PEM编码,也有可能是DER编码,大多数应该是PEM编码,相信你已经知道怎么辨别.

- CER - 还是certificate,还是证书,常见于Windows系统,同样的,可能是PEM编码,也可能是DER编码,大多数应该是DER编码.

- KEY - 通常用来存放一个公钥或者私钥,并非X.509证书,编码同样的,可能是PEM,也可能是DER.
  查看KEY的办法:
  openssl rsa -in mykey.key -text -noout
  如果是DER格式的话,同理应该这样了:
  openssl rsa -in mykey.key -text -noout -inform der

- CSR - Certificate Signing Request,即证书签名请求,这个并不是证书,而是向权威证书颁发机构获得签名证书的申请,其核心内容是一个公钥(当然还附带了一些别的信息),在生成这个申请的时候,同时也会生成一个私钥,私钥要自己保管好.做过iOS APP的朋友都应该知道是怎么向苹果申请开发者证书的吧.
  查看的办法:
  openssl req -noout -text -in my.csr
  (如果是DER格式的话照旧加上-inform der,这里不写了)

- PFX/P12 - predecessor of PKCS#12,对*nix服务器来说,一般CRT和KEY是分开存放在不同文件中的,但Windows的IIS则将它们存在一个PFX文件中,(因此这个文件包含了证书及私钥)这样会不会不安全？应该不会,PFX通常会有一个"提取密码",你想把里面的东西读取出来的话,它就要求你提供提取密码,PFX文件使用的是DER编码,如何把PFX转换为PEM编码？
  openssl pkcs12 -in for-iis.pfx -out for-iis.pem -nodes
  这个时候会提示你输入提取码. 输出文件for-iis.pem就是可读的文本.
  生成pfx的命令类似这样:
  openssl pkcs12 -export -in certificate.crt -inkey privateKey.key -out certificate.pfx -certfile CACert.crt
  其中CACert.crt是CA(权威证书颁发机构)的根证书,有的话也通过-certfile参数一起带进去.这么看来,PFX其实是个证书密钥库.

- JKS - 即Java Key Storage,这是Java的专利,跟OpenSSL关系不大,利用Java的一个叫"keytool"的工具,可以将PFX转为JKS. 注: keytool也能直接生成JKS.
  
- 备注
```
注意：在修改ssl_certificate（即公钥）时最好使用fullchain.pem而不是cert.pem。cert.pem中不包含中间
证书链的信息，某些客户端（比如Github使用的camo）在连接时可能会出现验证身份失败的情况。
```

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注
