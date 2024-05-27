//
//  SAVerifySMSCodeRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAVerifySMSCodeRspModel : SARspModel
/// 短信验证 Token
@property (nonatomic, copy) NSString *apiTicket;
/// 过期时间
@property (nonatomic, copy) NSString *expiresTime;
/// 用户名
@property (nonatomic, copy) NSString *loginName;
@end

NS_ASSUME_NONNULL_END
