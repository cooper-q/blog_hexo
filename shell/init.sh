#!/usr/bin/env bash
# 删除仓库
rm -rf /root/project/hexo
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
echo 'cd /root/project/hexo/deployment/local/remote' >> post-update
echo 'git pull' >> post-update
echo '/bin/sh /root/project/hexo/local/remote/shell/reload.sh' >> post-update
