---
layout:     post
title:      "CleanMyMac X 破解版"
date:       2019-03-18
top: 10
categories:
    - Mac
    - 软件
tags:
    - Mac
    - 软件
---

# CleanMyMac X破解
# 1.下载破解版

[下载地址](https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/CleanMyMac_X_4.3.0.zip)

# 2.解压并打开dmg文件

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/CleanMyMac%20X%20%E7%A0%B4%E8%A7%A301.png'/>

    双击上图红框位置
    双击CleanMyMac X 4.3.0 [TNT].dmg
    将程序拖入Application即可

# 3.破解

    双击Open Gatekeeper friendly
    一路回车即可

# 4.错误提示

>1.XXX文件已损坏，需要移到废纸篓。

    解决方法一：
        终端运行 sudo spctl --master-disable
        重新运行程序

    解决方法二：

        xattr -r -d com.apple.quarantine /Applications/CleanMyMac\ X.app /Applications/CleanMyMac\ X.app是CleanMyMac X

        运行此命令，需要自己对应到程序的安装目录

>2.提示文件不信任

    解决方法一：

        Control+单击右键打开

    解决方法二：

        终端运行 sudo spctl --master-disable
        更改为任何来源

>3.CleanMyMac X 因出现问题而无法打开

    解决方法一：
        运行此命令

        sudo codesign --force --deep --sign - /Applications/CleanMyMac\ X.app

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

>2019年3月18日添加

    亲测 macOS Mojave 10.14.3 可用


>2019年4月17日

    亲测 macOS Mojave 10.14.4 可用
    增加"CleanMyMac X 因出现问题而无法打开"的解决方案
