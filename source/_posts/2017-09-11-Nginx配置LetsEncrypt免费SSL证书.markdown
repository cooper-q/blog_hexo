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
/sbin/certbot-auto certonly --webroot -w /root/project/deployment/local/remote -d blog.mengxc.info -d xxxxx.mengxc.info
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


>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除


>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

>2019年3月14日更新

-完善内容，修改脚本

>2019年3月25日更新

- 增加ssl_certificate（公钥）使用fullchain.pem的备注信息

>2019年5月07日更新

- 删减内容、修改排版

>2019年5月23日更新

- 重新排版、修改无法适用于新版本的内容
