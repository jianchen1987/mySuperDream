#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import os
import re
import argparse
import subprocess as t

HDCommonConstPath = os.getcwd() + '/SuperApp/Classes/Master/General/Const/SACommonConst.h'


def setDebugButtonIsEnabled(enabled):
    print('HDCommonConstPath:' + HDCommonConstPath)
    with open(HDCommonConstPath, 'r') as file:
            fileStr = file.read()
            enableFlag = 'EnableDebug 1'
            disableFlag = 'EnableDebug 0'
            if enabled:  # 打开
                print('需要打开开关，进行替换')
                fileStr = fileStr.replace(disableFlag, enableFlag, 1)
            else:
                print('需要关闭开关，进行替换')
                fileStr = fileStr.replace(enableFlag, disableFlag, 1)

            with open(HDCommonConstPath, 'w') as file:
                print("写入修改后的调试开关配置内容到 HDCommonConst.h")
                file.write(fileStr)

            if enableFlag in fileStr:
                print('写入后检查，当前状态：打开')
            elif disableFlag in fileStr:
                print('写入后检查，当前状态：关闭')


def checkIsFaslaneInstalled():
    if 'command not found' in t.getoutput('fastlane -v'):
        return False
    else:
        return True


def checkIsHomebrewInstalled():
    if 'command not found' in t.getoutput('brew -v'):
        return False
    else:
        return True


def main(args=None):
    if args.enable_debug == 'True':
        print("打包配置：⚠️ 切服按钮，打开")
        setDebugButtonIsEnabled(True)
    elif args.enable_debug == 'False':
        print("打包配置： 切服按钮，关闭")
        setDebugButtonIsEnabled(False)

    if not checkIsHomebrewInstalled():
        print('检测到 homebrew 未安装，将进行安装')
        os.system(
            '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
    else:
        print('检查到 homebrew 已安装')

    if not checkIsFaslaneInstalled():
        print('检测到 fastlane 未安装，将进行安装')
        os.system('brew cask install fastlane')
    else:
        print('检查到 fastlane 已安装')

    if args.channel == 'appstore':
        print("打包配置：appstore 生产包，将关闭切服按钮开关，设置服务器环境为生产服")
        # ibn 为 true build 号自增
        os.system('fastlane release ibn:True')
    elif args.channel == 'develop':
        print("打包配置：测试包")
        os.system('fastlane develop')
    elif args.channel == 'ad_hoc':
        print("打包配置：ad-hoc包")
        os.system('fastlane ad_hoc')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='SuperApp iOS 客户端自动化打包脚本')
    parser.add_argument('-d', '--enable_debug', type=str, choices=['True', 'False'],
                        help='是否启用 debug 模式（控制切服按钮显示、隐藏）', required=True)
    parser.add_argument('-c', '--channel', type=str, choices=[
                        'appstore', 'ad_hoc', 'develop'], help='打包渠道，appstore线上包，develop 为测试包，ad_hoc为 ad-hoc 包', required=True)
    args = parser.parse_args()
    main(args)
