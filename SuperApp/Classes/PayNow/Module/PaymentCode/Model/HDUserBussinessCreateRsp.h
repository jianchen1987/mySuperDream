//
//  HDUserBussinessCreateRsp.h
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 开通业务结果 */
@interface HDUserBussinessCreateRsp : SAModel
@property (nonatomic, copy) NSString *authKey;       ///< 授权 key
@property (nonatomic, copy) NSString *payerUsrToken; ///< 支付用户TOKEN[注: 10位数字]
@end

NS_ASSUME_NONNULL_END
