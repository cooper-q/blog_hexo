#!/usr/bin/env bash
# 远端部署
export PATH='/root/.nvm/versions/node/v10.15.3/bin:/usr/bin:/root/.nvm/versions/node/v12.16.2/bin'
unset GIT_DIR
cd /root/project/blog_hexo
git reset --hard
git pull origin master
ps -ef | grep hexo |grep -v grep|awk '{print $2}'|xargs kill -9
nohup hexo s &
echo '部署完成'
