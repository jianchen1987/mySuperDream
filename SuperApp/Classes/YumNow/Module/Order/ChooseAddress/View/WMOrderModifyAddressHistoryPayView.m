//
//  WMOrderModifyAddressHistoryPayView.m
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderModifyAddressHistoryPayView.h"
#import "GNEvent.h"


@interface WMOrderModifyAddressHistoryPayView ()
/// timer
@property (nonatomic, strong, nullable) NSTimer *timer;
///剩余支付时间
@property (nonatomic, assign) NSInteger remainingPaymentTime;

@end


@implementation WMOrderModifyAddressHistoryPayView

- (void)hd_setupViews {
    [self addSubview:self.payLB];
    [self addSubview:self.cancelBTN];
    [self addSubview:self.payBTN];
}

- (void)updateConstraints {
    [self.payLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.centerY.equalTo(self.payBTN);
        make.right.equalTo(self.cancelBTN.mas_left).offset(-kRealWidth(12));
    }];

    [self.payBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(26));
        make.top.mas_equalTo(kRealWidth(7));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_equalTo(-kRealWidth(17));
    }];

    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.payBTN.mas_left).offset(-kRealWidth(12));
        make.centerY.equalTo(self.payBTN);
        make.height.equalTo(self.payBTN);
    }];

    [self.payLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.payLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setModel:(WMModifyAddressListModel *)model {
    _model = model;
    self.remainingPaymentTime = model.remainingPaymentTime;
    if (!self.timer) {
        [self createTimer];
    }
}

- (void)setRemainingPaymentTime:(NSInteger)remainingPaymentTime {
    _remainingPaymentTime = remainingPaymentTime;
    NSArray *strArr = [[self lessSecondToDay:remainingPaymentTime] componentsSeparatedByString:@":"];
    NSMutableAttributedString *timeStr = NSMutableAttributedString.new;
    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                      attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                                                           alignment:YYTextVerticalAlignmentCenter];
    [timeStr appendAttributedString:spaceText];

    NSMutableAttributedString *getStr = [[NSMutableAttributedString alloc] initWithString:strArr.firstObject];
    getStr.yy_color = UIColor.whiteColor;
    getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"];
    YYTextBorder *getBorder = YYTextBorder.new;
    getBorder.insets = UIEdgeInsetsMake(-kRealWidth(6), -kRealWidth(4), -kRealWidth(6), -kRealWidth(4));
    getBorder.fillColor = HDAppTheme.WMColor.mainRed;
    getBorder.cornerRadius = kRealWidth(4);
    getStr.yy_textBackgroundBorder = getBorder;
    [timeStr appendAttributedString:getStr];

    spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                              alignToFont:[UIFont systemFontOfSize:0]
                                                                alignment:YYTextVerticalAlignmentCenter];
    [timeStr appendAttributedString:spaceText];

    getStr = [[NSMutableAttributedString alloc] initWithString:@":"];
    getStr.yy_color = HDAppTheme.WMColor.mainRed;
    getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"];
    [timeStr appendAttributedString:getStr];

    spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                              alignToFont:[UIFont systemFontOfSize:0]
                                                                alignment:YYTextVerticalAlignmentCenter];
    [timeStr appendAttributedString:spaceText];

    getStr = [[NSMutableAttributedString alloc] initWithString:strArr.lastObject];
    getStr.yy_color = UIColor.whiteColor;
    getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"];
    getBorder = YYTextBorder.new;
    getBorder.insets = UIEdgeInsetsMake(-kRealWidth(6), -kRealWidth(4), -kRealWidth(6), -kRealWidth(4));
    getBorder.fillColor = HDAppTheme.WMColor.mainRed;
    getBorder.cornerRadius = kRealWidth(4);
    getStr.yy_textBackgroundBorder = getBorder;
    [timeStr appendAttributedString:getStr];

    self.payLB.attributedText = timeStr;
}
///倒计时
- (void)countDownAction {
    if (self.remainingPaymentTime <= 0) {
        [GNEvent eventResponder:self target:self.payLB key:@"payCountDownEndAction" indexPath:nil info:@{@"model": self.model}];
        [self cancelTimer];
        return;
    }
    self.remainingPaymentTime -= 1;
}

- (void)createTimer {
    self.timer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [self.timer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void)cancelTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (NSString *)lessSecondToDay:(long)seconds {
    if (seconds <= 0)
        return @"";
    long min = (long)(seconds % (3600)) / 60;
    long second = (long)(seconds % 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}

- (YYLabel *)payLB {
    if (!_payLB) {
        _payLB = YYLabel.new;
    }
    return _payLB;
}

- (HDUIButton *)payBTN {
    if (!_payBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = kRealWidth(13);
        btn.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.highlighted = NO;
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [GNEvent eventResponder:self target:btn key:@"payAction" indexPath:nil info:@{@"model": self.model}];
        }];
        [btn setTitle:SALocalizedString(@"top_up_pay_now", @"立即支付") forState:UIControlStateNormal];
        _payBTN = btn;
    }
    return _payBTN;
}

- (HDUIButton *)cancelBTN {
    if (!_cancelBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = kRealWidth(13);
        btn.layer.backgroundColor = UIColor.whiteColor.CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
        [btn setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        btn.highlighted = NO;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(16), 0, kRealWidth(16));
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [GNEvent eventResponder:self target:btn key:@"cancelAction" indexPath:nil info:@{@"model": self.model}];
        }];
        [btn setTitle:SALocalizedString(@"cancel", @"取消") forState:UIControlStateNormal];
        _cancelBTN = btn;
    }
    return _cancelBTN;
}

- (void)dealloc {
    [self cancelTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
