//
//  PNUserPasswordDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNValidateSMSCodeRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNUserPasswordDTO : PNModel

/// 修改用户支付密码Step2:用户端验证短信
- (void)validateSMSCode:(NSString *)smsCode success:(void (^_Nullable)(PNValidateSMSCodeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 修改用户支付密码Step3:确认修改交易密码
- (void)resetPassword:(NSString *)newTradePwd
                token:(NSString *)token
         serialNumber:(NSString *)serialNumber
              success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
              failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
