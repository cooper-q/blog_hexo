---
layout:     post
title:      "Nginx 配置Lets Encrypt 免费SSL证书"
date:       2017-9-11
top: 10
categories:
    - Nginx
    - HTTPS
catalog:    true
tags:
    - HTTPS
    - Nginx
---


# Nginx 配置Lets Encrypt 免费SSL证书
# 步骤概览
- 下载 certbot
- 配置 Nginx 以满足 WebRoot 验证方式的需要
- 使用 certbot 签发证书
- 配置 Nginx 以使用签发的证书
- 证书的自动续签
- 使用acme.sh脚本生成（终极大法）

# 1.下载 certbot


    wget https://dl.eff.org/certbot-auto -O /sbin/certbot-auto
    chmod a+x /sbin/certbot-auto

# 2.配置Nginx以满足WebRoot验证方式的需要
>配置说明

```
在使用 certbot 之前，我们先要对 Nginx 进行配置，因为使用 webroot 方式，
certbot 会在域名对应的根目录创建一个叫做 well-known 的隐藏文件夹，并且创建用于验证域名所有权的文件。
而这个文件夹在证书签发的过程中，是需要被访问的。

```
>修改nginx config

```
假设我们我们要签发用于 blog.mengxc.info 这个域名的 SSL 证书，而这个域名的配置文件在
/usr/local/nginx/conf/blog.conf ，于是我们打开这个文件，并且在 server block 内加入下面的内容：
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
>保存后，重启nginx nginx -s reload

>如果是403，可配置nginx user

# 3.使用Certbot签发证书
>签发证书说明

```
配置完 Nginx 后，我们就可以开始使用 certbot 签发证书了。
现在依然假设我们要对 blog.mengxc.info 签发证书。
并且这个域名对应的 webroot 目录是 /root/project/deployment/local/remote
```
>执行命令

```
/sbin/certbot-auto certonly --webroot -w /root/project/deployment/local/remote -d blog.mengxc.info
```
>注意

- /root/project/deployment/local/remote 该路径需要替换成自己的网站目录
- blog.mengxc.info 改域名需要改为自己的域名
- ~~certbot 是支持多个域名的（官方还没有支持 Wildcard）命令为[待验证]~~
```
/sbin/certbot-auto certonly --webroot -w /root/project/deployment/local/remote -d blog.mengxc.info -d blog.mengxc.info
```
>生成完毕后会有四个文件

```
privkey.pem 证书私钥
cert.pem 证书公钥
chain.pem 中间证书链
fullchain.pem 证书公钥 + 中间证书链的合并
```

# 4.配置Nginx以使用签发的证书

## 1.修改Nginx网站配置文件
>修改之前的文件并配置ssl以及443端口

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
>由于默认访问都是80，所以我们还需要增加对80端口跳转443端口的配置

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

>重启nginx

```
nginx -s reload
```
>备注

```
注意：在修改ssl_certificate（即公钥）时最好使用fullchain.pem而不是cert.pem。cert.pem中不包含中间
证书链的信息，某些客户端（比如Github使用的camo）在连接时可能会出现验证身份失败的情况。
```

# ~~5.证书的自动续签[由于certbot-auto升级可能不适用新版本]~~
>由于Let's Encrypt生成的证书只有90天，所以要定时进行续签

```
// 设置为一个月一更新

10 0 25 * *  /sbin/certbot-auto renew --quiet --no-self-upgrade
15 0 25 * *  /usr/sbin/nginx -s reload
```
[脚本下载地址](https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/shell/Lets%20Encrypt.cron)

>运行脚本

    运行定时脚本前，首先查看服务器其他定时脚本，以防出现不可控制的损失。

    运行此命令查看

        crontab -l

    如果有其他定时任务可以将其定时任务合并到该脚本下

    执行此命令运行定时脚本

    crontab /xx/Lets\ Encrypt.cron

# 6.使用acme.sh生成
## 1.安装acme.sh
```
curl https://get.acme.sh | sh
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                               Dload  Upload   Total   Spent    Left  Speed
100   671  100   671    0     0    680      0 --:--:-- --:--:-- --:--:--   679
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                               Dload  Upload   Total   Spent    Left  Speed
100  112k  100  112k    0     0   690k      0 --:--:-- --:--:-- --:--:--  693k
[Fri 30 Dec 01:03:32 GMT 2016] Installing from online archive.
[Fri 30 Dec 01:03:32 GMT 2016] Downloading https://github.com/Neilpang/acme.sh/archive/master.tar.gz
[Fri 30 Dec 01:03:33 GMT 2016] Extracting master.tar.gz
[Fri 30 Dec 01:03:33 GMT 2016] Installing to /home/user/.acme.sh
[Fri 30 Dec 01:03:33 GMT 2016] Installed to /home/user/.acme.sh/acme.sh
[Fri 30 Dec 01:03:33 GMT 2016] Installing alias to '/home/user/.profile'
[Fri 30 Dec 01:03:33 GMT 2016] OK, Close and reopen your terminal to start using acme.sh
[Fri 30 Dec 01:03:33 GMT 2016] Installing cron job
no crontab for user
no crontab for user
[Fri 30 Dec 01:03:33 GMT 2016] Good, bash is found, so change the shebang to use bash as preferred.
[Fri 30 Dec 01:03:33 GMT 2016] OK
[Fri 30 Dec 01:03:33 GMT 2016] Install success!
```
>注意看错误提示 一般都是缺少某个依赖 然后根据使用的系统来安装依赖就可以

## 2.使用acme.sh 生成证书

- 确保80端口没有被占用
- 替换下面命令中的mydomain.com字段
- 确定nginx 域名dns 都正常使用
- -k 表示密钥长度，后面的值可以是 ec-256 、ec-384、2048、3072、4096、8192，带有 ec 表示生成的是 ECC 证书，没有则是 RSA 证书。在安全性上 256 位的 ECC 证书等同于 3072 位的 RSA 证书。

```
$ sudo ~/.acme.sh/acme.sh --issue -d mydomain.com --standalone -k ec-256

