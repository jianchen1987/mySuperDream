//
//  SASearchAddressResultTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASearchAddressResultTableViewCell.h"


@interface SASearchAddressResultTableViewCell ()
/// icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 地址
@property (nonatomic, strong) SALabel *addressLB;
/// 详细地址
@property (nonatomic, strong) SALabel *detailAddressLB;
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation SASearchAddressResultTableViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.whiteColor;

    [self.contentView addSubview:self.iconIV];
    //    [self.contentView addSubview:self.addressLB];
    [self.contentView addSubview:self.detailAddressLB];
    [self.contentView addSubview:self.bottomLine];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 15));
        make.left.equalTo(self.contentView).offset(kRealWidth(20));
        make.centerY.equalTo(self.detailAddressLB.mas_centerY);
    }];

    //    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(15));
    //        make.top.equalTo(self.contentView).offset(kRealWidth(15));
    //        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
    //    }];

    [self.detailAddressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.bottom.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SAAddressAutoCompleteItem *)model {
    _model = model;

    //    self.addressLB.text = model.name;
    self.detailAddressLB.text = model.name;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"address_icon"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)addressLB {
    if (!_addressLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _addressLB = label;
    }
    return _addressLB;
}

- (SALabel *)detailAddressLB {
    if (!_detailAddressLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        _detailAddressLB = label;
    }
    return _detailAddressLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
