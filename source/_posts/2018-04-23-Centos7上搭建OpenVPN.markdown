---
layout:     post
title:      "Centos7上搭建OpenVPN.markdown"
subtitle:   "不忘初心，方得始终"
date:       2018-04-23
header-img: "img/in-post/Linux/openvpn.jpeg"
header-mask: 0.3
categories:
    - Linux 
    - centos7
    - OpenVPN
catalog:    true
tags:
    - OpenVPN
    - Linux
    - centos7
---

### 1.安装软件（如果没安装）
     yum install openvpn easy-rsa
### 2.准备相关目录和配置文件

    cp /usr/share/doc/easy-rsa-3.0.3/vars.example /etc/openvpn/easy-rsa/vars
    cp -r /usr/share/easy-rsa/3.0.3/* /etc/openvpn/easy-rsa/
>复制的文件有：easyrsa、openssl-1.0.cnf、x509-types；

    cp /usr/share/doc/openvpn-2.4.5/sample/sample-config-files/server.conf /etc/openvpn/

    编辑vars文件(/etc/openvpn/easy-rsa/vars)：
    set_var EASYRSA_REQ_COUNTRY "CN"
    set_var EASYRSA_REQ_PROVINCE    "Beijing"
    set_var EASYRSA_REQ_CITY    "Beijing"
    set_var EASYRSA_REQ_ORG "OpenVPN CA"
    set_var EASYRSA_REQ_EMAIL   "mxc441230435@gmail.com"
    set_var EASYRSA_REQ_OU      "My VPN"

### 3.创建服务器端证书和key

>1.目录初始化

    cd /etc/openvpn/easy-rsa/
    ./easyrsa init-pki
>2.创建根证书

    ./easyrsa build-ca
    Enter PEM pass phrase: 输入2次pem密码，并记住（输入的pem密码是openvpn，后面会用到）；
            ........
            Common Name (eg: your user, host, or server name) [Easy-RSA CA]: 输入名称；（输入的是opvpn-ca）

            回车后显示：
    CA creation complete and you may now import and sign cert requests.
    Your new CA certificate file for publishing is at:
    /etc/openvpn/easy-rsa/pki/ca.crt
>3.创建服务器端证书

     ./easyrsa gen-req server nopass
     Common Name (eg: your user, host, or server name) [server]: （输入是node2）

    输入回车后显示：
    Keypair and certificate request completed. Your files are:
    req: /etc/openvpn/easy-rsa/pki/reqs/server.req
    key: /etc/openvpn/easy-rsa/pki/private/server.key
>4.签署服务器端证书

    ./easyrsa sign server server
    回车后，Confirm request details: （输入yes）
    Enter pass phrase for /etc/openvpn/easy-rsa/pki/private/ca.key: （输入之前CA根证书的pem密码是openvpn）

    回车后显示：

    Check that the request matches the signature
    Signature ok
    The Subject's Distinguished Name is as follows
    commonName :ASN.1 12:'node2'
    Certificate is to be certified until Apr 4 16:04:29 2028 GMT (3650 days)

    Write out database with 1 new entries
    Data Base Updated

    Certificate created at: /etc/openvpn/easy-rsa/pki/issued/server.crt

>5.创建Diffie-Hellman，确保key穿越不安全网络的命令

     ./easyrsa gen-dh
     回车后，等的时间稍微长一点，最后显示：
    DH parameters of size 2048 created at /etc/openvpn/easy-rsa/pki/dh.pem
>6.生成ta密钥文件

    openvpn --genkey --secret /etc/openvpn/easy-rsa/ta.key

    不执行此命令，会报错：
    Sat Apr  7 12:53:37 2018 WARNING: cannot stat file 'ta.key': No such file or directory (errno=2)
    Options error: --tls-auth fails with 'ta.key': No such file or directory (errno=2)
    Options error: Please correct these errors.
    Use --help for more information.

### 4.创建客户端证书及key

>1.创建过程同服务端

    mkdir /root/client
    cd /root/client
    cp -r /usr/share/easy-rsa/3.0.3/* ./
    ./easyrsa init-pki
    ./easyrsa gen-req client

    回车后显示Enter PEM pass phrase: 输入密码，密码是之后客户端连接服务器要用的（输入的是vpnclient）
    Common Name (eg: your user, host, or server name) [client]: （输入的是client，后面会用到）
    回车后显示：
    Keypair and certificate request completed. Your files are:
    req: /root/client/pki/reqs/client.req
    key: /root/client/pki/private/client.key

>2.将得到的client.req导入然后签约证书

    cd /etc/openvpn/easy-rsa/
    ./easyrsa import-req /root/client/pki/reqs/client.req client

    Note: using Easy-RSA configuration from: ./vars

    The request has been successfully imported with a short name of: client
    You may now use this name to perform signing operations on this request.

>3.签约证书

    ./easyrsa sign client client
    回车后，输入yes；

    Enter pass phrase for /etc/openvpn/easy-rsa/pki/private/ca.key: （输入的是openvpn）

        注意：
    这里生成client所以第一个client位置必须为client，第二个参数client要与之前导入名字一致，导入的时候会要求输入密码，这个密码是第一次设置的根证书的密码，不要输错；因为openvpn是一个客户端对应一组证书密钥文件的；

        回车后显示：

    Check that the request matches the signature
    Signature ok
    The Subject's Distinguished Name is as follows
    commonName :ASN.1 12:'client'
    Certificate is to be certified until Apr 4 16:38:37 2028 GMT (3650 days)

    Write out database with 1 new entries
    Data Base Updated

    Certificate created at: /etc/openvpn/easy-rsa/pki/issued/client.crt

### 5.拷贝相关文件
>拷贝服务器端所需文件到各自位置：

    cd /etc/openvpn/
    cp pki/ca.crt /etc/openvpn/
    cp pki/private/server.key /etc/openvpn/
    cp pki/issued/server.crt /etc/openvpn/
    cp pki/dh.pem /etc/openvpn/
    cp /easy-rsa/ta.key /etc/openvpn/

>拷贝客户端所需文件到各种位置：

    cd /etc/openvpn/
    cp pki/ca.crt /root/client/
    cp pki/issued/client.crt /root/client/
    cp /root/client/pki/private/client.key /root/client/
    cp /etc/openvpn/easy-rsa/ta.key  /root/client/

### 6.修改配置文件

    /etc/openvpn/server.conf

    local vps ip
    port 1194
    proto udp
    dev tun
    ca /etc/openvpn/ca.crt
    cert /etc/openvpn/server.crt
    key /etc/openvpn/server.key  ### This file should be kept secret
    dh /etc/openvpn/dh.pem
    server 10.8.0.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    push "redirect-gateway def1 bypass-dhcp"
    push "dhcp-option DNS 8.8.8.8"
    push "dhcp-option DNS 208.67.220.220"
    duplicate-cn
    keepalive 10 120
    tls-auth ta.key 0 ### This file is secret
    cipher AES-256-CBC
    comp-lzo
    max-clients 100
    persist-key
    persist-tun
    status openvpn-status.log
    verb 3
    explicit-exit-notify 1
>关于server.conf具体内容可以查看另一篇文章

### 7.启动openvpn

    openvpn /etc/openvpn/server.conf &

    Sat Apr  7 13:00:23 2018 OpenVPN 2.4.5 x86_64-redhat-Linux-gnu [Fedora EPEL patched] [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Mar  1 2018
    Sat Apr  7 13:00:23 2018 library versions: OpenSSL 1.0.2k-fips  26 Jan 2017, LZO 2.06
    Sat Apr  7 13:00:23 2018 Diffie-Hellman initialized with 2048 bit key
    Sat Apr  7 13:00:23 2018 Outgoing Control Channel Authentication: Using 160 bit message hash 'SHA1' for HMAC authentication
    Sat Apr  7 13:00:23 2018 Incoming Control Channel Authentication: Using 160 bit message hash 'SHA1' for HMAC authentication
    Sat Apr  7 13:00:23 2018 ROUTE_GATEWAY 192.168.255.1/255.255.255.0 IFACE=eno16777736 HWADDR=00:0c:29:ef:e4:a7
    Sat Apr  7 13:00:23 2018 TUN/TAP device tun0 opened
    Sat Apr  7 13:00:23 2018 TUN/TAP TX queue length set to 100
    Sat Apr  7 13:00:23 2018 do_ifconfig, tt->did_ifconfig_ipv6_setup=0
    Sat Apr  7 13:00:23 2018 /sbin/ip link set dev tun0 up mtu 1500
    Sat Apr  7 13:00:23 2018 /sbin/ip addr add dev tun0 local 10.8.0.1 peer 10.8.0.2
    Sat Apr  7 13:00:23 2018 /sbin/ip route add 10.8.0.0/24 via 10.8.0.2
    Sat Apr  7 13:00:24 2018 Could not determine IPv4/IPv6 protocol. Using AF_INET
    Sat Apr  7 13:00:24 2018 Socket Buffers: R=[212992->212992] S=[212992->212992]
    Sat Apr  7 13:00:24 2018 UDPv4 link local (bound): [AF_INET][undef]:1194
    Sat Apr  7 13:00:24 2018 UDPv4 link remote: [AF_UNSPEC]
    Sat Apr  7 13:00:24 2018 MULTI: multi_init called, r=256 v=256
    Sat Apr  7 13:00:24 2018 IFCONFIG POOL: base=10.8.0.4 size=62, ipv6=0
    Sat Apr  7 13:00:24 2018 IFCONFIG POOL LIST
    Sat Apr  7 13:00:24 2018 Initialization Sequence Completed

    输出上面内容表示成功

    或使用systemctl启动：

    systemctl -f enable openvpn@server.service
    #设置启动文件

    systemctl start openvpn@server.service
    #启动openvpn的命令

### 8.使用（Linux）

    这里只介绍MacOs使用，如果想要科学上网建议使用ss，更快捷，更方便。

    windows可使用OpenVPN GUI

    访问下载tunnelblick：https://tunnelblick.net/

    创建openvpn.ovpn或者使用自带示例
>下载服务端四个文件

    1./root/client/ca.crt
    2./root/client/client.crt
    3./root/client/client.key
    4./root/client/ta.key
    上述四个文件和openvpn.ovpn放到同级目录下
>示例配置文件

    client
    dev tun
    proto udp
    remote vpsip port
    resolv-retry infinite
    nobind
    comp-lzo
    ### dhcp-option DNS 223.5.5.5
    ### dhcp-option DNS 223.6.6.6
    persist-key
    persist-tun
    ca ca.crt
    cert client.crt
    key client.key
    remote-cert-tls server
    tls-auth ta.key 1
    cipher AES-256-CBC
    verb 3
>导入

    修改完配置文件后双击就可以导入
>输入密码

    创建客户端时输入的密码（这里是vpnclient）

### 9.问题汇总（以上教程可以成功的情况下）

>1.服务端启动成功，客户端无法连接

    防火墙问题
        建立将OpenVPN的端口加入到防火墙列表（不建议关闭防火墙），防火墙相关知识可以查看博客另一篇文章（firewall）
>2.服务端启动成功，客户端可以连接，但是没有internet

    路由转发问题
        1.去掉转发规则中的 -o eth0
            iptables -t nat -A POSTROUTING -s 10.8.0.0/24  -j MASQUERADE
            如果不可以尝试第二种
        2.清空所有规则
            iptables -F
            iptables -X
            iptables -Z
            iptables -t nat -A POSTROUTING -s 10.8.0.0/24  -j MASQUERADE
            /etc/init.d/iptables save

>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)
