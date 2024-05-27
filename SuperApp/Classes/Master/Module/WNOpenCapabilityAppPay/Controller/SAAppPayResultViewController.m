//
//  SAAppPayResultViewController.m
//  SuperApp
//
//  Created by seeu on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAppPayResultViewController.h"
#import "SAOpenCapabilityDTO.h"


@interface SAAppPayResultViewController ()
@property (nonatomic, strong) HDUIButton *completeBtn;              ///< 完成按钮
@property (nonatomic, strong) SAOperationButton *backToMerchantBtn; ///< 回到商户

@property (nonatomic, strong) UIImageView *paymentStateIV; ///< 支付状态图标
@property (nonatomic, strong) UILabel *paymentStateDescLB; ///< 支付状态描述
@property (nonatomic, strong) UILabel *paymentAmountLB;    ///< 支付金额
@property (nonatomic, strong) UIView *container;           ///< 容器

@property (nonatomic, strong) SAOpenCapabilityDTO *openCapabilityDTO;     ///< DTO
@property (nonatomic, strong) SAQueryPaymentStateRspModel *paymentResult; ///< 支付结果
@end


@implementation SAAppPayResultViewController

- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.view addSubview:self.container];
    [self.container addSubview:self.paymentStateIV];
    [self.container addSubview:self.paymentStateDescLB];
    [self.container addSubview:self.paymentAmountLB];
    [self.container addSubview:self.backToMerchantBtn];

    self.hd_interactivePopDisabled = true;
    [self.paymentStateIV startAnimating];
    [self getPaymentState];
}

- (void)hd_setupNavigation {
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.completeBtn];
    [self setHd_navLeftBarButtonItem:nil];
}

- (void)hd_languageDidChanged {
    self.boldTitle = SALocalizedString(@"Log1CQtZ", @"支付结果");
    [self.completeBtn setTitle:SALocalizedString(@"complete", @"完成") forState:UIControlStateNormal];
    [self.backToMerchantBtn setTitle:SALocalizedString(@"app_pay_backToMerchant", @"返回商家") forState:UIControlStateNormal];
}

- (void)updateViewConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.paymentStateIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container);
        make.top.equalTo(self.container.mas_top).offset(kRealHeight(40));
    }];

    [self.paymentStateDescLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paymentStateIV.mas_bottom).offset(kRealHeight(20));
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(15));
        if (self.backToMerchantBtn.isHidden) {
            make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(170));
        }
    }];

    if (!self.paymentAmountLB.isHidden) {
        [self.paymentAmountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymentStateDescLB.mas_bottom).offset(kRealHeight(20));
            make.left.equalTo(self.container.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.container.mas_right).offset(-kRealWidth(15));
        }];
    }

    if (!self.backToMerchantBtn.isHidden) {
        [self.backToMerchantBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymentAmountLB.mas_bottom).offset(kRealHeight(30));
            make.left.equalTo(self.container.mas_left).offset(kRealWidth(80));
            make.right.equalTo(self.container.mas_right).offset(-kRealWidth(80));
            make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(30));
            make.height.mas_equalTo(kRealHeight(40));
        }];
    }

    [super updateViewConstraints];
}

#pragma mark - DATA
- (void)getPaymentState {
    @HDWeakify(self);
    [self.openCapabilityDTO queryPaymentStateWithPayOrderNo:self.payOrderNo success:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.paymentResult = rspModel;
        [self refreshUIWithModel:rspModel];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        /// 2秒后重试
        [self performSelector:@selector(getPaymentState) withObject:nil afterDelay:2];
    }];
}

