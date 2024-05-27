//
//  TNProductCenterDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNFirstLevelCategoryModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNProductCenterDTO : TNModel
///请求选品分类数据
- (void)querySellerAllCategorySuccess:(void (^_Nullable)(NSArray<TNFirstLevelCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
