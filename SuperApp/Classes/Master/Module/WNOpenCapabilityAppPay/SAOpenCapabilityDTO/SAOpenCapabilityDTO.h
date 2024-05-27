//
//  SAOpenCapabilityDTO.h
//  SuperApp
//
//  Created by seeu on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMNetworkRequest.h"
#import "SAOpenCapabilityMerchantInfoRespModel.h"
#import "SAPaymentDetailsRspModel.h"
#import "SAQueryAppSecretKeyRspModel.h"
#import "SAQueryPaymentStateRspModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAOpenCapabilityDTO : NSObject

/// 查询appid的密钥
/// @param appId appid
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryAppSecretKeyWithAppId:(NSString *)appId success:(void (^)(SAQueryAppSecretKeyRspModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 查询支付单详情
/// @param payOrderNo 支付单号
/// @param sign 签名
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryPaymentInfoWithPayOrderNo:(NSString *_Nullable)payOrderNo sign:(NSString *)sign success:(void (^)(SAPaymentDetailsRspModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 查询支付详情
/// @param orderNo 聚合订单号
/// @param sign 签名
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryPaymentInfoWithOrderNo:(NSString *_Nullable)orderNo sign:(NSString *)sign success:(void (^)(SAPaymentDetailsRspModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 根据订单号查询支付状态
/// @param payOrderNo 支付单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryPaymentStateWithPayOrderNo:(NSString *)payOrderNo success:(void (^)(SAQueryPaymentStateRspModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 查询商户信息
/// @param merchantNo 一级商户号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryMerchantInfoWithMerchantNo:(NSString *)merchantNo success:(void (^)(SAOpenCapabilityMerchantInfoRespModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
