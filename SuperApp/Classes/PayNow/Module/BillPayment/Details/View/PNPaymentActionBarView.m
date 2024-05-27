//
//  PNPaymentActionBar.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPaymentActionBarView.h"


@interface PNPaymentActionBarView ()
@property (nonatomic, strong) SAOperationButton *closeButton;
@end


@implementation PNPaymentActionBarView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    self.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.closeButton];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(10));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(kRealWidth(-10));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)closeOrderAction {
    [NAT showAlertWithMessage:PNLocalizedString(@"sure_close_order", @"确定关闭订单吗？") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
        confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];

            !self.clickCloseActionBlock ?: self.clickCloseActionBlock();
        }
        cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
        }];
}

#pragma mark
- (SAOperationButton *)closeButton {
    if (!_closeButton) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitle:PNLocalizedString(@"close", @"关闭") forState:0];
        [button addTarget:self action:@selector(closeOrderAction) forControlEvents:UIControlEventTouchUpInside];
        _closeButton = button;
    }
    return _closeButton;
}

@end
