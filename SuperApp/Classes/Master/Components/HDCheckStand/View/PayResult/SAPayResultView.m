//
//  SAPayResultView.m
//  SuperApp
//
//  Created by Chaos on 2020/8/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPayResultView.h"
#import "SAMultiLanguageManager.h"
#import "SAOperationButton.h"
#import "SAPayResultViewModel.h"
#import "SAQueryPaymentStateRspModel.h"
#import "SAWPointReceiveInfoView.h"


@interface SAPayResultView ()

/// 顶部背景
@property (nonatomic, strong) UIView *bgView;
/// 图标
@property (nonatomic, strong) UIImageView *iconView;
/// 状态
@property (nonatomic, strong) SALabel *statusLabel;
/// 金额
@property (nonatomic, strong) SALabel *moneyLabel;
/// 查看订单按钮
@property (nonatomic, strong) SAOperationButton *orderBtn;
/// viewmodel
@property (nonatomic, strong) SAPayResultViewModel *viewModel;

///< wpoint container
@property (nonatomic, strong) SAWPointReceiveInfoView *wpointView;

@end


@implementation SAPayResultView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.statusLabel];
    [self.bgView addSubview:self.moneyLabel];
    [self.bgView addSubview:self.wpointView];
    [self.bgView addSubview:self.orderBtn];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kRealHeight(10));
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.mas_bottom).offset(-kRealHeight(15));
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(20));
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.bgView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.bgView.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    if (!self.moneyLabel.isHidden) {
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.bgView.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.bgView.mas_right).offset(-HDAppTheme.value.padding.right);
        }];
    }

    if (!self.wpointView.isHidden) {
        [self.wpointView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moneyLabel.mas_bottom).offset(kRealHeight(10));
            make.left.equalTo(self.bgView.mas_left);
            make.right.equalTo(self.bgView.mas_right);
        }];
    }

    UIView *refView = !self.wpointView.isHidden ? self.wpointView : (self.moneyLabel.isHidden ? self.statusLabel : self.moneyLabel);

    [self.orderBtn sizeToFit];
    [self.orderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refView.mas_bottom).offset(kRealHeight(11));
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.bottom.equalTo(self.bgView).offset(kRealWidth(-30));
        make.width.mas_equalTo(self.orderBtn.size.width);
        make.height.mas_equalTo(kRealWidth(30));
    }];

    [super updateConstraints];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.KVOController hd_observe:self.viewModel keyPath:@"wpointRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (HDIsObjectNil(self.viewModel.wpointRspModel)) {
            // 没积分活动
            self.wpointView.hidden = YES;
        } else {
            self.wpointView.model = self.viewModel.wpointRspModel;
            self.wpointView.hidden = NO;
        }
        [self setNeedsUpdateConstraints];
    }];
}

#pragma mark - event response
- (void)orderBtnAction {
    !self.orderDetailClicked ?: self.orderDetailClicked();
}

#pragma mark - public methods
- (CGFloat)viewHeight {
    CGFloat height = 0;
    height += kRealHeight(10); // 上边距
    height += kRealWidth(20);  // icon top
    height += kRealWidth(50);  // icon height
    height += kRealWidth(10);  // status top
    CGSize statusLabelSzie = [self.statusLabel sizeThatFits:CGSizeMake(kScreenWidth - (HDAppTheme.value.padding.left + HDAppTheme.value.padding.right) * 2, CGFLOAT_MAX)];
    height += statusLabelSzie.height;          // status height
    height += kRealHeight(11);                 // button top
    height += kRealWidth(30);                  // button height
    height += kRealWidth(30);                  // button bottom
    height += HDAppTheme.value.padding.bottom; // 下边距

    if (!self.moneyLabel.isHidden) {
        height += kRealWidth(10);
        CGSize moneyLabelSize = [self.moneyLabel sizeThatFits:CGSizeMake(kScreenWidth - (HDAppTheme.value.padding.left + HDAppTheme.value.padding.right) * 2, CGFLOAT_MAX)];
        height += moneyLabelSize.height;
    }

    if (!self.wpointView.isHidden) {
        CGFloat wpointHeight = [self.wpointView fitHeightWithWidth:kScreenWidth - (HDAppTheme.value.padding.left + HDAppTheme.value.padding.right) * 2];
        height += kRealHeight(10);
        height += wpointHeight;
    }

    return height;
}

#pragma mark - setter
- (void)setModel:(SAQueryPaymentStateRspModel *)model {
    switch (model.payState) {
        case SAPaymentStateUnknown:
        case SAPaymentStateInit:
        case SAPaymentStatePaying: {
            [self.iconView startAnimating];
            break;
        }
        case SAPaymentStateRefunding:
        case SAPaymentStateRefunded:
        case SAPaymentStateClosed:
        case SAPaymentStatePayFail: {
            [self.iconView stopAnimating];
            self.statusLabel.text = WMLocalizedString(@"wm_payment_fail", @"支付失败");
            self.iconView.image = [UIImage imageNamed:@"online_state_fail"];
            break;
        }
        case SAPaymentStatePayed: {
            [self.iconView stopAnimating];
            self.statusLabel.text = WMLocalizedString(@"wm_payment_success", @"支付成功");
            self.iconView.image = [UIImage imageNamed:@"pay_success_icon"];
            self.moneyLabel.hidden = NO;
            self.moneyLabel.text = model.actualPayAmount.thousandSeparatorAmount;
            break;
        }
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10.0f];
        };
    }
    return _bgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        NSMutableArray<UIImage *> *arr = NSMutableArray.new;
        for (int i = 0; i < 24; i++) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"合成 1_000%02d", i]]];
        }
        _iconView.animationImages = arr;
        _iconView.animationDuration = 1;
        [_iconView startAnimating];
    }
    return _iconView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[SALabel alloc] init];
        _statusLabel.textColor = HDAppTheme.color.G1;
        _statusLabel.font = HDAppTheme.font.standard2;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = SALocalizedString(@"check_payment_result", @"查询支付结果中...");
    }
    return _statusLabel;
}

- (SALabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[SALabel alloc] init];
        _moneyLabel.textColor = HDAppTheme.color.G1;
        _moneyLabel.font = HDAppTheme.font.amountOnly;
        _moneyLabel.hidden = YES;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (SAOperationButton *)orderBtn {
    if (!_orderBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [button setTitleColor:[UIColor hd_colorWithHexString:@"#FC2040"] forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"wm_button_orderdetails", @"查看订单") forState:UIControlStateNormal];
        button.cornerRadius = kRealWidth(30) / 2.0;
        button.borderColor = [UIColor hd_colorWithHexString:@"#FC2040"];
        button.borderWidth = 1.0f;
        [button applyPropertiesWithBackgroundColor:UIColor.whiteColor];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 25, 5, 25);
        [button addTarget:self action:@selector(orderBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [button setHd_frameDidChangeBlock:^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        }];
        _orderBtn = button;
    }
    return _orderBtn;
}

/** @lazy wpointView */
- (SAWPointReceiveInfoView *)wpointView {
    if (!_wpointView) {
        _wpointView = [[SAWPointReceiveInfoView alloc] init];
        _wpointView.hidden = YES;
    }
    return _wpointView;
}

@end
