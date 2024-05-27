//
//  PNCreditDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNCreditRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNCreditDTO : PNModel
/// 钱包开通校验 & 是否授信额度
- (void)checkCreditAuthorization:(void (^)(PNCreditRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;


/// 授信额度
- (void)creditAuthorization:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
