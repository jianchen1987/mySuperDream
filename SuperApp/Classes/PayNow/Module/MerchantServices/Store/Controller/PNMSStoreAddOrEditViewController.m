//
//  PNMSStoreAddOrEditViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreAddOrEditViewController.h"
#import "PNMSStoreAddOrEditView.h"
#import "PNMSStoreManagerViewModel.h"


@interface PNMSStoreAddOrEditViewController ()
@property (nonatomic, strong) PNMSStoreAddOrEditView *contentView;
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@end


@implementation PNMSStoreAddOrEditViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        if ([parameters.allKeys containsObject:@"model"]) {
            self.viewModel.storeInfoModel = [PNMSStoreInfoModel yy_modelWithJSON:[parameters objectForKey:@"model"]];
        } else {
            self.viewModel.storeInfoModel = [PNMSStoreInfoModel new];
        }
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_stroe_info", @"门店信息");
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
- (PNMSStoreAddOrEditView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSStoreAddOrEditView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSStoreManagerViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSStoreManagerViewModel.new);
}

@end
