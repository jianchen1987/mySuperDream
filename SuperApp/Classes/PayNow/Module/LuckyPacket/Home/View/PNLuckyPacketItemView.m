//
//  PNLuckyPacketItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLuckyPacketItemView.h"


@interface PNLuckyPacketItemView ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *contentLabel;
@property (nonatomic, strong) HDUIButton *btn;
@end


@implementation PNLuckyPacketItemView

- (void)hd_setupViews {
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.btn];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(4));
        make.top.mas_equalTo(self.iconImgView.mas_top).offset(kRealWidth(5));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(16));
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(4));
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];

    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNLuckyPacketItemModel *)model {
    _model = model;

    self.iconImgView.image = model.icon;
    self.titleLabel.text = model.titleStr;
    self.contentLabel.text = model.contentStr;

    self.backgroundColor = model.bgColor;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 2;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (HDUIButton *)btn {
    if (!_btn) {
        _btn = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [_btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.btnClickBlock ?: self.btnClickBlock();
        }];
    }
    return _btn;
}

@end


@implementation PNLuckyPacketItemModel

@end
