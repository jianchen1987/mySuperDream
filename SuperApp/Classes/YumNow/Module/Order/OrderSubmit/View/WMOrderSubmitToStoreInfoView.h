//
//  WMOrderSubmitToStoreInfoView.h
//  SuperApp
//
//  Created by Tia on 2023/8/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "HDPaymentMethodType.h"

@class WMOrderSubscribeTimeModel;
@class WMOrderSubmitAggregationRspModel;


NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitToStoreInfoView : SAView

@property (nonatomic, copy) NSString *numberTextFieldText;
/// 配送时间
@property (nonatomic, strong, readonly) WMOrderSubscribeTimeModel *subscribeTimeModel;
/// 付款方式
@property (nonatomic, strong, readonly) HDPaymentMethodType *paymentType;

/// 选择了配送时间
@property (nonatomic, copy) void (^choosedDeliveryTimeBlock)(WMOrderSubscribeTimeModel *subscribeTimeModel);

/// 更新可预约时间和可选支付方式
- (void)updateUIWithOrderPreSubmitRspModel:(WMOrderSubmitAggregationRspModel *)aggregationRspModel userHasRisk:(BOOL)userHasRisk;

@end

NS_ASSUME_NONNULL_END
