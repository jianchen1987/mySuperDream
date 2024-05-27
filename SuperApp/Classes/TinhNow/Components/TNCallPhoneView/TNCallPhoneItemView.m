//
//  TNCallPhoneItemView.m
//  SuperApp
//
//  Created by xixi on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCallPhoneItemView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNCustomerServiceView.h"
#import <UIView+HD_Extension.h>


@interface TNCallPhoneItemView ()
/// icon
@property (nonatomic, strong) UIImageView *iconImgView;
/// 运营商电话
@property (nonatomic, strong) UILabel *phoneTitleLabel;
/// 电话
@property (nonatomic, strong) UILabel *phoneLabel;
/// 电话icon
@property (nonatomic, strong) UIImageView *callImgView;

@end


@implementation TNCallPhoneItemView

- (void)hd_setupViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.phoneTitleLabel];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.callImgView];

    [self addGestureRecognizer:self.hd_tapRecognizer];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.phoneTitleLabel.hidden) {
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(63.f));
            make.centerY.mas_equalTo(self.mas_centerY);
        } else {
            make.top.mas_equalTo(self.mas_top).offset(kRealWidth(30.f));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(50.f));
        }
        make.size.mas_equalTo(self.iconImgView.image.size);
    }];

    if (!self.callImgView.hidden) {
        [self.callImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.callImgView.image.size);
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-50.f));
            make.centerY.equalTo(self.phoneLabel.mas_centerY);
        }];
    }


    if (!self.phoneTitleLabel.hidden) {
        [self.phoneTitleLabel sizeToFit];
        [self.phoneTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImgView.mas_bottom);
            make.centerX.equalTo(self.iconImgView.mas_centerX);
        }];
    }


    [self.phoneLabel sizeToFit];
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.callImgView.hidden) {
            make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(86.f));
        } else {
            make.right.mas_equalTo(self.callImgView.mas_left).offset(-kRealWidth(12.f));
        }
        make.centerY.equalTo(self.mas_centerY);
    }];

    [super updateConstraints];
}

- (void)setModel:(TNCustomerServiceItemModel *)model {
    _model = model;

    if (HDIsStringNotEmpty(model.title)) {
        self.phoneTitleLabel.text = model.title;
        self.phoneTitleLabel.hidden = NO;
        self.phoneTitleLabel.textColor = model.themeColor;
    } else {
        self.phoneTitleLabel.text = @"";
        self.phoneTitleLabel.hidden = YES;
    }

    if (HDIsStringNotEmpty(model.btnTitle) && [model.btnTitle hd_isPureDigitCharacters]) {
        self.callImgView.hidden = NO;
    } else {
        self.callImgView.hidden = YES;
    }
    self.phoneLabel.text = model.btnTitle;
    self.iconImgView.image = [UIImage imageNamed:model.btnImage];


    [self setNeedsUpdateConstraints];
}

#pragma mark - call phone

- (void)hd_clickedViewHandler {
    NSString *phoneStr = self.model.key;
    if (HDIsStringNotEmpty(phoneStr) && [phoneStr hd_isPureDigitCharacters]) {
        [HDSystemCapabilityUtil makePhoneCall:phoneStr];
    }
}

#pragma mark -
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)phoneTitleLabel {
    if (!_phoneTitleLabel) {
        _phoneTitleLabel = [[UILabel alloc] init];
        _phoneTitleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:17.f];
    }
    return _phoneTitleLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [UIColor hd_colorWithHexString:@"626262"];
        _phoneLabel.font = [HDAppTheme.TinhNowFont fontRegular:20.f];
        _phoneLabel.textAlignment = NSTextAlignmentRight;
    }
    return _phoneLabel;
}

- (UIImageView *)callImgView {
    if (!_callImgView) {
        _callImgView = [[UIImageView alloc] init];
        _callImgView.image = [UIImage imageNamed:@"tn_icon_callPhone"];
    }
    return _callImgView;
}

@end
