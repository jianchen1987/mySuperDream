//
//  HDTradeAmountModel.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 金额模型
 */
@interface PayHDTradeAmountModel : SAModel
@property (nonatomic, copy) NSString *cent;                                    ///< 金额/单位分，转基本数据类型可以转整型，后台类型是 long
@property (nonatomic, copy) NSString *cy;                                      ///< 币种
@property (nonatomic, copy) NSString *currencySymbol;                          ///< 币种符号
@property (nonatomic, copy) NSString *thousandSeparatorAmount;                 ///< 带千位分隔符和币种符号隔开的金额
@property (nonatomic, copy) NSString *thousandSeparatorAmountNoCurrencySymbol; ///< 无千位分隔符隔开有币种符号的金额金额
+ (instancetype)modelWithAmount:(NSString *)cent currency:(NSString *)cy;
- (instancetype)initWithAmount:(NSString *)cent currency:(NSString *)cy;
@end

NS_ASSUME_NONNULL_END
