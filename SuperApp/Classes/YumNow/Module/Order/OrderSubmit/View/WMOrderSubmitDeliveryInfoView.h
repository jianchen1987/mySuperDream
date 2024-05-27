//
//  WMOrderSubmitDeliveryInfoView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class WMQueryOrderInfoRspModel;
@class WMOrderSubscribeTimeModel;
@class SAShoppingAddressModel;
@class HDPaymentMethodType;
@class WMOrderSubmitAggregationRspModel;

/// 配送信息、付款方式等
@interface WMOrderSubmitDeliveryInfoView : SAView
/// 选择地址
@property (nonatomic, copy) void (^chooseAddressBlock)(void);
/// 选择了付款方式
//@property (nonatomic, copy) void (^choosedPaymentMethodBlock)(WMOrderAvailablePaymentType paymentType);
/// 选择了配送时间
@property (nonatomic, copy) void (^choosedDeliveryTimeBlock)(WMOrderSubscribeTimeModel *subscribeTimeModel);
/// 付款方式
@property (nonatomic, strong, readonly) HDPaymentMethodType *paymentType;
/// 配送时间
@property (nonatomic, strong, readonly) WMOrderSubscribeTimeModel *subscribeTimeModel;

- (void)updateUIWithAddressModel:(SAShoppingAddressModel *)addressModel;

/// 更新可预约时间和可选支付方式
- (void)updateUIWithOrderPreSubmitRspModel:(WMOrderSubmitAggregationRspModel *)aggregationRspModel userHasRisk:(BOOL)userHasRisk;
@end

NS_ASSUME_NONNULL_END
