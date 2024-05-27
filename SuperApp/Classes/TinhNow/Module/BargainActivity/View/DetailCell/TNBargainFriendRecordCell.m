//
//  TNBargainFriendRecordCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainFriendRecordCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNBargainFriendRecordCell ()
/// 头像
@property (strong, nonatomic) UIImageView *userIcon;
/// 名字
@property (strong, nonatomic) UILabel *nameLabel;
/// 砍价金额
@property (strong, nonatomic) UILabel *bargainPriceLabel;
@end


@implementation TNBargainFriendRecordCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.userIcon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.bargainPriceLabel];
}
- (void)updateConstraints {
    [self.userIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon.mas_centerY);
        make.left.equalTo(self.userIcon.mas_right).offset(kRealWidth(10));
    }];
    [self.bargainPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.nameLabel.mas_right).offset(kRealWidth(10));
        make.centerY.equalTo(self.userIcon.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
- (void)setBargainType:(TNBargainTaskType)bargainType {
    _bargainType = bargainType;
}
- (void)setModel:(TNHelpPeolpleRecordeModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.img placeholderImage:[UIImage imageNamed:@"tinhnow-default-avatar"] imageView:self.userIcon];
    self.nameLabel.text = model.userName;
    if (self.bargainType != TNBargainTaskTypeBigChallenge) {
        self.bargainPriceLabel.text = [NSString stringWithFormat:@"-%@", model.money.thousandSeparatorAmount];
    } else {
        self.bargainPriceLabel.text = TNLocalizedString(@"tn_bargain_success", @"助力成功");
    }

    [self setNeedsUpdateConstraints];
}
/** @lazy userIcon */
- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width * 0.5];
        };
    }
    return _userIcon;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
        _nameLabel.textColor = [UIColor hd_colorWithHexString:@"#454545"];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
/** @lazy bargainPriceLabel */
- (UILabel *)bargainPriceLabel {
    if (!_bargainPriceLabel) {
        _bargainPriceLabel = [[UILabel alloc] init];
        _bargainPriceLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _bargainPriceLabel.textColor = [UIColor hd_colorWithHexString:@"#FE2337"];
    }
    return _bargainPriceLabel;
}
@end
