//
//  TNSearchFilterView.h
//  SuperApp
//
//  Created by seeu on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNFilterEnum.h"
#import "TNFilterOptionProtocol.h"
#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNSearchFilterView;

@protocol TNSearchFilterViewDelegate <NSObject>

/// 确认回调
/// @param options 筛选参数
- (void)TNSearchFilterView:(TNSearchFilterView *)filterView confirmWithFilterOptions:(NSDictionary<TNSearchFilterOptions, NSObject *> *)options;
- (void)TNSearchFilterView:(TNSearchFilterView *)filterView clickedOnCancelButton:(HDUIButton *)cancel;
/// 重置
- (void)TNSearchFilterView:(TNSearchFilterView *)filterView clickedOnResetButton:(HDUIButton *)reset;
@end


@interface TNSearchFilterView : TNView

/// delegate
@property (nonatomic, weak) id<TNSearchFilterViewDelegate> delegate;
/// 容器内边距
@property (nonatomic, assign) UIEdgeInsets filterContainerEdgeInsets;
/// 是否展开
@property (atomic, assign) BOOL showing;
/// 筛选视图高度
@property (nonatomic, assign, readonly) CGFloat filterContainerHeight;

/// 初始化筛选框
/// @param behindView 筛选框会在behindView下面弹出
- (instancetype)initWithView:(UIView *)behindView;

- (void)addFilter:(UIView<TNFilterOptionProtocol> *)filter;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
