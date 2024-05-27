//
//  PNIDVerifyDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNGetCardTypeRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNIDVerifyDTO : PNModel

/// 获取 注册的证件类型
- (void)getCardType:(void (^_Nullable)(PNGetCardTypeRspModel *model))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 客户信息校验
/// 客户信息校验
- (void)verifyCustomerInfo:(NSDictionary *)requestParam success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 激活钱包
- (void)walletActivation:(NSString *)index
                     pwd:(NSString *)pwd
             verifyParam:(NSDictionary *)verifyParam
                 success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
                 failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
