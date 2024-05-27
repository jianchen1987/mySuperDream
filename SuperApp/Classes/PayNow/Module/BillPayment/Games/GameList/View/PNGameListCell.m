//
//  PNGamePaymentListCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameListCell.h"
#import "PNGameRspModel.h"


@interface PNGameListCell ()
///
@property (strong, nonatomic) UIView *bgView;
/// 头像
@property (strong, nonatomic) UIImageView *headImageView;
/// 名称
@property (strong, nonatomic) UILabel *nameLabel;
/// 描述
@property (strong, nonatomic) UILabel *desLabel;
@end


@implementation PNGameListCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HexColor(0xF3F4FA);
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.headImageView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.desLabel];
}
- (void)setModel:(PNGameCategoryModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.image size:CGSizeMake(kRealWidth(56), kRealWidth(56)) placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_square"] imageView:self.headImageView];
    self.nameLabel.text = model.name;
    self.desLabel.text = model.des;
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(12));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-kRealWidth(12));
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(8));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(56), kRealWidth(56)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.right.lessThanOrEqualTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(4));
    }];
    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealHeight(3));
        make.right.lessThanOrEqualTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(4));
    }];
    [super updateConstraints];
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _bgView;
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
        _nameLabel.font = [HDAppTheme.PayNowFont fontBold:16];
        _nameLabel.textColor = HexColor(0x333333);
    }
    return _nameLabel;
}
/** @lazy desLabel */
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 2;
        _desLabel.font = [HDAppTheme.PayNowFont fontRegular:11];
        //        [UIFont fontWithName:@"SanFranciscoText-Regular" size:11];
        _desLabel.textColor = HexColor(0x666666);
    }
    return _desLabel;
}
@end
