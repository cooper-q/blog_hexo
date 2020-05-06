#!/usr/bin/env bash
# 1.初始化远程仓库
mkdir -p /root/project/hexo/remote && cd /root/project/hexo/remote
git init --bare

# 2.初始化远程本地仓库
mkdir -p /root/project/hexo/local && cd /root/project/hexo/local
git clone /root/project/hexo/remote

# 3.服务器远程仓库设置hook
cd /root/project/hexo/remote/hooks && touch post-update

echo '#!/bin/sh' >> post-update
echo 'unset GIT_DIR' >> post-update
echo 'cd /root/project/hexo/local/remote' >> post-update
echo 'git pull origin master' >> post-update
echo "ps -ef | grep 'hexo' |grep -v grep|awk '{print \$2}'|xargs kill -9" >> post-update
echo 'nohup hexo s' >> post-update
echo '部署完成' >> post-update
echo 'exit' >> post-update
chmod +x post-update
