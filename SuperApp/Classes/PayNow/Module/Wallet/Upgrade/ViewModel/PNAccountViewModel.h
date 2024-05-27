//
//  PNAccountViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

@class PNWalletLimitModel;
@class HDUserInfoRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNAccountViewModel : PNViewModel

@property (nonatomic, strong) NSString *currentDateStr;

@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, strong) HDUserInfoRspModel *userInfoModel;
///限额数据源
@property (nonatomic, assign) NSArray<PNWalletLimitModel *> *list;

/// 获取服务器当前时间
- (void)getCurrentDate;

/// 获取用户信息
- (void)getUserInfo;

/// 实名提交
- (void)submitRealNameWithParams:(NSMutableDictionary *)params successBlock:(void (^)(void))successBlock;

/// 实名提交V2
- (void)submitRealNameV2WithParams:(NSMutableDictionary *)params successBlock:(void (^)(void))successBlock;

/// 获取限额列表
- (void)getWalletLimit:(void (^_Nullable)(NSArray<PNWalletLimitModel *> *list))successBlock;

/// 查询最新提交的KYC信息
- (void)getUserInfoFromKYC;
@end

NS_ASSUME_NONNULL_END
