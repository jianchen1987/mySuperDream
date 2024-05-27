#!/usr/bin/python3
# -*- coding: utf-8 -*-

# 根据excel填充国际化文本
import sys
import os
import re
import xlrd

SALocalizedPath = './SuperApp/Classes/Master/Manager/MultiLanguage/Resource/SALocalizedResource.bundle'
WMLocalizedPath = './SuperApp/Classes/YumNow/Manager/MultiLanguage/Resource/WMLocalizedResource.bundle'
TNLocalizedPath = './SuperApp/Classes/TinhNow/Manager/MultiLanguage/Resource/TNLocalizedResource.bundle'
PNLocalizedPath = './SuperApp/Classes/PayNow/Manager/MultiLanguage/Resource/PayLocalizedResource.bundle'

chooseLocalizedPath = ''

def basisPath(localizedTpye):
    localizedTpye = localizedTpye.strip()
    if localizedTpye == "1":
        return SALocalizedPath
    elif localizedTpye == "2":
        return WMLocalizedPath
    elif localizedTpye == "3":
        return TNLocalizedPath
    elif localizedTpye == "4":
        return PNLocalizedPath
    else:
        print("==============请输入正确的参数！==============")
        sys.exit()
        return ""

def addLocalized(path, keys, values, defaultValues):
    if len(keys) != len(values) or len(keys) != len(defaultValues):
        print("==============获取翻译数组错误==============")
        sys.exit()
    f = open(path, "a", encoding='utf-16')
    f.write('\n')
    for index in range(len(keys)):
        key = keys[index]
        value = values[index]
        if len(value.strip()) == 0:
            value = defaultValues[index]
        f.write(r'"%s" = "%s";' % (key, value))
        f.write('\n')
    f.close()

def openExcel(path):
    path=path.strip()
    path=path.rstrip("\\")
    workBook = xlrd.open_workbook(r''+path)
    sheet = workBook.sheet_by_index(0)

    allKeys = sheet.col_values(0)
    allCns = sheet.col_values(1)
    allEns = sheet.col_values(2)
    allKhs = sheet.col_values(3)

    del allKeys[0]
    del allCns[0]
    del allEns[0]
    del allKhs[0]

    addLocalized(chooseLocalizedPath + "/zh-CN.lproj/Localizable.strings", allKeys, allCns, allEns)
    addLocalized(chooseLocalizedPath + "/en-US.lproj/Localizable.strings", allKeys, allEns, allEns)
    addLocalized(chooseLocalizedPath + "/km-KH.lproj/Localizable.strings", allKeys, allKhs, allEns)

chooseLocalizedPath = basisPath(input("请选择所属: 1、SA  2、WM  3、TN  4、PN "))
excelPath = input("请输入已翻译的excel文件地址：")
openExcel(excelPath)