#pragma mark - private
- (void)refreshUIWithModel:(SAQueryPaymentStateRspModel *)model {
    SAPaymentState payStateEnum = model.payState;
    switch (payStateEnum) {
        case SAPaymentStatePaying:
            self.paymentStateDescLB.text = SALocalizedString(@"app_pay_paying", @"支付中，请耐心等待...");
            /// 2秒后重试
            [self performSelector:@selector(getPaymentState) withObject:nil afterDelay:2];
            break;
        case SAPaymentStatePayed:
            [self.paymentStateIV stopAnimating];
            self.paymentStateDescLB.text = SALocalizedString(@"app_pay_success", @"支付成功");
            self.paymentStateIV.image = [UIImage imageNamed:@"pay_success_icon"];
            self.paymentAmountLB.text = model.actualPayAmount.thousandSeparatorAmount;
            self.backToMerchantBtn.hidden = NO;
            break;
        case SAPaymentStateUnknown:
        case SAPaymentStateInit:
        case SAPaymentStateRefunding:
        case SAPaymentStateRefunded:
        case SAPaymentStateClosed:
        case SAPaymentStatePayFail:
            [self.paymentStateIV stopAnimating];
            self.paymentStateDescLB.text = SALocalizedString(@"app_pay_fail", @"支付失败");
            self.paymentStateIV.image = [UIImage imageNamed:@"online_state_fail"];
            self.paymentAmountLB.text = model.actualPayAmount.thousandSeparatorAmount;
            self.backToMerchantBtn.hidden = NO;
            break;
    }

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Action
- (void)clickedOnCompleteButton:(HDUIButton *)button {
    !self.clickedCompleteHandler ?: self.clickedCompleteHandler(self.paymentResult);
}

- (void)clickedOnBakcToMerchantButton:(SAOperationButton *)button {
    !self.clickedBackToMerchantHandler ?: self.clickedBackToMerchantHandler(self.paymentResult);
}

#pragma mark - lazy load
- (UIView *)container {
    if (!_container) {
        _container = UIView.new;
        _container.backgroundColor = UIColor.whiteColor;
    }
    return _container;
}

- (HDUIButton *)completeBtn {
    if (!_completeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"complete", @"完成") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(12, 7, 12, 7);
        [button addTarget:self action:@selector(clickedOnCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _completeBtn = button;
    }
    return _completeBtn;
}

- (SAOperationButton *)backToMerchantBtn {
    if (!_backToMerchantBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        [button applyHollowPropertiesWithTintColor:[UIColor hd_colorWithHexString:@"#F83E00"]];
        [button addTarget:self action:@selector(clickedOnBakcToMerchantButton:) forControlEvents:UIControlEventTouchUpInside];
        button.cornerRadius = kRealHeight(40) / 2.0;
        button.hidden = YES;
        _backToMerchantBtn = button;
    }
    return _backToMerchantBtn;
}

- (UIImageView *)paymentStateIV {
    if (!_paymentStateIV) {
        _paymentStateIV = [[UIImageView alloc] init];
        NSMutableArray<UIImage *> *arr = NSMutableArray.new;
        for (int i = 0; i < 24; i++) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"合成 1_000%02d", i]]];
        }
        _paymentStateIV.animationImages = arr;
        _paymentStateIV.animationDuration = 1;
    }
    return _paymentStateIV;
}

- (UILabel *)paymentStateDescLB {
    if (!_paymentStateDescLB) {
        UILabel *label = UILabel.new;
        label.textColor = HDAppTheme.color.G1;
        label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        label.text = SALocalizedString(@"app_pay_paying", @"支付中，请耐心等待...");
        _paymentStateDescLB = label;
    }
    return _paymentStateDescLB;
}

- (UILabel *)paymentAmountLB {
    if (!_paymentAmountLB) {
        UILabel *label = UILabel.new;
        label.textColor = HDAppTheme.color.G1;
        label.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        _paymentAmountLB = label;
    }
    return _paymentAmountLB;
}

- (SAOpenCapabilityDTO *)openCapabilityDTO {
    if (!_openCapabilityDTO) {
        _openCapabilityDTO = SAOpenCapabilityDTO.new;
    }
    return _openCapabilityDTO;
}

@end
