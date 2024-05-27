//
//  TNOrderDetailAdressCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderDetailAdressCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNOrderDetailAdressCell ()
/// 人物头像
@property (strong, nonatomic) UIImageView *personImageView;
/// 名称电话文本
@property (strong, nonatomic) UILabel *nameAndPhoneLabel;
/// 定位图片
@property (strong, nonatomic) UIImageView *locationImageView;
/// 地址
@property (strong, nonatomic) UILabel *adressLabel;
///
@property (strong, nonatomic) HDUIButton *editBtn;
@end


@implementation TNOrderDetailAdressCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.personImageView];
    [self.contentView addSubview:self.nameAndPhoneLabel];
    [self.contentView addSubview:self.locationImageView];
    [self.contentView addSubview:self.adressLabel];
    [self.contentView addSubview:self.editBtn];
}
- (void)setModel:(TNOrderDetailAdressCellModel *)model {
    _model = model;
    if (HDIsStringNotEmpty(model.name) && HDIsStringNotEmpty(model.phone)) {
        NSString *key = [NSString stringWithFormat:@"tn_text_%@_title", model.gender];
        self.nameAndPhoneLabel.text = [NSString stringWithFormat:TNLocalizedString(key, @"%@,%@"), model.name, model.phone];
    }
    if (HDIsStringNotEmpty(model.address)) {
        self.adressLabel.text = model.address;
    }
    [self.editBtn setHidden:model.isShowEdit];
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.personImageView sizeToFit];
    [self.personImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(self.personImageView.image.size);
    }];
    [self.nameAndPhoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.personImageView.mas_right).offset(kRealWidth(5));
        if (!self.editBtn.isHidden) {
            make.right.lessThanOrEqualTo(self.editBtn.mas_left).offset(kRealWidth(5));
        } else {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }
    }];
    if (!self.editBtn.isHidden) {
        [self.editBtn sizeToFit];
        [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.centerY.equalTo(self.personImageView.mas_centerY);
            make.size.mas_equalTo(self.editBtn.imageView.image.size);
        }];
    }
    [self.locationImageView sizeToFit];
    [self.locationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameAndPhoneLabel.mas_bottom).offset(kRealWidth(5));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(self.locationImageView.image.size);
    }];
    [self.adressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameAndPhoneLabel.mas_bottom).offset(kRealWidth(5));
        make.left.equalTo(self.locationImageView.mas_right).offset(kRealWidth(5));
        if (!self.editBtn.isHidden) {
            make.right.lessThanOrEqualTo(self.editBtn.mas_left).offset(-kRealWidth(5));
        } else {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];

    [super updateConstraints];
}
/** @lazy personImageView */
- (UIImageView *)personImageView {
    if (!_personImageView) {
        _personImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_order_person"]];
    }
    return _personImageView;
}
/** @lazy nameAndPhoneLabel */
- (UILabel *)nameAndPhoneLabel {
    if (!_nameAndPhoneLabel) {
        _nameAndPhoneLabel = [[UILabel alloc] init];
        _nameAndPhoneLabel.font = HDAppTheme.TinhNowFont.standard14;
        _nameAndPhoneLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameAndPhoneLabel.numberOfLines = 0;
    }
    return _nameAndPhoneLabel;
}
/** @lazy locationImageView */
- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_order_location_k"]];
    }
    return _locationImageView;
}
/** @lazy adressLabel */
- (UILabel *)adressLabel {
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc] init];
        _adressLabel.font = HDAppTheme.TinhNowFont.standard14;
        _adressLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _adressLabel.numberOfLines = 0;
    }
    return _adressLabel;
}
- (HDUIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"tn_order_edit_k"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_editBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.editClickHanderBlock) {
                self.editClickHanderBlock();
            }
        }];
    }
    return _editBtn;
}
@end


@implementation TNOrderDetailAdressCellModel

@end
