//
//  WMModifyAddressSubmitOrderModel.h
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "SAShoppingAddressModel.h"
#import "WMEnum.h"
#import "WMModifyFeeModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMModifyAddressSubmitOrderPayModel;


@interface WMModifyAddressSubmitOrderModel : WMRspModel
/// orderNo
@property (nonatomic, copy) NSString *orderNo;
/// paymentMethod
@property (nonatomic, assign) SAOrderPaymentType paymentMethod;
///订单状态, 10: 修改成功, 11: 修改中, 12: 修改取消
@property (nonatomic, assign) WMModifyOrderType status;
///支付model
@property (nonatomic, strong) WMModifyAddressSubmitOrderPayModel *payOrderResp;

@end


@interface WMModifyAddressSubmitOrderPayModel : WMRspModel
/// actualPayAmount
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
/// businessNo
@property (nonatomic, copy) NSString *businessNo;
/// couponOrderNo
@property (nonatomic, copy) NSString *couponOrderNo;
/// firstMerchantNo
@property (nonatomic, copy) NSString *firstMerchantNo;
/// merchantNo
@property (nonatomic, copy) NSString *merchantNo;
/// orderNo
@property (nonatomic, copy) NSString *orderNo;
/// outPayOrderNo
@property (nonatomic, copy) NSString *outPayOrderNo;
/// totalPayableAmount
@property (nonatomic, strong) SAMoneyModel *totalPayableAmount;

@end

NS_ASSUME_NONNULL_END
