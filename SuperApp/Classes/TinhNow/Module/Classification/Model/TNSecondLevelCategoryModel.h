//
//  TNSecondLevelCategoryModel.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSecondLevelCategoryModel : TNModel
/// 分类名字
@property (nonatomic, copy) NSString *name;
/// 备注
@property (nonatomic, copy) NSString *memo;
/// 分类id
@property (nonatomic, copy) NSString *categoryId;
/// 品牌还是商品分类
@property (nonatomic, copy) TNCategoryType type;
/// 三级分类商品数据源
@property (nonatomic, strong) NSArray<TNCategoryModel *> *productCategories;
/// 三级分类品牌数据源
@property (nonatomic, strong) NSArray<TNCategoryModel *> *brands;
@end

NS_ASSUME_NONNULL_END
