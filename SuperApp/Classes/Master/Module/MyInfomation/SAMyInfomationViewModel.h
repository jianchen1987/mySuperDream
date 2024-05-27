//
//  SAMyInfomationViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAGetUserInfoRspModel.h"
#import "SAUser.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMyInfomationViewModel : SAViewModel
/// 用户信息
@property (nonatomic, strong, readonly) SAGetUserInfoRspModel *userInfoRspModel;

- (void)getNewData;

/// 更新绑定信息
/// @param channel 渠道
/// @param userName 第三方渠道名称
/// @param token token
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)updateThirdAccountBindStatusForChannel:(SAThirdPartyBindChannel)channel
                                                    userName:(NSString *)userName
                                                       token:(NSString *)token
                                                     success:(void (^)(void))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
