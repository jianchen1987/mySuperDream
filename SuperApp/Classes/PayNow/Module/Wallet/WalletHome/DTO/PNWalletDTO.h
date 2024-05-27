//
//  PNWalletDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNWalletAcountModel;
@class HDUserRegisterRspModel;
@class PNWalletListConfigModel;
@class PNWalletFunctionModel;

NS_ASSUME_NONNULL_BEGIN

@class PNWalletAcountModel;


@interface PNWalletDTO : PNModel

/// 查询我的账户余额
- (void)getMyWalletInfoSuccess:(void (^_Nullable)(PNWalletAcountModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取钱包列表配置
- (void)getWalletListConfig:(void (^_Nullable)(NSArray<PNWalletListConfigModel *> *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// KYC用户营销信息
- (void)getWalletMarketingInfo:(void (^_Nullable)(NSString *showMsg))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取APP 功能配置
- (void)getAllWalletFunctionConfig:(void (^_Nullable)(PNWalletFunctionModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
