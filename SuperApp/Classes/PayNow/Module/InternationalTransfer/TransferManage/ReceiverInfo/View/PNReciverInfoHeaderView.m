//
//  PNReciverInfoHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNReciverInfoHeaderView.h"
#import <YYText/YYText.h>


@interface PNReciverInfoHeaderView ()
@property (nonatomic, strong) YYLabel *tipsLabel;
@property (nonatomic, strong) UIView *checkBgView;
@property (nonatomic, strong) SALabel *agreementTipsLabel;

@property (nonatomic, assign) PNInterTransferThunesChannel channel;
@end


@implementation PNReciverInfoHeaderView

- (instancetype)initWithChannel:(PNInterTransferThunesChannel)channel {
    self = [super init];
    if (self) {
        HDLog(@"1");
        self.channel = channel;
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.tipsLabel];
    [self addSubview:self.checkBgView];
    [self.checkBgView addSubview:self.agreementBtn];
    [self.checkBgView addSubview:self.agreementTipsLabel];
}

- (void)hd_setupViews {
}

- (void)updateConstraints {
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
    }];

    [self.checkBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(4));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(4));
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.agreementBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkBgView.mas_top).offset(kRealWidth(5));
        make.size.mas_equalTo(self.agreementBtn.imageView.image.size);
        make.left.mas_equalTo(self.checkBgView.mas_left).offset(kRealWidth(8));
    }];

    [self.agreementTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agreementBtn.mas_right).offset(kRealWidth(8));
        make.top.mas_equalTo(self.checkBgView.mas_top).offset(kRealWidth(8));
        make.right.mas_equalTo(self.checkBgView.mas_right).offset(-kRealWidth(8));
        make.bottom.mas_equalTo(self.checkBgView.mas_bottom).offset(-kRealWidth(8));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setBgViewLabyer {
    self.checkBgView.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
    self.checkBgView.layer.borderWidth = 1;
    self.checkBgView.layer.cornerRadius = 4;
}

#pragma mark
- (UIView *)checkBgView {
    if (!_checkBgView) {
        _checkBgView = [[UIView alloc] init];
    }
    return _checkBgView;
}

- (HDUIButton *)agreementBtn {
    if (!_agreementBtn) {
        _agreementBtn = [[HDUIButton alloc] init];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_unselect"] forState:UIControlStateNormal];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_selected"] forState:UIControlStateSelected];
        @HDWeakify(self);
        [_agreementBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;

            if (btn.isSelected) {
                self.checkBgView.layer.borderWidth = 0;
            }
        }];
    }
    return _agreementBtn;
}

- (SALabel *)agreementTipsLabel {
    if (!_agreementTipsLabel) {
        _agreementTipsLabel = [[SALabel alloc] init];
        _agreementTipsLabel.numberOfLines = 0;
        _agreementTipsLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _agreementTipsLabel.font = HDAppTheme.PayNowFont.standard14;
        if (self.channel == PNInterTransferThunesChannel_Wechat) {
            _agreementTipsLabel.text = PNLocalizedString(@"pn_wechat_setting_tips_2", @"确认已阅读并完成收款人在微信中相关操作");
        } else {
            _agreementTipsLabel.text = PNLocalizedString(@"pn_alipay_setting_tips_2", @"确认已阅读并完成收款人在支付宝中相关操作");
        }
    }
    return _agreementTipsLabel;
}

- (YYLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[YYLabel alloc] init];
        _tipsLabel.font = HDAppTheme.PayNowFont.standard14;
        _tipsLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);

        if (self.channel == PNInterTransferThunesChannel_Wechat) {
            [self setTextWetchat];
        } else {
            [self setTextAlipay];
        }
    }
    return _tipsLabel;
}

- (void)setTextAlipay {
    NSString *tempStr
        = PNLocalizedString(@"pn_inter_big_tisp",
                            @"1、本服务为中国央行和柬埔寨国家银行审批通过的正规合法国际转账业务，相关资质请点击：>>国际转账业务资质\n2、使用本服务需先在支付宝“闪速收款”中绑定收款银行卡：\n    "
                            @"收款人为本人：>>点击“闪速收款”收款银行卡 \n    收款人为他人：>>复制“闪速收款”收款银行卡 \n3、请准确填写收款人信息 "
                            @"\n4、请确认收款人姓名为支付宝“闪速收款”收款人姓名。\n    收款人为本人：>>点击“闪速收款”首页\n    收款人为他人：>>复制“闪速收款”首页");

    // 1
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tempStr];
    text.yy_lineSpacing = 6;
    text.yy_font = HDAppTheme.PayNowFont.standard14;

    // 2
    NSString *h1 = PNLocalizedString(@"pn_inter_hig_qualifications", @">>国际转账业务资质");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             //        [SAWindowManager openUrl:kIR_Materials withParameters:@{}];
                             HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
                             vc.url = kIR_Materials;
                             [SAWindowManager navigateToViewController:vc parameters:@{}];
                         }];

    h1 = PNLocalizedString(@"pn_inter_hig_click_receiver_bank_card", @">>点击“闪速收款”收款银行卡");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             [SAWindowManager openUrl:kAlipay_url_3 withParameters:@{}];
                         }];

    // 3
    h1 = PNLocalizedString(@"pn_inter_hig_copy_receiver_bank_card", @">>复制“闪速收款”收款银行卡");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                             pasteboard.string = kAlipay_url_3;
                             [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_copy_success", @"复制成功") type:HDTopToastTypeInfo];
                         }];

    // 4
    h1 = PNLocalizedString(@"pn_inter_hig_click_home", @">>点击“闪速收款”首页");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             [SAWindowManager openUrl:kAlipay_url_4 withParameters:@{}];
                         }];

    // 5
    h1 = PNLocalizedString(@"pn_inter_hig_copy_home", @">>复制“闪速收款”首页");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                             pasteboard.string = kAlipay_url_4;
                             [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_copy_success", @"复制成功") type:HDTopToastTypeInfo];
                         }];

    self.tipsLabel.attributedText = text;
}

- (void)setTextWetchat {
    NSString *tempStr = PNLocalizedString(@"pn_wechat_big_tips",
                                          @"1、本服务为中国央行和柬埔寨国家银行审批通过的正规合法国际转账业务，相关资质请点击：>>"
                                          @"国际转账资质\n2、使用本服务需先在微信的小程序”微汇款“创建收款名片>>点击微信的“微汇款”\n3、请准确填写收款人信息");

    // 1
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tempStr];
    text.yy_lineSpacing = 6;
    text.yy_font = HDAppTheme.PayNowFont.standard14;

    // 2
    NSString *h1 = PNLocalizedString(@"pn_inter_hig_qualifications", @">>国际转账资质");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
                             vc.url = kIR_Materials;
                             [SAWindowManager navigateToViewController:vc parameters:@{}];
                         }];

    h1 = PNLocalizedString(@"pn_click_wechat_tiny", @">>点击微信的“微汇款”");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
                             vc.url = kWeChat_url_1;
                             [SAWindowManager navigateToViewController:vc parameters:@{}];
                         }];

    self.tipsLabel.attributedText = text;
}

@end
