//
//  PNMSPwdDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSEncryptFactorRspModel;
@class PNMSSMSValidateRspModel;
@class PNMSRoleManagerInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSPwdDTO : PNModel
/// 获取加密因子
- (void)getMSEncryptFactorWithRandom:(NSString *)random success:(void (^)(PNMSEncryptFactorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 设置交易密码
- (void)saveMSTradePwd:(NSString *)password
                 index:(NSString *)index
            operatorNo:(NSString *)operatorNo
               success:(void (^)(PNRspModel *rspModel))successBlock
               failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 校验交易密码
- (void)validatorMSTradePwd:(NSString *)password
                      index:(NSString *)index
                 operatorNo:(NSString *)operatorNo
                    success:(void (^)(PNRspModel *rspModel))successBlock
                    failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 修改交易密码
- (void)updateMSTradePwd:(NSString *)newPassword
             oldTradePwd:(NSString *)oldTradePwd
                   index:(NSString *)index
              operatorNo:(NSString *)operatorNo
                 success:(void (^)(PNRspModel *rspModel))successBlock
                 failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 发送短信 【忘记密码】
- (void)sendSMS:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 校验短信验证码
- (void)validateSMSCode:(NSString *)smsCode success:(void (^)(PNMSSMSValidateRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 重置密码
- (void)resetMSTradePwd:(NSString *)newPassword
                  index:(NSString *)index
             operatorNo:(NSString *)operatorNo
           serialNumber:(NSString *)serialNumber
                  token:(NSString *)token
                success:(void (^)(PNRspModel *rspModel))successBlock
                failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 返回操作员对应超管信息
- (void)getManagerInfo:(void (^)(PNMSRoleManagerInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 校验短信验证码 - 重置操作员密码
- (void)operatorPWdValidateSMSCode:(NSString *)smsCode success:(void (^)(PNMSSMSValidateRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 重置密码 - 重置操作员密码
- (void)operatorResetMSTradePwd:(NSString *)newPassword
                          index:(NSString *)index
                     operatorNo:(NSString *)operatorNo
                   serialNumber:(NSString *)serialNumber
                          token:(NSString *)token
                        success:(void (^)(PNRspModel *rspModel))successBlock
                        failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
