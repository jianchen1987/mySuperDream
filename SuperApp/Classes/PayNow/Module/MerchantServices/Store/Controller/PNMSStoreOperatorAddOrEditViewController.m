//
//  PNMSStoreOperatorAddOrEditViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorAddOrEditViewController.h"
#import "PNMSStoreManagerViewModel.h"
#import "PNMSStoreOperatorAddOrEditView.h"


@interface PNMSStoreOperatorAddOrEditViewController ()
@property (nonatomic, strong) PNMSStoreOperatorAddOrEditView *contentView;
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@end


@implementation PNMSStoreOperatorAddOrEditViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        if ([parameters.allKeys containsObject:@"storeOperatorId"]) {
            self.viewModel.storeOperatorId = [parameters objectForKey:@"storeOperatorId"];
        } else {
            /// 新增
            self.viewModel.storeOperatorInfoModel = [[PNMSStoreOperatorInfoModel alloc] init];
            self.viewModel.storeOperatorInfoModel.storeName = [parameters objectForKey:@"storeName"];
            self.viewModel.storeOperatorInfoModel.storeNo = [parameters objectForKey:@"storeNo"];
        }
        self.viewModel.canEidt = [[parameters objectForKey:@"canEdit"] boolValue];
    }
    return self;
}

- (void)hd_setupNavigation {
    if ([self.parameters.allKeys containsObject:@"storeOperatorId"]) {
        self.boldTitle = PNLocalizedString(@"pn_edit_store_operator", @"编辑店员");
    } else {
        self.boldTitle = PNLocalizedString(@"pn_add_store_operator", @"添加店员");
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
- (PNMSStoreOperatorAddOrEditView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSStoreOperatorAddOrEditView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSStoreManagerViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSStoreManagerViewModel.new);
}
@end
