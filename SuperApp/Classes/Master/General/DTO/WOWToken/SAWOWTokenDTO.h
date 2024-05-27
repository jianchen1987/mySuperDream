//
//  SAWOWToken.h
//  SuperApp
//
//  Created by Chaos on 2021/3/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAWOWTokenModel;


@interface SAWOWTokenDTO : SAModel

/// 解析WOW口令
/// @param token WOW口令
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)parsingWOWTokenWithToken:(NSString *)token success:(void (^_Nullable)(SAWOWTokenModel *wowTokenModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