[Fri Dec 30 08:59:12 HKT 2016] Standalone mode.
[Fri Dec 30 08:59:12 HKT 2016] Single domain='mydomain.com'
[Fri Dec 30 08:59:12 HKT 2016] Getting domain auth token for each domain
[Fri Dec 30 08:59:12 HKT 2016] Getting webroot for domain='mydomain.com'
[Fri Dec 30 08:59:12 HKT 2016] _w='no'
[Fri Dec 30 08:59:12 HKT 2016] Getting new-authz for domain='mydomain.com'
[Fri Dec 30 08:59:14 HKT 2016] The new-authz request is ok.
[Fri Dec 30 08:59:14 HKT 2016] mydomain.com is already verified, skip.
[Fri Dec 30 08:59:14 HKT 2016] mydomain.com is already verified, skip http-01.
[Fri Dec 30 08:59:14 HKT 2016] mydomain.com is already verified, skip http-01.
[Fri Dec 30 08:59:14 HKT 2016] Verify finished, start to sign.
[Fri Dec 30 08:59:16 HKT 2016] Cert success.
-----BEGIN CERTIFICATE-----
MIIEMTCCAxmgAwIBAgISA1+gJF5zwUDjNX/6Xzz5fo3lMA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xNjEyMjkyMzU5MDBaFw0x
NzAzMjkyMzU5MDBaMBcxFTATBgNVBAMTDHdlYWtzYW5kLmNvbTBZMBMGByqGSM49
****************************************************************
4p40tm0aMB837XQ9jeAXvXulhVH/7/wWZ8/vkUUvuHSCYHagENiq/3DYj4a85Iw9
+6u1r7atYHJ2VwqSamiyTGDQuhc5wdXIQxY/YQQqkAmn5tLsTZnnOavc4plANT40
zweiG8vcIvMVnnkM0TSz8G1yzv1nOkruN3ozQkLMu6YS7lk/ENBN7DBtYVSmJeU2
VAXE+zgRaP7JFOqK6DrOwhyE2LSgae83Wq/XgXxjfIo1Zmn2UmlE0sbdNKBasnf9
gPUI45eltrjcv8FCSTOUcT7PWCa3
-----END CERTIFICATE-----
[Fri Dec 30 08:59:16 HKT 2016] Your cert is in  /root/.acme.sh/mydomain.com_ecc/mydomain.com.cer
[Fri Dec 30 08:59:16 HKT 2016] Your cert key is in  /root/.acme.sh/mydomain.com_ecc/mydomain.com.key
[Fri Dec 30 08:59:16 HKT 2016] The intermediate CA cert is in  /root/.acme.sh/mydomain.com_ecc/ca.cer
[Fri Dec 30 08:59:16 HKT 2016] And the full chain certs is there:  /root/.acme.sh/mydomain.com_ecc/fullchain.cer
```
## 3.证书更新
- Let's Encrypt 的证书有效期只有 3 个月 需要使用一下命令手动更新

- ECC证书
```
sudo ~/.acme.sh/acme.sh --renew -d mydomain.com --force --ecc
```

- RSA证书
```
sudo ~/.acme.sh/acme.sh --renew -d mydomain.com --force
```

- 通配符证书
```
# 首先要根据下面配置全局key或者其余内容
https://github.com/Neilpang/acme.sh/wiki/dnsapi

acme.sh --issue --dns dns_cf -d *.example.com -d example.com
```

## 4.安装证书和密钥
- 安装到/etc/nginx目录下（目录可更改）
- 证书安装完毕后重复上面的第四步骤（配置Nginx以使用签发的证书）即可

-ECC证书
```
~/.acme.sh/acme.sh --installcert -d mydomain.com --fullchainpath /etc/nginx/mydomain.com.crt --keypath /etc/nginx/mydomain.com.key --ecc
```

-RSA证书
```
sudo ~/.acme.sh/acme.sh --installcert -d mydomain.com --fullchainpath /etc/nginx/mydomain.com.crt --keypath /etc/nginx/mydomain.com.key
```
## 5.错误处理
- zsh: no matches found: *.example.com
```
# .zshrc下增加
setopt no_nomatch
```

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除


>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

>2019年3月14日更新

- 完善内容，修改脚本

>2019年3月25日更新

- 增加ssl_certificate（公钥）使用fullchain.pem的备注信息

>2019年5月07日更新

- 删减内容、修改排版

>2019年5月23日更新

- 重新排版、修改无法适用于新版本的内容

>2019年7月05日更新

- 增加使用acme.sh脚本生成TLS（终极大法）
