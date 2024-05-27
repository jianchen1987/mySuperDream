//
//  WMRestaurantNavigationBarView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

/// 外卖导航栏，抽为自定义 View 方便定制
@interface WMRestaurantNavigationBarView : SAView

/// 分享
@property (nonatomic, copy) void (^shareStore)(void);
/// 门店内搜索
@property (nonatomic, copy) void (^searchInStore)(void);
/// 收藏
@property (nonatomic, copy) void (^favouriteStore)(void);
/// 消息
@property (nonatomic, copy) void (^newList)(void);
- (void)updateTitle:(NSString *)title;
- (void)updateFavouriteBTN:(BOOL)favourite;
- (void)showOrHiddenFunctionBTN:(BOOL)show;

/// 根据 UIScrollView 偏移更新 UI
- (void)updateUIWithScrollViewOffsetY:(CGFloat)offsetY;

- (void)updateCNUIWithScrollViewOffsetY:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END
