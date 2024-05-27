//
//  SAMoneyModel.h
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 金额模型
 */
@interface SAMoneyModel : SACodingModel
@property (nonatomic, copy) NSString *cent;                                              ///< 金额/单位分，转基本数据类型可以转整型，后台类型是 long
@property (nonatomic, copy) NSString *centFace;                                          ///< 金额/单位原单位，cent 除以了 100 的值,   大部分情况下等同于Amount
@property (nonatomic, copy) SACurrencyType cy;                                           ///< 币种
@property (nonatomic, copy) NSString *currencySymbol;                                    ///< 币种符号
@property (nonatomic, copy, readonly) NSString *thousandSeparatorAmount;                 ///< 带千位分隔符和币种符号隔开的金额
@property (nonatomic, copy, readonly) NSString *thousandSeparatorAmountNoCurrencySymbol; ///< 无千位分隔符隔开有币种符号的金额金额
@property (nonatomic, copy, readonly) NSString *amount;                                  ///< 金额, 格式化显示

+ (instancetype)modelWithAmount:(NSString *)cent currency:(NSString *)cy;

- (instancetype)initWithAmount:(NSString *)cent currency:(NSString *)cy;

/// 加上一个数
/// @param addend 被加数
- (SAMoneyModel *)plus:(SAMoneyModel *_Nullable)addend;

/// 减去一个数
/// 金额没有负数，需要做负数的判断，请在业务侧实现，该方法不能用于普通数值相减，差值小于0会直接返回0
/// @param minuend 被减数
- (SAMoneyModel *)minus:(SAMoneyModel *_Nullable)minuend;

- (BOOL)isZero;

@end

NS_ASSUME_NONNULL_END
