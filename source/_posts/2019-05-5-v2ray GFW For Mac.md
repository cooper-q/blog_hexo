---
layout: post
title: v2ray GFW For Mac
date: 2019-05-04
keywords: GFW、v2ray
top: 10
password: v2rayPWD
abstract: 此文章较为敏感，请点击左下角的Email发送邮件索要。
message: 此文章较为敏感，请点击左下角的Email发送邮件索要。
categories: 
    - v2ray
tags:
    - v2ray
---
# v2ray GFW For Mac
# 环境
- 服务器系统：Centos7
- V2Ray Version：V2Ray 4.18.0 (Po) 20190228
- 客户端系统：macOS Mojave 10.1
- VPS：搬瓦工 [通过我的购买链接购买](https://bandwagonhost.com/aff.php?aff=46893)

# 服务器安装
>-bash: xxx: command not found
```
由于是新买的服务器，所以很多软件都没有安装。
如果出现上述描述的问题，可以直接使用yum install xxx即可。
```
>v2ray注意事项
```
如果大家公寓shadowsocks之类的软件就会发现，他们是分客户端和服务端的。
但是v2ray没有这种概念，v2ray客户端和服务端是一样的，但是配置文件不一样。
v2ray是一个平台，不同于shadowsocks。本教程只科学上网，其余参考官网。
```
## 1.下载脚本
```
wget https://install.direct/go.sh
```
## 2.执行安装
```
bash ./go.sh
如果安装结束出现
PORT:xxx
UUID:xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx
Created symlink from /etc/systemd/system/multi-user.target.wants/v2ray.service to /etc/systemd/system/v2ray.service.
V2Ray v4.18.0 is installed.

说明安装成功
```
## 3.配置
```
安装完毕后，需要对客户端、服务器进行配置。
配置文件地址：/etc/v2ray/config.json
v2ray支持多种协议，针对不同的协议需要进行不同的配置。
```
>1.vmess协议配置（默认即可）
```
服务端配置文件注意的点
inbounds里面的port、protocol、id、level、alterId 
以上一定要和客户端配置相匹配（稍后讲到）
    
{
  "inbounds": [{
    "port": 16718,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "a9160079-d888-4300-8e3f-e9343b594b0f",
          "level": 1,
          "alterId": 64
        }
      ]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "blocked"
      }
    ]
  }
}
```
>2.防火墙 
```
搬瓦工默认不开启防火墙，这里不做过多赘述，想了解请点击下面文章地址。
```
[centos7 firewall](https://blog.mengxc.info/2018-04-23-Centos7-firewall/)

## 4.启动
```
v2ray 默认不会自动启动，需要手动启动。
在启动的情况下，再次执行安装脚本会进行更新、升级v2ray。

## 启动
sudo systemctl start v2ray

## 停止
sudo systemctl stop v2ray

## 重启
sudo systemctl restart v2ray
```
## 5.客户端
>1.下载

[点击下载](https://github.com/yanue/V2rayU/releases)

>2.配置
```
右上角点击安装完毕后的客户端图标

Configure->Manual
```
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/v2ray/v2ray%20Configure%20Manual.png'/>

```
根据图中相应的说明和标记，找到服务端配置对应项填写完毕，其余的默认即可。
```
  
>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

