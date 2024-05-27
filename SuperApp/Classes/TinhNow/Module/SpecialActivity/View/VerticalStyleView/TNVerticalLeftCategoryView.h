//
//  TNVerticalLeftCategoryView.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNVerticalLeftCategoryView : TNView
/// 是否可以滚动
@property (nonatomic, assign) BOOL canScroll;
/// 分类点击回调
@property (nonatomic, copy) void (^categoryClickCallBack)(NSString *categoryId, NSInteger index, BOOL isNeedLoadNewData);
/// 视图滚动到最顶部回调
@property (nonatomic, copy) void (^scrollerViewScrollerToTopCallBack)(void);
/// 滚动到最顶部
- (void)scrollerToTop;
@end

NS_ASSUME_NONNULL_END
