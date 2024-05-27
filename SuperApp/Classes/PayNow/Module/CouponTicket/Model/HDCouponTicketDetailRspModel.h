//
//  HDCouponTicketDetailRspModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDMerchantInfoModel.h"
#import "PNEnum.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 优惠券详情 */
@interface HDCouponTicketDetailRspModel : SAModel

@property (nonatomic, strong) SAMoneyModel *couponAmount;                     ///< 优惠金额
@property (nonatomic, strong) NSNumber *couponDiscount;                       ///< 折扣券专用 折扣比例
@property (nonatomic, copy) NSString *couponNo;                               ///< 优惠券分类ID
@property (nonatomic, copy) NSString *couponCode;                             ///< 优惠券唯一编号
@property (nonatomic, assign) PNCouponTicketStatus couponState;               ///< 优惠券状态 10-未生效 11-未使用 12-已锁定 13-已使用 14-已过期
@property (nonatomic, copy) NSString *couponTitle;                            ///< 优惠券标题
@property (nonatomic, assign) PNTradePreferentialType couponType;             ///< 优惠券类型 13-折扣券 14-满减券
@property (nonatomic, assign) HDCouponTicketSceneType sceneType;              ///< 优惠券归属类型 10-平台券 11-商户券 12-平台+商户券
@property (nonatomic, copy) NSString *couponUsageDescribe;                    ///< 优惠券使用说明
@property (nonatomic, copy) NSString *effectiveDate;                          ///< 生效日期
@property (nonatomic, copy) NSString *expireDate;                             ///< 失效日期
@property (nonatomic, strong) HDMerchantInfoModel *merchantInfo;              ///< 商户信息
@property (nonatomic, strong) SAMoneyModel *limitAmountUSD;                   ///< 消费上线美金金额
@property (nonatomic, strong) SAMoneyModel *limitAmountKHR;                   ///< 消费上线瑞尔金额
@property (nonatomic, strong) SAMoneyModel *thresholdAmountUSD;               ///< 消费门槛美金金额
@property (nonatomic, strong) SAMoneyModel *thresholdAmountKHR;               ///< 消费门槛瑞尔金额
@property (nonatomic, assign) HDCouponTicketSupportCurrencyType currencyType; ///< 币种类型 10 KHR 11 USD 12 KHR+USD
@property (nonatomic, copy) NSString *couponUsageRule;                        ///< 优惠券使用规则
@property (nonatomic, copy) NSString *discountRadioStr;                       ///< 折扣百分比
@property (nonatomic, copy) NSArray<NSString *> *sceneItem;                   ///< 优惠券核销场景

@property (nonatomic, strong) SAMoneyModel *thresholdAmount; ///< 满减券消费门槛金额（满减券只有一种币种）
@property (nonatomic, strong) SAMoneyModel *limitAmount;     ///< 满减券消费上线金额（满减券只有一种币种）
@property (nonatomic, copy) NSString *usableCurrencyDesc;    ///< 统一设置支付货币描述

@end

NS_ASSUME_NONNULL_END
