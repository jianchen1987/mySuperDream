//
//  TNSellerOrderFooterView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderFooterView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import "TNSellerOrderModel.h"
#import <HDUIKit/HDUIKit.h>
#import <HDVendorKit/HDWebImageManager.h>
#import <Masonry.h>


@interface TNSellerOrderFooterView ()
@property (strong, nonatomic) UIImageView *avatarImageView; ///< 头像
@property (strong, nonatomic) UILabel *nameLabel;           ///< 名称
@property (strong, nonatomic) HDLabel *expireResonLabel;    ///< 失效原因
@property (strong, nonatomic) UIView *sectionView;          ///<  底部分割视图
///
@property (strong, nonatomic) UIControl *phoneControl;
///
@property (strong, nonatomic) UIImageView *phoneImageView;
///
@property (strong, nonatomic) UILabel *phoneLabel;
@end


@implementation TNSellerOrderFooterView

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.expireResonLabel];
    [self.contentView addSubview:self.sectionView];
    [self.contentView addSubview:self.phoneControl];
    [self.phoneControl addSubview:self.phoneImageView];
    [self.phoneControl addSubview:self.phoneLabel];
}
- (void)setModel:(TNSellerOrderModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.headImgUrl placeholderImage:[UIImage imageNamed:@"neutral"] imageView:self.avatarImageView];
    self.nameLabel.text = model.nickName;
    if (model.status == TNSellerOrderStatusExpired && HDIsStringNotEmpty(model.invalidReason)) {
        self.expireResonLabel.hidden = NO;
        self.expireResonLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"CFoNRsJY", @"失效原因"), model.invalidReason];
    } else if (model.status == TNSellerOrderStatusFinish && model.commissionType == TNSellerIdentityTypePartTime) {
        self.expireResonLabel.hidden = NO;
        self.expireResonLabel.text = TNLocalizedString(@"GnNBppFg", @"兼职收益，不能自行发起提现");
    } else {
        self.expireResonLabel.hidden = YES;
    }
    self.phoneControl.hidden = (model.status != TNSellerOrderStatusPendingPayment);
    self.phoneLabel.text = model.phone;
    [self setNeedsUpdateConstraints];
}
- (void)clickCallPhone {
    if (HDIsStringNotEmpty(self.model.phone) && [self.model.phone hd_isPureDigitCharacters]) {
        [HDSystemCapabilityUtil makePhoneCall:self.model.phone];
    }
}
- (void)updateConstraints {
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(5));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(25), kRealWidth(25)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.left.equalTo(self.avatarImageView.mas_right).offset(kRealWidth(10));
        if (!self.phoneControl.isHidden) {
            make.right.lessThanOrEqualTo(self.phoneControl.mas_left).offset(-kRealWidth(15));
        } else {
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }
    }];
    if (!self.phoneControl.isHidden) {
        [self.phoneImageView sizeToFit];
        [self.phoneImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.phoneControl);
        }];
        [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.phoneControl.mas_centerY);
            make.left.equalTo(self.phoneImageView.mas_right).offset(kRealWidth(5));
            make.right.equalTo(self.phoneControl.mas_right).offset(-kRealWidth(25));
        }];
        [self.phoneControl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarImageView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    if (!self.expireResonLabel.isHidden) {
        [self.expireResonLabel sizeToFit];
        [self.expireResonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(kRealWidth(15));
        }];
    }
    [self.sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(10));
        if (!self.expireResonLabel.isHidden) {
            make.top.equalTo(self.expireResonLabel.mas_bottom);
        } else {
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(kRealWidth(15));
        }
    }];
    [super updateConstraints];
}
/** @lazy avatarImageView */
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neutral"]];
        _avatarImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width / 2];
        };
    }
    return _avatarImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.TinhNowFont.standard14;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _nameLabel;
}
/** @lazy expireResonLabel */
- (HDLabel *)expireResonLabel {
    if (!_expireResonLabel) {
        _expireResonLabel = [[HDLabel alloc] init];
        _expireResonLabel.font = HDAppTheme.TinhNowFont.standard12;
        _expireResonLabel.textColor = HexColor(0xFF2323);
        _expireResonLabel.numberOfLines = 0;
        _expireResonLabel.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(15));
    }
    return _expireResonLabel;
}
/** @lazy sectionView */
- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _sectionView;
}

/** @lazy phoneControl */
- (UIControl *)phoneControl {
    if (!_phoneControl) {
        _phoneControl = [[UIControl alloc] init];
        _phoneControl.layer.borderWidth = 0.5;
        _phoneControl.layer.borderColor = HDAppTheme.TinhNowColor.cD6DBE8.CGColor;
        _phoneControl.layer.cornerRadius = 12;
        [_phoneControl addTarget:self action:@selector(clickCallPhone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneControl;
}
/** @lazy phoneImageView */
- (UIImageView *)phoneImageView {
    if (!_phoneImageView) {
        _phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_seller_order_phone"]];
    }
    return _phoneImageView;
}
/** @lazy phoneLabel */
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = HDAppTheme.TinhNowFont.standard12;
        _phoneLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
    }
    return _phoneLabel;
}
@end
