//
//  PNWalletController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNWalletController.h"
#import "PNContactUSWindow.h"
#import "PNNotificationMacro.h"
#import "PNWalletView.h"
#import "PNWalletViewModel.h"
#import "VipayUser.h"


@interface PNWalletController ()
@property (nonatomic, strong) UIImageView *bgImgView;
/// 列表
@property (nonatomic, strong) PNWalletView *contentView;
/// 设置按钮
@property (nonatomic, strong) HDUIButton *recordButton;

@property (nonatomic, strong) SALabel *coolCashLabel;
/// 交易记录
@property (nonatomic, strong) HDUIButton *navBtn;

@property (nonatomic, strong) PNWalletViewModel *viewModel;

@end


@implementation PNWalletController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.viewModel.routPath = [parameters objectForKey:@"routPath"];
    if ([VipayUser isLogin]) {
        [self.viewModel hd_bindView:self.contentView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [PNContactUSWindow.sharedInstance show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PNContactUSWindow.sharedInstance.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    PNContactUSWindow.sharedInstance.hidden = YES;
}

#pragma mark - SAViewControllerProtocol
- (BOOL)needCheckPayPwd {
    return true;
}

- (BOOL)allowContinuousBePushed {
    return NO;
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];

    [self.KVOController hd_observe:self.viewModel keyPath:@"settingRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];

        if (!WJIsArrayEmpty(VipayUser.shareInstance.functionModel.SETTING)) {
            [arr addObject:[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
        }

        self.hd_navRightBarButtonItems = arr;
    }];
}

- (void)hd_getNewData {
    [self.contentView beginGetNewData];
}

- (void)hd_setupViews {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.contentView];

    [self addNotification];
}

- (void)hd_setupNavigation {
}

- (void)hd_languageDidChanged {
    self.boldTitle = SALocalizedString(@"wallet", @"钱包");
}

- (void)updateViewConstraints {
    [self.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        //        make.size.mas_equalTo(self.bgImgView.image.size);
        make.width.mas_equalTo(self.bgImgView.image.size.width);
        make.height.mas_equalTo(self.hd_navigationBar.mas_height);
    }];

    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark
- (void)addNotification {
    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getNewdata) name:kNOTIFICATIONSuccessOpenWallet object:nil];
    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getNewdata) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)getNewdata {
    if ([VipayUser shareInstance].loginName.length <= 0) {
        HDUserRegisterRspModel *RegisterRspModel = HDUserRegisterRspModel.new;
        RegisterRspModel.loginName = [SAUser shared].loginName;
        [VipayUser loginWithModel:RegisterRspModel];
    }
    [self.contentView beginGetNewData];
}
//更新用户数据
- (void)userLoginHandler {
    HDUserRegisterRspModel *RegisterRspModel = HDUserRegisterRspModel.new;
    RegisterRspModel.loginName = [SAUser shared].loginName;
    [VipayUser loginWithModel:RegisterRspModel];
}

- (void)userLogoutHandler {
    [[VipayUser shareInstance] logout];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNOTIFICATIONSuccessOpenWallet object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark
- (PNWalletView *)contentView {
    if (!_contentView) {
        _contentView = [[PNWalletView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"icon_settings"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowSettingVC:@{}];
        }];
        _navBtn = button;
    }
    return _navBtn;
}

- (HDUIButton *)recordButton {
    if (!_recordButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"pn_record_white"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowBillListVC:@{}];
        }];
        _recordButton = button;
    }
    return _recordButton;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = iPhoneXSeries ? [UIImage imageNamed:@"pn_nav_bg_x"] : [UIImage imageNamed:@"pn_nav_bg"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImgView;
}

- (PNWalletViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNWalletViewModel alloc] init];
    }
    return _viewModel;
}
@end
