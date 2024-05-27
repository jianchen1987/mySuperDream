//
//  TNCategoryChildControllerConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/2/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHomeCategoryModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNCategoryChildControllerConfig : TNModel
/// 分类模型
@property (strong, nonatomic) TNHomeCategoryModel *model;
+ (instancetype)configWithModel:(TNHomeCategoryModel *)model;
@end

NS_ASSUME_NONNULL_END
