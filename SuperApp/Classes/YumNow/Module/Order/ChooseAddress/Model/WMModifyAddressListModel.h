//
//  WMModifyAddressListModel.h
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMModifyAddressListModel : WMRspModel
///增加配送时间
@property (nonatomic, assign) NSInteger addDeliveryTime;
///聚合订单号
@property (nonatomic, copy) NSString *aggregateNo;
///提交时间
@property (nonatomic, assign) NSTimeInterval createTime;
/// deliveryPrice
@property (nonatomic, strong) SAMoneyModel *deliveryPrice;
/// oldDeliveryPrice
@property (nonatomic, strong) SAMoneyModel *oldDeliveryPrice;
///原配送地址
@property (nonatomic, copy) NSString *oldReceiverAddress;
///原收货人纬度
@property (nonatomic, strong) NSNumber *oldReceiverLat;
///原收货人经度
@property (nonatomic, strong) NSNumber *oldReceiverLon;
///原收货人姓名
@property (nonatomic, copy) NSString *oldReceiverName;
///原收货人电话
@property (nonatomic, copy) NSString *oldReceiverPhone;
///订单号
@property (nonatomic, copy) NSString *orderNo;
/// payPrice
@property (nonatomic, strong) SAMoneyModel *payPrice;
/// paymentMethod
@property (nonatomic, assign) SAOrderPaymentType paymentMethod;
///支付流水號
@property (nonatomic, copy) NSString *paymentNo;
///支付状态, 10: 未付款, 20: 已付款
@property (nonatomic, assign) WMModifyOrderPayType paymentState;
///配送地址
@property (nonatomic, copy) NSString *receiverAddress;
///原收货人性别, M: 男性, F: 女性
@property (nonatomic, copy) SAGender receiverGender;
///原收货人性别, M: 男性, F: 女性
@property (nonatomic, copy) SAGender oldReceiverGender;
///收货人纬度
@property (nonatomic, strong) NSNumber *receiverLat;
///收货人经度
@property (nonatomic, strong) NSNumber *receiverLon;
///收货人姓名
@property (nonatomic, copy) NSString *receiverName;
///收货人电话
@property (nonatomic, copy) NSString *receiverPhone;
///剩余支付时间（秒）
@property (nonatomic, assign) NSInteger remainingPaymentTime;
///修改状态, 10: 修改成功, 11: 修改中, 12: 修改取消
@property (nonatomic, assign) WMModifyOrderType status;
///修改到终态的时间（成功、失败）
@property (nonatomic, assign) NSTimeInterval updateToEndTime;
///退款状态
@property (nonatomic, assign) WMOrderDetailRefundState refundState;
///商户号
@property (nonatomic, copy) NSString *merchantNo;
/// storeNo
@property (nonatomic, copy) NSString *storeNo;
@end

NS_ASSUME_NONNULL_END
