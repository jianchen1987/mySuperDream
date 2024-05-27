//
//  PNUserDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class HDUserRegisterRspModel;
@class HDUserInfoRspModel;
@class PNWalletLimitModel;
@class PNContactUSModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNUserDTO : PNModel
/// 查询我的用户信息
- (void)getPayNowUserInfoSuccess:(void (^_Nullable)(HDUserInfoRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询我的用户信息V2
- (void)getPayNowUserInfoV2Success:(void (^_Nullable)(HDUserInfoRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取限额列表
- (void)getWalletLimit:(void (^_Nullable)(NSArray<PNWalletLimitModel *> *list))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询最新提交的KYC信息
- (void)queryUserInfoFromKYC:(void (^_Nullable)(HDUserInfoRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取服务器当前时间
- (void)getCurrentDay:(void (^_Nullable)(NSString *rspDate))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 联系我们
- (void)getContactUSInfo:(void (^_Nullable)(PNContactUSModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取所有公告，
- (void)getAllNoticeSuccess:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
