//
//  PNGameDetailInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailInfoCell.h"
#import "PNGameRspModel.h"


@interface PNGameDetailInfoCell ()
/// 背景
@property (strong, nonatomic) UIImageView *bgImageView;
///
@property (strong, nonatomic) UIView *alphaView;
///
@property (strong, nonatomic) UIImageView *headImageView;
///
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UILabel *desLabel;
@end


@implementation PNGameDetailInfoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.alphaView];

    [self.bgImageView addSubview:self.headImageView];
    [self.bgImageView addSubview:self.nameLabel];
    [self.bgImageView addSubview:self.desLabel];
}
- (void)setModel:(PNGameCategoryModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.image size:CGSizeMake(kRealWidth(56), kRealWidth(56)) placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_square"] imageView:self.headImageView];
    [HDWebImageManager setImageWithURL:model.image size:CGSizeMake(kScreenWidth, kRealWidth(118)) placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_square"] imageView:self.bgImageView];
    self.nameLabel.text = model.name;

    self.desLabel.hidden = HDIsStringEmpty(model.des);
    self.desLabel.text = model.des;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.alphaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.bgImageView.mas_top).offset(kRealHeight(20));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(56), kRealWidth(56)));
        make.bottom.lessThanOrEqualTo(self.bgImageView.mas_bottom).offset(-kRealHeight(20));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.bgImageView.mas_right).offset(-kRealWidth(12));
    }];
    if (!self.desLabel.isHidden) {
        [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.lessThanOrEqualTo(self.bgImageView.mas_right).offset(-kRealWidth(12));
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealHeight(4));
            make.bottom.lessThanOrEqualTo(self.bgImageView.mas_bottom).offset(-kRealHeight(20));
        }];
        [self.desLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.headImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    }

    [super updateConstraints];
}
/** @lazy  bgImageView*/
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImageView;
}
/** @lazy alphaView */
- (UIView *)alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc] init];
        _alphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _alphaView;
}
/** @lazy headImageView */
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _headImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [HDAppTheme.PayNowFont fontSemibold:20];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
/** @lazy desLabel */
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 0;
        _desLabel.font = [HDAppTheme.PayNowFont fontRegular:12];
        _desLabel.textColor = [UIColor whiteColor];
    }
    return _desLabel;
}
@end
