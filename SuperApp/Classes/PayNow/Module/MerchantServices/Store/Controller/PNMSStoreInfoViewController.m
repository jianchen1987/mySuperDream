//
//  PNMSStoreInfoViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreInfoViewController.h"
#import "PNMSStoreInfoView.h"
#import "PNMSStoreManagerViewModel.h"


@interface PNMSStoreInfoViewController ()
@property (nonatomic, strong) PNMSStoreInfoView *contentView;
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@property (nonatomic, strong) HDUIButton *editBtn;
@end


@implementation PNMSStoreInfoViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.storeNo = [parameters objectForKey:@"storeNo"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_store_detail", @"门店详情");

    if (VipayUser.shareInstance.role == PNMSRoleType_MANAGEMENT || VipayUser.shareInstance.role == PNMSRoleType_OPERATOR) {
        self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.editBtn]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel getStoreInfo];
}

- (void)hd_getNewData {
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSStoreInfoView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSStoreInfoView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSStoreManagerViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSStoreManagerViewModel.new);
}

- (HDUIButton *)editBtn {
    if (!_editBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_edit", @"编辑") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAddOrEditStoreVC:@{
                @"model": [self.viewModel.storeInfoModel yy_modelToJSONObject],
            }];
        }];

        _editBtn = button;
    }
    return _editBtn;
}

@end
