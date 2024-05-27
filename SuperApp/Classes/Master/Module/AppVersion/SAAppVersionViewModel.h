//
//  SAAppVersionViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppVersionInfoRspModel.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppVersionViewModel : SAViewModel

/// 获取版本信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getAppVersionInfoSuccess:(void (^)(SAAppVersionInfoRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
