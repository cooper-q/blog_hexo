#!/usr/bin/env bash
start(){
  echo 'start'
  cd /root/project/deployment/local/remote
  /root/.nvm/versions/node/v10.15.3/bin/hexo clean
  /usr/bin/nohup /root/.nvm/versions/node/v10.15.3/bin/hexo s
}

stop(){
    ps -ef |grep -v grep|grep -v sh|grep hexo|awk '{print $2}'|xargs kill -9
}
case $1 in
    start)
        start
    ;;
    stop)
        stop
    ;;
esac
exit 0
