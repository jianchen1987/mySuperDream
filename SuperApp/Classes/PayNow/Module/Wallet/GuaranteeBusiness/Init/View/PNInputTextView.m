//
//  PNInputTextView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNInputTextView.h"
#import "NSMutableAttributedString+Highlight.h"


@interface PNInputTextView () <HDTextViewDelegate>
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDTextView *textView;
@property (nonatomic, strong) SALabel *textLengthLabel;
@property (nonatomic, strong) UIView *lineLabel;
@end


@implementation PNInputTextView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.titleLabel];
    [self addSubview:self.textView];
    [self addSubview:self.textLengthLabel];
    [self addSubview:self.lineLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
        make.height.equalTo(@(kRealWidth(100)));
    }];

    [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(kRealWidth(16));
        make.bottom.equalTo(self.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (NSString *)currentText {
    return self.textView.text;
}

#pragma mark
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    if (height <= kRealWidth(100))
        return;

    [UIView animateWithDuration:0.25 animations:^{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)textViewDidChange:(HDTextView *)textView {
    self.textLengthLabel.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, textView.maximumTextLength];

    !self.textViewDidChangeBlock ?: self.textViewDidChangeBlock(textView.text);
}

#pragma mark
- (NSMutableAttributedString *)setTitleHighLight:(NSString *)title {
    NSString *higStr = @"*";
    NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, title];
    return [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14M highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                              norFont:HDAppTheme.PayNowFont.standard14M
                                             norColor:HDAppTheme.PayNowColor.c333333];
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.attributedText = [self setTitleHighLight:PNLocalizedString(@"Vd1QTGmu", @"交易内容")];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDTextView *)textView {
    if (!_textView) {
        HDTextView *textView = HDTextView.new;
        textView.maximumTextLength = 1000;
        textView.delegate = self;
        textView.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        textView.placeholderColor = HDAppTheme.color.G3;
        textView.bounces = false;
        textView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        textView.font = HDAppTheme.PayNowFont.standard14;
        textView.textColor = HDAppTheme.PayNowColor.c333333;
        textView.showsVerticalScrollIndicator = false;
        textView.layer.cornerRadius = kRealWidth(4);
        textView.tintColor = HDAppTheme.PayNowColor.mainThemeColor;
        _textView = textView;
    }
    return _textView;
}

- (SALabel *)textLengthLabel {
    if (!_textLengthLabel) {
        SALabel *label = SALabel.new;
        label.text = @"0/1000";
        label.textAlignment = NSTextAlignmentRight;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        label.hd_edgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        _textLengthLabel = label;
    }
    return _textLengthLabel;
}

- (UIView *)lineLabel {
    if (!_lineLabel) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _lineLabel = view;
    }
    return _lineLabel;
}

@end
