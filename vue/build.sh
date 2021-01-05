#!/usr/bin/env bash

#author: huahui.wu
#E-mail: gayhub@live.cn

clear
echo

# 代码拉去路径
clone_path="/app/web"

# 静态文件位置
web_path="/app/tmp/web"

# 默认构建环境
evn="prod"

# 代码仓库地址
svn_address="https://192.168.158.242/svn/web2/code/SupplyChain"

# 模块名称
model=""

# 模块路径
model_path=""

# 设置展示颜色
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

clone_code_model(){
    svn co ${svn_address}/${2}
    echo && echo -e "${Info} 成功拉取 ${1} 代码....."
}

## 拉取代码 ${1}：模块 wms admin agent data mall
clone_code(){
    echo " "
    echo && echo -e "${Tip} 开始拉取 ${1} 代码....."
    echo " "
    cd ${clone_path}
    if [[ ${1} == "wms" ]]; then
        model="wms"
    elif [[ ${1} == "admin" ]]; then
        model="mro-Admin"
    elif [[ ${1} == "agent" ]]; then
        model="mro-admin-dls"
    elif [[ ${1} == "data" ]]; then
        model="mro-full-screen"
    else
        echo && echo -e "${Tip} ${1} 该模块不需要构建 谢谢！"
    fi
    # 执行拉去代码
    clone_code_model ${1} ${model}
}

## 构建代码  ${1}：模块 ${2}：环境
build_code(){
    echo && echo -e "${Tip} 开始构建 ${1} 模块....."

    cd ${clone_path}/${model}

    rm -rf ${clone_path}/${model}/dist

    # yarn install
    install_logs=`yarn install 2>&1`
    if [[ "$install_logs | tail -1" == *Done* ]];  then
        echo && echo -e "${Info} yarn install 成功....."
    else
        echo && echo -e "${Error} yarn install 失败....."
        echo "失败日志如下："
        echo ${install_logs} && exit 1
    fi

    # yarn run build
    echo " "
    build_logs=`yarn run build:${2} --report 2>&1`
    if [[ "$build_logs | tail -1" == *Done* ]];  then
        echo && echo -e "${Info} 构建 ${1} 模块 成功....."
    else
        echo && echo -e "${Error} 构建 ${1} 模块 失败....."
        echo "失败日志如下："
        echo ${build_logs} && exit 1
    fi

}

# 备份旧版本
backups_old_code(){
    echo " "
}

# 复制代码文件   ${1}：模块 ${2}：model
copy_code_model(){
    echo && echo -e "${Tip} 开始复制 ${1} 模块静态文件....."
    # 先创建文件夹，如果不存在的话
    mkdir -p ${web_path}/${1}
    # 删除原文件内容
    rm -rf ${web_path}/${1}/*
    # 移动最新前端文件到web目录
    cp -a ${clone_path}/${2}/* ${web_path}/${1}/
    echo && echo -e "${Info} 成功复制 ${1} 模块静态文件....."
}

# 复制代码
copy_code(){
    if [[ ${1} == "wms" ]]; then
        copy_code_model ${1} "${model}/dist"
    elif [[ ${1} == "admin" ]]; then
        copy_code_model ${1} ${model}
    elif [[ ${1} == "agent" ]]; then
        copy_code_model ${1} ${model}
    elif [[ ${1} == "data" ]]; then
        copy_code_model ${1} "${model}/dist"
    fi
}


# 启动 wms admin agent data mall
build(){

    for loop in $*
    do
        if [[ ${loop} == "prod" || ${loop} == "sit" ]]; then
            evn=${loop}
            echo && echo -e "${Info} 检测到打包环境为：${Red_font_prefix}${evn}${Red_font_prefix}"
        else
            # 拉取代码
            clone_code ${loop}
            # 构建编译代码
            build_code ${loop} ${evn}
            # 复制代码到 web 目录下
            copy_code ${loop}
        fi

    done
}

echo
echo "*******编译开始********"
# 入口
build $*
echo
echo "*******编译结束********"