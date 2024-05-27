//
//  PNMSStoreOperatorManagerViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorManagerViewController.h"
#import "PNMSStoreManagerViewModel.h"
#import "PNMSStoreOperatorManagerView.h"


@interface PNMSStoreOperatorManagerViewController ()
@property (nonatomic, strong) HDUIButton *addBtn;
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@property (nonatomic, strong) PNMSStoreOperatorManagerView *contentView;
@end


@implementation PNMSStoreOperatorManagerViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.storeNo = [parameters objectForKey:@"storeNo"];
        self.viewModel.storeName = [parameters objectForKey:@"storeName"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = self.viewModel.storeName;
    if (VipayUser.shareInstance.role != PNMSRoleType_STORE_STAFF) {
        self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.addBtn]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contentView loadData];
}

- (void)hd_getNewData {
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSStoreOperatorManagerView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSStoreOperatorManagerView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSStoreManagerViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSStoreManagerViewModel.new);
}

- (HDUIButton *)addBtn {
    if (!_addBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_add", @"添加") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesStoreOperatorAddOrEditVC:@{
                @"storeNo": self.viewModel.storeNo,
                @"storeName": self.viewModel.storeName,
                @"canEdit": @(YES),
            }];
        }];

        _addBtn = button;
    }
    return _addBtn;
}

@end
