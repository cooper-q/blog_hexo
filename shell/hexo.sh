#!/bin/sh

start(){
  echo 'start'
  cd /root/project/deployment/local/remote
  /root/.nvm/versions/node/v10.15.3/bin/hexo clean
  /usr/bin/nohup /root/.nvm/versions/node/v10.15.3/bin/hexo s &
}

stop(){
    processID=`ps -ef |grep -v grep|grep -v sh|grep hexo|awk '{print $2}'`
    bool=`echo $processID|awk '{print($0~/^[-]?([0-9])+[.]?([0-9])+$/)?"true":"false"}'`

    if [ $bool == "true" ]
    then
        kill -9 $processID
    else
        echo '服务未启动'
    fi
}
case $1 in
    start)
        start && exit 0
    ;;
    stop)
        stop && exit 0
    ;;
esac
