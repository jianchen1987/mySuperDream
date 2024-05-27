//
//  WMFeedBackRefundAmountModel.h
//  SuperApp
//
//  Created by wmz on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMFeedBackRefundAmountModel : WMRspModel
///退款金额
@property (nonatomic, strong) SAMoneyModel *refund;
///商品总金额
@property (nonatomic, strong) SAMoneyModel *commodityAmount;
///配送费金额
@property (nonatomic, strong) SAMoneyModel *deliveryFee;
///税费
@property (nonatomic, strong) SAMoneyModel *vat;
///包装费
@property (nonatomic, strong) SAMoneyModel *packageFee;

@end

NS_ASSUME_NONNULL_END
