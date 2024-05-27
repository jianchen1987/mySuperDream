//
//  SARemoteNotifyViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SARemoteNotifyViewModel : SAViewModel

/// 反注册推送
/// @param channel 渠道
/// @param success 成功回调
/// @param failure 失败回调
- (void)unregisterUserRemoteNotificationTokenWithChannel:(SAPushChannel)channel success:(CMNetworkSuccessVoidBlock _Nullable)success failure:(CMNetworkFailureBlock _Nullable)failure;

/// 注册通知
/// @param deviceToken 设备 id
/// @param channel 推送渠道
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)registerUserRemoteNofityDeviceToken:(NSString *)deviceToken
                                    channel:(SAPushChannel)channel
                                    success:(CMNetworkSuccessVoidBlock _Nullable)successBlock
                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 消息回调
/// @param channel 推送渠道
/// @param bizId 推送id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)notificationCallbackInChannel:(SAPushChannel)channel
                                bizId:(NSString *)bizId
                           templateNo:(NSString *_Nullable)templateNo
                              isClick:(BOOL)isClick
                          newStrategy:(BOOL)newStrategy
                              success:(CMNetworkSuccessVoidBlock _Nullable)successBlock
                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
