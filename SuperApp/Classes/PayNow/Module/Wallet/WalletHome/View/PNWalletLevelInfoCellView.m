//
//  PNWalletLevelInfoViewCellModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNWalletLevelInfoCellView.h"
#import "PNCommonUtils.h"
#import "VipayUser.h"
#import <HDUIKit/HDMarqueeLabel.h>


@interface PNWalletLevelInfoCellView ()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView *tipsBgView;
@property (nonatomic, strong) UIImageView *leftIconImgView;
@property (nonatomic, strong) HDMarqueeLabel *tipsLabel;
@property (nonatomic, strong) UIImageView *levelLogoImgView;
@property (nonatomic, strong) SALabel *levelName;
@property (nonatomic, strong) HDUIButton *upgradeBtn;
@property (nonatomic, strong) HDUIButton *infoBtn;

@property (nonatomic, strong) UIView *bottomView;
@end


@implementation PNWalletLevelInfoCellView

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgImgView];

    [self.contentView addSubview:self.tipsBgView];
    [self.tipsBgView addSubview:self.leftIconImgView];
    [self.tipsBgView addSubview:self.tipsLabel];

    [self.contentView addSubview:self.levelLogoImgView];
    [self.contentView addSubview:self.levelName];
    [self.contentView addSubview:self.upgradeBtn];
    [self.contentView addSubview:self.infoBtn];

    [self.contentView addSubview:self.bottomView];
}

- (void)updateConstraints {
    [self.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    if (!self.tipsBgView.hidden) {
        [self.tipsBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.contentView);
            make.height.equalTo(@(kRealWidth(25)));
        }];

        [self.leftIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tipsBgView.mas_left).offset(kRealWidth(15));
            make.centerY.mas_equalTo(self.tipsBgView.mas_centerY);
            make.size.mas_equalTo(self.leftIconImgView.image.size);
        }];

        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftIconImgView.mas_right).offset(kRealWidth(10));
            make.right.mas_equalTo(self.tipsBgView.mas_right).offset(kRealWidth(-5));
            make.centerY.mas_equalTo(self.tipsBgView.mas_centerY);
        }];
    }

    [self.levelLogoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipsBgView.hidden) {
            make.top.mas_equalTo(self.tipsBgView.mas_bottom).offset(kRealWidth(15));
        } else {
            make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        }
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(kRealWidth(-15));
        //        make.size.mas_equalTo(@(CGSizeMake(kRealWidth(35), kRealWidth(35))));
        make.width.mas_equalTo(self.levelLogoImgView.mas_height);
    }];

    [self.infoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(self.levelLogoImgView);
        make.right.mas_equalTo(self.levelName.mas_right);
    }];

    [self.upgradeBtn sizeToFit];
    [self.upgradeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kRealWidth(30)));
        make.width.equalTo(@(self.upgradeBtn.width + kRealWidth(30)));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.levelLogoImgView.mas_centerY);
    }];

    [self.levelName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.levelLogoImgView.mas_right).offset(kRealWidth(5));
        make.centerY.mas_equalTo(self.levelLogoImgView.mas_centerY);
        make.right.mas_equalTo(self.upgradeBtn.mas_left).offset(kRealWidth(-10));
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@(15));
    }];
    [super updateConstraints];
}

