//
//  SAViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+YumNow.h"
#import "HDMediator+PayNow.h"
#import "NSArray+SASudokuMasonry.h"
#import "SAAppTheme.h"
#import "SACacheManager.h"
#import "SALabel.h"
#import "SAMultiLanguageManager.h"
#import "SAMultiLanguageRespond.h"
#import "SANotificationConst.h"
#import "SAOperationButton.h"
#import "SAViewControllerProtocol.h"
#import "SAWindowManager.h"
#import "UITabBarController+SATabbar.h"
#import "WMAppTheme.h"
#import "WMModel.h"
#import "WMViewModel.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAViewController : HDCommonViewController <SAViewControllerProtocol, SAViewControllerRoutableProtocol, SAMultiLanguageRespond>

/// 设置加粗标题（17 bold, #343B4D）
@property (nonatomic, copy) NSString *boldTitle;
/// 滚动容器
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
/// 撑大 UIScrollView 的 UIView
@property (nonatomic, strong, readonly) UIView *scrollViewContainer;
/**
 设置加粗标题，带颜色

 @param color 颜色
 */
- (void)setBoldWithTitle:(NSString *)title color:(UIColor *)color;

/// 路由参数
@property (nonatomic, copy) NSDictionary<NSString *, id> *parameters;

///
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters NS_REQUIRES_SUPER;
- (void)hd_setupViews;
- (void)hd_bindViewModel;
- (void)hd_getNewData;
- (void)hd_setupNavigation;


@end

/** 不需要登录的界面 */
@interface SALoginlessViewController : SAViewController
@end

NS_ASSUME_NONNULL_END
