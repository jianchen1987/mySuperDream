//
//  TNSpecialVerticalStyleView.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSpecialVerticalStyleView : TNView
/// 是否可以滚动
@property (nonatomic, assign) BOOL canScroll;
/// 视图滚动到最顶部回调
@property (nonatomic, copy) void (^scrollerViewScrollerToTopCallBack)(void);
/// 是否展示置顶按钮
@property (nonatomic, copy) void (^scrollerShowTopBtnCallBack)(BOOL isShow);
/// 滚动到最顶部
- (void)scrollerToTop;
/// 保持内部滑动位置
- (void)keepScollerContentOffset;
///// 重新刷新数据
- (void)refreshListData;
/// 刷新分类
- (void)refreshCategory;
@end

NS_ASSUME_NONNULL_END
