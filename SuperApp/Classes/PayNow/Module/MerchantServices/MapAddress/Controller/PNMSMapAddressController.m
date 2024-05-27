//
//  PNMSMapAddressController.m
//  SuperApp
//
//  Created by xixi on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSMapAddressController.h"
#import "PNMSMapAddressView.h"
#import "PNMSMapAddressViewModel.h"


@interface PNMSMapAddressController ()
@property (nonatomic, strong) PNMSMapAddressViewModel *viewModel;
@property (nonatomic, strong) PNMSMapAddressView *contentView;
@end


@implementation PNMSMapAddressController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.choosedAddressBlock = [parameters objectForKey:@"callback"];
        self.viewModel.addressModel = [SAAddressModel yy_modelWithJSON:[parameters objectForKey:@"address"]];
        self.viewModel.currentSelectProvince = self.viewModel.addressModel.state ?: @"";
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_ms_use_adddress", @"使用该地址");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

#pragma mark
- (PNMSMapAddressView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSMapAddressView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSMapAddressViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSMapAddressViewModel.new);
}

@end
