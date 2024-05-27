#!/usr/bin/python3
# -*- coding: utf-8 -*-

# 获取项目中未国际化的文本
import sys
import os
import re
import xlwt
import time
import uuid

ezxf = xlwt.easyxf

PROJECT_ROOT = './'
# 各模块LocalizedPath路径
SALocalizedPath = './SuperApp/Classes/Master/Manager/MultiLanguage/Resource/SALocalizedResource.bundle'
WMLocalizedPath = './SuperApp/Classes/YumNow/Manager/MultiLanguage/Resource/WMLocalizedResource.bundle'
TNLocalizedPath = './SuperApp/Classes/TinhNow/Manager/MultiLanguage/Resource/TNLocalizedResource.bundle'
PNLocalizedPath = './SuperApp/Classes/PayNow/Manager/MultiLanguage/Resource/PayLocalizedResource.bundle'

ExcelDir = './LocalizedExcel'
SAExcelName = './LocalizedExcel/sa.xls'
WMExcelName = './LocalizedExcel/wm.xls'
TNExcelName = './LocalizedExcel/tn.xls'
PNExcelName = './LocalizedExcel/pn.xls'

SALocalizedString = "SALocalizedString(@\"\""
WMLocalizedString = "WMLocalizedString(@\"\""
TNLocalizedString = "TNLocalizedString(@\"\""
PNLocalizedString = "PNLocalizedString(@\"\""

SAOldLocalizedDict = {}
WMOldLocalizedDict = {}
TNOldLocalizedDict = {}
PNOldLocalizedDict = {}

SANewLocalizedArray = []
WMNewLocalizedArray = []
TNNewLocalizedArray = []
PNNewLocalizedArray = []

def isChinese(string):
    for ch in string:
        if u'\u4e00' <= ch <= u'\u9fff':
            return True
    return False

def short_uuid(name):
    uuidChars = ("a", "b", "c", "d", "e", "f",
       "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",
       "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5",
       "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I",
       "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
       "W", "X", "Y", "Z")
    uuidStr = str(uuid.uuid3(uuid.NAMESPACE_DNS, name)).replace('-', '')
    result = ''
    for i in range(0,8):
        sub = uuidStr[i * 4: i * 4 + 4]
        x = int(sub,16)
        result += uuidChars[x % 0x3E]
    return result

def localizedKey(placeholder, old, new):
    key = old.get(placeholder)
    if key is None:
        defaultKey = short_uuid(placeholder)
        old[placeholder] = defaultKey
        dict = {"key": defaultKey}
        if isChinese(placeholder):
            dict["cn"] = placeholder
        else:
            dict["en"] = placeholder
        new.append(dict)
        return defaultKey
    else:
        return key

def changeLine(line, findStr, old, new):
    index = line.find(findStr)
    pattern = re.compile(r'"(.*?)"')
    placeholder = pattern.findall(line, index + len(findStr))[0]
    key = localizedKey(placeholder, old, new)
    line = line.replace(findStr, findStr[0:len(findStr)-1] + key + "\"", 1)
    return line

def findAndChangeLine(line):
    if line.find(SALocalizedString) >= 0:
        return findAndChangeLine(changeLine(line, SALocalizedString, SAOldLocalizedDict, SANewLocalizedArray))
    elif line.find(WMLocalizedString) >= 0:
        return findAndChangeLine(changeLine(line, WMLocalizedString, WMOldLocalizedDict, WMNewLocalizedArray))
    elif line.find(TNLocalizedString) >= 0:
        return findAndChangeLine(changeLine(line, TNLocalizedString, TNOldLocalizedDict, TNNewLocalizedArray))
    elif line.find(PNLocalizedString) >= 0:
        return findAndChangeLine(changeLine(line, PNLocalizedString, PNOldLocalizedDict, PNNewLocalizedArray))
    else: 
        return line

def readfile(file_path):
    f = open(file_path,"r+")
    new = []
    for line in f:
        new.append(findAndChangeLine(line))

    # 重写文件
    f.seek(0)
    for n in new:
        f.write(n)
    f.close()

