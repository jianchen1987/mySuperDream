//
//  WMModifyAddressPopModel.h
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressModel.h"
#import "WMModifyFeeModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMModifyAddressPopModel : WMRspModel
/// custom
/// oldAddress
@property (nonatomic, strong) SAShoppingAddressModel *oldAddress;
/// newAddress
@property (nonatomic, strong) SAShoppingAddressModel *neAddress;
/// feeModel
@property (nonatomic, strong) WMModifyFeeModel *feeModel;
///实付金额
@property (nonatomic, strong) SAMoneyModel *actualAmount;
///旧配送费
@property (nonatomic, strong) SAMoneyModel *oldDeliveryFee;
///支付方式
@property (nonatomic, assign) SAOrderPaymentType paymentMethod;
/// 支付方式国际化
@property (nonatomic, copy) NSString *paymentMethodStr;
@end

NS_ASSUME_NONNULL_END
