//
//  PNMSWithdrawListItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdrawListItemView.h"


@interface PNMSWithdrawListItemView ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDUIButton *clickBtn;
@property (nonatomic, strong) UIImageView *arrowImgView;
@end


@implementation PNMSWithdrawListItemView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImgView];
    [self addSubview:self.clickBtn];
}

- (void)setTitlel:(NSString *)title icon:(NSString *)icon {
    self.iconImgView.image = [UIImage imageNamed:icon];
    self.titleLabel.text = title;

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
    }];

    [self.clickBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (HDUIButton *)clickBtn {
    if (!_clickBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickBtnBlock ?: self.clickBtnBlock();
        }];

        _clickBtn = button;
    }
    return _clickBtn;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_arrow_gray_small"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

@end
