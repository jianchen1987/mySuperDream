//
//  SAWechatGetAccessTokenRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/9/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWechatGetAccessTokenRspModel : SARspModel
/// openId
@property (nonatomic, copy) NSString *openId;
/// accessToken
@property (nonatomic, copy) NSString *accessToken;
/// 用户昵称
@property (nonatomic, copy) NSString *nickName;
@end

NS_ASSUME_NONNULL_END
