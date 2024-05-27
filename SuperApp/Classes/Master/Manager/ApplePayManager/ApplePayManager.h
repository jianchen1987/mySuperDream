//
//  ApplePayManager.h
//  SuperApp
//
//  Created by seeu on 2022/1/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^_Nullable ApplePayCompletionBlock)(NSError *error, NSDictionary *userInfo);

@class SKPaymentTransaction;
/**
 苹果支付管理类，用于管理苹果支付相关
 */
@interface ApplePayManager : NSObject

+ (instancetype)shared;

/// 发起支付
/// @param orderNo 支付单号
/// @param productId 商品ID
/// @param completion 完成回调
- (void)requestPaymentWithOrderNo:(NSString *)orderNo
                        productId:(NSString *)productId
                         quantity:(NSInteger)quantity
                         userInfo:(NSDictionary *_Nullable)userInfo
                       completion:(void (^)(NSInteger rspCode, NSDictionary *userInfo))completion;

/// 交易结果回调
/// @param transactions 交易对象
- (void)handleTransactions:(NSArray<SKPaymentTransaction *> *)transactions;

@end

NS_ASSUME_NONNULL_END
