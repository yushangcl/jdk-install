#!/bin/bash

# author:HuaHui.wu
# date:2020-12-11
# department:供应链仓储日志压缩

# 设置展示颜色
# shellcheck disable=SC2034
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Red_font_prefix}[注意]${Red_font_prefix}"

logPath="/app/scs/logs"

# shellcheck disable=SC2034
# shellcheck disable=SC2010
fileDirList=$(ls $logPath -1 -c |grep "scs-*")

echo ""
echo ""
# shellcheck disable=SC2046
echo $(date '+%Y-%m-%d %H:%M:%S')" 打包程序执行开始！"

#echo "开始打包从天前截止昨天的日志(如本周日打包上周日到上周六的日志)!"

# shellcheck disable=SC2043
for fileDir in $fileDirList; do
  echo -e "${Tip} 执行打包${fileDir}模块"
  sh pack.sh $logPath/tar/$fileDir $logPath/$fileDir;
done

echo ""
# shellcheck disable=SC2046
echo $(date '+%Y-%m-%d %H:%M:%S')" 打包程序执行结束！"
