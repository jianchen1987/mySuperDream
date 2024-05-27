//
//  TNOrderSubmitAddressChooseTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderSubmitAddressChooseTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAShoppingAddressModel.h"
#import "SACompleteAddressTipsView.h"


@interface TNOrderSubmitAddressChooseTableViewCell ()

/// 地址图标
@property (nonatomic, strong) UIImageView *addressIV;
///// 标题
//@property (nonatomic, strong) UILabel *titleLB;
/// 占位字符
@property (nonatomic, strong) UILabel *placeholderLB;
/// 地址容器
@property (nonatomic, strong) UIView *addrContainer;
/// 地址
@property (nonatomic, strong) UILabel *addressLB;
/// 联系人，电话
@property (nonatomic, strong) UILabel *contactLB;
/// 选择图片
@property (nonatomic, strong) UIImageView *arrowIV;
/// 底部线条
@property (nonatomic, strong) UIView *line;
/// 提示完善信息
@property (nonatomic, strong) SACompleteAddressTipsView *tipsView;

@end


@implementation TNOrderSubmitAddressChooseTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.addressIV];
    //    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.placeholderLB];
    [self.contentView addSubview:self.addrContainer];
    [self.addrContainer addSubview:self.addressLB];
    [self.addrContainer addSubview:self.contactLB];
    [self.contentView addSubview:self.arrowIV];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.tipsView];
}

- (void)updateConstraints {
    [self.addressIV sizeToFit];
    [self.addressIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(23));

        make.size.mas_equalTo(self.addressIV.frame.size);
    }];

    if (!self.placeholderLB.isHidden) {
        [self.placeholderLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressIV.mas_right).offset(kRealWidth(6));
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(22));
            make.right.equalTo(self.arrowIV.mas_left).offset(-kRealWidth(15));
            if (self.tipsView.isHidden) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(21));
            }
        }];
    }

    if (!self.addrContainer.isHidden) {
        [self.addrContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(22));
            make.right.equalTo(self.arrowIV.mas_left);
            if (self.tipsView.isHidden) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(20));
            }
        }];

        [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addrContainer.mas_left).offset(kRealWidth(31));
            make.top.equalTo(self.addrContainer.mas_top).offset(kRealWidth(0));
            make.right.equalTo(self.addrContainer.mas_right);
        }];

        [self.contactLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addrContainer.mas_left).offset(kRealWidth(31));
            make.top.equalTo(self.addressLB.mas_bottom).offset(kRealWidth(9));
            make.right.equalTo(self.addrContainer.mas_right);
            make.bottom.equalTo(self.addrContainer.mas_bottom);
        }];
    }
    [self.arrowIV sizeToFit];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.size.mas_equalTo(self.arrowIV.frame.size);
        if (!self.placeholderLB.isHidden) {
            make.centerY.equalTo(self.placeholderLB.mas_centerY);
        } else if (!self.addrContainer.isHidden) {
            make.centerY.equalTo(self.addrContainer.mas_centerY);
        } else {
            make.centerY.equalTo(self.contentView.mas_centerY);
        }
    }];

    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipsView.isHidden) {
            make.left.equalTo(self.contentView).offset(kRealWidth(28));
            make.top.equalTo(self.addrContainer.mas_bottom).offset(kRealWidth(12));
            make.bottom.equalTo(self.contentView).offset(-kRealWidth(10));
        }
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo([HDHelper pixelOne]);
    }];

    [super updateConstraints];
}

- (void)setModel:(SAShoppingAddressModel *)model {
    _model = model;
    if (HDIsStringNotEmpty(model.fullAddress)) {
        self.addressLB.text = model.fullAddress;
        NSString *key = [NSString stringWithFormat:@"tn_text_%@_title", model.gender];
        self.contactLB.text = [NSString stringWithFormat:TNLocalizedString(key, @"%@,%@"), model.consigneeName, model.mobile];
        self.addrContainer.hidden = NO;
        self.placeholderLB.hidden = YES;
        self.tipsView.hidden = ![model isNeedCompleteAddressInClientType:SAClientTypeTinhNow];
    } else {
        self.addrContainer.hidden = YES;
        self.tipsView.hidden = YES;
        self.placeholderLB.hidden = NO;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy addressIv */
- (UIImageView *)addressIV {
    if (!_addressIV) {
        _addressIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_product_adress"]];
    }
    return _addressIV;
}
/** @lazy placeholderLB */
- (UILabel *)placeholderLB {
    if (!_placeholderLB) {
        _placeholderLB = [[UILabel alloc] init];
        _placeholderLB.textColor = HDAppTheme.TinhNowColor.G1;
        _placeholderLB.font = HDAppTheme.TinhNowFont.standard17B;
        _placeholderLB.text = TNLocalizedString(@"tn_submit_address_placeholder", @"Choose shipping address");
        _placeholderLB.numberOfLines = 0;
    }
    return _placeholderLB;
}
/** @lazy addrContainer */
- (UIView *)addrContainer {
    if (!_addrContainer) {
        _addrContainer = [[UIView alloc] init];
    }
    return _addrContainer;
}
/** @lazy addressLB */
- (UILabel *)addressLB {
    if (!_addressLB) {
        _addressLB = [[UILabel alloc] init];
        _addressLB.font = HDAppTheme.TinhNowFont.standard15B;
        _addressLB.textColor = HDAppTheme.TinhNowColor.G1;
        _addressLB.numberOfLines = 0;
    }
    return _addressLB;
}
/** @lazy contactLb */
- (UILabel *)contactLB {
    if (!_contactLB) {
        _contactLB = [[UILabel alloc] init];
        _contactLB.font = HDAppTheme.TinhNowFont.standard15;
        _contactLB.textColor = HDAppTheme.TinhNowColor.G3;
        _contactLB.numberOfLines = 0;
    }
    return _contactLB;
}
/** @lazy arrowIV */
- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowIV;
}
/** @lazy line */
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _line;
}

- (SACompleteAddressTipsView *)tipsView {
    if (!_tipsView) {
        _tipsView = SACompleteAddressTipsView.new;
        _tipsView.tintColor = HDAppTheme.TinhNowColor.C1;
    }
    return _tipsView;
}
@end
