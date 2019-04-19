---
layout: post
title: ShadowsocksR 多用户 一键脚本
date: 2019-03-26
tags: Shadowsocks、GFW
top: 10
password: ShadowsocksRPWD
abstract: 此文章较为敏感，请点击左下角的Email发送邮件索要。
message: 此文章较为敏感，请点击左下角的Email发送邮件索要。
categories:
    - Shadowsocks

---
>系统要求
    
    Centos 6+/Debian 6+/Ubuntu 14+

>脚本特点
    
    支持 限制 用户速度
    支持 限制 用户设备数
    支持 限制 用户总流量
    支持 定时 流量清零
    支持 显示 当前连接IP
    支持 显示 SS/SSR连接+二维码
    支持 一键安装 BBR
    支持 一键安装 锐速
    支持 一键安装 LotServer
    支持 一键封禁 垃圾邮件(SMAP)/BT/PT

# 1.安装步骤
    
    简单的来说，如果你什么都不懂，那么你直接一路回车就可以了！本脚本需要Linux root账户权限才能正常安装运行，所以如果不是 root账号，请先切换为root，如果是 root账号，那么请跳过！
    
>sudo su
    
    输入上面代码回车后会提示你输入当前用户的密码，输入并回车后，没有报错就继续下面的步骤安装ShadowsocksR。
>输入下面指令即可开始安装。
    
    1.wget -N --no-check-certificate https://makeai.cn/bash/ssrmu.sh && chmod +x ssrmu.sh && bash ssrmu.sh
      
    2.链接: https://pan.baidu.com/s/1gbdOEnOq78foKECVOm3RMw 密码: fujx
    base /path/ssrmu.sh
    
>输入 1
    
    就会开始安装ShadowsocksR服务端，并且会提示你输入Shadowsocks的 端口/密码/加密方式/ 协议/混淆（混淆和协议是通过输入数字选择的） 等参数来添加第一个用户。
>注意：用户名不支持中文，如果输入中文会一直保存下去！
    
    1. 请输入要设置的用户 用户名(请勿重复, 用于区分, 不支持中文, 会报错 !)
    2. (默认: bbaaz):bbaz
    3. 
    4. ——————————————————————————————
    5.         用户名 : bbaaz
    6. ——————————————————————————————
    7. 
    8. 请输入要设置的用户 端口(请勿重复, 用于区分)
    9. (默认: 6899):6899
    10. 
    11. ——————————————————————————————
    12.         端口 : 6899
    13. ——————————————————————————————
    14. 
    15. 请输入要设置的用户 密码
    16. (默认: bbaaz.com):bbaaz.com
    17. 
    18. ——————————————————————————————
    19.         密码 : bbaaz.com
    20. ——————————————————————————————
    21. 
    22. 请选择要设置的用户 加密方式
    23.   1. none
    24. [注意] 如果使用 auth_chain_* 系列协议，建议加密方式选择 none (该系列协议自带 RC4 加密)，混淆随意
    25. 
    26.   2. rc4
    27.   3. rc4-md5
    28.   4. rc4-md5-6
    29. 
    30.   5. aes-128-ctr
    31.   6. aes-192-ctr
    32.   7. aes-256-ctr
    33. 
    34.   8. aes-128-cfb
    35.   9. aes-192-cfb
    36. 10. aes-256-cfb
    37. 
    38. 11. aes-128-cfb8
    39. 12. aes-192-cfb8
    40. 13. aes-256-cfb8
    41. 
    42. 14. salsa20
    43. 15. chacha20
    44. 16. chacha20-ietf
    45. [注意] salsa20/chacha20-*系列加密方式，需要额外安装依赖 libsodium ，否则会无法启动ShadowsocksR !
    46. 
    47. (默认: 5. aes-128-ctr):5
    48. 
    49. ——————————————————————————————
    50.         加密 : aes-128-ctr
    51. ——————————————————————————————
    52. 
    53. 请选择要设置的用户 协议插件
    54. 1. origin
    55. 2. auth_sha1_v4
    56. 3. auth_aes128_md5
    57. 4. auth_aes128_sha1
    58. 5. auth_chain_a
    59. 6. auth_chain_b
    60. [注意] 如果使用 auth_chain_* 系列协议，建议加密方式选择 none (该系列协议自带 RC4 加密)，混淆随意
    61. 
    62. (默认: 2. auth_sha1_v4):2
    63. 
    64. ——————————————————————————————
    65.         协议 : auth_sha1_v4
    66. ——————————————————————————————
    67. 
    68. 是否设置 协议插件兼容原版(_compatible)？[Y/n]y
    69. 
    70. 请选择要设置的用户 混淆插件
    71. 1. plain
    72. 2. http_simple
    73. 3. http_post
    74. 4. random_head
    75. 5. tls1.2_ticket_auth
    76. [注意] 如果使用 ShadowsocksR 代理游戏，建议选择 混淆兼容原版或 plain 混淆，然后客户端选择 plain，否则会增加延迟 !
    77. 另外, 如果你选择了 tls1.2_ticket_auth，那么客户端可以选择 tls1.2_ticket_fastauth，这样即能伪装特征 又不会增加延迟 !
    78. 
    79. (默认: 5. tls1.2_ticket_auth):5
    80. 
    81. ——————————————————————————————

