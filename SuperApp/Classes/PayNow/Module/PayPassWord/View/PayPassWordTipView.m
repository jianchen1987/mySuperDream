//
//  PayPassWordTip.m
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PayPassWordTipView.h"


@implementation PayPassWordTipView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.bigBgView];
    [self.bigBgView addSubview:self.bgView];
    [self.bigBgView addSubview:self.iconImg];
    [self.bgView addSubview:self.detailLB];
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.sureBtn];
}

- (void)updateConstraints {
    [self.bigBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigBgView).offset(kRealWidth(30));
        make.right.equalTo(self.bigBgView.mas_right).offset(-kRealWidth(30));
        make.bottom.equalTo(self.cancelBtn).offset(kRealHeight(15));
        make.centerY.equalTo(self.bigBgView.mas_centerY).offset(kRealHeight(20));
    }];
    [self.iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView.mas_top);
        make.width.mas_equalTo(kRealWidth(75));
        make.height.mas_equalTo(kRealWidth(75));
    }];
    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(50));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(50));
        make.top.equalTo(self.iconImg.mas_bottom).offset(kRealHeight(23));
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLB.mas_bottom).offset(kRealWidth(38));
        make.right.equalTo(self.bgView.mas_centerX).offset(-kRealWidth(10));
        make.left.equalTo(self.bgView).offset(kRealWidth(10));
    }];
    [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn);
        make.left.equalTo(self.bgView.mas_centerX).offset(kRealWidth(10));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(10));
    }];

    NSArray *number = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    NSString *content = self.detailLB.text;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    for (int i = 0; i < content.length; i++) {
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:253 / 255.0 green:113 / 255.0 blue:39 / 255.0 alpha:1]} range:NSMakeRange(i, 1)];
        }
    }
    self.detailLB.attributedText = attributeString;

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)sureBtnTap {
    !self.sureBlock ?: self.sureBlock();
}

- (void)cancelBtnTap {
    !self.cancelBlock ?: self.cancelBlock();
}

- (UIView *)bigBgView {
    if (!_bigBgView) {
        _bigBgView = UIView.new;
        _bigBgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    }
    return _bigBgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _bgView;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = UIImageView.new;
        _iconImg.image = [UIImage imageNamed:@"pay_warning"];
    }
    return _iconImg;
}

- (SALabel *)detailLB {
    if (!_detailLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:16];
        ;
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _detailLB = label;
    }
    return _detailLB;
}

- (PNOperationButton *)cancelBtn {
    if (!_cancelBtn) {
        PNOperationButton *button = [PNOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:UIControlStateNormal];
        [button setTitle:PNLocalizedString(@"Forgot_password", @"") forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [button sizeToFit];
        //        [button applyPropertiesWithBackgroundColor:UIColor.clearColor];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.font forSize:14];
        [button addTarget:self action:@selector(cancelBtnTap) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = button;
    }
    return _cancelBtn;
}

- (PNOperationButton *)sureBtn {
    if (!_sureBtn) {
        PNOperationButton *button = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:PNLocalizedString(@"Re-enter", @"") forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [button sizeToFit];
        //        [button applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#FD7127"]];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.font forSize:14];
        [button addTarget:self action:@selector(sureBtnTap) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn = button;
    }
    return _sureBtn;
}
@end
