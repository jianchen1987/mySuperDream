//
//  PNMSBindDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBindDTO : PNModel

/// 查询商户信息 - [绑定关联商户那边使用]
- (void)queryMerchantServicesInfoWithMerchantNo:(NSString *)merchantNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取验证码 - [绑定商户]
- (void)sendSMSCodeWithMerchantNo:(NSString *)merchantNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 校验 验证码 并且 绑定
- (void)verifyAndBindWithMerchantNo:(NSString *)merchantNo smsCode:(NSString *)smsCode success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
