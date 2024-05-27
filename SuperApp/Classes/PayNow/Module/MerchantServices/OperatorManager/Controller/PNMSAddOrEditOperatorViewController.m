//
//  PNMSAddOrEditOperatorViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSAddOrEditOperatorViewController.h"
#import "PNMSAddOrEditOperatorView.h"
#import "PNMSOperatorInfoModel.h"
#import "PNMSOperatorViewModel.h"


@interface PNMSAddOrEditOperatorViewController ()
@property (nonatomic, strong) PNMSAddOrEditOperatorView *contentView;
@property (nonatomic, strong) PNMSOperatorViewModel *viewModel;
@end


@implementation PNMSAddOrEditOperatorViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.operatorMobile = [parameters objectForKey:@"operatorMobile"];
        if (WJIsStringEmpty(self.viewModel.operatorMobile)) {
            self.viewModel.operatorInfoModel = [PNMSOperatorInfoModel new];
        }
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    if (WJIsStringEmpty(self.viewModel.operatorMobile)) {
        self.boldTitle = PNLocalizedString(@"pn_add_operator", @"添加操作员");
    } else {
        self.boldTitle = PNLocalizedString(@"pn_edit_operator", @"编辑操作员");
    }
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
- (PNMSAddOrEditOperatorView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSAddOrEditOperatorView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSOperatorViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSOperatorViewModel.new);
}

@end
