//
//  PNMSTradePwdViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PNMSSettingPayPwdActionType) {
    PNMSSettingPayPwdActionTypeSetFirst = 1,             ///< 设置商户钱包交易密码 - 初次设置
    PNMSSettingPayPwdActionTypeSetConfirm = 2,           ///< 设置商户钱包交易密码 - 确认
    PNMSSettingPayPwdActionTypeValidator = 3,            ///< 校验旧密码
    PNMSSettingPayPwdActionTypeUpdate = 4,               ///< 重新设置密码 - 记得原来密码 校验旧密码通过之后 第一次设置新密码
    PNMSSettingPayPwdActionTypeUpdateConfrim = 5,        ///< 重新设置密码 - 再次确认设置的密码
    PNMSSettingPayPwdActionTypeReset = 6,                ///< 重新设置密码 - 忘记密码 ，短信校验通过进来
    PNMSSettingPayPwdActionTypeResetConfirm = 7,         ///< 重新设置密码 - 再次确认设置的密码
    PNMSSettingPayPwdActionTypeResetOperator = 8,        ///< 重新设置密码 - 忘记密码 ，短信校验通过进来 [重置操作员]
    PNMSSettingPayPwdActionTypeResetOperatorConfirm = 9, ///< 重新设置密码 - 再次确认设置的密码 [重置操作员]
};


@interface PNMSTradePwdViewModel : PNViewModel
/// 令牌流水号,短信验证接口返回的参数 【忘记密码流程用到】
@property (nonatomic, copy) NSString *serialNumber;
/// 令牌,短信验证接口返回的参数 【忘记密码流程用到】
@property (nonatomic, copy) NSString *token;
/// 当前密码【更新密码才需要用到】
@property (nonatomic, strong) NSString *currentPassword;
/// 旧支付密码
@property (nonatomic, assign) NSString *oldPayPassword;
/// 类型
@property (nonatomic, assign) PNMSSettingPayPwdActionType actionType;
/// 商家的操作员编号
@property (nonatomic, copy) NSString *operatorNo;

/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL isSuccess);

/// 设置商户交易密码
- (void)saveTradePwd:(NSString *)pwd success:(void (^)(void))successBlock;

/// 校验交易密码
- (void)validatorTradePwd:(NSString *)pwd success:(void (^)(void))successBlock;

/// 更新交易密码
- (void)updateTradePwd:(NSString *)pwd oldPwd:(NSString *)oldPwd success:(void (^)(void))successBlock;

/// 重新交易密码
- (void)resetTradePwd:(NSString *)pwd success:(void (^)(void))successBlock;

/// 重新交易密码 - 重置操作员密码
- (void)operatorResetTradePwd:(NSString *)pwd success:(void (^)(void))successBlock;
@end

NS_ASSUME_NONNULL_END
