//
//  HDCouponTicketModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDMerchantInfoModel.h"
#import "PNEnum.h"
#import "PayHDTradeAmountModel.h"
#import "SAModel.h"

@class HDTradePreferentialModel;

NS_ASSUME_NONNULL_BEGIN

/** 优惠券模型 */
@interface HDCouponTicketModel : SAModel
@property (nonatomic, strong) PayHDTradeAmountModel *couponAmount; ///< 优惠金额
@property (nonatomic, strong) NSNumber *couponDiscount;            ///< 折扣券专用 折扣比例
@property (nonatomic, copy) NSString *couponNo;                    ///< 优惠券分类ID
@property (nonatomic, copy) NSString *couponCode;                  ///< 优惠券唯一编号
@property (nonatomic, copy) NSString *couponTitle;                 ///< 优惠券标题
@property (nonatomic, assign) PNCouponTicketStatus couponState;    ///< 优惠券状态 10-未生效 11-未使用 12-已锁定 13-已使用 14-已过期
@property (nonatomic, assign) PNTradePreferentialType couponType;  ///< 优惠券类型 13-折扣券 14-满减券 15-代金券
@property (nonatomic, assign) HDCouponTicketSceneType sceneType;   ///< 优惠券归属类型 10-平台券 11-商户券 12-平台+商户券

@property (nonatomic, copy) NSString *couponStateDesc; ///< 优惠券状态描述（埋点使用）
@property (nonatomic, copy) NSString *couponTypeDesc;  ///< 优惠券类型描述（埋点使用）
@property (nonatomic, copy) NSString *sceneTypeDesc;   ///< 优惠券归属类型描述（埋点使用）

@property (nonatomic, copy) NSString *couponUsageDescribe;                    ///< 优惠券使用说明
@property (nonatomic, copy) NSString *effectiveDate;                          ///< 生效日期
@property (nonatomic, copy) NSString *expireDate;                             ///< 失效日期
@property (nonatomic, strong) HDMerchantInfoModel *merchantInfo;              ///< 商户信息
@property (nonatomic, strong) PayHDTradeAmountModel *thresholdAmount;         ///< 消费门槛金额
@property (nonatomic, assign) HDCouponTicketSupportCurrencyType currencyType; ///< 币种类型 10 KHR 11 USD 12 KHR+USD
@property (nonatomic, copy, readonly) NSString *usableCurrencyDesc;           ///< 统一设置支付货币描述
@property (nonatomic, assign) CGFloat gradientLayerWidth;                     ///< 色块宽度
@property (nonatomic, assign) NSUInteger numbersOfLineOfTitle;                ///< 标题行数
@property (nonatomic, assign) NSUInteger numbersOfLineOfDate;                 ///< 日期行数
@property (nonatomic, copy) NSString *discountRadioStr;                       ///< 折扣百分比
@property (nonatomic, assign) BOOL isFixedHeight;                             ///< 是否固定高度（同时支持变高和定高 cell 布局）

+ (instancetype)modelWithTradePreferentialModel:(HDTradePreferentialModel *)model;
- (instancetype)initWithTradePreferentialModel:(HDTradePreferentialModel *)model;
@end

NS_ASSUME_NONNULL_END
