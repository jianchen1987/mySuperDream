//
//  PNGamePaymentAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGamePaymentAlertView.h"
#import "HDAppTheme+PayNow.h"
#import "PNOperationButton.h"
#import "SAInfoView.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface PNGamePaymentAlertView ()
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 美金余额
@property (strong, nonatomic) SAInfoView *usBalanceAmountView;
/// 瑞尔余额
@property (strong, nonatomic) SAInfoView *khBalanceAmountView;
/// 汇率
@property (strong, nonatomic) SAInfoView *rateView;
/// 提示
@property (strong, nonatomic) UILabel *tipsLabel;
/// 取消
@property (strong, nonatomic) PNOperationButton *cancelBtn;
/// 确定按钮
@property (strong, nonatomic) PNOperationButton *confirmBtn;
/// 余额模型
@property (strong, nonatomic) PNBalanceAndExchangeModel *model;
@end


@implementation PNGamePaymentAlertView
- (instancetype)initWithBalanceModel:(PNBalanceAndExchangeModel *)model {
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
    [self.containerView addSubview:self.usBalanceAmountView];
    [self.containerView addSubview:self.khBalanceAmountView];
    [self.containerView addSubview:self.rateView];
    [self.containerView addSubview:self.tipsLabel];
    [self.containerView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.confirmBtn];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealHeight(16));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(16));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(16));
    }];
    [self.usBalanceAmountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealHeight(16));
    }];
    [self.khBalanceAmountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.usBalanceAmountView.mas_bottom).offset(kRealHeight(16));
    }];
    [self.rateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.khBalanceAmountView.mas_bottom).offset(kRealHeight(16));
    }];
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealHeight(12));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.rateView.mas_bottom).offset(kRealHeight(8));
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(16));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(kRealHeight(8));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-(kRealHeight(8) + kiPhoneXSeriesSafeBottomHeight));
        make.height.mas_equalTo(kRealHeight(48));
        make.width.equalTo(self.confirmBtn.mas_width);
    }];
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(16));
        make.centerY.equalTo(self.cancelBtn.mas_centerY);
        make.left.equalTo(self.cancelBtn.mas_right).offset(kRealWidth(15));
        make.height.mas_equalTo(kRealHeight(48));
    }];
}
- (SAInfoViewModel *)getDefalutInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = [HDAppTheme.PayNowFont fontBold:14];
    infoModel.keyColor = HDAppTheme.PayNowColor.c333333;
    infoModel.valueFont = [HDAppTheme.PayNowFont fontRegular:14];
    infoModel.valueColor = HDAppTheme.PayNowColor.c333333;
    return infoModel;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = PNLocalizedString(@"pn_select_payment", @"选择支付方式");
        _titleLabel.font = [HDAppTheme.PayNowFont fontSemibold:16];
        _titleLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
/** @lazy usBalanceAmountView */
- (SAInfoView *)usBalanceAmountView {
    if (!_usBalanceAmountView) {
        _usBalanceAmountView = [[SAInfoView alloc] init];
        SAInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = [NSString stringWithFormat:@"%@(%@)", PNLocalizedString(@"pn_wallet_balance", @"钱包余额"), self.model.usdBalance.cy];
        infoModel.valueText = self.model.usdBalance.amount;
        _usBalanceAmountView.model = infoModel;
    }
    return _usBalanceAmountView;
}
/** @lazy khBalanceAmountView */
- (SAInfoView *)khBalanceAmountView {
    if (!_khBalanceAmountView) {
        _khBalanceAmountView = [[SAInfoView alloc] init];
        SAInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        infoModel.keyText = [NSString stringWithFormat:@"%@(%@)", PNLocalizedString(@"pn_wallet_balance", @"钱包余额"), self.model.khrBalance.cy];
        infoModel.valueText = self.model.khrBalance.amount;
        _khBalanceAmountView.model = infoModel;
    }
    return _khBalanceAmountView;
}
/** @lazy rateView */
- (SAInfoView *)rateView {
    if (!_rateView) {
        _rateView = [[SAInfoView alloc] init];
        SAInfoViewModel *infoModel = [self getDefalutInfoViewModel];
        NSString *khr = @"KHR";
        NSString *usd = @"USD";
        NSString *str = [NSString stringWithFormat:@"%@(%@%@)", PNLocalizedString(@"exchange_rate", @"兑换汇率"), khr, usd];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];

        [attr addAttribute:NSFontAttributeName value:infoModel.keyFont range:NSMakeRange(0, [str length])];
        [attr addAttribute:NSForegroundColorAttributeName value:infoModel.keyColor range:NSMakeRange(0, [str length])];

        NSRange usdRange = [str rangeOfString:usd];

        NSTextAttachment *imageAttach = [[NSTextAttachment alloc] init];
        imageAttach.image = [UIImage imageNamed:@"pn_exchange_rate"];
        imageAttach.bounds = CGRectMake(0, -2.5, imageAttach.image.size.width, imageAttach.image.size.height);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:imageAttach];
        [attr insertAttributedString:imageAttr atIndex:usdRange.location];

        infoModel.attrKey = attr;

        infoModel.valueText = [NSString stringWithFormat:@"%@%@=1%@", self.model.exchange, self.model.khrBalance.cy, self.model.usdBalance.cy];
        _rateView.model = infoModel;
    }
    return _rateView;
}
/** @lazy tipsLabel */
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = HDAppTheme.PayNowFont.standard11;
        _tipsLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = PNLocalizedString(@"pn_balance_not_enough_tips", @"您的USD账户余额不足，我们支持您将KHR账户资金汇兑为USD后来支付该笔业务，请选择是否汇兑");
    }
    return _tipsLabel;
}
/** @lazy cancelBtn */
- (PNOperationButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_cancelBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_NO", @"否") forState:UIControlStateNormal];
        [_cancelBtn applyPropertiesWithBackgroundColor:[HDAppTheme.PayNowColor.mainThemeColor colorWithAlphaComponent:0.1]];
        [_cancelBtn setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:UIControlStateNormal];
        @HDWeakify(self);
        [_cancelBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            !self.choosePaymentMethodCallBack ?: self.choosePaymentMethodCallBack(NO);
        }];
    }
    return _cancelBtn;
}
/** @lazy confirmBtn */
- (PNOperationButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_YES", @"是") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_confirmBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            !self.choosePaymentMethodCallBack ?: self.choosePaymentMethodCallBack(YES);
        }];
    }
    return _confirmBtn;
}

@end
