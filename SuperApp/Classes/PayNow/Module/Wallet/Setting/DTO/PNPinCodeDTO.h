//
//  PNPinCodeDTO.h
//  SuperApp
//
//  Created by seeu on 2023/9/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PNMSSMSValidateRspModel;


@interface PNPinCodeDTO : PNModel

+ (void)checkPinCodeExistsCompletion:(void (^)(BOOL isExist))completion;

+ (void)createPinCodeWithPinCode:(NSString *_Nonnull)pinCode index:(NSString *_Nonnull)index success:(void (^_Nullable)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 校验pinCode，返回token，用于修改pincode
/// - Parameters:
///   - pinCode: 原pinCode的密文
///   - index: 加密索引
///   - successBlock: 成功毁掉
///   - failureBlock: 失败回调
+ (void)validatePinCodeWithPinCode:(NSString *_Nonnull)pinCode index:(NSString *_Nonnull)index success:(void (^_Nullable)(NSString *_Nullable token))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;


/// 修改pinCode
/// - Parameters:
///   - newPinCode: 新的pinCode密文
///   - token: token
///   - index: 加密索引
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
+ (void)modifyPinCodeWithNewPinCode:(NSString *_Nonnull)newPinCode token:(NSString *_Nonnull)token index:(NSString *_Nonnull)index success:(void (^_Nullable)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 发送找回pincode验证码
/// - Parameter completion: 回调
+ (void)forgotPinCodeSendSmsCompletion:(void (^_Nullable)(NSString *_Nullable serialNum))completion;

+ (void)validateForgotPinCodeSMSWithCode:(NSString *_Nonnull)code serialNum:(NSString *_Nonnull)serialNum success:(void (^_Nullable)(PNMSSMSValidateRspModel *_Nullable rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
