//
//  TNSearchFindSubItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSearchFindSubItemView.h"


@interface TNSearchFindSubItemView ()
/// 点击按钮
@property (nonatomic, strong) HDUIButton *clickBtn;
/// icon
@property (nonatomic, strong) UIImageView *iconImgView;
/// 文本
@property (nonatomic, strong) SALabel *contentLabel;
@end


@implementation TNSearchFindSubItemView
- (void)hd_setupViews {
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(12)];
    };

    [self addSubview:self.iconImgView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.clickBtn];
}

- (void)updateConstraints {
    if (!self.iconImgView.isHidden) {
        [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(@(CGSizeMake(kRealWidth(14), kRealWidth(14))));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.iconImgView.isHidden) {
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        } else {
            make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(5));
        }

        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(15));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    [self.clickBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(TNSearchRankAndDiscoveryItemModel *)model {
    _model = model;
    self.contentLabel.text = self.model.value;
    self.contentLabel.textColor = self.model.valueColor;

    if (HDIsStringNotEmpty(self.model.imageName)) {
        self.iconImgView.image = [UIImage imageNamed:self.model.imageName];
        self.iconImgView.hidden = NO;
    } else {
        self.iconImgView.hidden = YES;
    }

    self.backgroundColor = model.bgColor;

    [self setNeedsUpdateConstraints];
}

- (CGSize)getSizeFits {
    //    [self setNeedsLayout];
    //    [self layoutIfNeeded];
    CGFloat height = kRealHeight(25);
    CGFloat textWidth = [self.contentLabel.text boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(15) * 2, height) font:self.contentLabel.font].width;
    CGFloat width = textWidth + kRealWidth(30) + (self.iconImgView.isHidden ? 0 : kRealWidth(20));

    return CGSizeMake(width, height);
}
- (CGSize)sizeThatFits:(CGSize)size {
    return [self getSizeFits];
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.hidden = YES;
    }
    return _iconImgView;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.TinhNowColor.cFFFFFF;
        label.font = HDAppTheme.TinhNowFont.standard12M;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (HDUIButton *)clickBtn {
    if (!_clickBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.btnClickBlock ?: self.btnClickBlock(self.model);
        }];

        _clickBtn = button;
    }
    return _clickBtn;
}
@end
