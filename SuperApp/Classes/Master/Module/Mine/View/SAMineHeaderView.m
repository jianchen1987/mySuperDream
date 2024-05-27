//
//  SAMineHeaderView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMineHeaderView.h"
#import "SAApolloManager.h"
#import "SAGetUserInfoRspModel.h"
#import "SAInternationalizationModel.h"


@interface SAMineHeaderView ()
///< 头像
@property (nonatomic, strong) UIImageView *headIV;
///< 昵称
@property (nonatomic, strong) SALabel *nicknameLB;
///< 会员信息
@property (nonatomic, strong) SAOperationButton *memberInfo;
///< 积分余额
@property (nonatomic, strong) UILabel *pointBalance;
///< 签到有礼按钮
@property (nonatomic, strong) SAOperationButton *signupGiftBtn;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;
///< 签到跳转地址
@property (nonatomic, copy) NSString *signinEntranceUrlStr;

@end


@implementation SAMineHeaderView
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;

    [self addSubview:self.headIV];
    [self addSubview:self.nicknameLB];
    [self addSubview:self.memberInfo];
    [self addSubview:self.pointBalance];
    [self addSubview:self.signupGiftBtn];
    [self addSubview:self.arrowIV];

    [self addGestureRecognizer:self.hd_tapRecognizer];

    self.headIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
    };
    self.nicknameLB.text = SALocalizedString(@"nickname", @"请设置昵称");
}

- (void)hd_languageDidChanged {
    [self.signupGiftBtn setTitle:SALocalizedString(@"btn_sign_git", @"签到有礼") forState:UIControlStateNormal];
    if (![SAUser hasSignedIn]) {
        self.nicknameLB.text = SALocalizedString(@"please_sign_in", @"请登录");
    }

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.headIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(55), kRealWidth(55)));
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.centerY.equalTo(self);
    }];

    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.size.mas_equalTo(self.arrowIV.image.size);
    }];

    [self.signupGiftBtn sizeToFit];
    if ([SAUser hasSignedIn]) {
        [self.nicknameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIV.mas_right).offset(kRealWidth(15));
            make.top.equalTo(self.headIV.mas_top);
        }];

        [self.memberInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLB.mas_right).offset(5);
            make.centerY.equalTo(self.nicknameLB.mas_centerY);
            make.right.lessThanOrEqualTo(self.arrowIV.mas_left).offset(-10);
            make.height.mas_equalTo(kRealHeight(20));
        }];

        [self.pointBalance mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLB.mas_left);
            make.top.equalTo(self.nicknameLB.mas_bottom).offset(kRealHeight(14));
        }];

        [self.signupGiftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pointBalance.mas_right).offset(5);
            make.centerY.equalTo(self.pointBalance.mas_centerY);
            make.right.lessThanOrEqualTo(self.arrowIV.mas_left).offset(-10);
            make.height.mas_equalTo(kRealHeight(20));
        }];

        [self.memberInfo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.nicknameLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

        [self.signupGiftBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.pointBalance setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        [self.nicknameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIV.mas_right).offset(kRealWidth(15));
            if (self.signupGiftBtn.hidden) {
                make.centerY.equalTo(self.headIV.mas_centerY);
                make.right.equalTo(self.arrowIV.mas_left).offset(-10);
            } else {
                make.top.equalTo(self.headIV.mas_top);
            }
        }];

        if (!self.signupGiftBtn.hidden) {
            [self.signupGiftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nicknameLB.mas_left);
                make.top.equalTo(self.nicknameLB.mas_bottom).offset(kRealHeight(14));
            }];
        }
    }

    [super updateConstraints];
}

#pragma mark - override
- (void)hd_clickedViewHandler {
    !self.tapEventHandler ?: self.tapEventHandler();
}

#pragma mark - public methods
- (void)updateInfoWithNickName:(NSString *)nickName headUrl:(NSString *)url pointBalance:(NSNumber *)balance {
    [HDWebImageManager setImageWithURL:url placeholderImage:[UIImage imageNamed:@"neutral"] imageView:self.headIV];
    self.nicknameLB.text = HDIsStringEmpty(nickName) ? @"" : nickName;
    [self updatePointWithNumber:balance];
    self.memberInfo.hidden = YES;
    self.pointBalance.hidden = NO;

    [self setNeedsUpdateConstraints];
}

