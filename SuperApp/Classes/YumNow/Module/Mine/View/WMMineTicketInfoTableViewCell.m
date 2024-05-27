//
//  WMMineTicketInfoTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMineTicketInfoTableViewCell.h"


@interface WMMineTicketInfoTableViewCell ()
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 现金券数量
@property (nonatomic, strong) SALabel *cashCouponAmountLB;
/// 标题
@property (nonatomic, strong) SALabel *cashCouponLB;
/// 标题
@property (nonatomic, strong) SALabel *discountCouponAmountLB;
/// 标题
@property (nonatomic, strong) SALabel *discountCouponLB;
@end


@implementation WMMineTicketInfoTableViewCell

- (void)hd_setupViews {
    self.imageView.image = [UIImage imageNamed:@"icon-coupon"];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.cashCouponAmountLB];
    [self.contentView addSubview:self.cashCouponLB];
    [self.contentView addSubview:self.discountCouponAmountLB];
    [self.contentView addSubview:self.discountCouponLB];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.imageView.image.size);
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.centerY.equalTo(self.titleLB);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.contentView).offset(kRealWidth(10));
    }];

    [self.cashCouponAmountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(20));
        make.centerX.equalTo(self.cashCouponLB);
        if (self.discountCouponLB.isHidden) {
            make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        } else {
            make.right.lessThanOrEqualTo(self.contentView.mas_centerX).offset(-5);
        }
    }];

    [self.discountCouponAmountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.discountCouponAmountLB.isHidden) {
            make.top.equalTo(self.cashCouponAmountLB);
            make.centerX.equalTo(self.discountCouponLB);
            make.left.greaterThanOrEqualTo(self.contentView.mas_centerX).offset(5);
        }
    }];

    [self.cashCouponLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).multipliedBy(self.discountCouponLB.isHidden ? 1 : 0.5);
        make.top.equalTo(self.cashCouponAmountLB.mas_bottom).offset(kRealWidth(8));
        make.left.greaterThanOrEqualTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(15));
    }];

    [self.discountCouponLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.discountCouponLB.isHidden) {
            make.centerX.equalTo(self.contentView).multipliedBy(1.5);
            make.top.equalTo(self.discountCouponAmountLB.mas_bottom).offset(kRealWidth(8));
            make.right.lessThanOrEqualTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(15));
        }
    }];
    [super updateConstraints];
}

#pragma mark - public methods
- (void)configCellWithModel:(SACouponInfoRspModel *)model {
    self.cashCouponAmountLB.text = model.cashCouponAmount.stringValue;

    if (model.discountCouponAmount <= 0) {
        self.cashCouponLB.textAlignment = NSTextAlignmentCenter;
        self.cashCouponAmountLB.textAlignment = NSTextAlignmentCenter;
    } else {
        self.cashCouponLB.textAlignment = NSTextAlignmentLeft;
        self.cashCouponAmountLB.textAlignment = NSTextAlignmentRight;
    }

    self.discountCouponAmountLB.hidden = model.discountCouponAmount <= 0;
    self.discountCouponLB.hidden = self.discountCouponAmountLB.isHidden;
    if (!self.discountCouponAmountLB.isHidden) {
        self.discountCouponAmountLB.text = model.discountCouponAmount.stringValue;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"my_coupons", @"我的优惠券");
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)cashCouponAmountLB {
    if (!_cashCouponAmountLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard1Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.text = @"0";
        _cashCouponAmountLB = label;
    }
    return _cashCouponAmountLB;
}

- (SALabel *)cashCouponLB {
    if (!_cashCouponLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"cash_coupons", @"现金券");
        _cashCouponLB = label;
    }
    return _cashCouponLB;
}

- (SALabel *)discountCouponAmountLB {
    if (!_discountCouponAmountLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard1Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.text = @"0";
        label.hidden = true;
        _discountCouponAmountLB = label;
    }
    return _discountCouponAmountLB;
}

- (SALabel *)discountCouponLB {
    if (!_discountCouponLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"discount_coupons", @"折扣券");
        label.hidden = true;
        _discountCouponLB = label;
    }
    return _discountCouponLB;
}
@end
