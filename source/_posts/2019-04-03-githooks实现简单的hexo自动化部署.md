---
layout: post
title: git hooks实现简单的hexo自动化部署
date: 2019-04-03
tags: git
keywords: git,githook,hexo

categories:
    - git
---
# git hooks实现简单的hexo自动化部署

本文章只讲解简单的git hooks实现自动化部署，其余关于git hooks的内容请移步 [githooks(中文)](https://git-scm.com/book/zh/v2/%E8%87%AA%E5%AE%9A%E4%B9%89-Git-Git-%E9%92%A9%E5%AD%90) [githooks(英文)](https://git-scm.com/docs/githooks)

# 1.部署

## 1.服务端初始化一个远程仓库
```
cd /root/project
mkdir remote
cd remote

// 初始化一个裸仓库，无工作区
git init --bare
```
<!-- more -->
## 2.服务器初始化一个本地仓库
```
cd /root/project
mkdir local
cd local
git clone /root/project/remote
```

## 3.服务器远程仓库设置hook
- 1.创建git hook post-receive 或者 post-update
```
cd /root/project/remote/hooks
touch post-receive // 创建文件 加入以下代码
```
- 2.post-receive 文件内容
```
#!/bin/sh
unset GIT_DIR
cd /root/project/local/remote
git pull origin master
source ~/.bashrc
ps -ef | grep "hexo" |grep -v grep|awk '{print $2}'|xargs kill -9
nohup hexo s
exit 0
```

- 3.增加可执行权限
```
chmod +x [post-receive or post-update]
```

# 2.测试是否自动部署
## 1.增加remote源
```
# 找到本地想要自动部署的项目
git remote add deploy user@ip:/root/project/deployment/remote
git push deploy master
```

## 2.查看是否部署成功
```
# 1.查看/root/project/deployment/local/remote 路径下是否有想要部署的仓库文件
# 2.如果有说明git hooks配置成功
```

# 3.自动化脚本
## 1.服务器初始化服务自动化脚本
```
#!/usr/bin/env bash
# 1.初始化远程仓库
mkdir -p /root/project/remote && cd /root/project/remote
git init --bare

# 2.初始化远程本地仓库
mkdir -p /root/project/local && cd /root/project/local
git clone /root/project/remote

# 3.服务器远程仓库设置hook
cd /root/project/remote/hooks && touch post-update

echo '#!/bin/sh' >> post-update
echo 'unset GIT_DIR' >> post-update
echo 'cd /root/project/local/remote' >> post-update
echo 'git pull origin master' >> post-update
# echo 'source ~/.bashrc' >> post-update
echo "ps -ef | grep 'hexo' |grep -v grep|awk '{print \$2}'|xargs kill -9" >> post-update
echo 'nohup hexo s' >> post-update
echo 'exit 0' >> post-update
chmod +x post-update
echo 'done'
```

## ~~2.本地提交时脚本【暂未测试通过】~~
- 1.进入.git/hooks下创建 pre-push文件
- 2.加入下方内容
```
#!/bin/sh
git push deploy master
```

>如有侵权行为，请[点击这里](https://github.com/cooper-q/MattMeng_hexo/issues)联系我删除

>[如发现疑问或者错误点击反馈](https://github.com/cooper-q/MattMeng_hexo/issues)

# 备注

