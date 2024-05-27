//
//  PNMSBindViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBindModel.h"
#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBindViewModel : PNViewModel

@property (nonatomic, strong) PNMSBindModel *model;

/// 查询商户信息
- (void)getMerchantInfoWithMerchantNo:(NSString *)merchantNo;

/// 获取验证码
- (void)sendSMSCodeWithMerchantNo:(NSString *)merchantNo success:(void (^)(void))successBlock;

/// 校验 验证码并且绑定
- (void)verifyAndBindWithMerchantNo:(NSString *)merchantNo smsCode:(NSString *)smsCode;

@end

NS_ASSUME_NONNULL_END
