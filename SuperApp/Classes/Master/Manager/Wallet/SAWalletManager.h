//
//  SAWalletManager.h
//  SuperApp
//
//  Created by VanJay on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletManager : NSObject

+ (void)adjustShouldSettingPayPwdCompletion:(void (^)(BOOL needSetting, BOOL isSuccess))completion;

/// 判断是否需要设置支付密码，如果需要，内部会自动弹起设置支付密码界面并处理 block 回调
/// @param completion 回调
/// @param shouldSet 是否要弹窗，默认是
+ (void)adjustShouldSettingPayPwdCompletion:(void (^)(BOOL needSetting, BOOL isSuccess))completion shouldSet:(BOOL)shouldSet;
@end

NS_ASSUME_NONNULL_END
