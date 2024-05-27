//
//  SAMoneyTools.h
//  SuperApp
//
//  Created by VanJay on 2020/4/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAMoneyTools : NSObject

/// 元转分
/// @param yuan 金额 （元)
+ (NSString *__nonnull)yuanTofen:(NSString *__nonnull)yuan;

/// 分转元
/// @param fen 金额（分）
+ (NSString *__nonnull)fenToyuan:(NSString *__nonnull)fen;

/// 根据货币代码获取货币符号
/// @param code 货币代码
+ (NSString *__nullable)getCurrencySymbolByCode:(NSString *__nonnull)code;

/// 返回千分符分割的金额字符串，带货币符号
/// @param yuan 金额 (元)
/// @param code 货币代码
+ (NSString *)thousandSeparatorAmountYuan:(NSString *)yuan currencyCode:(NSString *)code;

/// 返回千分符分割的金额字符串，不带货币符号
/// @param yuan 金额（元）
/// @param code 货币代码
+ (NSString *)thousandSeparatorNoCurrencySymbolWithAmountYuan:(NSString *)yuan currencyCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