>同时最后也会提示是否设置 混淆 兼容原版（也就是使用原版SS也能链接），不懂 直接回车 或 输入 y。（协议不在兼容原版）
    
    注意：关于限制设备数数，这个协议必须是非原版并且不兼容原版才有效，也就是必须SSR客户端使用协议的情况下，才有效！不输入一路回车就是 默认参数：
    1. 用户 : bbaaz
    2. 端口 : 6899
    3. 密码 : bbaaz.com
    4. 加密 : aes-128-ctr
    5. 协议 : auth_sha1_v4_compatible
    6. 混淆 : tls1.2_ticket_auth_compatible
    7. 设备数限制: 0(无限)
    8. 单线程限速: 0 KB/S (不限速)
    9. 端口总限速: 0 KB/S (不限速)
    10. 禁止的端口 : 无限制
    11. 用户总流量 : 819.21 TB

>如果安装过程没有出错，那么最后就会提示：
    
    1. ############################################################
    2. 用户 [bbaaz] 的配置信息：
    3. 
    4. I P     : xxx.xxx.xxx.xxx
    5. 端口     : 6899
    6. 密码     : bbaaz.com
    7. 加密     : aes-128-ctr
    8. 协议     : auth_sha1_v4_compatible
    9. 混淆     : tls1.2_ticket_auth_compatible
    10. 设备数限制: X
    11. 单线程限速: XXX KB/S
    12. 端口总限速: XXX KB/S
    13. 禁止的端口 : 无限制
    14. 
    15. 已使用流量 : 上传: XXX KB + 下载: XXX MB = XXX MB
    16. 剩余的流量 : XXX TB
    17. 用户总流量 : XXX TB
    18. 
    19. SS链接: ss://xxxxxxxxxxxxx
    20. SS二维码: http://pan.baidu.com/share/qrcode?w=300&h=300&url=ss://xxxxxxxxxxxxx
    21. SSR链接: ssr://xxxxxxxxxxxxx
    22. SSR二维码: http://pan.baidu.com/share/qrcode?w=300&h=300&url=ssr://xxxxxxxxxxxxx
    23. 
    24. 提示:
    25. 在浏览器中，打开二维码链接，就可以看到二维码图片。
    26. 协议和混淆后面的[ _compatible ]，指的是 兼容原版协议/混淆。
    27. 
    28. ############################################################

>SS/SSR链接
    
    （格式： ss://XXXXXXX ，很长），可以从剪辑版导入Shadowsocks客户端，不懂的话看下面二维码。
    
>SS/SSR二维码
    
    复制后面的链接在浏览器打开，就会显示一个二维码的图片，可以用Shadowsocks客户端扫描二维码来添加。

# 2.使用说明
    
    运行脚本
    1. bash ssrmu.sh
    2. 
    3. # 还有一个 运行参数，是用于所有用户流量清零的
    4. bash ssrmu.sh clearall
    5. # 不过不需要管这个，可以通过脚本自动化的设置 crontab 定时运行脚本
    复制代码
    输入对应的数字来执行相应的命令。
    1. ShadowsocksR MuJSON一键管理脚本 [vX.X.X]
    2.   ---- dary | bbaaz.com/ss-jc60 ----
    3. 
    4.   1. 安装 ShadowsocksR
    5.   2. 更新 ShadowsocksR
    6.   3. 卸载 ShadowsocksR
    7.   4. 安装 libsodium(chacha20)
    8. ————————————
    9.   5. 查看 账号信息
    10.   6. 显示 连接信息
    11.   7. 设置 用户配置
    12.   8. 手动 修改配置
    13.   9. 清零 已用流量
    14. ————————————
    15. 10. 启动 ShadowsocksR
    16. 11. 停止 ShadowsocksR
    17. 12. 重启 ShadowsocksR
    18. 13. 查看 ShadowsocksR 日志
    19. ————————————
    20. 14. 其他功能
    21. 15. 升级脚本
    22. 
    23. 当前状态: 已安装 并 已启动
    24. 
    25. 请输入数字 [1-15]：

>注意
    
    添加/删除/修改 用户配置后，无需重启ShadowsocksR服务端，ShadowsocksR服务端会定时读取数据库文件内的信息，不过修改 用户配置后，可能要等个十几秒才能应用最新的配置（因为ShadowsocksR不是实时读取数据库的，所以有间隔时间）。

>文件位置
    
    安装目录：/usr/local/shadowsocksr
    配置文件：/usr/local/shadowsocksr/user-config.json
    数据文件：/usr/local/shadowsocksr/mudb.json

>ShadowsocksR服务端不会实时的把流量数据写入 数据库文件，所以脚本读取流量信息也不是实时的！

# 3.其他说明
    
    ShadowsocksR 安装后，自动设置为 系统服务，所以支持使用服务来启动/停止等操作，同时支持开机启动。
    
    ● 启动 ShadowsocksR：service ssrmu start
    ● 停止 ShadowsocksR：service ssrmu stop
    ● 重启 ShadowsocksR：service ssrmu restart
    ● 查看 ShadowsocksR状态：service ssrmu status

>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

>我已经忘记在哪看的这个文章，暂时无法标记处出处，侵删
