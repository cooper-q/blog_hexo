---
layout: layout
title: git hooks实现简单的hexo自动化部署
date: 2019-04-03 12:00:00
tags: GIT
top: 100
---
# git hooks实现简单的hexo自动化部署
    
本文章只讲解简单的git hooks实现自动化部署，其余关于git hooks的内容请移步 [githooks(中文)](https://git-scm.com/book/zh/v2/%E8%87%AA%E5%AE%9A%E4%B9%89-Git-Git-%E9%92%A9%E5%AD%90) [githooks(英文)](https://git-scm.com/docs/githooks)

# 1.部署
    
## 1.服务端初始化一个远程仓库
    
    cd /root/project/deployment
    mkdir remote
    cd remote
    git init --bare // 初始化一个裸仓库，无工作区
    

## 2.服务器初始化一个本地仓库
    
    cd /root/project/deployment
    mkdir local
    cd local
    git clone /root/project/deployment/remote
    
## 3.服务器远程仓库设置hook

    cd /root/project/deployment/remote/hooks
    touch post-receive // 创建文件 加入以下代码
    
    ### 
    #!/bin/sh
    unset GIT_DIR
    cd /root/project/deployment/local/remote
    git pull origin master
    source ~/.zshrc
    ps -ef | grep "hexo" |grep -v grep|awk '{print $2}'|xargs kill -9
    nohup hexo s
    exit 0
    ###
    
    chmod +x post-receive // 增加可执行权限

# 2.测试是否自动部署
## 1.增加remote源
        
    
    找到本地想要自动部署的项目
    
    git remote add deploy user@ip:/root/project/deployment/remote    
    git push deploy master

## 2.查看是否部署成功
    
    查看/root/project/deployment/local/remote 路径下是否有想要部署的仓库文件
    如果有说明git hooks配置成功

>如有侵权行为，请[点击这里](https://github.com/mattmengCooper/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/mattmengCooper/MattMeng_hexo/issues)

# 备注

