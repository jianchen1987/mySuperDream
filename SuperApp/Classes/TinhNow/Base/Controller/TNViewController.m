//
//  TNViewController.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNViewController.h"
#import "TNTabBarViewController.h"


@interface TNViewController ()
@property (nonatomic, strong) HDPlaceholderView *hd_placeholderView; ///< 占位控件
@end


@implementation TNViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hd_navItemLeftSpace = 15;
    self.hd_navItemRightSpace = 15;
    //微店也是一个tabBar要设置返回按钮
    if (self.navigationController.viewControllers.count > 1 || ![self.tabBarController isKindOfClass:[TNTabBarViewController class]]) {
        HDUIButton *backButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"tn_back_image_new"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(hd_backItemClick:) forControlEvents:UIControlEventTouchUpInside];
        self.hd_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [self trackingPage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

// 页面埋点
- (void)trackingPage {
    NSString *pageName = NSStringFromClass([self class]);
    id eventName = [[TNGlobalData trackingPageEventMap] objectForKey:pageName];
    if ([eventName isKindOfClass:[NSString class]]) {
        NSString *eventNameStr = eventName;
        if (HDIsStringNotEmpty(eventNameStr)) {
            pageName = eventNameStr;
        }
    }
    [TNEventTrackingInstance trackPage:pageName properties:nil];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)showNoDataPlaceHolderNeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^_Nullable)(void))refrenshCallBack {
    UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
    model.title = SALocalizedString(@"no_data", @"暂无数据");
    model.image = @"no_data_placeholder";
    model.needRefreshBtn = needRefrenshBtn;
    model.refreshBtnTitle = SALocalizedString(@"refresh", @"刷新");
    model.backgroundColor = [self.view.backgroundColor isEqual:UIColor.clearColor] ? UIColor.whiteColor : self.view.backgroundColor;
    [self showPlaceHolder:model NeedRefrenshBtn:needRefrenshBtn refrenshCallBack:refrenshCallBack];
}
- (void)showErrorPlaceHolderNeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^_Nullable)(void))refrenshCallBack {
    UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
    model.image = @"placeholder_network_error";
    model.title = SALocalizedString(@"network_error", @"网络开小差啦");
    model.needRefreshBtn = needRefrenshBtn;
    model.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
    model.backgroundColor = [self.view.backgroundColor isEqual:UIColor.clearColor] ? UIColor.whiteColor : self.view.backgroundColor;
    [self showPlaceHolder:model NeedRefrenshBtn:needRefrenshBtn refrenshCallBack:refrenshCallBack];
}
- (void)showPlaceHolder:(UIViewPlaceholderViewModel *)placeHolder NeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^)(void))refrenshCallBack {
    if (!self.hd_placeholderView) {
        self.hd_placeholderView = [[HDPlaceholderView alloc] init];
        [self.view addSubview:self.hd_placeholderView];
    }
    __weak __typeof(self) weakSelf = self;
    self.hd_placeholderView.tappedRefreshBtnHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removePlaceHolder];
        !refrenshCallBack ?: refrenshCallBack();
    };
    self.hd_placeholderView.hidden = false;
    [self.hd_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (self.hd_navigationBar && self.hd_navigationBar.isHidden == false) {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        } else {
            make.top.equalTo(self.view);
        }
    }];
    self.hd_placeholderView.model = placeHolder;
}
- (void)removePlaceHolder {
    if (self.hd_placeholderView) {
        [self.hd_placeholderView removeFromSuperview];
        self.hd_placeholderView = nil;
    }
}
@end


@implementation TNLoginlessViewController
#pragma mark - override
- (BOOL)needLogin {
    return false;
}
@end