def findfile(startdir):
    for dir_path, subdir_list, file_list in os.walk(startdir):
        # 可以在这里设置过滤不相关目录
        if not(dir_path.find("Pods") > -1 or dir_path.find(".git") > -1 or dir_path.find(".gitee") > -1 or dir_path.find(".svn") > -1 or dir_path.endswith('lproj') or dir_path.endswith('xcassets')):
            for fname in file_list:
                if fname.lower().endswith(".m"):
                    full_path = os.path.join(dir_path, fname)
                    readfile(full_path)

def loadLocalized(path,dict):
    f = open(path, "r", encoding='utf-16')
    for line in f:
        line = line.strip().strip(";")
        array = line.split(" = ")
        if len(array) == 2:
            dict[array[1].replace("\"", "")] = array[0].replace("\"", "")
    f.close()

def loadOldLocalized():
    loadLocalized(SALocalizedPath + "/zh-CN.lproj/Localizable.strings", SAOldLocalizedDict)
    loadLocalized(SALocalizedPath + "/en-US.lproj/Localizable.strings", SAOldLocalizedDict)
    loadLocalized(WMLocalizedPath + "/en-US.lproj/Localizable.strings", WMOldLocalizedDict)
    loadLocalized(WMLocalizedPath + "/zh-CN.lproj/Localizable.strings", WMOldLocalizedDict)
    loadLocalized(TNLocalizedPath + "/en-US.lproj/Localizable.strings", TNOldLocalizedDict)
    loadLocalized(TNLocalizedPath + "/zh-CN.lproj/Localizable.strings", TNOldLocalizedDict)
    loadLocalized(PNLocalizedPath + "/en-US.lproj/Localizable.strings", PNOldLocalizedDict)
    loadLocalized(PNLocalizedPath + "/zh-CN.lproj/Localizable.strings", PNOldLocalizedDict)
    
def mkdir(path):
    path=path.strip()
    path=path.rstrip("\\")
    isExists=os.path.exists(path)
 
    if not isExists:
        os.makedirs(path) 
        return True
    else:
        return False

def arrayWriteExcel(array, excelName):
    # 创建一个workbook 设置编码
    workbook = xlwt.Workbook(encoding = 'utf-8')
    # 创建一个worksheet
    worksheet = workbook.add_sheet('LocalizedString')

    read_only = ezxf("protection: cell_locked true;align: horz center,vert center;")  # 不可編輯,horz center:水平居中,vert center:垂直居中

    # 写入excel
    # 参数对应 行, 列, 值
    worksheet.write(0, 0, label = 'key', style=read_only)
    worksheet.write(0, 1, label = 'cn', style=read_only)
    worksheet.write(0, 2, label = 'en', style=read_only)
    worksheet.write(0, 3, label = 'kh', style=read_only)
    worksheet.col(0).width = 5000
    worksheet.col(1).width = 15000
    worksheet.col(2).width = 15000
    worksheet.col(3).width = 15000

    for index in range(len(array)):
        dict = array[index]
        worksheet.write(index + 1, 0, label = dict["key"], style=read_only)
        worksheet.write(index + 1, 1, label = dict.get("cn", ""))
        worksheet.write(index + 1, 2, label = dict.get("en", ""))
        worksheet.write(index + 1, 3, label = "")
        tall_style = xlwt.easyxf('font:height 720;')
        worksheet.row(index + 1).set_style(tall_style)

    # 保存
    mkdir(ExcelDir)
    localtime = time.strftime("%Y%m%d%H%M%S", time.localtime())
    workbook.save(excelName[0:len(excelName)-4] + localtime + ".xls")

def writeExcel():
    arrayWriteExcel(SANewLocalizedArray, SAExcelName)
    arrayWriteExcel(WMNewLocalizedArray, WMExcelName)
    arrayWriteExcel(TNNewLocalizedArray, TNExcelName)
    arrayWriteExcel(PNNewLocalizedArray, PNExcelName)


loadOldLocalized()
findfile(PROJECT_ROOT)
writeExcel()
