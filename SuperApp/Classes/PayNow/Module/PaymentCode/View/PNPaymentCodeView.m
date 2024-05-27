//
//  PNPaymentCodeView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNPaymentCodeView.h"
#import "PNCommonUtils.h"
#import "UIImage+PNExtension.h"


@interface PNPaymentCodeView ()
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) SALabel *timerLabel;
@property (nonatomic, strong) UIImageView *qrCodeImgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) SALabel *limitLabel;

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) HDUIButton *scanButton;
@property (nonatomic, strong) HDUIButton *receiveButton;

@property (nonatomic, strong) UIImage *coolcashLogo;

@property (nonatomic, strong) dispatch_source_t countDownTimer; //二维码倒计时

@end


@implementation PNPaymentCodeView

- (void)hd_setupViews {
    [self addSubview:self.topBgView];
    [self.topBgView addSubview:self.timerLabel];
    [self.topBgView addSubview:self.qrCodeImgView];
    [self.topBgView addSubview:self.line];
    [self.topBgView addSubview:self.limitLabel];

    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.scanButton];
    [self.bottomBgView addSubview:self.receiveButton];

    // test
    //    [self setTimerText:@"200"];
    //    [self setLimitText:@"$50" khr:@"៛200,000"];
}

- (void)updateConstraints {
    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.mas_top);
    }];

    [self.timerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBgView.mas_top).offset(kRealWidth(25));
        make.left.mas_equalTo(self.topBgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.topBgView.mas_right).offset(kRealWidth(-15));
    }];

    self.qrCodeImgView.image = [UIImage imageQRCodeContent:self.model.payCode withSize:500 centerImage:self.coolcashLogo centerImageSize:70];
    [self.qrCodeImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timerLabel.mas_bottom).offset(kRealWidth(25));
        make.left.mas_equalTo(self.topBgView.mas_left).offset(kRealWidth(55));
        make.right.mas_equalTo(self.topBgView.mas_right).offset(kRealWidth(-55));
        make.height.mas_equalTo(self.qrCodeImgView.mas_width);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.qrCodeImgView.mas_bottom).offset(kRealWidth(25));
        make.height.equalTo(@(kRealWidth(1)));
    }];

    [self.limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.line.mas_bottom).offset(kRealWidth(25));
        make.bottom.mas_equalTo(self.topBgView).offset(kRealWidth(-25));
    }];

    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.topBgView.mas_bottom).offset(kRealWidth(20));
        make.height.equalTo(@(104));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    [self.scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomBgView.mas_centerX).offset(kRealWidth(-40));
        make.centerY.mas_equalTo(self.bottomBgView.mas_centerY);
    }];
    [self.receiveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomBgView.mas_centerX).offset(kRealWidth(40));
        make.centerY.mas_equalTo(self.bottomBgView.mas_centerY);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNOpenPaymentRspModel *)model {
    _model = model;
    [self startCountdown];
    NSString *usdStr = [PNCommonUtils thousandSeparatorAmount:[NSString stringWithFormat:@"%zd", model.usdLimitAmount] currencyCode:PNCurrencyTypeUSD];
    NSString *khrStr = [PNCommonUtils thousandSeparatorAmount:[NSString stringWithFormat:@"%zd", model.khrLimitAmount] currencyCode:PNCurrencyTypeKHR];
    [self setLimitText:usdStr khr:khrStr];
    [self setNeedsUpdateConstraints];
}

- (void)setTimerText:(NSString *)timer {
    NSString *allStr = [NSString stringWithFormat:@"%@ %@ %@", PNLocalizedString(@"expire_later", @"二维码将在"), timer, PNLocalizedString(@"expire_later_end", @"秒后失效")];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSDictionary *dict = @{NSForegroundColorAttributeName: HDAppTheme.PayNowColor.cFD7127};
    [attStr setAttributes:dict range:[allStr rangeOfString:timer]];
    self.timerLabel.attributedText = attStr;
}

- (void)setLimitText:(NSString *)usd khr:(NSString *)khr {
    NSString *allStr = [NSString stringWithFormat:@"%@%@ %@ %@", PNLocalizedString(@"paymentCode_limit_to", @"单笔限额"), usd, PNLocalizedString(@"pn_or", @"或"), khr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSDictionary *dict = @{NSForegroundColorAttributeName: HDAppTheme.PayNowColor.cFD7127};
    [attStr setAttributes:dict range:[allStr rangeOfString:usd]];
    [attStr setAttributes:dict range:[allStr rangeOfString:khr]];
    self.limitLabel.attributedText = attStr;
}

- (void)startCountdown {
    self.timerLabel.hidden = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(countDownTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行一次
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:self.model.validTime];                 // 最后期限
    dispatch_source_set_event_handler(countDownTimer, ^{
        int interval = [endTime timeIntervalSinceNow];
        if (interval > 0) { // 更新倒计时
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *timeStr = [NSString stringWithFormat:@"%d", interval];
                [self setTimerText:timeStr];
            });
        } else { // 倒计时结束，关闭
            dispatch_source_cancel(countDownTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                HDLog(@"倒计时结束，返回上一个页面");
                [self.viewController.navigationController popViewControllerAnimated:YES];
            });
        }
    });
    dispatch_resume(countDownTimer);
}

- (void)stopTimer {
    if (_countDownTimer) {
        dispatch_source_cancel(_countDownTimer);
        _countDownTimer = nil;
    }
}

#pragma mark
- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _topBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _topBgView;
}

- (SALabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[SALabel alloc] init];
        _timerLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _timerLabel.font = HDAppTheme.PayNowFont.standard15;
        _timerLabel.adjustsFontSizeToFitWidth = YES;
        _timerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timerLabel;
}

- (UIImageView *)qrCodeImgView {
    if (!_qrCodeImgView) {
        _qrCodeImgView = [[UIImageView alloc] init];
    }
    return _qrCodeImgView;
}

- (SALabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[SALabel alloc] init];
        _limitLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _limitLabel.font = HDAppTheme.PayNowFont.standard15;
        _limitLabel.textAlignment = NSTextAlignmentCenter;
        _limitLabel.numberOfLines = 0;
        _limitLabel.text = @"单笔限额";
    }
    return _limitLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
        _bottomBgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bottomBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _bottomBgView;
}

- (HDUIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _scanButton.imagePosition = HDUIButtonImagePositionTop;
        _scanButton.spacingBetweenImageAndTitle = kRealWidth(5);
        [_scanButton setTitle:PNLocalizedString(@"Sweep", @"扫一扫") forState:0];
        [_scanButton setImage:[UIImage imageNamed:@"pay_wallet_scan"] forState:0];
        [_scanButton setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        _scanButton.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_scanButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.scanBlock ?: self.scanBlock();
        }];
    }
    return _scanButton;
}

- (HDUIButton *)receiveButton {
    if (!_receiveButton) {
        _receiveButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _receiveButton.imagePosition = HDUIButtonImagePositionTop;
        _receiveButton.spacingBetweenImageAndTitle = kRealWidth(5);
        [_receiveButton setTitle:PNLocalizedString(@"Collection_code", @"收款码") forState:0];
        [_receiveButton setImage:[UIImage imageNamed:@"pay_wallet_collectionCode"] forState:0];
        [_receiveButton setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        _receiveButton.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_receiveButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.receiveCodeBlock ?: self.receiveCodeBlock();
        }];
    }
    return _receiveButton;
}

- (UIImage *)coolcashLogo {
    if (!_coolcashLogo) {
        _coolcashLogo = [UIImage imageNamed:@"CoolCash"];
    }
    return _coolcashLogo;
}
@end