- (void)setRefreshFlag:(BOOL)refreshFlag {
    _refreshFlag = refreshFlag;

    /**
     1、页面引导语栏需要根据账户等级展示不同的引导语；
     经典账户： 实名认证，升级高级账户，提高账户限额。
     高级账户：提供手持证件照认证，可升级为尊享账户，获得更高交易额度。
     尊享账户：无引导语
     */
    PNUserLevel accountLevel = VipayUser.shareInstance.accountLevel;
    // 非实名认证 显示提示语
    if (accountLevel == PNUserLevelNormal) {
        self.tipsBgView.hidden = NO;
        self.tipsLabel.text = PNLocalizedString(@"Real-name_upgrade", @"实名认证，升级高级账户，提高账户限额");
        [self.tipsLabel restartLabel];
        self.upgradeBtn.hidden = NO;
    } else if (accountLevel == PNUserLevelAdvanced) {
        // 非尊享用户 显示提示语
        self.tipsBgView.hidden = NO;
        self.tipsLabel.text = PNLocalizedString(@"Provide_photo_upgrade", @"提供手持证件照认证，可升级为尊享账户，获得更高交易额度。");
        [self.tipsLabel restartLabel];
        self.upgradeBtn.hidden = NO;
    } else if (accountLevel == PNUserLevelHonour) {
        self.tipsBgView.hidden = YES;
        self.tipsLabel.text = @"";

        if (VipayUser.shareInstance.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_SUCCESS) {
            self.upgradeBtn.hidden = YES;
        } else {
            self.upgradeBtn.hidden = NO;
        }
    } else {
        self.tipsBgView.hidden = YES;
        self.tipsLabel.text = @"";
        self.upgradeBtn.hidden = YES;
    }

    self.levelLogoImgView.image = [UIImage imageNamed:[PNCommonUtils getAccountLevelIconByCode:VipayUser.shareInstance.accountLevel]];
    self.levelName.text = [PNCommonUtils getAccountLevelNameByCode:VipayUser.shareInstance.accountLevel] ?: @"";
    [self.upgradeBtn setTitle:[PNCommonUtils getUpgradeStatusNameByCode:VipayUser.shareInstance.upgradeStatus] forState:0];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"pb_wallet_bg"];
    }
    return _bgImgView;
}

- (UIView *)tipsBgView {
    if (!_tipsBgView) {
        _tipsBgView = [[UIView alloc] init];
        _tipsBgView.hidden = YES;
        _tipsBgView.backgroundColor = [HDAppTheme.PayNowColor.c000000 colorWithAlphaComponent:0.5];
    }
    return _tipsBgView;
}

- (UIImageView *)leftIconImgView {
    if (!_leftIconImgView) {
        _leftIconImgView = [[UIImageView alloc] init];
        _leftIconImgView.image = [UIImage imageNamed:@"tips_info"];
    }
    return _leftIconImgView;
}

- (HDMarqueeLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = HDMarqueeLabel.new;
        _tipsLabel.marqueeType = HDMarqueeTypeContinuous;
        _tipsLabel.trailingBuffer = 20;
        _tipsLabel.rate = 50;
        _tipsLabel.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        _tipsLabel.font = HDAppTheme.PayNowFont.standard12M;
    }
    return _tipsLabel;
}

- (UIImageView *)levelLogoImgView {
    if (!_levelLogoImgView) {
        _levelLogoImgView = [[UIImageView alloc] init];
        _levelLogoImgView.image = [UIImage imageNamed:[PNCommonUtils getAccountLevelIconByCode:PNUserLevelNormal]];
    }
    return _levelLogoImgView;
}

- (SALabel *)levelName {
    if (!_levelName) {
        _levelName = [[SALabel alloc] init];
        _levelName.font = HDAppTheme.PayNowFont.standard13;
        _levelName.textColor = HDAppTheme.PayNowColor.cFFFFFF;
    }
    return _levelName;
}

- (HDUIButton *)upgradeBtn {
    if (!_upgradeBtn) {
        _upgradeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_upgradeBtn setTitle:@"升级中" forState:UIControlStateNormal];
        _upgradeBtn.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _upgradeBtn.titleLabel.font = HDAppTheme.PayNowFont.standard13;
        _upgradeBtn.hidden = YES;
        [_upgradeBtn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:UIControlStateNormal];
        _upgradeBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(17)];
        };

        [_upgradeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");

            PNAccountLevelUpgradeStatus upgradeStatus = VipayUser.shareInstance.upgradeStatus;

            if (upgradeStatus == PNAccountLevelUpgradeStatus_GoToUpgrade) {
                [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{@"needCall": @(YES)}];
            } else {
                [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountResultVC:@{}];
            }
        }];
    }
    return _upgradeBtn;
}

- (HDUIButton *)infoBtn {
    if (!_infoBtn) {
        _infoBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_infoBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            //            [HDMediator.sharedInstance navigaveToPayNowAccountInfoVC:@{}];
        }];
    }
    return _infoBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _bottomView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(15)];
        };
    }
    return _bottomView;
}

@end


@implementation PNWalletLevelInfoViewCellModel

@end
