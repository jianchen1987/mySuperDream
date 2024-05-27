//
//  TNOneLevelCategoryFilterView.h
//  SuperApp
//
//  Created by 张杰 on 2022/5/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCategoryModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOneLevelCategoryFilterView : TNView
/// 选中分类回调
@property (nonatomic, copy) void (^selectedCategoryCallBack)(TNCategoryModel *model);
/// 初始化筛选框
/// @param behindView 筛选框会在behindView下面弹出
/// @param categoryArr  分类数组
- (instancetype)initWithView:(UIView *)behindView categoryArr:(NSArray<TNCategoryModel *> *)categoryArr;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
