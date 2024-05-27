//
//  TNPaymentResultViewController.m
//  SuperApp
//
//  Created by seeu on 2020/8/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPaymentResultViewController.h"
#import "SAOperationButton.h"
#import "SAShadowBackgroundView.h"
#import "SAUserCenterDTO.h"
#import "SAWPointReceiveInfoView.h"


@implementation TNPaymentResultModel

@end


@interface TNPaymentResultViewController ()

/// 容器
@property (nonatomic, strong) SAShadowBackgroundView *containerView;
/// 状态图片
@property (nonatomic, strong) UIImageView *stateImageView;
/// 状态
@property (nonatomic, strong) UILabel *stateLabel;
/// 状态描述
@property (nonatomic, strong) UILabel *stateDescLabel;
/// 金额
@property (nonatomic, strong) UILabel *amountLabel;
/// 左边按钮
@property (nonatomic, strong) SAOperationButton *leftButton;
/// 右边按钮
@property (nonatomic, strong) SAOperationButton *rightButton;
///< 积分获取提示
@property (nonatomic, strong) SAWPointReceiveInfoView *wpointView;

@end


@implementation TNPaymentResultViewController

- (void)hd_setupViews {
    [self.view addSubview:self.containerView];
    self.view.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self.containerView addSubview:self.stateImageView];
    [self.containerView addSubview:self.stateLabel];
    [self.containerView addSubview:self.wpointView];
    [self.containerView addSubview:self.stateDescLabel];
    [self.containerView addSubview:self.amountLabel];

    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    [self queryWPoint];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hd_navLeftBarButtonItem = nil;
}

- (void)updateViewConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarH + 15);
    }];

    [self.stateImageView sizeToFit];
    [self.stateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(20);
        make.centerX.equalTo(self.containerView);
    }];

    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15);
        make.right.equalTo(self.containerView.mas_right).offset(-15);
        make.top.equalTo(self.stateImageView.mas_bottom).offset(15);
        UIView *refView = self.wpointView.isHidden ? (self.stateDescLabel.isHidden ? (self.amountLabel.isHidden ? nil : self.amountLabel) : self.stateDescLabel) : self.wpointView;
        if (!refView) {
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-38);
        }
    }];

    if (!self.wpointView.isHidden) {
        [self.wpointView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateLabel.mas_bottom).offset(10);
            make.left.equalTo(self.containerView.mas_left).offset(8);
            make.right.equalTo(self.containerView.mas_right).offset(-8);
            UIView *refView = self.stateDescLabel.isHidden ? (self.amountLabel.isHidden ? nil : self.amountLabel) : self.stateDescLabel;
            if (!refView) {
                make.bottom.equalTo(self.containerView.mas_bottom).offset(-38);
            }
        }];
    }

    if (!self.stateDescLabel.isHidden) {
        [self.stateDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(15);
            make.right.equalTo(self.containerView.mas_right).offset(-15);
            UIView *topView = self.wpointView.isHidden ? self.stateLabel : self.wpointView;
            make.top.equalTo(topView.mas_bottom).offset(10);
            if (self.amountLabel.isHidden) {
                make.bottom.equalTo(self.containerView.mas_bottom).offset(-38);
            }
        }];
    }

    if (!self.amountLabel.isHidden) {
        [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(15);
            make.right.equalTo(self.containerView.mas_right).offset(-15);

            UIView *topView = self.stateDescLabel.isHidden ? (self.wpointView.isHidden ? self.stateLabel : self.wpointView) : self.stateDescLabel;
            make.top.equalTo(topView.mas_bottom).offset(10);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-38);
        }];
    }
    CGFloat buttonWith = kScreenWidth / 2.0 - 40;
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(25);
        make.left.equalTo(self.containerView.mas_left).offset(15);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(buttonWith);
    }];

    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(buttonWith);
        make.centerY.equalTo(self.leftButton.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-15);
    }];

    [super updateViewConstraints];
}

#pragma mark - DATA
- (void)queryWPoint {
    SAUserCenterDTO *dto = SAUserCenterDTO.new;
    @HDWeakify(self);
    [dto queryHowManyWPointWillGetWithOrderNo:self.model.orderNo businessLine:SAClientTypeTinhNow actuallyPaidAmount:self.model.amount merchantNo:self.model.merchantNo
        success:^(SAWPontWillGetRspModel *_Nullable rspModel) {
            @HDStrongify(self);
            if (!HDIsObjectNil(rspModel)) {
                self.wpointView.model = rspModel;
                self.wpointView.hidden = NO;
            } else {
                self.wpointView.hidden = YES;
            }

            [self.view setNeedsUpdateConstraints];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            self.wpointView.hidden = YES;
            [self.view setNeedsUpdateConstraints];
        }];
}

