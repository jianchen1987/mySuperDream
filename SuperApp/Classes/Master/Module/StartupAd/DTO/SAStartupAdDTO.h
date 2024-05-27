//
//  SAStartupAdDTO.h
//  SuperApp
//
//  Created by Tia on 2022/9/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

@class SAStartupAdModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAStartupAdDTO : SAModel
/// 查询地区广告
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryAdSuccess:(void (^_Nullable)(NSArray<SAStartupAdModel *> *advertising))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
