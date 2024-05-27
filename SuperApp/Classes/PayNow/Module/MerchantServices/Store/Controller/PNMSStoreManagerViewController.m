//
//  PNMSStoreManagerViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreManagerViewController.h"
#import "PNMSStoreManagerView.h"
#import "PNMSStoreManagerViewModel.h"


@interface PNMSStoreManagerViewController ()
@property (nonatomic, strong) PNMSStoreManagerView *contentView;
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@property (nonatomic, strong) HDUIButton *addBtn;
@end


@implementation PNMSStoreManagerViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_store_manager", @"门店管理");

    if (VipayUser.shareInstance.role != PNMSRoleType_STORE_MANAGER) {
        self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.addBtn]];
    }
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

- (void)hd_getNewData {
    [self.viewModel getNewData:YES];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSStoreManagerView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSStoreManagerView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSStoreManagerViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSStoreManagerViewModel.new);
}

- (HDUIButton *)addBtn {
    if (!_addBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_add_store", @"新建门店") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAddOrEditStoreVC:@{
                @"model": [self.viewModel.storeInfoModel yy_modelToJSONObject],
            }];
        }];

        _addBtn = button;
    }
    return _addBtn;
}

@end