#pragma mark - setter
- (void)setModel:(TNPaymentResultModel *)model {
    _model = model;
    self.boldTitle = model.pageName;
    if (SAOrderPaymentTypeCashOnDelivery == model.paymentType) {
        self.stateImageView.image = [UIImage imageNamed:@"offline_state_success"];
        self.stateLabel.text = TNLocalizedString(@"tn_order_success", @"下单成功");
    } else if (SAOrderPaymentTypeOnline == model.paymentType) {
        if (SAPaymentStatePayed == model.state) {
            self.stateImageView.image = [UIImage imageNamed:@"online_state_success"];
            self.stateLabel.text = TNLocalizedString(@"tn_payment_success", @"支付成功");
            if (model.amount) {
                [self.amountLabel setHidden:NO];
                self.amountLabel.text = model.amount.thousandSeparatorAmount;
            }
        } else if (SAPaymentStatePaying == model.state) {
            self.stateImageView.image = [UIImage imageNamed:@"online_state_process"];
            self.stateLabel.text = TNLocalizedString(@"tn_payment_processing", @"支付中");
        } else if (SAPaymentStatePayFail == model.state) {
            self.stateImageView.image = [UIImage imageNamed:@"online_state_fail"];
            self.stateLabel.text = TNLocalizedString(@"tn_payment_fail", @"支付失败");
        } else {
            self.stateImageView.image = [UIImage imageNamed:@"online_state_fail"];
            self.stateLabel.text = TNLocalizedString(@"xqTIQcI9", @"Unknow");
        }
    } else if (SAOrderPaymentTypeTransfer == model.paymentType) {
        self.stateImageView.image = [UIImage imageNamed:@"offline_state_success"];
        self.stateLabel.text = TNLocalizedString(@"tn_order_success", @"下单成功");
    }
    if (HDIsStringNotEmpty(model.stateDesc)) {
        [self.stateDescLabel setHidden:NO];
        self.stateDescLabel.text = model.stateDesc;
    } else {
        [self.stateDescLabel setHidden:YES];
    }

    [self.leftButton applyPropertiesWithBackgroundColor:model.buttonBackgroundColor];
    [self.rightButton applyPropertiesWithBackgroundColor:model.buttonBackgroundColor];

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Event
- (void)clickOnBackHomeButton:(SAOperationButton *)button {
    @HDWeakify(self);
    [self.navigationController dismissAnimated:YES completion:^{
        @HDStrongify(self);
        if (self.backHomeClickedHander) {
            self.backHomeClickedHander(self.model);
        }
    }];
}
- (void)clickOnOrderDetailsButton:(SAOperationButton *)button {
    @HDWeakify(self);
    [self.navigationController dismissAnimated:YES completion:^{
        @HDStrongify(self);
        if (self.orderDetailClickedHandler) {
            self.orderDetailClickedHandler(self.model);
        }
    }];
}
#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}
#pragma mark - lazy load
/** @lazy containerView */
- (SAShadowBackgroundView *)containerView {
    if (!_containerView) {
        _containerView = [[SAShadowBackgroundView alloc] init];
    }
    return _containerView;
}
/** @lazy stateImageview */
- (UIImageView *)stateImageView {
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
    }
    return _stateImageView;
}
/** @lazy stateLabel */
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = HDAppTheme.TinhNowFont.standard17B;
        _stateLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}
/** @lazy statedescLabel */
- (UILabel *)stateDescLabel {
    if (!_stateDescLabel) {
        _stateDescLabel = [[UILabel alloc] init];
        _stateDescLabel.font = HDAppTheme.TinhNowFont.standard17B;
        _stateDescLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _stateDescLabel.textAlignment = NSTextAlignmentCenter;
        _stateDescLabel.numberOfLines = 0;
        _stateDescLabel.hidden = YES;
    }
    return _stateDescLabel;
}
/** @lazy amountLabel */
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = HDAppTheme.font.amountOnly;
        _amountLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.hidden = YES;
    }
    return _amountLabel;
}
/** @lazy leftButton */
- (SAOperationButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_leftButton addTarget:self action:@selector(clickOnBackHomeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTitle:TNLocalizedString(@"tn_back_home", @"返回首页") forState:UIControlStateNormal];
        _leftButton.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
        [_leftButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _leftButton;
}
/** @lazy rightButton */
- (SAOperationButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_rightButton addTarget:self action:@selector(clickOnOrderDetailsButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitle:TNLocalizedString(@"tn_check_order", @"查看订单") forState:UIControlStateNormal];
        _rightButton.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _rightButton;
}
/** @lazy wpointview */
- (SAWPointReceiveInfoView *)wpointView {
    if (!_wpointView) {
        _wpointView = [[SAWPointReceiveInfoView alloc] init];
        _wpointView.hidden = YES;
    }
    return _wpointView;
}

@end
