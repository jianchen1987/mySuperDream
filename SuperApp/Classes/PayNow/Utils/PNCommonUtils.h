//
//  PNCommonUtils.h
//  National Wallet
//
//  Created by 陈剑 on 2018/4/25.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "HDReachability.h"
#import "PNEnum.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PNCommonUtils : NSObject
/**
 获取当前的网络类型

 @return 网络类型
 */
+ (NSString *)getCurrentNetworkType;

/**
 获取运营商名称
 */
+ (NSString *)getCurrentCarrierName;

/**
 获取日期字符串

 @param date 日期
 @return 字符串
 */
+ (NSString *)getyyyyMMddhhmmss:(NSDate *)date;

+ (NSString *)getDateStrByFormat:(NSString *)format withDate:(NSDate *)date;

/// 比较两个时间的时间间隔【单位是 天】
+ (NSInteger)getDiffenrenceByDate1:(NSString *)date1Str date2:(NSString *)date2Str;
/**
 获取日期跟现在的相差天数
 @param date 指定日期
 @return 相差天数
 */
+ (NSInteger)getDiffenrenceByDate:(NSString *)date;

+ (NSInteger)getDiffenrenceYearByDate:(NSDate *)date;
+ (NSInteger)getDiffenrenceYearByDate:(NSString *)date1Str date2:(NSString *)date2Str;
///针对年龄
+ (NSInteger)getDiffenrenceYearByDate_age:(NSString *)date1Str date2:(NSString *)date2Str;
/**
 获取日期跟现在的相差秒数

 @param date 指定日期
 @return 秒数
 */
+ (NSInteger)getDiffenrenceMinByDate:(NSDate *)date;

/**
 获取16位随机数

 @return 随机数
 */
+ (NSString *)getRandomKey;

/**
 通过货币代码获取货币名称

 @param code 货币代码
 @return 名称
 */
+ (NSString *)getCurrenceNameByCode:(NSString *)code;

/**
 通过交易类型代码获取交易类型名称

 @param code 代码
 @return 名称
 */
+ (NSString *)getTradeTypeNameByCode:(PNTransType)code;

+ (NSString *)getSubTradeTypeNameByCode:(PNTradeSubTradeType)code;

/// 获取账户等级名称
/// @param level 账户等级
+ (NSString *)getAccountLevelNameByCode:(PNUserLevel)level;
/// 根据升级状态获取 对应的 文案
+ (NSString *)getAccountUpgradeStatusNameByCode:(PNAccountLevelUpgradeStatus)status;
/// 获取账户等级icon
+ (NSString *)getAccountLevelIconByCode:(PNUserLevel)level;
/// 根据code 获取对应的 证件类型名字
+ (NSString *)getCardTypeNameByCode:(PNPapersType)type;
/// 根据code 获取对应的 升级状态名字
+ (NSString *)getUpgradeStatusNameByCode:(PNAccountLevelUpgradeStatus)status;
/// 根据code 获取对应的 性别名字
+ (NSString *)getGenderNameByCode:(PNSexType)type;

/**
 加密密码

 @param pwd 明文
 @param loginName 登录名
 @return 密文
 */
+ (NSString *)getSecretTextForPwd:(NSString *)pwd LoginName:(NSString *)loginName;

/**
 对字符串脱敏

 @param ori 原文
 @return 密文
 */
+ (NSString *)deSensitiveString:(NSString *)ori;
/// 针对姓名
+ (NSString *)deSensitiveWithName:(NSString *)name;
/**
 根据货币代码返回货币符号

 @param code 代码
 @return 符号
 */
+ (NSString *)getCurrencySymbolByCode:(NSString *)code;

/**
 根据币种拿小数点位数

 @param code 币种
 @return 小数点位数
 */
+ (NSInteger)getAmountDecimalsCountByCurrency:(NSString *)code;

/**
 按格式返回当前时间字符串

 @param format 时间格式
 @return 字符串
 */
+ (NSString *)getCurrentDateStrByFormat:(NSString *)format;

/**
 根据证件代码返回证件名称

 @param code 证件代码
 @return 证件名称
 */
+ (NSString *)getPapersNameByPapersCode:(PNPapersType)code;

/**
 根据性别代码返回性别字符串

 @param code 代码
 @return 字符串
 */
+ (NSString *)getSexBySexCode:(PNSexType)code;

