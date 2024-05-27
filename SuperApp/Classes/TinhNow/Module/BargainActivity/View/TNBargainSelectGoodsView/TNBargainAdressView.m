//
//  TNBargainAdressView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainAdressView.h"


@interface TNBargainAdressView ()
/// 标题  收货地址
@property (strong, nonatomic) UILabel *titleLabel;
/// 实际运费提示
@property (strong, nonatomic) UILabel *deliveryTips;
/// 背景圆角视图
@property (strong, nonatomic) UIView *bgView;
/// stackView
@property (strong, nonatomic) UIStackView *stackView;
/// 姓名 电话视图
@property (strong, nonatomic) UIView *nameBgView;
/// 地址视图
@property (strong, nonatomic) UIView *adressBgView;
/// 姓名
@property (strong, nonatomic) UILabel *nameLabel;
/// 电话
@property (strong, nonatomic) UILabel *phoneLabel;
/// 地址图片
@property (strong, nonatomic) UIImageView *adressImageView;
/// 地址文本
@property (strong, nonatomic) UILabel *adressLabel;
/// 右箭头
@property (strong, nonatomic) UIImageView *arrowImageView;
@end


@implementation TNBargainAdressView
- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.deliveryTips];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.nameBgView];
    [self.stackView addArrangedSubview:self.adressBgView];
    [self.nameBgView addSubview:self.nameLabel];
    [self.nameBgView addSubview:self.phoneLabel];
    [self.adressBgView addSubview:self.adressImageView];
    [self.adressBgView addSubview:self.adressLabel];
    [self.bgView addSubview:self.arrowImageView];

    self.titleLabel.text = TNLocalizedString(@"tn_bargain_shipping_adress", @"收货地址");
    self.deliveryTips.text = TNLocalizedString(@"tn_bargain_free_shipping", @"(免运费)");
    self.adressImageView.image = [UIImage imageNamed:@"tinhnow_adress_black"];
}
- (void)setAddressModel:(SAShoppingAddressModel *)addressModel {
    _addressModel = addressModel;
    if (HDIsStringNotEmpty(addressModel.fullAddress)) {
        self.nameBgView.hidden = false;
        self.adressLabel.text = addressModel.fullAddress;
        self.nameLabel.text = addressModel.consigneeName;
        self.phoneLabel.text = addressModel.mobile;
    } else {
        self.nameBgView.hidden = true;
        self.adressLabel.text = TNLocalizedString(@"tn_bargain_select_shipping_adress", @"请选择收货地址");
    }
    [self setNeedsUpdateConstraints];
}
- (CGFloat)getAdressViewHeight {
    [self layoutIfNeeded];
    CGFloat height = self.titleLabel.bottom + kRealWidth(10);
    height += kRealWidth(10);
    height += kRealWidth(22);
    height += self.adressBgView.height;
    height += kRealWidth(10);
    return height;
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
    }];
    [self.deliveryTips mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(kRealWidth(10));
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        make.bottom.left.right.equalTo(self);
    }];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.arrowImageView.mas_left).offset(-kRealWidth(10));
        make.center.equalTo(self.bgView);
    }];
    if (!self.nameBgView.isHidden) {
        [self.nameBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.stackView);
            make.height.mas_equalTo(kRealWidth(22));
        }];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.nameBgView);
        }];
        [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(kRealWidth(12));
            make.centerY.equalTo(self.nameLabel.mas_centerY);
        }];
    }

    CGFloat labelWidth = kScreenWidth - kRealWidth(30) - kRealWidth(38) - kRealWidth(30);
    CGFloat adressHeight = [self.adressLabel.text boundingAllRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard13].height;
    if (adressHeight <= 16) {
        adressHeight = kRealWidth(20);
    }
    [self.adressBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.stackView);
        make.height.mas_equalTo(adressHeight);
    }];
    [self.adressImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adressBgView);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
        make.centerY.equalTo(self.adressLabel.mas_centerY);
    }];
    [self.adressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adressImageView.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self.adressBgView);
        make.top.equalTo(self.adressBgView);
    }];

    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(1));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
    }];
    [super updateConstraints];
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor hd_colorWithHexString:@"#F8F8F8"];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:6];
        };
    }
    return _bgView;
}
/** @lazy stackView */
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = kRealWidth(5);
    }
    return _stackView;
}
/** @lazy nameBgView */
- (UIView *)nameBgView {
    if (!_nameBgView) {
        _nameBgView = [[UIView alloc] init];
    }
    return _nameBgView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
        _nameLabel.textColor = [UIColor hd_colorWithHexString:@"#2E2E2E"];
    }
    return _nameLabel;
}
/** @lazy _deliveryTips */
- (UILabel *)deliveryTips {
    if (!_deliveryTips) {
        _deliveryTips = [[UILabel alloc] init];
        _deliveryTips.font = HDAppTheme.TinhNowFont.standard12;
        _deliveryTips.textColor = [UIColor hd_colorWithHexString:@"#F65E6E"];
    }
    return _deliveryTips;
}
/** @lazy phoneLabel */
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = HDAppTheme.TinhNowFont.standard13;
        _phoneLabel.textColor = [UIColor hd_colorWithHexString:@"#767676"];
    }
    return _phoneLabel;
}
/** @lazy adressBgView */
- (UIView *)adressBgView {
    if (!_adressBgView) {
        _adressBgView = [[UIView alloc] init];
    }
    return _adressBgView;
}
/** @lazy adressImageView */
- (UIImageView *)adressImageView {
    if (!_adressImageView) {
        _adressImageView = [[UIImageView alloc] init];
        _adressImageView.contentMode = UIViewContentModeCenter;
        _adressImageView.image = [UIImage imageNamed:@"tinhnow_adress_add"];
    }
    return _adressImageView;
}
/** @lazy adressLabel */
- (UILabel *)adressLabel {
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc] init];
        _adressLabel.font = HDAppTheme.TinhNowFont.standard13;
        _adressLabel.numberOfLines = 0;
    }
    return _adressLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow_gray_small"];
        _arrowImageView.contentMode = UIViewContentModeCenter;
    }
    return _arrowImageView;
}
/** @lazy specNameLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12B;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}
@end
