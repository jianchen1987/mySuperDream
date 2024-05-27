//
//  SACancellationApplicationView.m
//  SuperApp
//
//  Created by Tia on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationView.h"

/// 注销原因控件
@interface SACancellationApplicationItemView : SAView
/// 按钮名称
@property (nonatomic, copy) NSString *name;
/// 选择状态
@property (nonatomic, assign) BOOL selected;
/// 隐藏分割线
@property (nonatomic, assign) BOOL hiddenLine;
/// 点击回调
@property (nonatomic, copy) dispatch_block_t clickBlock;
/// 按钮
@property (nonatomic, strong) HDUIButton *button;
/// 分割线
@property (nonatomic, strong) UIView *line;

- (instancetype)initWithName:(NSString *)name;

@end


@implementation SACancellationApplicationItemView

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        [self.button setTitle:self.name forState:UIControlStateNormal];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.button];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(kRealWidth(-15));
        make.bottom.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];

    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedBTNHandler:(HDUIButton *)btn {
    !self.clickBlock ?: self.clickBlock();
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.button.selected = selected;
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    self.line.hidden = hiddenLine;
}

#pragma mark - lazy load
- (HDUIButton *)button {
    if (!_button) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchDown];
        [button setImage:[UIImage imageNamed:@"ac_icon_radio_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ac_icon_radio_sel"] forState:UIControlStateSelected];
        button.titleLabel.numberOfLines = 2;
        button.adjustsButtonWhenHighlighted = NO;
        button.spacingBetweenImageAndTitle = 4;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button sizeToFit];
        _button = button;
    }
    return _button;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hd_colorWithHexString:@"#E9EAEF"];
    }
    return _line;
}

@end


@interface SACancellationApplicationView () <HDTextViewDelegate>
/// 容器
@property (nonatomic, strong) UIView *reasonView;
/// 请选择注销原因文言
@property (nonatomic, strong) SALabel *reasonLB;
/// 选项按钮数组
@property (nonatomic, strong) NSArray *btnList;
/// 其他原因输入框
@property (nonatomic, strong) HDTextView *textView;
/// 下一步按钮
@property (nonatomic, strong) SAOperationButton *nextBtn;
/// 当前选中选项的按钮
@property (nonatomic, strong) SACancellationApplicationItemView *selectBtn;

@end


@implementation SACancellationApplicationView

- (void)hd_setupViews {
    self.backgroundColor = self.scrollView.backgroundColor = HDAppTheme.color.normalBackground;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.reasonView];
    [self.reasonView addSubview:self.reasonLB];

    [self.scrollViewContainer addSubview:self.textView];

    [self addSubview:self.nextBtn];
}

- (void)updateConstraints {
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-kRealWidth(8));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];

    [self.reasonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(8));
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.reasonLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonView).offset(kRealWidth(16));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    UIView *lastView = nil;
    for (SACancellationApplicationItemView *view in self.btnList) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.reasonLB.mas_bottom).offset(0);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            make.height.mas_equalTo(56);
            if (view == self.btnList.lastObject) {
                view.hiddenLine = YES;
                make.bottom.equalTo(self.reasonView);
            }
        }];
        lastView = view;
    }

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(8));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(96));
    }];
    [super updateConstraints];
}

#pragma mark - HDTextViewDelegate
- (void)textView:(HDTextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [HDTips showError:[NSString stringWithFormat:SALocalizedString(@"text_not_longer_than", @"文字不能超过 %@ 个字符"), @(textView.maximumTextLength)] inView:self];
}

- (BOOL)textViewShouldReturn:(HDTextView *)textView {
    [self endEditing:YES];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.selectBtn && [self.selectBtn.name isEqualToString:SALocalizedString(@"ac_reason5", @"其他原因")]) {
        self.nextBtn.enabled = self.textView.text.length;
    }
}

