//
//  TNUserDTO.h
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNGetTinhNowUserDiffRspModel;


@interface TNUserDTO : TNModel

/// 获取电商用户差异部分信息，是否分销员
/// @param userNo 操作员 号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getTinhNowUserDifferenceWithUserNo:(NSString *)userNo success:(void (^_Nullable)(TNGetTinhNowUserDiffRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取电商用户是否是卖家
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getTinhNowUserIsSellerSuccess:(void (^_Nullable)(TNGetTinhNowUserDiffRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
