---
layout:     post
title:      "Nginx 配置Lets Encrypt 免费SSL证书"
subtitle:   "不忘初心，方得始终"
date:       2017-9-11
header-img: "img/in-post/https_lets_encrypt/le-logo-wide.png"
header-mask: 0.3
categories:
    - Nginx 
    - HTTPS  
catalog:    true
tags:
    - HTTPS
    - Nginx
---


# Nginx 配置Lets Encrypt 免费SSL证书

    一、下载 certbot
    二、配置 Nginx 以满足 WebRoot 验证方式的需要
    三、使用 certbot 签发证书
    四、配置 Nginx 以使用签发的证书

### 一、下载 certbot


    wget https://dl.eff.org/certbot-auto -O /sbin/certbot-auto
    chmod a+x /sbin/certbot-auto

### 二、配置Nginx以满足WebRoot验证方式的需要

    在使用 certbot 之前，我们先要对 Nginx 进行配置，因为使用 webroot 方式，certbot 会在域名对应的根目录创建一个叫做 well-known 的隐藏文件夹，并且创建用于验证域名所有权的文件。而这个文件夹在证书签发的过程中，是需要被访问的。

    假设我们我们要签发用于 blog.mengxc.info 这个域名的 SSL 证书，而这个域名的配置文件在 /usr/local/nginx/conf/blog.conf ，于是我们打开这个文件，并且在 server block 内加入下面的内容：

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

## 如果是403，可配置nginx user

    保存退出、重启nginx。
    nginx -s reload

### 三、使用Certbot签发证书

    配置完 Nginx 后，我们就可以开始使用 certbot 签发证书了。现在依然假设我们要对 blog.mengxc.info 签发证书，并且这个域名对应的 webroot 目录是 /home/matt/project/ghost_blog，那么对应的命令则是：


    /sbin/certbot-auto certonly --webroot -w /home/matt/project/jekyll_blog -d blog.mengxc.info


    需要注意，你需要把上面这个命令中的 /home/matt/project/jekyll_blog 替换成你自己的网站目录，并且把 blog.mengxc.info 替换成你自己的域名。

    另外，certbot 是支持多个域名的（官方还没有支持 Wildcard），对应的命令是：


    /sbin/certbot-auto certonly --webroot -w /home/matt/project/jekyll_blog -d blog.mengxc.info -d xxxxx.guorenxi.com

    生成完毕后会有四个文件:

        privkey.pem 证书私钥
        cert.pem 证书公钥
        chain.pem 中间证书链
        fullchain.pem 证书公钥 + 中间证书链的合并


### 四、配置Nginx以使用签发的证书

    在拿到证书后，我们要开始配置 Nginx 来使用这些证书。我们需要再一次打开网站的配置文件，并且让 Nginx 监听 443 端口、配置 SSL 地址以及配置 80 自动跳转。

    我们直接修改刚才那个配置文件，把 Listen 80; 改成 Listen 443 ssl; ，修改完之后的配置文件是这样的：

    server {
        listen 443;
        server_name blog.mengxc.info;
        root /home/matt/project/ghost_blog;

        ssl_certificate /etc/letsencrypt/live/blog.mengxc.info/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/blog.mengxc.info/privkey.pem;

        localtion / {
            ...............
        }

        location ~ /.well-known {
            allow all;
        }
    }

    我们还要让访客在访问 80 端口的时候，跳转到 HTTPS ，于是还要在配置文件里面增加一个 Server Block ，修改完之后是这样的：

    server {
        listen 80;
        server_name blog.mengxc.info;
            return 301 https://$host$request_uri;
    }

    server {
        listen 443;
        server_name blog.mengxc.info;
        root /var/www/html/blog;

        ssl_certificate /etc/letsencrypt/live/blog.mengxc.info/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/blog.mengxc.info/privkey.pem;

        localtion / {
            ...............
        }

        location ~ /.well-known {
          allow all;
        }
    }

    重启nginx，nginx -s reload

    注意：在修改ssl_certificate（即公钥）时最好使用fullchain.pem而不是cert.pem。cert.pem中不包含中间
    证书链的信息，某些客户端（比如Github使用的camo）在连接时可能会出现验证身份失败的情况。

# 5.证书的自动续签

    正如前文提到的，Let's Encrypt 证书的有效期只有 90 天，因此我们需要定期的对他进行续签，我们使用 cron 来设定计划任务。

    所以可以设置为一个月一更新

    10 0 25 * *  /sbin/certbot-auto renew --quiet --no-self-upgrade
    15 0 25 * *  /usr/sbin/nginx -s reload

[脚本下载地址](https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/shell/Lets%20Encrypt.cron)

>运行脚本

    运行定时脚本前，首先查看服务器其他定时脚本，以防出现不可控制的损失。

    运行此命令查看

        crontab -l

    如果有其他定时任务可以将其定时任务合并到该脚本下

    执行此命令运行定时脚本

    crontab /xx/Lets\ Encrypt.cron



[原文链接，略有修改](https://blog.mengxc.info/43.html)

>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除


>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

>2019年3月14日更新

    完善内容，修改脚本

>2019年3月25日更新

    增加ssl_certificate（公钥）使用fullchain.pem的备注信息

