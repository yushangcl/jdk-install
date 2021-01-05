#!/bin/bash

sc_key=SCU25876T56c16e4fd034f006d118398111e5320c5aebc6bc2ced6

get_content(){
  echo '```' && echo ""
   while read line
    do
    echo $line
    done  < logs/upload.log
   echo "" && echo '```'
   echo "" && echo "任务结束"
  # shellcheck disable=SC2006
  github=`cat logs/github.log`
  content=$github
  echo $content

}
send_msg(){
  sleep 1s
  get_content
  curl -H "Content-type: application/x-www-form-urlencoded" -X POST --data "text=Github部分软件备份&desp=$content" https://sc.ftqq.com/$sc_key.send >logs/msg.log 2>&1 &
  echo "发生通知成功"
}

send_msg
