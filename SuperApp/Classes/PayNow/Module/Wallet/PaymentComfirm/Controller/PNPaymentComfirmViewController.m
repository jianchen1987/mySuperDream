//
//  PNPaymentComfirmViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentComfirmViewController.h"
#import "PNPaymentComfirmDTO.h"
#import "PNPaymentComfirmRspModel.h"
#import "PNPaymentComfirmView.h"
#import "PNPaymentComfirmViewModel.h"
#import "PNPaymentResultViewController.h"


@interface PNPaymentComfirmViewController ()
@property (nonatomic, strong) PNPaymentComfirmViewModel *viewModel;
@property (nonatomic, strong) PNPaymentComfirmView *contentView;
@property (nonatomic, strong) PNPaymentComfirmDTO *paymentComfirmDTO;

@end


@implementation PNPaymentComfirmViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.buildModel = [PNPaymentBuildModel yy_modelWithJSON:[parameters objectForKey:@"data"]];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"BTN_TITLE_CONFIRM_PAY", @"确认支付");
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userGoBack:)]) {
        [self.delegate userGoBack:self];
    }

    if (self.viewModel.buildModel.fromType == PNPaymentBuildFromType_Default) {
        [NAT showAlertWithMessage:PNLocalizedString(@"ALERT_MSG_CANCEL_TRANSATION", @"是否放弃本次交易?") confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];

                ///调用一下关闭订单 - 根据类型来关闭（有些订单是不需要关闭）
                [super hd_backItemClick:sender];
            }
            cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
    } else {
        [super hd_backItemClick:sender];
    }
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

#pragma mark
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNPaymentComfirmView *)contentView {
    if (!_contentView) {
        _contentView = [[PNPaymentComfirmView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNPaymentComfirmViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNPaymentComfirmViewModel alloc] init];
    }
    return _viewModel;
}
@end
