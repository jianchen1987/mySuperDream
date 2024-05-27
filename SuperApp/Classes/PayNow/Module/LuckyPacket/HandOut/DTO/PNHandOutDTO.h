//
//  PNHandOutDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNExchangeRateModel;
@class PNPacketBuildRspModel;
@class PNFactorRspModel;
@class PNCashToolsRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNHandOutDTO : PNModel

/// 查询汇率
- (void)getExchangeRate:(void (^_Nullable)(PNExchangeRateModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取图片地址
- (void)getCoverImageList:(void (^_Nullable)(NSArray<NSString *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取加密因子
- (void)getFactor:(void (^_Nullable)(PNFactorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 下单
- (void)packetBuild:(NSDictionary *)param success:(void (^_Nullable)(PNPacketBuildRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取资金工具
- (void)cashTool:(NSString *)tradeNo success:(void (^_Nullable)(PNCashToolsRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
