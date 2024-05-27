//
//  TNSpecialHorizontalStyleView.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSpecialHorizontalStyleView : TNView
//刷新列表数据
- (void)refreshListData;
/// 是否可以滚动
@property (nonatomic, assign) BOOL canScroll;
/// 视图滚动到最顶部回调
@property (nonatomic, copy) void (^scrollerViewScrollerToTopCallBack)(void);
/// 是否展示置顶按钮
@property (nonatomic, copy) void (^scrollerShowTopBtnCallBack)(BOOL isShow);
/// 滚动到最顶部
- (void)scrollerToTop;
/// 重置视图
- (void)resetView;
@end

NS_ASSUME_NONNULL_END
