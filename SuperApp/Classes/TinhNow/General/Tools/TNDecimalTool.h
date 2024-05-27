//
//  TNDecimalTool.h
//  SuperApp
//
//  Created by 张杰 on 2020/10/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//  小数相关处理类  double  float会有精度问题

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNDecimalTool : NSObject

/// 返回一个NSDecimalNumber 类型
/// @param number  参数
+ (NSDecimalNumber *)toDecimalNumber:(NSString *)number;

/// 返回一个相除结果
/// @param num1 分子
/// @param num2 分母
+ (NSDecimalNumber *)decimalDividingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2;

/// 返回一个相除结果
/// @param num1 分子
/// @param num2 分母
+ (NSDecimalNumber *)stringDecimalDividingBy:(NSString *)num1 num2:(NSString *)num2;

/// 返回一个相减结果
/// @param num1 减数
/// @param num2 被减数
+ (NSDecimalNumber *)decimalSubtractingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2;

/// 返回一个相减结果
/// @param num1 减数
/// @param num2 被减数
+ (NSDecimalNumber *)stringDecimalSubtractingBy:(NSString *)num1 num2:(NSString *)num2;

/// 返回一个相乘的结果
/// @param num1 乘数1
/// @param num2 乘数2
+ (NSDecimalNumber *)decimalMultiplyingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2;

/// 返回一个相乘的结果
/// @param num1 乘数1
/// @param num2 乘数2
+ (NSDecimalNumber *)stringDecimalMultiplyingBy:(NSString *)num1 num2:(NSString *)num2;

/// 返回一个相加的结果
/// @param num1 加数1
/// @param num2 加数2
+ (NSDecimalNumber *)decimalAddingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2;

/// 返回一个相加的结果
/// @param num1 加数1
/// @param num2 加数2
+ (NSDecimalNumber *)stringDecimalAddingBy:(NSString *)num1 num2:(NSString *)num2;

/// 获取折扣   (1 - num1/num2) * 100
/// @param num1 除数
/// @param num2 被除数
+ (NSDecimalNumber *)decimslDisCountNumber:(NSString *)num1 num2:(NSString *)num2;

/// 四舍五入
/// @param number 原值
/// @param position 小数点后几位
+ (NSDecimalNumber *)roundingNumber:(NSDecimalNumber *)number afterPoint:(NSInteger)position;

@end

NS_ASSUME_NONNULL_END
