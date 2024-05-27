//
//  SASettingPayPwdViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"
#import "SAEnableWalletRspModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SASettingPayPwdActionType) {
    SASettingPayPwdActionTypeConfirmID = 1,               ///< 确认身份
    SASettingPayPwdActionTypeSetFirst = 2,                ///< 设置密码初次设置
    SASettingPayPwdActionTypeSetConfirm = 3,              ///< 设置密码确认
    SASettingPayPwdActionTypeChange = 4,                  ///< 设置新密码
    SASettingPayPwdActionTypeChangeVerify = 5,            ///< 校验旧密码修改密码
    SASettingPayPwdActionTypeChangeConfirm = 6,           ///< 修改密码确认
    SASettingPayPwdActionTypeWalletActivation = 7,        ///< 钱包激活 设置密码
    SASettingPayPwdActionTypeWalletActivationConfirm = 8, ///< 钱包激活 再次设置密码
    SASettingPayPwdActionTypePinCodeSetting = 9,          ///< 设置pincode
    SASettingPayPwdActionTypePinCodeSettingVerify = 10,   ///< 设置pincode二次确认
    SASettingPayPwdActionTypePinCodeVerify = 11,          ///<  校验原pincode
    SASettingPayPwdActionTypePinCodeNew = 12,             ///< 修改pincode
    SASettingPayPwdActionTypePinCodeNewConfirm = 13       ///<  修改pincode确认
};


@interface SASettingPayPwdViewModel : PNViewModel
/// 旧支付密码
@property (nonatomic, assign) NSString *oldPayPassword;
/// 类型
@property (nonatomic, assign) SASettingPayPwdActionType actionType;
/// token
@property (nonatomic, copy) NSString *accessToken;
/// 流水号
@property (nonatomic, copy) NSString *serialNumber;
/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL needSetting, BOOL isSuccess);

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString *birthday;

@property (nonatomic, strong) NSDictionary *verifyParam;

/// 验证支付密码是否正确
- (void)validatePassword:(NSString *)password;

/// 开通钱包
/// @param password 密码（明文）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)enableWalletWithPassword:(NSString *)password
                                     firstName:(NSString *)firstName
                                      lastName:(NSString *)lastName
                                        gender:(NSInteger)gender
                                       headUrl:(NSString *)headUrl
                                      birthday:(NSString *)birthday
                                       success:(void (^_Nullable)(SAEnableWalletRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 校验支付密码
/// @param password 原交易密码明文
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)verifyOriginalPayPwdWithPassword:(NSString *)password success:(void (^)(NSString *accessToken))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 修改支付密码
/// @param password 新交易密码明文
/// @param accessToken token
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)changePayPwdWithPassword:(NSString *)password accessToken:(NSString *)accessToken success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 修改支付密码
- (void)resetPwd:(NSString *)password success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 钱包激活
- (void)walletActivation:(NSString *)password;

//创建pincode
- (void)createPinCodeWithPinCode:(NSString *_Nonnull)pinCode success:(void (^_Nullable)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
//校验原pinCode
- (void)validatePinCodeWithPinCode:(NSString *_Nonnull)pinCode success:(void (^_Nonnull)(NSString *_Nullable token, NSString * _Nullable errMsg))completion;
//修改pincode
- (void)modifyPinCodeWithPinCode:(NSString *_Nonnull)newPinCode token:(NSString *_Nonnull)token success:(void (^_Nonnull)(void))successBlock failure:(PNNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
