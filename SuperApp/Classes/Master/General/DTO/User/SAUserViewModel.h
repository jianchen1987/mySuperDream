//
//  SAUserViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAGetUserInfoRspModel.h"
#import "SAMemberLevelInfoRspModel.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUserViewModel : SAViewModel

/// 用户登出
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)logoutSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取操作员信息
/// @param operatorNo 操作员编号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getUserInfoWithOperatorNo:(NSString *)operatorNo success:(void (^_Nullable)(SAGetUserInfoRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询会员等级信息
/// @param operatorNo 操作员号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getMemberLevelInfoWithOperatorNo:(NSString *)operatorNo success:(void (^)(SAMemberLevelInfoRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
