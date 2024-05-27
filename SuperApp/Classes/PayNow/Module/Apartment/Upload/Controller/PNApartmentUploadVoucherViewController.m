//
//  PNApartmentUploadVoucherViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentUploadVoucherViewController.h"
#import "PNApartmentUploadVoucherView.h"


@interface PNApartmentUploadVoucherViewController ()
@property (nonatomic, strong) PNApartmentUploadVoucherView *contentView;
@end


@implementation PNApartmentUploadVoucherViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Rent_bill", @"公寓缴费");
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

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNApartmentUploadVoucherView *)contentView {
    if (!_contentView) {
        _contentView = [[PNApartmentUploadVoucherView alloc] init];
        _contentView.paymentId = [self.parameters objectForKey:@"paymentId"];
    }
    return _contentView;
}

@end
