//
//  TNBargainProductNavBarView.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNBargainProductNavBarView : TNView
/// 标题数据源
@property (strong, nonatomic) NSArray *titleArr;
/// 分享回调
@property (nonatomic, copy) void (^shareCallBack)(void);
/// 拨打电话回调
@property (nonatomic, copy) void (^callPhoneCallBack)(void);
/// 搜索回调
@property (nonatomic, copy) void (^searchCallBack)(void);
/// 更多回调
@property (nonatomic, copy) void (^moreCallBack)(HDUIButton *sender);
/// 点击标题回调
@property (nonatomic, copy) void (^selectedItemCallBack)(NSInteger index);
/// alpha
- (void)updateUIWithScrollViewOffsetY:(CGFloat)offsetY;
/// 获取当前index
- (NSInteger)currentTitleIndex;
///更新标题栏的选中位置
- (void)updateSectionViewSelectedItemWithIndex:(NSInteger)index;
///隐藏分享按钮
- (void)hiddinShareBtn;

/// 用于接口异常 隐藏
- (void)hiddenShareAndMoreBtn;
- (void)showShareBtn;
- (void)showMoreBtn;
@end

NS_ASSUME_NONNULL_END
