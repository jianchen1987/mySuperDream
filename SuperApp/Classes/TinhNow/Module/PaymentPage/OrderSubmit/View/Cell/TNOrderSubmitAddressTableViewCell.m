//
//  TNOrderSubmitAddressTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderSubmitAddressTableViewCell.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNOrderSubmitAddressTableViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.hideRightArrow = NO;
        self.isShowEdit = NO;
    }
    return self;
}
@end


@interface TNOrderSubmitAddressTableViewCell ()

///
@property (nonatomic, strong) UILabel *titleLabel;
/// defualt
@property (nonatomic, strong) HDLabel *defaultLabel;
///
@property (nonatomic, strong) UIImageView *addressImageView;
///
@property (nonatomic, strong) UILabel *subTitleLabel;
///
@property (nonatomic, strong) UIImageView *arrowImageView;
///
@property (nonatomic, strong) UIButton *editBtn;
@end


@implementation TNOrderSubmitAddressTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.addressImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.defaultLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.editBtn];
}

- (void)updateConstraints {
    [self.addressImageView sizeToFit];
    [self.addressImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(self.addressImageView.frame.size);
    }];

    UIView *rightView = self.defaultLabel.isHidden ? (self.arrowImageView.isHidden ? nil : self.arrowImageView) : self.defaultLabel;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImageView.mas_right).offset(12);
        if (rightView) {
            make.right.lessThanOrEqualTo(rightView.mas_left).offset(-5);
        } else {
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
        }
        make.top.equalTo(self.contentView.mas_top).offset(14);
    }];

    if (!self.defaultLabel.hidden) {
        [self.defaultLabel sizeToFit];
        [self.defaultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.arrowImageView.isHidden) {
                make.right.lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-5);
            } else {
                make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
            }
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
            make.size.mas_equalTo(self.defaultLabel.frame.size);
        }];
    }

    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImageView.mas_right).offset(12);
        if (!self.arrowImageView.hidden) {
            make.right.lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-5);
        } else {
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
        }
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
    }];

    if (!self.arrowImageView.isHidden) {
        [self.arrowImageView sizeToFit];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(self.arrowImageView.frame.size);
        }];
    }

    if (!self.editBtn.isHidden) {
        [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.width.equalTo(@(45.f));
            make.height.equalTo(@(38.f));
        }];
    }

    [super updateConstraints];
}

- (void)setModel:(TNOrderSubmitAddressTableViewCellModel *)model {
    _model = model;

    if (HDIsStringNotEmpty(_model.name) && HDIsStringNotEmpty(_model.phone)) {
        NSString *key = [NSString stringWithFormat:@"tn_text_%@_title", model.gender];
        self.titleLabel.text = [NSString stringWithFormat:TNLocalizedString(key, @"%@,%@"), _model.name, _model.phone];
    }
    if (HDIsStringNotEmpty(_model.address)) {
        self.subTitleLabel.text = _model.address;
    }
    [self.defaultLabel setHidden:!_model.isDefault];
    [self.arrowImageView setHidden:_model.hideRightArrow];
    [self.editBtn setHidden:_model.isShowEdit];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy addressImageView */
- (UIImageView *)addressImageView {
    if (!_addressImageView) {
        _addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow-address-icon"]];
    }
    return _addressImageView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard15B;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"tn_page_deliveryto_title", @"Delivery to");
    }
    return _titleLabel;
}
/** @lazy subtitle */
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = HDAppTheme.TinhNowFont.standard15;
        _subTitleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.text = TNLocalizedString(@"tn_page_deliveryto_placeholder", @"Choose shipping address");
    }
    return _subTitleLabel;
}
/** @lazy default */
- (HDLabel *)defaultLabel {
    if (!_defaultLabel) {
        _defaultLabel = [[HDLabel alloc] init];
        _defaultLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 6, 2, 6);
        _defaultLabel.text = TNLocalizedString(@"tn_page_default_title", @"Default");
        _defaultLabel.backgroundColor = HDAppTheme.TinhNowColor.cFFF3E8;
        _defaultLabel.font = HDAppTheme.TinhNowFont.standard12;
        _defaultLabel.textColor = [UIColor hd_colorWithHexString:@"#FC821A"];
        _defaultLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _defaultLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"tn_order_detial_address_edit"] forState:0];
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
