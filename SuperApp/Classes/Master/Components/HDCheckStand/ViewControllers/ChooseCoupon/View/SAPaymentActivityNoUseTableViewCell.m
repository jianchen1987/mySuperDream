//
//  SAPaymentActivityNoUseTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/5/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPaymentActivityNoUseTableViewCell.h"


@interface SAPaymentActivityNoUseTableViewCell ()
///< title
@property (nonatomic, strong) SALabel *titleLabel;
///<
@property (nonatomic, strong) UIImageView *tickIV;

@end


@implementation SAPaymentActivityNoUseTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tickIV];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.contentView.mas_top).offset(kRealHeight(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(15));
    }];

    [self.tickIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.tickIV.image = selected ? [UIImage imageNamed:@"chckstand_selected"] : [UIImage imageNamed:@"chckstand_unselected"];
}

#pragma mark - lazy load
/** @lazy titlelabel */
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _titleLabel.textColor = HDAppTheme.color.G1;
        _titleLabel.text = SALocalizedString(@"coupon_match_DiscountUnavailable", @"不使用优惠");
    }
    return _titleLabel;
}

/** @lazy tickivSA */
- (UIImageView *)tickIV {
    if (!_tickIV) {
        _tickIV = [[UIImageView alloc] init];
    }
    return _tickIV;
}

@end


@implementation SAPaymentActivityNoUseModel

@end
