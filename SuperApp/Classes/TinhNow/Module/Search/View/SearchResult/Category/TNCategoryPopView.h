//
//  TNCategoryPopView.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNCategoryModel;


@interface TNCategoryPopView : TNView
/// 点击回调
@property (nonatomic, copy) void (^itemClickCallBack)(TNCategoryModel *targetModel);
/// 初始化筛选框
/// @param categoryArr  分类数组
- (instancetype)initWithCategoryArr:(NSArray *)categoryArr;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
