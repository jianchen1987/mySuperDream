//
//  PNDepositDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNDepositRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNDepositDTO : PNModel
/// 用户入金向导
- (void)queryDepositGuide:(void (^)(PNDepositRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
