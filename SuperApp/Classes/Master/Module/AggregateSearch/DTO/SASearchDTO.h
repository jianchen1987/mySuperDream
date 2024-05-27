//
//  SASearchDTO.h
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchDTO : SAModel
/// 获取热词
/// - Parameters:
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)queryHotwordWithSuccess:(void (^)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 获取主题
/// - Parameters:
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)queryThematicWithSuccess:(void (^)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
