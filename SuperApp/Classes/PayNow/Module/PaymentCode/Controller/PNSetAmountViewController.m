//
//  PNSetAmountViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNSetAmountViewController.h"
#import "PNSetAmountView.h"
#import "PNWalletLimitModel.h"


@interface PNSetAmountViewController ()
@property (nonatomic, strong) PNSetAmountView *contentView;
@end


@implementation PNSetAmountViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.contentView.amountType = [[parameters objectForKey:@"type"] integerValue];
        self.contentView.callback = [parameters objectForKey:@"callback"];
    }
    return self;
}

- (void)hd_setupViews {
    self.boldTitle = PNLocalizedString(@"set_amount", @"设置金额");
    self.view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self.view addSubview:self.contentView];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNSetAmountView *)contentView {
    if (!_contentView) {
        _contentView = [[PNSetAmountView alloc] init];

        //        @HDWeakify(self);
        //        _contentView.confirmBlock = ^(NSString *_Nonnull accountType, NSString *_Nonnull amount) {
        //            HDLog(@"%@ - %@", accountType, amount);
        //            @HDStrongify(self);
        //            if (self.delegate && [self.delegate respondsToSelector:@selector(callBackAmount:currency:)]) {
        //                [self.delegate callBackAmount:amount currency:accountType];
        //            }
        //            [self.navigationController popViewControllerAnimated:YES];
        //        };
    }
    return _contentView;
}

@end
