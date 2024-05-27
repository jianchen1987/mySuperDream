//
//  PNPacketRecordDetailsPasswordView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordDetailsPasswordView.h"


@interface PNPacketRecordDetailsPasswordView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDUIButton *copyPasswordBtn;
@end


@implementation PNPacketRecordDetailsPasswordView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };
    [self addSubview:self.titleLabel];
    [self addSubview:self.copyPasswordBtn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(16));
        make.right.mas_equalTo(self.copyPasswordBtn.mas_left).offset(-kRealWidth(12));
    }];

    [self.copyPasswordBtn sizeToFit];
    [self.copyPasswordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.width.equalTo(@(self.copyPasswordBtn.width + kRealWidth(15)));
        make.height.equalTo(@(self.copyPasswordBtn.height + kRealWidth(10)));
    }];

    [self.copyPasswordBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setPassword:(NSString *)password {
    _password = password;
    self.titleLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"pn_packet_lucky_number", @"红包口令"), self.password];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDUIButton *)copyPasswordBtn {
    if (!_copyPasswordBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_copy_packet_number", @"复制口令") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard11;
        button.layer.cornerRadius = kRealWidth(12);
        button.layer.borderWidth = PixelOne;
        button.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.password;
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_copy_success", @"复制成功") type:HDTopToastTypeSuccess];
        }];

        _copyPasswordBtn = button;
    }
    return _copyPasswordBtn;
}

@end
