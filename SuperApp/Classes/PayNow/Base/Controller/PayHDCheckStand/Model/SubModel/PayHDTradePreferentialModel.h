//
//  PayHDTradePreferentialModel.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDBaseCodingObject.h"
#import "PNEnum.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 优惠信息模型
 */
@interface PayHDTradePreferentialModel : HDBaseCodingObject
@property (nonatomic, assign) HDCouponTicketSupportCurrencyType ableCurrencyType; ///< 可用币种: 10-KHR, 11-USD, 12-USD/KHR
@property (nonatomic, strong) NSNumber *discountRatio;                            ///< 折扣比例(折扣类型活动和优惠券要用)
@property (nonatomic, copy) NSString *effectiveDate;                              ///< 有效开始时间
@property (nonatomic, copy) NSString *expireDate;                                 ///< 有效结束时间
@property (nonatomic, strong) SAMoneyModel *couponAmt;                            ///< 实际优惠金额
@property (nonatomic, strong) SAMoneyModel *couponMoney;                          ///< 优惠面值金额
@property (nonatomic, strong) SAMoneyModel *thresholdMoney;                       ///< 消费门槛金额
@property (nonatomic, copy) NSString *desc;                                       ///< 描述(USD,KHR)
@property (nonatomic, copy) NSString *title;                                      ///< 优惠标题
@property (nonatomic, copy) NSString *descSymbol;                                 ///< 描述 符号($,￥)
@property (nonatomic, copy) NSString *number;                                     ///< 活动编号(00001)
@property (nonatomic, assign) int32_t sort;                                       ///< 排序(0)
@property (nonatomic, assign) PNTradePreferentialType type;                       ///< 优惠类型(优惠类型 10:立返;11:立减;12:折扣;13:折扣券;14:满减券;)
@property (nonatomic, copy) NSString *typeDescForTrack;                           ///< 优惠券类型描述（埋点使用）
@property (nonatomic, copy) NSString *typeDesc;                                   ///< 优惠描述
@property (nonatomic, assign) PNTradePreferentialStatus usable;                   ///< 可用状态(0-不可用,1-可用)
@property (nonatomic, assign) HDCouponTicketSceneType origin;                     ///< 优惠券归属类型 10-平台券 11-商户券 12-平台+商户券

@property (nonatomic, assign) BOOL showStamp;                   ///< 是否显示印戳
@property (nonatomic, assign) BOOL isCommonCoupon;              ///< 是否常规优惠
@property (nonatomic, assign) BOOL isCouponTicket;              ///< 是否优惠券
@property (nonatomic, assign) BOOL isDontUseCoupon;             ///< 是否不使用优惠
@property (nonatomic, assign, getter=isSelected) BOOL selected; ///< 是否选中
@property (nonatomic, assign) CGFloat gradientLayerWidth;       ///< 色块宽度
@property (nonatomic, assign) NSUInteger numbersOfLineOfTitle;  ///< 标题行数
@property (nonatomic, assign) NSUInteger numbersOfLineOfDate;   ///< 日期行数
@property (nonatomic, assign) BOOL isFixedHeight;               ///< 是否固定高度（同时支持变高和定高 cell 布局）
@end

NS_ASSUME_NONNULL_END
