//
//  TNCategoryDTO.h
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNFirstLevelCategoryModel;


@interface TNCategoryDTO : TNModel

/// 查询分类菜单
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryCategorySuccess:(void (^_Nullable)(NSArray<TNFirstLevelCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
