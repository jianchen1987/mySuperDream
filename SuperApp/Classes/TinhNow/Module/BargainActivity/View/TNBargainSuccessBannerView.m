//
//  TNBargainSuccessBannerView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainSuccessBannerView.h"


@interface TNBargainSuccessBannerView ()
/// 背景图
@property (strong, nonatomic) UIView *bgView;
/// 头像
@property (strong, nonatomic) UIImageView *headImageView;
/// 文案
@property (strong, nonatomic) UILabel *textLabel;
/// 商品图案
@property (strong, nonatomic) UIImageView *goodImageView;
@end


@implementation TNBargainSuccessBannerView
- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.headImageView];
    [self.bgView addSubview:self.textLabel];
    [self.bgView addSubview:self.goodImageView];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(12));
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(6));
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(23), kRealWidth(23)));
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(6));
    }];
    [self.goodImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.left.equalTo(self.textLabel.mas_right).offset(kRealWidth(6));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(11));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(23), kRealWidth(23)));
    }];
    [super updateConstraints];
}
- (void)setModel:(TNBargainSuccessModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.userImage placeholderImage:[UIImage imageNamed:@"tinhnow-default-avatar"] imageView:self.headImageView];
    self.textLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_bargain_show_get_tips", @"%@已拿到"), model.userName];
    [HDWebImageManager setImageWithURL:model.goodsNameImage placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(23), kRealWidth(23))] imageView:self.goodImageView];
    [self setNeedsUpdateConstraints];
}
- (void)setBackgroundColorAlpha:(CGFloat)alpha {
    _bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight radius:100];
        };
    }
    return _bgView;
}
/** @lazy headImageView */
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width * 0.5];
        };
    }
    return _headImageView;
}
/** @lazy textLabel */
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = HDAppTheme.TinhNowFont.standard11;
        _textLabel.textColor = [UIColor hd_colorWithHexString:@"#101010"];
    }
    return _textLabel;
}
/** @lazy goodImageView */
- (UIImageView *)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] init];
    }
    return _goodImageView;
}
@end
