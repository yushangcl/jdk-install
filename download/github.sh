#!/bin/bash

# ����չʾ��ɫ
# shellcheck disable=SC2034
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[��Ϣ]${Font_color_suffix}"
Error="${Red_font_prefix}[ע��]${Font_color_suffix}"
Tip="${Green_font_prefix}[ע��]${Font_color_suffix}"

# ����·��
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
  echo -e "[��Ϣ] ��⵽ $repo ���°汾��$version"
}

download_latest_release() {
  echo -e "[��Ϣ] ��ʼ���� $repo ���°汾��$version"
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
  echo -e "[��Ϣ] �������� $repo ���°汾��$version �ɹ���������`ls | wc -w`����ʱ��$((end_seconds-start_seconds))��"

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
    echo -e "[��Ϣ] ����Դ�� $repo ���°汾��$version �ɹ���������`ls | wc -w`"
}

mkdir_releases(){
  if [ ! -d "$base_url/app/$1/" ];then
    echo "[��Ϣ] $1 �ֿⲻ���ڣ�����"
    mkdir -p $base_url/app/$1
  else
    echo "[ע��] $1 �ֿ��Ѵ��ڣ�����"
  fi
  # shellcheck disable=SC2164
  cd $base_url/app/$1
}

mkdir_version(){
  # �жϸð汾�Ƿ��Ѿ���ȡ
  if [ ! -d "$base_url/app/$repo/$version/" ];then
    echo "[��Ϣ] $version �汾�����ڣ�����"
    mkdir  $version
    # shellcheck disable=SC2164
    cd $version
    else
    # �ж�һ���Ƿ�����ļ�
    # shellcheck disable=SC2164
    cd $version
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    if [ `ls | wc -w` -gt  0 ]; then
      echo "[ע��] $version �汾�Ѵ��ڣ�����"
      already_exist=1
    fi
  fi

}



# ִ�з������
# shellcheck disable=SC2006
start_date_all=`date +'%Y-%m-%d %H:%M:%S'`
echo "��ȡ�����ã�"

for element in ${repos[*]}; do
echo - $element
done

echo "" && echo "ִ��������־��"
# shellcheck disable=SC2016
echo '```'
for repo in ${repos[*]}; do
  echo "-------------------------------------------"
  echo -e "[��Ϣ] ��ʼ��� $repo ���°汾"
  # ���� github �û� + �ֿ�Ŀ¼
  mkdir_releases $repo
  # ��ȡ���µİ汾
  get_latest_release $repo
  # �������°汾Ŀ¼
  mkdir_version
  # ��������release
  if [ $already_exist -eq 0 ]; then
      download_latest_release $repo
  fi
  already_exist=0
  echo "$repo ����"
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
  echo -e "�������ݣ����α���������$index����ʱ��$((end_seconds_all-start_seconds_all))��"
  echo "" && echo "-------------------------------------------"
  echo "" && echo "ִ���ϴ���־"
# shellcheck disable=SC2164
  cd $base_url
  rm -rf logs/upload.log
# ִ��ͬ��
  sh upload.sh $base_url/app
# ����֪ͨ
  sh msg.sh