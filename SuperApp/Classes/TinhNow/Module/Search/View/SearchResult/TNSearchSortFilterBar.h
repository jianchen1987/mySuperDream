//
//  TNSearchSortFilterBar.h
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNSearchBaseViewModel;


@interface TNSearchSortFilterBar : TNView
@property (nonatomic, strong) TNSearchBaseViewModel *viewModel;
/// 弹窗输入框点击回调  可以重新设置键盘出来后的偏移量
@property (nonatomic, copy) void (^clickShowFilterViewCallBack)(CGFloat updateOffsetY);
/// 点击了搜索条件回调
@property (nonatomic, copy) void (^clickFilterConditionCallBack)(void);
//隐藏最右边筛选按钮
- (void)hideRightFilterBtn;
//隐藏销量筛选按钮
- (void)hideSaleSortBtn;
@end

NS_ASSUME_NONNULL_END
