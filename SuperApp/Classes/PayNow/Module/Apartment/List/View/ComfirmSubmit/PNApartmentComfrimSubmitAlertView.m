//
//  PNGamePaymentAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentComfrimSubmitAlertView.h"
#import "HDAppTheme+PayNow.h"
#import "PNOperationButton.h"
#import "SAInfoView.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import "NSMutableAttributedString+Highlight.h"


@interface PNApartmentComfrimSubmitAlertView ()
/// 标题
@property (strong, nonatomic) SALabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
/// 付款金额 - 美元
@property (nonatomic, strong) SALabel *usdPayAmountLabel;
/// 付款金额 文本
@property (nonatomic, strong) SALabel *subLabel;
/// 缴费金额
@property (strong, nonatomic) SAInfoView *payAmountInfoView;
/// 汇率
@property (strong, nonatomic) SAInfoView *rateInfoView;
/// 确认
@property (strong, nonatomic) PNOperationButton *confirmBtn;

@property (strong, nonatomic) PNApartmentComfirmRspModel *model;
@end


@implementation PNApartmentComfrimSubmitAlertView

- (instancetype)initWithBalanceModel:(PNApartmentComfirmRspModel *)model {
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
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:16];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.topLine];
    [self.containerView addSubview:self.usdPayAmountLabel];
    [self.containerView addSubview:self.subLabel];

    if ([self.model.payTheFees.cy isEqualToString:PNCurrencyTypeKHR]) {
        [self.containerView addSubview:self.payAmountInfoView];
        self.payAmountInfoView.hidden = NO;
        [self.containerView addSubview:self.rateInfoView];
        self.rateInfoView.hidden = NO;
    }

    [self.containerView addSubview:self.confirmBtn];
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

    if (!self.payAmountInfoView.hidden) {
        [self.payAmountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.mas_equalTo(self.subLabel.mas_bottom).offset(kRealHeight(8));
        }];

        [self.rateInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.mas_equalTo(self.payAmountInfoView.mas_bottom);
        }];
    }

    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateInfoView.hidden) {
            make.top.mas_equalTo(self.rateInfoView.mas_bottom).offset(kRealHeight(16));
        } else {
            make.top.mas_equalTo(self.subLabel.mas_bottom).offset(kRealHeight(40));
        }
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-(kRealHeight(16) + kiPhoneXSeriesSafeBottomHeight));
        make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
    }];
}

#pragma mark
- (SAInfoViewModel *)getDefalutInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = HDAppTheme.PayNowFont.standard14B;
    infoModel.keyColor = HDAppTheme.PayNowColor.c333333;
    infoModel.valueFont = HDAppTheme.PayNowFont.standard14;
    infoModel.valueColor = HDAppTheme.PayNowColor.c333333;
    infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));

    return infoModel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.text = PNLocalizedString(@"pn_comfirm_to_pay", @"确认缴费");
        _titleLabel.font = [HDAppTheme.PayNowFont fontSemibold:16];
        _titleLabel.textColor = HDAppTheme.PayNowColor.c333333;
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

- (SALabel *)usdPayAmountLabel {
    if (!_usdPayAmountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [HDAppTheme.PayNowFont fontDINBold:32];
        NSString *hightStr = self.model.amount.thousandSeparatorAmountNoCurrencySymbol;
        NSString *allStr = self.model.amount.thousandSeparatorAmount;
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:[HDAppTheme.PayNowFont fontDINBold:32]
                                                           highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                                  norFont:[HDAppTheme.PayNowFont fontDINBold:14]
                                                                 norColor:HDAppTheme.PayNowColor.mainThemeColor];
        _usdPayAmountLabel = label;
    }
    return _usdPayAmountLabel;
}

- (SALabel *)subLabel {
    if (!_subLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"TEXT_PAY_AMOUNT", @"付款金额");
        _subLabel = label;
    }
    return _subLabel;
}

- (SAInfoView *)payAmountInfoView {
    if (!_payAmountInfoView) {
        _payAmountInfoView = [[SAInfoView alloc] init];
        SAInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"pn_bill_amount", @"缴费金额");
        infoModel.valueText = self.model.payTheFees.thousandSeparatorAmount;
        infoModel.valueFont = [HDAppTheme.PayNowFont fontDINMedium:14];
        _payAmountInfoView.model = infoModel;

        _payAmountInfoView.hidden = YES;
    }
    return _payAmountInfoView;
}

- (SAInfoView *)rateInfoView {
    if (!_rateInfoView) {
        _rateInfoView = [[SAInfoView alloc] init];
        SAInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"exchange_rate", @"汇率");
        infoModel.valueText = [NSString stringWithFormat:@"$1 = ៛%@", self.model.rate];
        infoModel.valueFont = [HDAppTheme.PayNowFont fontDINMedium:14];
        _rateInfoView.model = infoModel;

        _rateInfoView.hidden = YES;
    }
    return _rateInfoView;
}

- (PNOperationButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmBtn setTitle:PNLocalizedString(@"pn_comfirm_to_pay", @"确认缴费") forState:UIControlStateNormal];
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
