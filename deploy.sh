#!/usr/bin/env bash
# 添加一个githook 并提交至githook服务器进行部署
echo ''>>git_hook
git commit -am '部署'
if [[ !-z $1 ]]
then
    echo '参数错误'
    exit 0;
elif [[ "$1" = "tx"  ]]
then
    echo '开始部署腾讯云服务器'
    git push tx master
elif [ $1 = cc ]
then
    echo '开始部署境外vps'
    git push cc master
else
    echo '参数错误'
fi
echo '部署结束'

