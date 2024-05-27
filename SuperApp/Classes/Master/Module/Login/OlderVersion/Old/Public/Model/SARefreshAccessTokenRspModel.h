//
//  SARefreshAccessTokenRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SARefreshAccessTokenRspModel : SARspModel
/// 登录token
@property (nonatomic, copy) NSString *accessToken;
/// 刷新token
@property (nonatomic, copy) NSString *refreshToken;

@end

NS_ASSUME_NONNULL_END
