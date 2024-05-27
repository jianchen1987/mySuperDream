//
//  HDRemoteNotificationModel.h
//  ViPay
//
//  Created by VanJay on 2019/8/9.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPaymentCodeCouponModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDRemoteNotificationAPSAlertModel : NSObject
@property (nonatomic, copy) NSString *title; ///< 标题
@property (nonatomic, copy) NSString *body;  ///< 内容
@end


@interface HDRemoteNotificationAPSModel : NSObject
@property (nonatomic, strong) HDRemoteNotificationAPSAlertModel *alert; ///< alert
@property (nonatomic, assign) BOOL mutableContent;                      ///< 币种单位
@property (nonatomic, assign) BOOL contentAvailable;                    ///< 消息 ID
@end


@interface HDRemoteNotificationModel : SAModel
@property (nonatomic, copy) NSString *msgTitle;                              ///< 标题
@property (nonatomic, copy) NSString *googleCAE;                             ///< google.c.a.e
@property (nonatomic, copy) NSString *incomeFlag;                            ///< 金额正负
@property (nonatomic, copy) NSString *amount;                                ///< 金额
@property (nonatomic, copy) NSString *currency;                              ///< 币种单位
@property (nonatomic, copy) NSString *payAmount;                             ///< 实付金额
@property (nonatomic, copy) NSString *payAmountCurrency;                     ///< 实付金额币种单位
@property (nonatomic, copy) NSString *orderAmount;                           ///< 订单金额金额
@property (nonatomic, copy) NSString *orderAmountCurrency;                   ///< 订单金额金额单位
@property (nonatomic, copy) NSString *headUrl;                               ///< 图片地址
@property (nonatomic, copy) NSString *messageID;                             ///< 消息 ID
@property (nonatomic, copy) NSString *businessNo;                            ///< 业务号
@property (nonatomic, assign) PNTransType type;                              ///< 类型
@property (nonatomic, assign) PNTransType tradeType;                         ///< 类型
@property (nonatomic, assign) PNTransType businessType;                      ///< 类型
@property (nonatomic, copy) NSString *deviceNo;                              ///< 设备 ID
@property (nonatomic, copy) NSString *msgBody;                               ///< 消息内容
@property (nonatomic, copy) NSString *cashBackMoney;                         ///< 返现金额
@property (nonatomic, copy) NSString *payeeName;                             ///< 收款方名称
@property (nonatomic, strong) HDRemoteNotificationAPSModel *aps;             ///< aps
@property (nonatomic, assign) PNOrderStatus status;                          ///< 交易状态
@property (nonatomic, copy) NSArray<HDPaymentCodeCouponModel *> *couponList; ///< 优惠列表
@property (nonatomic, copy) NSString *merchantNo;                            ///< 商户号
@property (nonatomic, copy) NSString *userFeeAmount;                         ///< 手续费金额
@property (nonatomic, copy) NSString *userFeeCurrency;                       ///< 手续费币种

@end

NS_ASSUME_NONNULL_END
