//
//  TNProductNavigationBarView.h
//  SuperApp
//
//  Created by 张杰 on 2020/12/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductNavigationBarView : TNView
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
/// 购物车回调
@property (nonatomic, copy) void (^shopCartcallBack)(void);
/// 点击标题回调
@property (nonatomic, copy) void (^selectedItemCallBack)(NSInteger index);
/// alpha
- (void)updateUIWithScrollViewOffsetY:(CGFloat)offsetY;
/// 获取当前index
- (NSInteger)currentTitleIndex;
///更新标题栏的选中位置
- (void)updateSectionViewSelectedItemWithIndex:(NSInteger)index;

/// 用于接口异常 隐藏
- (void)hiddenShareAndMoreBtn;
- (void)showMoreBtn;

@end

NS_ASSUME_NONNULL_END
