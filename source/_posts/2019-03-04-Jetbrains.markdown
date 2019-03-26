---
layout:     post
subtitle:   "不忘初心，方得始终"
title:      "Jetbrains"
date:       2019-03-04
author:     "mattmeng"
header-img: ""
header-mask: 0.3

catalog:    true
tags:
    - Jetbrains、软件
---
# 破解Jetbrains家族系列产品

## 1.下载相应的jar文件

    IDEA 3.5 版本、以及 DataGrip 3.3 支持

[下载的地址](https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/jetbrains-agent.jar)


## 2.修改相应的vm options

    -javaagent:/path/jetbrains-agent.jar
    // path是自己存放jetbrains-agent.jar的文件地址


    两种方法修改vmoptions

    1.试用版进入后

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JetBrains%20%E4%BF%AE%E6%94%B9VM%20Options%E6%96%87%E4%BB%B6'/>

    2.进入项目后

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/JetBrains%20%E4%BF%AE%E6%94%B9VM%20Options%E6%96%87%E4%BB%B602'/>

    vmoptions示例
    
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/vm%20options%E7%A4%BA%E4%BE%8B%E5%9B%BE'/>

## 3.修改hosts

    vim /etc/hosts

    添加上
        0.0.0.0 account.jetbrains.com

## 4.激活

<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/Manage%20License%E7%A4%BA%E4%BE%8B%E5%9B%BE'/>
<img src='https://dpq123456-1256164122.cos.ap-beijing.myqcloud.com/software/picture/License%20Server'/>

    只要符合规范（http://xxxxx），地址可以随便写。

>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/jekyll_blog/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/jekyll_blog/issues)

# 备注

>2019年3月25日
    
    更新jetbrains-agent.jar来适用于新版本
