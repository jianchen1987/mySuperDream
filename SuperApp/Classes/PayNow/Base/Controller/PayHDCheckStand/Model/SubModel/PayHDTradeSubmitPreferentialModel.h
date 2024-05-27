//
//  PayHDTradeSubmitPreferentialModel.h
//  customer
//
//  Created by VanJay on 2019/5/17.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 支付成功的优惠信息
 */
@interface PayHDTradeSubmitPreferentialModel : SAModel
@property (nonatomic, strong) SAMoneyModel *couponAmt;      ///< 优惠金额
@property (nonatomic, strong) SAMoneyModel *merchantAmt;    ///< 商户金额
@property (nonatomic, strong) SAMoneyModel *platformAmt;    ///< 平台金额
@property (nonatomic, copy) NSString *incomeFlag;           ///< 收益符号
@property (nonatomic, assign) PNTradePreferentialType type; ///< 优惠类型(优惠类型 10:立返;11:立减;12:折扣;13:折扣券;14:满减券;)
@property (nonatomic, copy) NSString *typeDesc;             ///< 优惠描述
@end

NS_ASSUME_NONNULL_END
