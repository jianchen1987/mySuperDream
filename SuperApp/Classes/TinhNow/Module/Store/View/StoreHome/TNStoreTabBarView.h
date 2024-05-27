//
//  TNStoreTabBarView.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TNStoreTabBarViewItemClickType) {
    TNStoreTabBarViewItemClickTypeHome = 0,     //首页
    TNStoreTabBarViewItemClickTypeCategory = 1, //分类
    TNStoreTabBarViewItemClickTypeCustomer = 2, // 客服
};


@interface TNStoreTabBarView : TNView
/// 首页点击
@property (nonatomic, copy) void (^homeClickCallBack)(void);
/// 分类点击
@property (nonatomic, copy) void (^categoryClickCallBack)(void);
/// 客服点击
@property (nonatomic, copy) void (^customerClickCallBack)(void);
///代码发送点击事件
- (void)sendActiconClickType:(TNStoreTabBarViewItemClickType)type;
@end

NS_ASSUME_NONNULL_END
