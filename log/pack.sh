#!/bin/bash

# author:HuaHui.wu
# date:2020-12-11
# department:供应链仓储日志压缩

# 设置展示颜色
# shellcheck disable=SC2034
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"


# 压缩文件路径
#tarPath="/app/scs/logs/tar/scs-bid"
tarPath=$1
# 文件路径
#filePath="/app/scs/logs/scs-bid"
filePath=$2
# shellcheck disable=SC2054
filePathChild=(/default /debug /error)

# 创建文件夹
mkdir -p "$tarPath"

# 筛选打包日志文件的起始日期
sevenDaysAgoDate=$(date -d "1 days ago" +%Y-%m-%d)

# 筛选打包日志文件的截止日期(此处为获取当前日期)
currentDate=$(date +%Y-%m-%d)

# 起始日期时间戳(作为日期范围对比使用)
sevenTimeStamp=$(date -d "$sevenDaysAgoDate" +%s)

# 截至日期时间戳
currentTimeStamp=$(date -d "$currentDate" +%s)

index=0
# shellcheck disable=SC2128
# shellcheck disable=SC2034
for Child in ${filePathChild[*]}; do
  # 获取当前目录下的所有文件
  fileList=$(ls $filePath$Child -1 -c)

  # 定义需要打包的数组文件
  meetConFiles=()
  for fileName in $fileList; do

    # 将日志文件名及后缀与正则表达式做对比返回yyyy-mm-dd格式的日期值(如2018-09-10)
    fileDate=$(expr "$fileName" : '.*\([0-9]\{4\}\-[0-9]\{2\}\-[0-9]\{2\}\).*.*')

    # 将日期转换为时间戳
    fileDateTimeStamp=$(date -d "$fileDate" +%s)

    # 当时间戳值不为空且大于等于起始日期小于当前日期，那么获取该日志文件
    if [ "$fileDateTimeStamp" != "" ] && [ $fileDateTimeStamp -ge $sevenTimeStamp ] && [ $fileDateTimeStamp -lt $currentTimeStamp ]; then
      meetConFiles[${#meetConFiles[*]}]="$filePath$Child/$fileName"
    fi
    ((index++))
  done

  # 符合条件的日志文件数大于0就打包压缩
  if [ "${#meetConFiles}" -gt 0 ]; then
    for fileName in $meetConFiles; do
      echo -e "${Info} 执行压缩文件：" $fileName
    done
     zip -q -r -j $tarPath$Child-$sevenDaysAgoDate.zip $meetConFiles
  else
    echo "Not found the meet condition's files!"
    exit 0
  fi
  # 清空数组
  unset meetConFiles
  unset fileList
done
