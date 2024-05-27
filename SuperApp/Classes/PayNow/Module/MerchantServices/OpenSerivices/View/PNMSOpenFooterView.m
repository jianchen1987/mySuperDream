//
//  PNMSOpenFooterView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOpenFooterView.h"
#import "HDAppTheme+PayNow.h"
#import "HDMediator+PayNow.h"
#import "HDTextView.h"
#import "HDUIButton.h"
#import "PNMultiLanguageManager.h"
#import "SALabel.h"
#import <YYText.h>


@interface PNMSOpenFooterView () <UITextViewDelegate>
@property (nonatomic, strong) HDUIButton *checkBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) HDUIButton *submitBtn;
@property (nonatomic, strong) YYLabel *yylabel;
@end


@implementation PNMSOpenFooterView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.checkBtn];
    [self addSubview:self.yylabel];
    [self addSubview:self.submitBtn];

    [self setProtocolText];
}

- (void)updateConstraints {
    [self.checkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(20));
        make.size.mas_equalTo(@(self.checkBtn.imageView.image.size));
    }];

    [self.yylabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBtn.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(20));
    }];

    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.yylabel.mas_bottom).offset(kRealWidth(35));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(kRealWidth(10) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark click
- (void)clickCheckAction {
    self.checkBtn.selected = !self.checkBtn.selected;

    self.submitBtn.enabled = self.checkBtn.selected;
}

#pragma mark
- (HDUIButton *)checkBtn {
    if (!_checkBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_check_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_check_sel"] forState:UIControlStateSelected];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self clickCheckAction];
        }];

        _checkBtn = button;
    }
    return _checkBtn;
}

- (HDUIButton *)submitBtn {
    if (!_submitBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"ms_submit_apply", @"提交申请") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        button.enabled = NO;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            !self.submitBtnClickBlock ?: self.submitBtnClickBlock();
        }];

        _submitBtn = button;
    }
    return _submitBtn;
}

- (YYLabel *)yylabel {
    if (!_yylabel) {
        _yylabel = [[YYLabel alloc] init];
        _yylabel.font = [HDAppTheme.PayNowFont fontMedium:12];
        _yylabel.textColor = HDAppTheme.PayNowColor.c333333;
        _yylabel.numberOfLines = 0;
        _yylabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(15) - kRealWidth(5) - kRealWidth(15) - self.checkBtn.imageView.image.size.width;
    }
    return _yylabel;
}

//设置协议文本
- (void)setProtocolText {
    NSString *h1 = @"T&C for KHQR";
    NSString *h2 = @"Merchant PAYMENT SERVICE AGREEMENT";
    NSString *postStr = [NSString stringWithFormat:@"%@", PNLocalizedString(@"ms_have_read_and_agree", @"我已阅读并同意")];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:postStr];
    NSMutableAttributedString *highlightText = [[NSMutableAttributedString alloc] initWithString:h1];
    [highlightText yy_setTextHighlightRange:highlightText.yy_rangeOfAll color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                      [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName": @"Disclaimer", @"navTitle": PNLocalizedString(@"disclaimer", @"免责声明")}];
                                  }];
    [text appendAttributedString:highlightText];

    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" & "]];
    highlightText = [[NSMutableAttributedString alloc] initWithString:h2];
    [highlightText yy_setTextHighlightRange:highlightText.yy_rangeOfAll color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                      [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName": @"MerchantServices", @"navTitle": @"Merchant PAYMENT SERVICE AGREEMENT"}];
                                  }];
    [text appendAttributedString:highlightText];

    self.yylabel.attributedText = text;
}
@end
