//
//  SAPayResultViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/9/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "SAWPontWillGetRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SACouponRedemptionRspModel;
@class SAQueryPaymentStateRspModel;
@class SAMoneyModel;


@interface SAPayResultViewModel : SAViewModel

/// orderNo 中台聚合订单号
@property (nonatomic, copy) NSString *orderNo;
/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
/// 支付订单号
@property (nonatomic, copy) NSString *outPayOrderNo;
///< 二级商户号
@property (nonatomic, copy, nullable) NSString *merchantNo;
/// 外部传的状态
//@property (nonatomic, assign) SAPaymentState paymentState;
//@property (nonatomic, strong) SAMoneyModel *paymentMoney;  ///< 支付金额
/// 点击完成回调
@property (nonatomic, copy) void (^doneClickBlock)(UIViewController *vc);
/// 点击查看订单回调
@property (nonatomic, copy) void (^orderClickBlock)(UIViewController *vc);

/// 查询结果
@property (nonatomic, strong, readonly, nullable) SAQueryPaymentStateRspModel *resultModel;
/// 领券结果
@property (nonatomic, strong, readonly, nullable) SACouponRedemptionRspModel *couponRspModel;
///< 获取积分结果
@property (nonatomic, strong, nullable) SAWPontWillGetRspModel *wpointRspModel;

- (void)getNewData;

/// 查询订单支付状态
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryOrderPaymentStateSuccess:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 支付成功自动领券
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)autoCouponRedemptionSuccess:(void (^_Nullable)(SACouponRedemptionRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询该笔订单获得的积分数
- (void)queryHowManyWPontWillGetWithThisOrderCompletion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
