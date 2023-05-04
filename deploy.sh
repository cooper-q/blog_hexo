#!/usr/bin/env bash
version=`cat ./git_hook|awk -F "[.]" '{print $3}'`
version=`expr ${version} + 1`
echo v0.0.${version} > git_hook
echo v0.0.${version}
git commit -am '部署'
ssh ma <./shell/reload.sh
