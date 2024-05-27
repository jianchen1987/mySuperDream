//
//  GNOrderHomeViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderHomeViewController.h"
#import "GNNewsViewModel.h"
#import "GNOrderDTO.h"
#import "GNOrderViewController.h"
#import "SAOrderNotLoginView.h"
#import "SATabBar.h"
#import "SATabBarButton.h"
#import "WMZPageView.h"


@interface GNOrderHomeViewController ()
/// 网络请求
@property (nonatomic, strong) GNOrderDTO *orderDTO;
/// 对比前后的数量 更新数据
@property (nonatomic, strong) NSDictionary *numInfo;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
/// 子控制器对应的index
@property (nonatomic, strong) NSDictionary *controllerInfo;
/// viewModel
@property (nonatomic, strong) GNNewsViewModel *viewModel;
/// pageView
@property (nonatomic, strong) WMZPageView *pageView;
@end


@implementation GNOrderHomeViewController

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.boldTitle = GNLocalizedString(@"gn_order_my", @"我的订单");
    self.hd_navLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.backBtn]];
    @HDWeakify(self)[self.backBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        @HDStrongify(self)[self dismissAnimated:YES completion:nil];
    }];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    NSArray *orderType = @[GNOrderStatusAll, GNOrderStatusUse, GNOrderStatusFinish, GNOrderStatusCancel];
    WMZPageParam *param = WMZPageParam.new;
    param.wCustomNaviBarY = ^CGFloat(CGFloat nowY) {
        return kNavigationBarH;
    };
    param.wCustomTabbarY = ^CGFloat(CGFloat nowY) {
        return kTabBarH;
    };
    param.wHideRedCircle = NO;
    param.wMenuTitleUIFont = [HDAppTheme.font gn_ForSize:14];
    param.wMenuTitleSelectUIFont = [HDAppTheme.font gn_boldForSize:14];
    param.wMenuTitleWidth = (kScreenWidth - kRealWidth(60)) / 3.0;
    param.wTitleArr = @[
        @{
            WMZPageKeyName: GNLocalizedString(@"gn_order_all", @"全部"),
            WMZPageKeyTitleWidth: @(kRealWidth(60)),
        },
        GNLocalizedString(@"gn_order_unuse", @"待使用"),
        GNLocalizedString(@"gn_order_finish", @"已完成"),
        GNLocalizedString(@"gn_order_canced", @"已取消"),
    ];
    param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
        GNOrderViewController *orderVC = GNOrderViewController.new;
        orderVC.orderStatus = orderType[index];
        return orderVC;
    };
    self.pageView = [[WMZPageView alloc] initWithFrame:self.view.bounds param:param parentReponder:self];
    self.pageView.hidden = !SAUser.hasSignedIn;
    [self.view addSubview:self.notSignInView];
    [self.view addSubview:self.pageView];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
}

- (void)updateViewConstraints {
    [self.notSignInView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (void)hd_languageDidChanged {
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = SALocalizedString(@"view_order_after_sign_in", @"登录后可查看订单");
        [self.notSignInView.signInSignUpBTN setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [self getUnReadCount];
}

- (void)getData {
    if (!SAUser.hasSignedIn)
        return;
    @HDWeakify(self)[self.orderDTO orderListCountRequestSuccess:^(SARspModel *_Nonnull rspModel) {
        @HDStrongify(self) NSDictionary *info = (NSDictionary *)rspModel.data;
        if (info && [info isKindOfClass:NSDictionary.class]) {
            if (self.numInfo && [self.numInfo allKeys].count == [info allKeys].count) {
                __block BOOL change = NO;
                [self.numInfo enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
                    if ([obj isKindOfClass:NSNumber.class] && [info[key] isKindOfClass:NSNumber.class] && obj.intValue != [info[key] intValue]) {
                        change = YES;
                        /// 数量不相等 刷新对应子控制器
                        [self changeSonVCData:key];
                    }
                }];
                if (change) {
                    /// 更新全部的list
                    [self changeSonVCData:@"All"];
                }
            }
            [self.pageView.upSc.btnArr[1] showBadgeWithTopMagin:@{WMZPageKeyBadge: [self checkMore:info[@"toBeUser"]]}];
            [self.pageView.upSc.btnArr[2] showBadgeWithTopMagin:@{WMZPageKeyBadge: [self checkMore:info[@"finished"]]}];
            [self.pageView.upSc.btnArr[3] showBadgeWithTopMagin:@{WMZPageKeyBadge: [self checkMore:info[@"canceled"]]}];
            self.numInfo = [NSDictionary dictionaryWithDictionary:info];
        }
    } failure:nil];
}

- (NSString *)checkMore:(NSString *)more {
    if (more && [more integerValue] > 99) {
        return @"99+";
    }
    return more;
}

/// 根据tag更新对应的list数据
- (void)changeSonVCData:(NSString *)tag {
    NSNumber *number = self.controllerInfo[tag];
    if (!number || [number intValue] < 0)
        return;
    GNOrderViewController *orderController = (GNOrderViewController *)[self.pageView.cache objectForKey:number];
    if (!orderController || ![orderController isKindOfClass:GNOrderViewController.class])
        return;
    if (orderController.viewModel.dataSource) {
        [orderController requestData:1];
    }
}

#pragma mark - Notification
- (void)userLoginHandler {
    self.notSignInView.hidden = true;
    self.pageView.hidden = false;
    [self getData];
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
    self.pageView.hidden = true;
}

/// 获取未读数量
- (void)getUnReadCount {
    if (self.notSignInView.isHidden) {
        @HDWeakify(self);
        [self.viewModel.newsDTO getUnreadSystemMessageCountBlock:^(NSUInteger station) {
            @HDStrongify(self);
            SATabBarButton *tabbarBtn = [self getCurrentTabBarButton];
            tabbarBtn.config.badgeValue = station ? @" " : @"";
            [tabbarBtn setConfig:[self getCurrentTabBarButton].config];
        }];
    }
}

- (GNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = GNOrderDTO.new;
    }
    return _orderDTO;
}

- (GNNewsViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNNewsViewModel.new; });
}

- (SAOrderNotLoginView *)notSignInView {
    if (!_notSignInView) {
        _notSignInView = SAOrderNotLoginView.new;
        _notSignInView.hidden = SAUser.hasSignedIn;
        _notSignInView.clickedSignInSignUpBTNBlock = ^{
            [SAWindowManager switchWindowToLoginViewController];
        };
    }
    return _notSignInView;
}

- (SATabBarButton *)getCurrentTabBarButton {
    SATabBar *tabbar = (SATabBar *)self.tabBarController.tabBar;
    if ([tabbar isKindOfClass:SATabBar.class] && tabbar.buttons.count > 2) {
        return tabbar.buttons[2];
    }
    return nil;
}

- (NSDictionary *)controllerInfo {
    if (!_controllerInfo) {
        _controllerInfo = @{
            @"All": @(0),
            @"toBeUser": @(1),
            @"finished": @(2),
            @"canceled": @(3),
            @"forThePayment": @(-1),
        };
    }
    return _controllerInfo;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

@end
