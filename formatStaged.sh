#!/usr/bin/env bash

# 设置环境变量
export PATH=$PATH:/usr/local/bin:/usr/local/sbin

# 设置 clang-format 文件
STYLE=$(git config --get hooks.clangformat.style)
if [ -n "${STYLE}" ] ; then
  STYLEARG="-style=${STYLE}"
else
  # 项目目录下寻找 .clang-format 文件
  STYLE=$(git rev-parse --show-toplevel)/.clang-format
  if [ -n "${STYLE}" ] ; then
    STYLEARG="-style=file"
  else
    STYLEARG=""
  fi
fi

format_file() {
  file="${1}"
  clang-format -i ${STYLEARG} $file
  git add $file
}

git add .

STAGE_FILES=$(git diff --cached --name-only --diff-filter=ACM -- *.h *.m *.c)
if test ${#STAGE_FILES} -gt 0
then
    echo "开始依赖检查"

	which brew &> /dev/null
    if [[ "$?" == 1 ]]; then
        echo -e "没安装homebrew! 将安装"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        exit 1
    fi

    which clang-format &> /dev/null
    if [[ "$?" == 1 ]]; then
        echo "没安装clang-format! 将安装"
        brew install clang-format
        exit 1
    fi

    for FILE in $STAGE_FILES; do
      format_file "${FILE}"
    done

    echo "clang-format 代码格式修正完毕"

else
    echo "未检测到改动的源码文件（*.h，*.m，*.c），如使用命令提交，请确保执行了 git add 目标文件 "
fi

exit 0

