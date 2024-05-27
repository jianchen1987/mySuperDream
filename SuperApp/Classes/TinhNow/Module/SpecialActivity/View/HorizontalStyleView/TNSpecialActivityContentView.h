//
//  TNSpecialActivityContentView.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNActivityCardRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSpecialActivityContentView : TNView <HDCategoryListContentViewDelegate>

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel categoryId:(NSString *)categoryId;
/// 分类id
@property (nonatomic, strong) NSString *categoryId;
/// 是否可以滚动
@property (nonatomic, assign) BOOL canScroll;
/// 视图即将拖拽滚动
@property (nonatomic, copy) void (^scrollerViewWillBegainDraggingCallBack)(void);
/// 视图结束拖拽
@property (nonatomic, copy) void (^scrollerViewDidEndDragCallBack)(void);
/// 视图滚动到最顶部回调
@property (nonatomic, copy) void (^scrollerViewScrollerToTopCallBack)(void);
/// 是否展示置顶按钮
@property (nonatomic, copy) void (^scrollerShowTopBtnCallBack)(BOOL isShow);
/// 获取新数据
- (void)getNewData;
/// 滚动到最顶部
- (void)scrollerToTop;
/// 重新刷新数据
- (void)refreshData;
/// 刷新广告位
- (void)reloadAdsData:(TNActivityCardRspModel *)rspModel;
@end

NS_ASSUME_NONNULL_END
