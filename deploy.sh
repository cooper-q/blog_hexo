#!/usr/bin/env bash
version=`cat ./git_hook|awk -F "[.]" '{print $3}'`
version=`expr ${version} + 1`
echo v0.0.${version} > git_hook
echo v0.0.${version}
git commit -am '部署'
ssh ma <./shell/reload.sh

# 添加一个githook 并提交至githook服务器进行部署

#version=`cat ./git_hook|awk -F "[.]" '{print $3}'`
#version=`expr ${version} + 1`
#echo v0.0.${version} > git_hook
#echo v0.0.${version}
#git commit -am '部署'
#if [[ -z "$1" ]]
#then
#    echo '开始部署腾讯云服务器'
#    git push tx master
#elif [[ "$1" = "cc" ]]
#then
#    echo '开始部署境外vps'
#    git push cc master
#else
#    echo '参数错误'
#fi
#echo '部署结束'

