//
//  TNNotReviewGoodCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNotReviewGoodCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNNotReviewGoodCell ()
/// 图片
@property (strong, nonatomic) UIImageView *goodImageView;
/// 标题
@property (strong, nonatomic) HDLabel *nameLabel;
/// 价格
@property (strong, nonatomic) HDLabel *priceLabel;
/// 数量
@property (strong, nonatomic) HDLabel *numLabel;
/// 规格
@property (strong, nonatomic) HDLabel *specLabel;
@end


@implementation TNNotReviewGoodCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.goodImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.specLabel];
}
- (void)updateConstraints {
    [self.goodImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodImageView.mas_top);
        make.left.equalTo(self.goodImageView.mas_right).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.specLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(8));
        make.left.equalTo(self.goodImageView.mas_right).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodImageView.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
- (void)setInfo:(TNMyNotReviewGoodInfo *)info {
    _info = info;
    [HDWebImageManager setImageWithURL:info.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80))] imageView:self.goodImageView];
    self.nameLabel.text = info.name;
    self.priceLabel.text = info.price.thousandSeparatorAmount;
    self.numLabel.text = [NSString stringWithFormat:@"x%ld", info.quantity];
    self.specLabel.text = [info.specificationValue componentsJoinedByString:@","];
    [self setNeedsUpdateConstraints];
}
/** @lazy goodImageView */
- (UIImageView *)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] init];
        _goodImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _goodImageView;
}
/** @lazy nameLabel */
- (HDLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[HDLabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.hd_lineSpace = 3;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _nameLabel;
}
/** @lazy priceLabel */
- (HDLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[HDLabel alloc] init];
        _priceLabel.textColor = HexColor(0xFF2323);
        _priceLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _priceLabel;
}
/** @lazy numLabel */
- (HDLabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[HDLabel alloc] init];
        _numLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _numLabel.font = HDAppTheme.TinhNowFont.standard15;
        _numLabel.numberOfLines = 2;
    }
    return _numLabel;
}
/** @lazy specLabel */
- (HDLabel *)specLabel {
    if (!_specLabel) {
        _specLabel = [[HDLabel alloc] init];
        _specLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _specLabel.font = HDAppTheme.TinhNowFont.standard12;
        _specLabel.numberOfLines = 2;
    }
    return _specLabel;
}
@end
