//
//  WMStoreDetailHeaderView.h
//  SuperApp
//
//  Created by wmz on 2023/2/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMCNStoreInfoView.h"

@class WMCNStoreInfoView;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreDetailHeaderView : SAView
/// 模型
@property (nonatomic, strong) WMStoreDetailRspModel *model;
/// showDetail
@property (nonatomic, assign) BOOL showDetail;
/// storeInfoView
@property (nonatomic, strong) WMCNStoreInfoView *storeInfoView;
/// 更多
@property (nonatomic, strong) HDUIButton *moreBtn;
/// 背景
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) void (^videoTapClick)(HDCyclePagerView *pagerView, NSIndexPath *indexPath, NSURL *videoUrl);

@property (nonatomic, copy) void (^videoAutoPlayCallBack)(NSURL *url);         ///< 视频自动播放回调
/// 更新更多按钮的状态
- (void)updateMoreBtnSelect:(BOOL)select;
/// 更多点击
- (void)moreClickAction;
/// 改变透明度
- (void)changeAlpah:(CGFloat)alpah;

@end

NS_ASSUME_NONNULL_END
