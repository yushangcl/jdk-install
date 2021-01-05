#!/bin/bash

# 设置展示颜色
# shellcheck disable=SC2034
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[注意]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 基本路径
base_url="/home/app/github"
repos=$*
already_exist=0
index=0

get_latest_release() {
  version=$(curl -s -u 6mb:8db2600fe742fc82d073de224c10335f2a4ac4b5 https://api.github.com/repos/$1/releases/latest |
    grep "tag_name.*" |
    cut -d ":" -f 2,3 |
    tr -d \")
  version=${version%?}
  # shellcheck disable=SC2116
  version=$(echo $version)
  echo -e "[信息] 检测到 $repo 最新版本：$version"
}

download_latest_release() {
  echo -e "[信息] 开始下载 $repo 最新版本：$version"
  # shellcheck disable=SC2155
  # shellcheck disable=SC2006
  local start_date=`date +'%Y-%m-%d %H:%M:%S'`

  curl -s -u 6mb:8db2600fe742fc82d073de224c10335f2a4ac4b5 https://api.github.com/repos/$1/releases/latest |
    grep "browser_download_url.*" |
    cut -d ":" -f 2,3 |
    tr -d \" |
    wget -qi -

  # shellcheck disable=SC2046
  # shellcheck disable=SC2006
  if [ `ls | wc -w` -eq  0 ]; then
      # shellcheck disable=SC2119
      download_latest_code $1
  fi

  # shellcheck disable=SC2155
  # shellcheck disable=SC2006
  local end_date=`date +'%Y-%m-%d %H:%M:%S'`
  # shellcheck disable=SC2155
  local start_seconds=$(date --date="$start_date" +%s);
  # shellcheck disable=SC2155
  local end_seconds=$(date --date="$end_date" +%s);
  # shellcheck disable=SC2006
  echo -e "[信息] 结束下载 $repo 最新版本：$version 成功。数量：`ls | wc -w`，耗时：$((end_seconds-start_seconds))秒"

  ((index++))
}

# shellcheck disable=SC2120
download_latest_code() {
   curl -s -u 6mb:8db2600fe742fc82d073de224c10335f2a4ac4b5 https://api.github.com/repos/$1/releases/latest |
    grep "zipball_url.*" |
    cut -d ":" -f 2,3 |
    tr -d \" |
    tr -d , |
    wget -qi -

    mv $version ${1////-}-$version.zip
    echo -e "[信息] 下载源码 $repo 最新版本：$version 成功。数量：`ls | wc -w`"
}

mkdir_releases(){
  if [ ! -d "$base_url/app/$1/" ];then
    echo "[信息] $1 仓库不存在，创建"
    mkdir -p $base_url/app/$1
  else
    echo "[注意] $1 仓库已存在，跳过"
  fi
  # shellcheck disable=SC2164
  cd $base_url/app/$1
}

mkdir_version(){
  # 判断该版本是否已经拉取
  if [ ! -d "$base_url/app/$repo/$version/" ];then
    echo "[信息] $version 版本不存在，创建"
    mkdir  $version
    # shellcheck disable=SC2164
    cd $version
    else
    # 判断一下是否存在文件
    # shellcheck disable=SC2164
    cd $version
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    if [ `ls | wc -w` -gt  0 ]; then
      echo "[注意] $version 版本已存在，跳过"
      already_exist=1
    fi
  fi

}



# 执行方法入口
# shellcheck disable=SC2006
start_date_all=`date +'%Y-%m-%d %H:%M:%S'`
echo "获取到配置："

for element in ${repos[*]}; do
echo - $element
done

echo "" && echo "执行下载日志："
# shellcheck disable=SC2016
echo '```'
for repo in ${repos[*]}; do
  echo "-------------------------------------------"
  echo -e "[信息] 开始检查 $repo 最新版本"
  # 创建 github 用户 + 仓库目录
  mkdir_releases $repo
  # 获取最新的版本
  get_latest_release $repo
  # 创建最新版本目录
  mkdir_version
  # 下载最新release
  if [ $already_exist -eq 0 ]; then
      download_latest_release $repo
  fi
  already_exist=0
  echo "$repo 结束"
  echo ""
done
# shellcheck disable=SC2016
echo '```'

# shellcheck disable=SC2155
# shellcheck disable=SC2006
  end_date_all=`date +'%Y-%m-%d %H:%M:%S'`
# shellcheck disable=SC2155
  start_seconds_all=$(date --date="$start_date_all" +%s);
# shellcheck disable=SC2155
  end_seconds_all=$(date --date="$end_date_all" +%s);
# shellcheck disable=SC2006
  echo -e "结束备份，本次备份数量：$index，耗时：$((end_seconds_all-start_seconds_all))秒"
  echo "" && echo "-------------------------------------------"
  echo "" && echo "执行上传日志"
# shellcheck disable=SC2164
  cd $base_url
  rm -rf logs/upload.log
# 执行同步
  sh upload.sh $base_url/app
# 发生通知
  sh msg.sh