//
//  PNInterTransferReciverInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferReciverInfoCell.h"
#import "NSString+SA_Extension.h"


@interface PNInterTransferReciverInfoCell ()
@property (nonatomic, strong) UIImageView *leftIconImgView;
///
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UILabel *phoneLabel;
///
@property (strong, nonatomic) HDUIButton *editBtn;
///
@property (strong, nonatomic) UIView *lineView;
@end


@implementation PNInterTransferReciverInfoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.leftIconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.editBtn];
    [self.contentView addSubview:self.lineView];
}

- (void)setRightImage:(UIImage *)rightImage {
    [self.editBtn setImage:rightImage forState:UIControlStateNormal];
    [self.editBtn sizeToFit];
    self.editBtn.userInteractionEnabled = NO;
}

- (void)setModel:(PNInterTransferReciverModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:self.model.logoPath placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(45), kRealWidth(45))] imageView:self.leftIconImgView];
    self.nameLabel.text = model.fullName;
    NSString *phone = model.msisdn;
    if (model.msisdn.length >= 11) {
        phone = [model.msisdn stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    } else if (HDIsStringNotEmpty(model.msisdn)) {
        phone = [model.msisdn SA_desensitize];
    }
    self.phoneLabel.text = phone;
    [self setNeedsUpdateConstraints];
}

- (void)setHiddenEditBtn:(BOOL)hiddenEditBtn {
    _hiddenEditBtn = hiddenEditBtn;
    self.editBtn.hidden = hiddenEditBtn;
}

- (void)setHiddenLeftImage:(BOOL)hidden {
    self.leftIconImgView.hidden = NO;

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.leftIconImgView.hidden) {
        [self.leftIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(@(CGSizeMake(kRealWidth(45), kRealWidth(45))));
            make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
            make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(16));
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-16));
        }];
    }

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        if (self.leftIconImgView.hidden) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        } else {
            make.left.equalTo(self.leftIconImgView.mas_right).offset(kRealWidth(8));
        }
        make.right.lessThanOrEqualTo(self.editBtn.mas_left).offset(kRealWidth(10));
    }];

    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(5));
        if (self.leftIconImgView.hidden) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }
    }];
    [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.height.equalTo(@(PixelOne));
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-PixelOne));
    }];

    [super updateConstraints];
}

#pragma mark
- (UIImageView *)leftIconImgView {
    if (!_leftIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"CoolCash"];
        imageView.hidden = YES;
        _leftIconImgView = imageView;
    }
    return _leftIconImgView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [HDAppTheme.PayNowFont fontBold:16];
        _nameLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

/** @lazy phoneLabel */
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [HDAppTheme.PayNowFont fontRegular:12];
        _phoneLabel.textColor = HDAppTheme.PayNowColor.c333333;
    }
    return _phoneLabel;
}

/** @lazy editBtn */
- (HDUIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[HDUIButton alloc] init];
        [_editBtn setImage:[UIImage imageNamed:@"pn_receiver_edit"] forState:UIControlStateNormal];
        [_editBtn sizeToFit];
        @HDWeakify(self);
        [_editBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.editClickCallBack ?: self.editClickCallBack();
        }];
    }
    return _editBtn;
}

/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _lineView;
}
@end