+ (NSString *)getStatusByCode:(PNOrderStatus)code;

+ (NSString *)getAccountNameByCode:(NSString *)code;

+ (NSString *)yuanTofen:(NSString *)yuan;
+ (NSString *)fenToyuan:(NSString *)fen;

/**
 转为千分符分割

 @param amount 原始金额(分)
 @return 千分符分割字符串
 */
+ (NSString *)thousandSeparatorAmount:(NSString *)amount currencyCode:(NSString *)code;
+ (NSString *)thousandSeparatorNoCurrencySymbolWithAmount:(NSString *)amount currencyCode:(NSString *)code;

/**
 判断闰年

 @param year 指定年份
 @return YES 闰年
 */
+ (BOOL)isLeapYear:(NSInteger)year;

+ (NSInteger)getDayByMonth:(NSInteger)month Year:(NSInteger)year;

+ (BOOL)isDate:(NSString *)date withFormat:(NSString *)format;
+ (void)setNetworkType:(NSString *)type;

+ (NSDate *)getNewDateByDay:(NSInteger)day Month:(NSInteger)month Year:(NSInteger)year fromDate:(NSDate *)from;

/**
 手机号运营商名称获取
 @param phoneNumber 手机号
 @return  运营商名称
 */
+ (NSString *)getOperatorName:(NSString *)phoneNumber;

/**
 时间戳转时间
 @param interval 时间戳
 @param format 时间格式
 @return YYYY-MM-dd HH:mm:ss和YYYY-MM-dd hh:mm:ss的区别
 */
+ (NSString *)dateSecondToDate:(NSInteger)interval dateFormat:(NSString *)format;
+ (NSString *)dateSecondToDate:(NSInteger)interval dateFormat:(NSString *)format dateInTodayFormat:(NSString *)dateInTodayFormat;

/// 根据账单类型返回对应的账单icon名字
+ (NSString *)getBillPaymentIconCategoryName:(PNPaymentCategory)type;
/// 根据账单类型返回对应的名字
+ (NSString *)getBillCategoryName:(PNPaymentCategory)type;

/// 获取缴费状态对应的文案
+ (NSString *)getBillPayStatusName:(PNBillPaytStatus)status;

/// 获取缴费状态对应的icon - 支付结果页
+ (NSString *)getBillPayStatusResultIconName:(PNBillPaytStatus)status;

/// 获取账单详情页的状态icon
+ (NSString *)getBillOrderDetailsStattesIconName:(PNBillPaytStatus)status;

/// 获取 手续费承担方的 文案
+ (NSString *)getChargeTypeName:(PNChargeType)type;

/// 获取对应的连接
+ (NSString *)getURLWithName:(NSString *)typeName;

/// 根据type 获取对应的商户类型名称
+ (NSString *)getMerchantTypeName:(PNMerchantType)type;

/// 获取商户状态名称
+ (NSString *)getMerchantStatusName:(PNMerchantStatus)type;

/// 获取商户状态名称 - 【跟上面的国际化的描述不一样】
+ (NSString *)getMerchantStatusName2:(PNMerchantStatus)type;

/// 国际转账 根据状态获取对应的文案
+ (NSString *)getInterTransferOrderStatus:(PNInterTransferOrderStatus)status;

/// 获取公寓缴费状态名字
+ (NSString *)getApartmentStatusName:(PNApartmentPaymentStatus)status;

/// 获取红包 状态
+ (NSString *)packetStatusName:(PNPacketMessageStatus)status;

/// 获取红包领取 状态
+ (NSString *)packetReceiveStatusName:(PNPacketReceiveStatus)status;

/// 获取担保交易状态名称
+ (NSString *)getGuarateenStatusName:(PNGuarateenStatus)status;

#pragma mark 获取纯数字
+ (int)getnum:(NSString *)str;

///为url后面拼接上时间搓
+ (NSString *)urlWithTime:(NSString *)url;

/// 商户服务 基本信息 的商户状态
+ (NSString *)getMerchantInfoStatus:(NSInteger)status;

/// 根据类型获取公告
+ (NSString *)getNotifiView:(PNWalletListItemType)type;

/// 返回钱包明细筛选的枚举名称
+ (NSString *)getWalletOrderListFilterTypeName:(PNWalletListFilterType)type;
@end
