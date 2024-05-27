//
//  PNAccountUpgradeDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNAccountUpgradeDTO : PNModel
/// 实名提交
- (void)submitRealNameWithParams:(NSMutableDictionary *)params successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 实名提交V2
- (void)submitRealNameV2WithParams:(NSMutableDictionary *)params successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 手持证件认证提交 => [高级 升级到 尊享]
- (void)submitCardHandAuthWidthURL:(NSString *)cardHandURL successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