- (void)updateInfoWithModel:(SAGetUserInfoRspModel *_Nullable)model {
    if ([SAUser hasSignedIn]) {
        self.memberInfo.hidden = NO;
        self.pointBalance.hidden = NO;
    } else {
        self.memberInfo.hidden = YES;
        self.pointBalance.hidden = YES;
    }
    if (model) {
        if (HDIsStringNotEmpty(model.headURL)) {
            [HDWebImageManager setImageWithURL:model.headURL placeholderImage:[UIImage imageNamed:@"neutral"] imageView:self.headIV];
        } else {
            self.headIV.image = [UIImage imageNamed:@"neutral"];
        }

        if (HDIsStringNotEmpty(model.nickName)) {
            self.nicknameLB.text = model.nickName;
        }

        [self updatePointWithNumber:model.pointBalance];

        switch (model.opLevel) {
            case 2:
                [self.memberInfo setTitleColor:[UIColor hd_colorWithHexString:@"#495055"] forState:UIControlStateNormal];
                break;
            case 3:
                [self.memberInfo setTitleColor:[UIColor hd_colorWithHexString:@"#A5742D"] forState:UIControlStateNormal];
                break;
            case 4:
                [self.memberInfo setTitleColor:[UIColor hd_colorWithHexString:@"#635944"] forState:UIControlStateNormal];
                break;

            default:
                [self.memberInfo setTitleColor:[UIColor hd_colorWithHexString:@"#778FA0"] forState:UIControlStateNormal];
                break;
        }

        @HDWeakify(self);
        [HDWebImageManager setImageWithURL:model.memberLogo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(16, 16) logoWidth:8] imageView:self.memberInfo.imageView
                                 completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                     @HDStrongify(self);
                                     if (!error) {
                                         [self.memberInfo setImage:[image scaleToSize:CGSizeMake(16, 16)] forState:UIControlStateNormal];
                                         [self.memberInfo setTitle:model.opLevelName forState:UIControlStateNormal];
                                         [self.memberInfo sizeToFit];
                                         [self setNeedsUpdateConstraints];
                                     }
                                 }];

    } else {
        self.headIV.image = [UIImage imageNamed:@"neutral"];
        self.nicknameLB.text = SALocalizedString(@"please_sign_in", @"请登录");
    }

    [self setNeedsUpdateConstraints];
}

- (void)updateSigninEntrance:(NSString *)url {
    NSString *entranceSwitch = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeySigninEntrance];
    self.signinEntranceUrlStr = url;
    if (HDIsStringNotEmpty(self.signinEntranceUrlStr) && [entranceSwitch.lowercaseString isEqualToString:@"on"]) {
        self.signupGiftBtn.hidden = NO;
    } else {
        self.signupGiftBtn.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updatePointWithNumber:(NSNumber *)balance {
    NSString *pointBalanceStr = [NSString stringWithFormat:@"%@", balance];
    NSRange range = [pointBalanceStr rangeOfString:@"."];
    if (range.location != NSNotFound) {
        // 有小数
        if (range.location + 2 < pointBalanceStr.length) {
            // 精度丢失
            self.pointBalance.text = [NSString stringWithFormat:@"%@:%.1f", SALocalizedString(@"wcoin_balance", @"积分余额"), balance.doubleValue];
        } else {
            self.pointBalance.text = [NSString stringWithFormat:@"%@:%@", SALocalizedString(@"wcoin_balance", @"积分余额"), balance];
        }
    } else {
        // 无小数
        self.pointBalance.text = [NSString stringWithFormat:@"%@:%@", SALocalizedString(@"wcoin_balance", @"积分余额"), balance];
    }
}

#pragma mark - action
- (void)clickOnSigninEntranceButton:(SAOperationButton *)button {
    if (HDIsStringNotEmpty(self.signinEntranceUrlStr)) {
        [SAWindowManager openUrl:self.signinEntranceUrlStr withParameters:nil];
    }
}

#pragma mark - lazy load
- (UIImageView *)headIV {
    if (!_headIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"neutral"];
        _headIV = imageView;
    }
    return _headIV;
}

- (SALabel *)nicknameLB {
    if (!_nicknameLB) {
        SALabel *label = SALabel.new;
        label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        label.textColor = UIColor.whiteColor;
        label.numberOfLines = 1;
        _nicknameLB = label;
    }
    return _nicknameLB;
}

- (SAOperationButton *)memberInfo {
    if (!_memberInfo) {
        _memberInfo = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_memberInfo applyPropertiesWithBackgroundColor:UIColor.whiteColor];
        _memberInfo.cornerRadius = kRealHeight(20) / 2.0;
        _memberInfo.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _memberInfo.imageEdgeInsets = UIEdgeInsetsMake(2, 8, 2, 2);
        _memberInfo.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 8);
        [_memberInfo setImage:[HDHelper placeholderImageWithCornerRadius:8 size:CGSizeMake(16, 16) logoSize:CGSizeMake(8, 8)] forState:UIControlStateNormal];
        [_memberInfo setTitle:@"--" forState:UIControlStateNormal];
        [_memberInfo setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _memberInfo.userInteractionEnabled = NO;
    }

    return _memberInfo;
}

- (SAOperationButton *)signupGiftBtn {
    if (!_signupGiftBtn) {
        _signupGiftBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_signupGiftBtn applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#FFF100"]];
        _signupGiftBtn.cornerRadius = 4.0;
        _signupGiftBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_signupGiftBtn setTitle:SALocalizedString(@"btn_sign_git", @"签到有礼") forState:UIControlStateNormal];
        [_signupGiftBtn setTitleColor:[UIColor hd_colorWithHexString:@"#A5742D"] forState:UIControlStateNormal];
        [_signupGiftBtn setImage:[UIImage imageNamed:@"icon_signup_gift"] forState:UIControlStateNormal];
        _signupGiftBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 8, 2, 2);
        _signupGiftBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 8);
        [_signupGiftBtn addTarget:self action:@selector(clickOnSigninEntranceButton:) forControlEvents:UIControlEventTouchUpInside];
        _signupGiftBtn.hidden = YES;
    }

    return _signupGiftBtn;
}

- (UILabel *)pointBalance {
    if (!_pointBalance) {
        UILabel *label = UILabel.new;
        label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        label.textColor = UIColor.whiteColor;
        label.numberOfLines = 1;
        _pointBalance = label;
    }
    return _pointBalance;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [[UIImage imageNamed:@"black_arrow"] hd_imageWithTintColor:UIColor.whiteColor];
        _arrowIV = imageView;
    }
    return _arrowIV;
}
@end
