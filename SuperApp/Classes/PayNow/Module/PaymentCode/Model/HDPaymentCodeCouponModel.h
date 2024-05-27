//
//  HDPaymentCodeCouponModel.h
//  ViPay
//
//  Created by VanJay on 2019/8/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDPaymentCodeCouponModel : SAModel
@property (nonatomic, strong) SAMoneyModel *couponAmt;        ///< 优惠金额
@property (nonatomic, copy) NSString *incomeFlag;             ///< 正负
@property (nonatomic, strong) SAMoneyModel *merchantAmt;      ///< 商户金额
@property (nonatomic, strong) SAMoneyModel *platformAmt;      ///< 平台金额
@property (nonatomic, assign) HDCouponTicketSceneType origin; ///< 优惠券归属类型 10-平台券 11-商户券 12-平台+商户券
@property (nonatomic, assign) PNTradePreferentialType type;   ///< 优惠类型(优惠类型 10:立返;11:立减;12:折扣;13:折扣券;14:满减券;)
@end

NS_ASSUME_NONNULL_END