#pragma mark - event response
- (void)clickedNextBtnHandler {
    if (self.nextBlock) {
        SACancellationReasonType name;
        NSString *reason = nil;
        if ([self.selectBtn.name isEqualToString:SALocalizedString(@"ac_reason1", @"需要解绑手机")]) {
            name = SACancellationReasonTypeUnbindMobile;
        } else if ([self.selectBtn.name isEqualToString:SALocalizedString(@"ac_reason2", @"安全/隐私顾虑")]) {
            name = SACancellationReasonTypeSecurityConcerns;
        } else if ([self.selectBtn.name isEqualToString:SALocalizedString(@"ac_reason3", @"这是多余的账户")]) {
            name = SACancellationReasonTypeRedundantAccount;
        } else if ([self.selectBtn.name isEqualToString:SALocalizedString(@"ac_reason4", @"WOWNOW使用遇到困难")]) {
            name = SACancellationReasonTypeUseDifficulty;
        } else {
            name = SACancellationReasonTypeOtherReason;
            reason = self.textView.text;
        }
        SACancellationReasonModel *model = SACancellationReasonModel.new;
        model.type = name;
        model.reason = reason;
        self.nextBlock(model);
    }
}

- (void)clickedBTNHandler:(SACancellationApplicationItemView *)sender {
    if (self.selectBtn == sender)
        return;
    for (SACancellationApplicationItemView *btn in self.btnList) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.nextBtn.enabled = YES;
    self.textView.hidden = YES;
    if ([sender.name isEqualToString:SALocalizedString(@"ac_reason5", @"其他原因")]) {
        self.textView.hidden = NO;
        [self.textView becomeFirstResponder];
        self.nextBtn.enabled = self.textView.text.length;
    } else {
        [self endEditing:YES];
    }
    self.selectBtn = sender;
}

#pragma mark - lazy load
- (UIView *)reasonView {
    if (!_reasonView) {
        _reasonView = UIView.new;
        _reasonView.backgroundColor = UIColor.whiteColor;
    }
    return _reasonView;
}

- (SALabel *)reasonLB {
    if (!_reasonLB) {
        _reasonLB = SALabel.new;
        _reasonLB.numberOfLines = 0;
        _reasonLB.font = [HDAppTheme.font boldForSize:16];
        _reasonLB.textColor = HDAppTheme.color.G1;
        NSString *text = [NSString stringWithFormat:@"%@*", SALocalizedString(@"ac_tips2", @"请选择注销原因")];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributeString addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.color.sa_C1} range:[text rangeOfString:@"*"]];
        _reasonLB.attributedText = attributeString;
    }
    return _reasonLB;
}

- (NSArray *)btnList {
    if (!_btnList) {
        NSArray *btnTitlelist = @[
            SALocalizedString(@"ac_reason1", @"需要解绑手机"),
            SALocalizedString(@"ac_reason2", @"安全/隐私顾虑"),
            SALocalizedString(@"ac_reason3", @"这是多余的账户"),
            SALocalizedString(@"ac_reason4", @"WOWNOW使用遇到困难"),
            SALocalizedString(@"ac_reason5", @"其他原因")
        ];
        NSMutableArray *btns = NSMutableArray.new;
        for (int i = 0; i < btnTitlelist.count; i++) {
            SACancellationApplicationItemView *v = [[SACancellationApplicationItemView alloc] initWithName:btnTitlelist[i]];
            @HDWeakify(self);
            @HDWeakify(v);
            v.clickBlock = ^{
                @HDStrongify(self);
                @HDStrongify(v);
                [self clickedBTNHandler:v];
            };
            [self.reasonView addSubview:v];
            [btns addObject:v];
        }
        _btnList = btns;
    }
    return _btnList;
}

- (HDTextView *)textView {
    if (!_textView) {
        _textView = HDTextView.new;
        _textView.placeholder = SALocalizedString(@"ac_textview_placehold", @"请输入其他原因");
        _textView.placeholderColor = HDAppTheme.color.G3;
        _textView.font = HDAppTheme.font.standard4;
        _textView.textColor = HDAppTheme.color.G1;
        _textView.delegate = self;
        _textView.maximumTextLength = 150;
        _textView.backgroundColor = UIColor.whiteColor;
        _textView.layer.cornerRadius = 5;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.hidden = YES;
    }
    return _textView;
}

- (SAOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn addTarget:self action:@selector(clickedNextBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitle:SALocalizedStringFromTable(@"next_step", @"下一步", @"Buttons") forState:UIControlStateNormal];
        [_nextBtn applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
        _nextBtn.enabled = NO;
    }
    return _nextBtn;
}

@end
