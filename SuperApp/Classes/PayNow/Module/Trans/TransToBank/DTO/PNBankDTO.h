//
//  PNBankDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBankDTO : PNModel

/// 获取银行列表
- (void)getBankList:(void (^_Nullable)(NSArray *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
