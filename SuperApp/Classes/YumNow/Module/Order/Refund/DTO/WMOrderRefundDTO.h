//
//  WMOrderRefundDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMOrderCancelReasonModel;


@interface WMOrderRefundDTO : WMModel

/// 用户售后申请
/// @param orderNo 订单号
/// @param applyDesc 原因
/// @param reason 问题描述
/// @param pictures 图片 id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)orderRefundApplyWithOrderNo:(NSString *)orderNo
                                        applyDesc:(NSString *_Nullable)applyDesc
                                           reason:(NSString *_Nullable)reason
                                         pictures:(NSArray<NSString *> *_Nullable)pictures
                                          success:(void (^)(void))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 用户售后申请
/// @param orderNo 订单号
/// @param applyDesc 原因
/// @param model 原因(新版)
/// @param reason 问题描述
/// @param pictures 图片 id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)orderRefundApplyWithOrderNo:(NSString *)orderNo
                                        applyDesc:(NSString *)applyDesc
                                     cancelReason:(nullable WMOrderCancelReasonModel *)model
                                           reason:(NSString *)reason
                                         pictures:(NSArray<NSString *> *)pictures
                                          success:(void (^)(void))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
