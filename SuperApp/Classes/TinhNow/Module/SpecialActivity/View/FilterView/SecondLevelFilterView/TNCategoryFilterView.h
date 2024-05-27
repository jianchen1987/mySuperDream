//
//  TNCategoryFilterView.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCategoryFilterView : TNView
/// 是否在展示中
@property (nonatomic, assign) BOOL isShowing;
/// 视图消失后的回调
@property (nonatomic, copy) void (^dismissCallBack)(void);
/// 选中的分类回调 targetIndex 一级分类id 在数组的位置 childId 二级分类id  可能多个转成json
@property (nonatomic, copy) void (^selectedCallBack)(NSInteger targetIndex, NSString *childId);
/// 初始化筛选框
/// @param behindView 筛选框会在behindView下面弹出
/// @param categoryArr  分类数组
- (instancetype)initWithView:(UIView *)behindView categoryArr:(NSArray *)categoryArr;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
