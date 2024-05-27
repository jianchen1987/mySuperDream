//
//  TNMicroShopLeftCategoryView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNFirstLevelCategoryModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopLeftCategoryView : TNView
/// 一级分类数据源
@property (nonatomic, strong) NSArray<TNFirstLevelCategoryModel *> *dataArr;
/// 点击回调
@property (nonatomic, copy) void (^categoryClickCallBack)(TNFirstLevelCategoryModel *model);
@end

NS_ASSUME_NONNULL_END
