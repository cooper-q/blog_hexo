#!/bin/sh
unset GIT_DIR
cd /root/project/deployment/local/remote
git reset --hard
git pull origin master
source ~/.zshrc
hexo clean
ps -ef | grep "hexo" |grep -v grep|awk '{print $2}'|xargs kill -9
nohup hexo s &
