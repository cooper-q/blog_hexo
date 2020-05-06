#!/usr/bin/env bash
# 添加一个githook 并提交至githook服务器进行部署
echo ''>>git_hook
git commit -am '部署'
echo '开始部署腾讯云服务器'
git push tx master
echo '开始部署境外vps'
git push cc master
echo '部署结束'

