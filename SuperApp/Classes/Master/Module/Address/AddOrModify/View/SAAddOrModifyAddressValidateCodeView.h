//
//  SAAddOrModifyAddressValidateCodeView.h
//  SuperApp
//
//  Created by seeu on 2021/11/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyAddressValidateCodeView : SAAddOrModifyAddressBaseView

/// 验证码
@property (nonatomic, strong, readonly) HDUITextField *validateCodeTF;
/// 验证码
@property (nonatomic, copy, readonly) NSString *validateCode;

/// 发送短信
/// @param mobile 手机号
- (void)sendValidateSmsWthMobileNo:(NSString *)mobile;

@end

NS_ASSUME_NONNULL_END
