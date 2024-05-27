//
//  WMOrderDetailModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMModel.h"
#import "WMOrderDetailCommodityModel.h"
#import "WMOrderDetailDeliveryInfoModel.h"
#import "WMOrderDetailReceiverModel.h"
#import "WMOrderDetailRefundInfoModel.h"
#import "WMOrderEventModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMUpdateAddressRefundInfo;


@interface WMOrderDetailModel : WMModel
/// 总共优惠的金额
@property (nonatomic, strong) SAMoneyModel *totalDiscountAmount;
/// 实付金额
@property (nonatomic, strong) SAMoneyModel *actualAmount;
/// 应付金额
@property (nonatomic, strong) SAMoneyModel *payableAmount;
/// 实际出餐时间
@property (nonatomic, copy) NSString *actualPrepareTime;
/// 实际到达时间
@property (nonatomic, copy) NSString *ata;
/// 业务状态
@property (nonatomic, assign) WMBusinessStatus bizState;
/// 是否可以申请退款
@property (nonatomic, assign) BOOL canApplyRefund;
/// 是否可以取消
@property (nonatomic, assign) BOOL canCancel;
/// 取消订单时间
@property (nonatomic, copy) NSString *cancelTime;
/// 客户编号
@property (nonatomic, copy) NSString *customerNo;
/// 派单时间
@property (nonatomic, copy) NSString *dispatchTime;
/// 服务器时间
@property (nonatomic, copy) NSString *serviceTime;
/// 预计出餐时间
@property (nonatomic, copy) NSString *estimatePrepareTime;
/// 汇率
@property (nonatomic, assign) NSUInteger exchangeRate;
/// 完成时间
@property (nonatomic, copy) NSString *finishTime;
/// 事件列表
@property (nonatomic, copy) NSArray<WMOrderEventModel *> *orderEventList;
/// 收货人信息
@property (nonatomic, strong) WMOrderDetailReceiverModel *receiver;
/// 商品项
@property (nonatomic, strong) WMOrderDetailCommodityModel *commodity;
/// 配送信息
@property (nonatomic, strong) WMOrderDetailDeliveryInfoModel *deliveryInfo;
/// 退款信息
@property (nonatomic, strong) WMOrderDetailRefundInfoModel *refundInfo;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 订单状态
@property (nonatomic, assign) WMOrderStatus orderState;
/// 下单时间
@property (nonatomic, copy) NSString *orderTime;
/// 支付时间
@property (nonatomic, copy) NSString *paymentTime;
/// 支付方式
@property (nonatomic, assign) SAOrderPaymentType paymentMethod;
/// 备注
@property (nonatomic, copy) NSString *remark;
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 是否支持极速达配送服务
@property (nonatomic, copy) SABoolValue speedDelivery;
/// 慢必赔
@property (nonatomic, assign) BOOL slowPayMark;
/// 是否存在订单反馈
@property (nonatomic, assign) BOOL hasFeedBack;
/// 特殊配送
@property (nonatomic, assign) BOOL increaseTimeFlag;
/// 特殊配送备注
@property (nonatomic, strong) SAInternationalizationModel *timeRemark;
/// 预约状态
@property (nonatomic, strong) WMOrderDeliveryTimeType deliveryTimelinessType;
/// 商家接单时间
@property (nonatomic, copy) NSString *merchantAcceptTime;
/// 更改了地址
@property (nonatomic, assign) WMOrderUpdateAddressStatus isUpdateAddress;
/// 有更改地址的记录
@property (nonatomic, assign) BOOL isUpdateAddressHistory;
/// 修改地址退款信息
@property (nonatomic, strong) WMUpdateAddressRefundInfo *updateAddressRefundInfo;
/// 群聊id
@property (nonatomic, copy) NSString *imGroupId;
/// 用户是否创建过售后反馈单
@property (nonatomic, assign) BOOL hasPostSale;
/// 反馈进度
@property (nonatomic, copy) WMOrderFeedBackHandleStatus handleStatus;
/// 售后反馈状态展示类型
@property (nonatomic, copy) WMOrderFeedBackStepShowType postSaleShowType;
/// 骑手评估到达时间
@property (nonatomic, assign) NSTimeInterval riderEstimateArriveTime;

@property (nonatomic, assign) NSInteger serviceType;
///   取餐码
@property (nonatomic, copy) NSString *pickUpCode;

@end


@interface WMUpdateAddressRefundInfo : WMModel
/// 聚合单号
@property (nonatomic, copy) NSString *aggregateNo;
/// 退款状态, 10: 退款中, 11: 退款成功
@property (nonatomic, assign) WMOrderDetailRefundState refundState;

@end

NS_ASSUME_NONNULL_END
