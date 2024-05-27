//
//  GNOrderCellModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNMessageCode.h"
#import "GNStoreCellModel.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GNQrCodeInfo;


@interface GNOrderCellModel : GNCellModel
///订单编号
@property (nonatomic, copy) NSString *orderNo;
///订单编号 聚合
@property (nonatomic, copy) NSString *aggregateOrderNo;
///支付方式   枚举: ALL,ONLINE_PAYMENT,CASH
@property (nonatomic, strong) GNMessageCode *paymentMethod;
///订单状态  10使用 20完成 30取消
@property (nonatomic, strong) GNMessageCode *bizState;
///退款状态 30已退款
@property (nonatomic, strong) GNMessageCode *refundState;
///下单时间
@property (nonatomic, assign) NSTimeInterval createTime;
///取消时间
@property (nonatomic, assign) NSTimeInterval cancelTime;
///完成时间
@property (nonatomic, assign) NSTimeInterval finishTime;
///订单有效截止时间
@property (nonatomic, assign) NSTimeInterval effectiveTime;
///商品数量
@property (nonatomic, assign) NSInteger productCount;
///总金额（实付金额）
@property (nonatomic, strong) NSDecimalNumber *actualAmount;
///总金额（实付金额）
@property (nonatomic, strong) NSDecimalNumber *vat;
///优惠码金额
@property (nonatomic, strong) NSDecimalNumber *discountFee;
///订单取消类型
@property (nonatomic, strong) NSString *neCancelState;
///取消原因
@property (nonatomic, copy) NSString *cancelCause;
///订单商品实体信息
@property (nonatomic, strong) GNProductModel *productInfo;
///订单商家信息
@property (nonatomic, strong) GNStoreCellModel *merchantInfo;
///订单二维码信息
@property (nonatomic, copy) NSArray<GNQrCodeInfo *> *qrCodeInfo;
///订单失效时间
@property (nonatomic, assign) long payFailureTime;
///支付时间
@property (nonatomic, assign) NSTimeInterval payTime;
/// 参加活动
@property (nonatomic, assign) BOOL joinActivity;
/// 活动时间
@property (nonatomic, assign) NSTimeInterval activityTime;
/// 是否已预约
@property (nonatomic, assign) BOOL reservation;
/// 支付优惠减免
@property (nonatomic, strong) SAMoneyModel *payDiscountAmount;
/// 实付金额（应付 - 支付优惠)
@property (nonatomic, strong) SAMoneyModel *payActualPayAmount;

/// custom
/// 订单状态国际化
@property (nonatomic, copy) NSString *bitStateStr;
/// 订单状态图
@property (nonatomic, copy) NSString *bitStateImageStr;
/// 支付方式国际化
@property (nonatomic, copy) NSString *paymentMethodStr;
/// 退款国际化
@property (nonatomic, copy) NSString *refundStr;
/// 首张未使用
@property (nonatomic, strong) GNQrCodeInfo *firstUnUseCode;
/// 未使用总数
@property (nonatomic, assign) NSInteger unuseCount;

@end


@interface GNQrCodeInfo : GNCellModel
///核销码名称
@property (nonatomic, copy) NSString *codeName;
///核销状态  10:待使用  :20:已使用  30:已取消
@property (nonatomic, strong) GNMessageCode *codeState;
/// 核销状态国际化
@property (nonatomic, copy) NSString *codeStateStr;
///数字号
@property (nonatomic, copy) NSString *codeNo;

@end

NS_ASSUME_NONNULL_END
