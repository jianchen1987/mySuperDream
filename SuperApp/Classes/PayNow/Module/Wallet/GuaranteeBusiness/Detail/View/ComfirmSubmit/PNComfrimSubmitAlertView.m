//
//  PNComfrimSubmitAlertView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/11.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNComfrimSubmitAlertView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNInfoView.h"
#import <HDKitCore/HDKitCore.h>


@interface PNComfrimSubmitAlertView ()
/// 标题
@property (strong, nonatomic) SALabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
/// 关闭
@property (nonatomic, strong) HDUIButton *closeBtn;
/// 付款金额 - 美元
@property (nonatomic, strong) SALabel *usdPayAmountLabel;
/// 付款金额 文本
@property (nonatomic, strong) SALabel *subLabel;
/// 缴费金额
@property (strong, nonatomic) PNInfoView *payAmountInfoView;
/// 服务费
@property (strong, nonatomic) PNInfoView *freeAmountInfoView;
/// 汇率
@property (strong, nonatomic) PNInfoView *rateInfoView;

@property (nonatomic, strong) UIView *bottomLineView;
/// 底部的文案提示
@property (nonatomic, strong) SALabel *bottomTipsLabel;
/// 确认
@property (strong, nonatomic) PNOperationButton *confirmBtn;

@property (strong, nonatomic) PNGuarateenBuildOrderPaymentRspModel *model;
@end


@implementation PNComfrimSubmitAlertView

- (instancetype)initWithBalanceModel:(PNGuarateenBuildOrderPaymentRspModel *)model {
    if (self = [super init]) {
        self.model = model;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = NO;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:16];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.topLine];
    [self.containerView addSubview:self.closeBtn];
    [self.containerView addSubview:self.usdPayAmountLabel];
    [self.containerView addSubview:self.subLabel];

    [self.containerView addSubview:self.payAmountInfoView];
    [self.containerView addSubview:self.freeAmountInfoView];
    [self.containerView addSubview:self.rateInfoView];

    [self.containerView addSubview:self.bottomLineView];
    [self.containerView addSubview:self.bottomTipsLabel];

    [self.containerView addSubview:self.confirmBtn];

    /// 处理view
    if ([self.model.tradeCy isEqualToString:PNCurrencyTypeKHR]) {
        self.rateInfoView.hidden = NO;
    }

    if (WJIsStringNotEmpty(self.model.guarateenTipsStr)) {
        self.bottomTipsLabel.hidden = NO;
    } else {
        self.bottomTipsLabel.hidden = YES;
    }
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_top).offset(kRealHeight(16));
        make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
    }];

    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(16));
    }];

    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView.mas_right);
        make.top.mas_equalTo(self.containerView.mas_top);
        make.bottom.mas_equalTo(self.topLine.mas_top);
    }];

    [self.usdPayAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(kRealHeight(24));
        make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
    }];

    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usdPayAmountLabel.mas_bottom).offset(kRealHeight(4));
        make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
    }];

    [self.payAmountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.mas_equalTo(self.subLabel.mas_bottom).offset(kRealHeight(8));
    }];

    [self.freeAmountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.mas_equalTo(self.payAmountInfoView.mas_bottom);
    }];

    if (!self.rateInfoView.hidden) {
        [self.rateInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.mas_equalTo(self.freeAmountInfoView.mas_bottom);
        }];
    }

    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(PixelOne));
        make.left.right.equalTo(self.containerView);
        if (!self.rateInfoView.hidden) {
            make.top.mas_equalTo(self.rateInfoView.mas_bottom).offset(kRealWidth(12));
        } else {
            make.top.mas_equalTo(self.freeAmountInfoView.mas_bottom).offset(kRealWidth(12));
        }
    }];

    [self.bottomTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomLineView.mas_bottom).offset(kRealWidth(20));
        make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
    }];

    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.bottomTipsLabel.mas_bottom).offset(kRealHeight(24));
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-(kRealHeight(16) + kiPhoneXSeriesSafeBottomHeight));
    }];
}

#pragma mark
- (PNInfoViewModel *)getDefalutInfoViewModel {
    PNInfoViewModel *infoModel = [[PNInfoViewModel alloc] init];
    infoModel.keyFont = HDAppTheme.PayNowFont.standard14;
    infoModel.keyColor = HDAppTheme.PayNowColor.c999999;
    infoModel.valueFont = HDAppTheme.PayNowFont.standard14;
    infoModel.valueColor = HDAppTheme.PayNowColor.c333333;
    infoModel.lineWidth = 0;
    //    infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));

    return infoModel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.text = PNLocalizedString(@"checkStand_pay_confirm", @"确认付款");
        _titleLabel.font = HDAppTheme.PayNowFont.standard16M;
        _titleLabel.textColor = [UIColor hd_colorWithHexString:@"#262936"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)topLine {
    if (!_topLine) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _topLine = view;
    }
    return _topLine;
}

- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_pay_close"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];

        _closeBtn = button;
    }
    return _closeBtn;
}

- (SALabel *)usdPayAmountLabel {
    if (!_usdPayAmountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#262936"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [HDAppTheme.PayNowFont fontDINBold:32];
        label.text = self.model.payAmtMoneyModel.thousandSeparatorAmount;

        _usdPayAmountLabel = label;
    }
    return _usdPayAmountLabel;
}

- (SALabel *)subLabel {
    if (!_subLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#262936"];
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"TEXT_PAY_AMOUNT", @"付款金额");
        _subLabel = label;
    }
    return _subLabel;
}

- (PNInfoView *)payAmountInfoView {
    if (!_payAmountInfoView) {
        _payAmountInfoView = [[PNInfoView alloc] init];
        PNInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"pQAaSPwA", @"交易金额");
        infoModel.valueText = self.model.tradeAmtMoneyModel.thousandSeparatorAmount;
        infoModel.valueFont = [HDAppTheme.PayNowFont fontDINMedium:14];
        _payAmountInfoView.model = infoModel;
    }
    return _payAmountInfoView;
}

- (PNInfoView *)freeAmountInfoView {
    if (!_freeAmountInfoView) {
        _freeAmountInfoView = [[PNInfoView alloc] init];
        PNInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"IVm6l92o", @"服务费");
        infoModel.valueText = self.model.freeAmtMoneyModel.thousandSeparatorAmount;
        infoModel.valueFont = [HDAppTheme.PayNowFont fontDINMedium:14];
        _freeAmountInfoView.model = infoModel;
    }
    return _freeAmountInfoView;
}

- (PNInfoView *)rateInfoView {
    if (!_rateInfoView) {
        _rateInfoView = [[PNInfoView alloc] init];
        PNInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"exchange_rate", @"汇率");
        infoModel.valueText = [NSString stringWithFormat:@"$1 = ៛%@", self.model.khrBuyUsd];
        infoModel.valueFont = [HDAppTheme.PayNowFont fontDINMedium:14];
        _rateInfoView.model = infoModel;

        _rateInfoView.hidden = YES;
    }
    return _rateInfoView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;

        _bottomLineView = view;
    }
    return _bottomLineView;
}

- (SALabel *)bottomTipsLabel {
    if (!_bottomTipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.text = self.model.guarateenTipsStr;
        label.numberOfLines = 0;
        label.hidden = YES;
        _bottomTipsLabel = label;
    }
    return _bottomTipsLabel;
}

- (PNOperationButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmBtn setTitle:PNLocalizedString(@"checkStand_pay_confirm", @"确认付款") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_confirmBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];

            !self.comfrimBlock ?: self.comfrimBlock();
        }];
    }
    return _confirmBtn;
}

@end
