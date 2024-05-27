//
//  PNMSIntroductionView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSIntroductionView.h"
#import "SAInfoView.h"
#import "ViPayUser.h"


@interface PNMSIntroductionView ()
@property (nonatomic, strong) UIImageView *bannerImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *sectionLabel;
@property (nonatomic, strong) SAInfoView *oneInfoView;
@property (nonatomic, strong) SAInfoView *twoInfoView;
@property (nonatomic, strong) SAInfoView *threeInfoView;
@property (nonatomic, strong) HDUIButton *openBtn; ///< 开通
@property (nonatomic, strong) HDUIButton *bindBtn; ///< 关联
@end


@implementation PNMSIntroductionView

- (void)hd_bindViewModel {
    [self updateData];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.bannerImgView];
    [self.scrollViewContainer addSubview:self.titleLabel];
    [self.scrollViewContainer addSubview:self.sectionLabel];
    [self.scrollViewContainer addSubview:self.oneInfoView];
    [self.scrollViewContainer addSubview:self.twoInfoView];
    [self.scrollViewContainer addSubview:self.threeInfoView];
    [self.scrollViewContainer addSubview:self.openBtn];
    [self.scrollViewContainer addSubview:self.bindBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bannerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(12));
        CGFloat width = kScreenWidth - 2 * kRealWidth(12);
        // 宽高比例是 1.99
        make.height.equalTo(@(width / 1.99));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.bannerImgView.mas_bottom).offset(kRealWidth(24));
    }];

    [self.sectionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(24));
    }];

    [self.oneInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(12));
        make.top.mas_equalTo(self.sectionLabel.mas_bottom).offset(kRealWidth(12));
    }];

    [self.twoInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(12));
        make.top.mas_equalTo(self.oneInfoView.mas_bottom);
    }];

    [self.threeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(12));
        make.top.mas_equalTo(self.twoInfoView.mas_bottom);
    }];

    [self.openBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.threeInfoView.mas_bottom).offset(kRealWidth(100));
        make.height.equalTo(@(kRealWidth(48)));
    }];

    [self.bindBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.openBtn.mas_bottom).offset(kRealWidth(8));
        make.height.equalTo(@(kRealWidth(48)));
        make.bottom.equalTo(self.scrollViewContainer).offset(-(kRealWidth(24) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)updateData {
    NSString *url = @"";
    if (SAMultiLanguageManager.currentLanguage == SALanguageTypeKH) {
        url = @"https://img.coolcashcam.com/assets/khqr/poster/scan220607_km_KH_3x.png";
    } else if (SAMultiLanguageManager.currentLanguage == SALanguageTypeCN) {
        url = @"https://img.coolcashcam.com/assets/khqr/poster/scan220607_zh_CN_3x.png";
    } else {
        url = @"https://img.coolcashcam.com/assets/khqr/poster/scan220607_en_US_3x.png";
    }

    [HDWebImageManager setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_middle"] imageView:self.bannerImgView
                             completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                 if (error) {
                                     self.bannerImgView.contentMode = UIViewContentModeCenter;
                                     self.bannerImgView.backgroundColor = HDAppTheme.PayNowColor.cCCCCCC;
                                     self.bannerImgView.layer.cornerRadius = kRealWidth(4);
                                 }
                             }];
}

- (BOOL)checkUserLevel {
    ///用户KYC是否为高级或尊享账户？
    if (VipayUser.shareInstance.accountLevel != PNUserLevelHonour && VipayUser.shareInstance.accountLevel != PNUserLevelAdvanced) {
        [NAT showAlertWithMessage:PNLocalizedString(@"pre_upgrade_KYC_tips", @"您的账户还完成KYC认证，请先升级您的账户。") confirmButtonTitle:PNLocalizedString(@"Go_to_upgrade", @"去升级")
            confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
                if (VipayUser.shareInstance.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALING || VipayUser.shareInstance.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_UPGRADING
                    || VipayUser.shareInstance.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING) {
                    [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountResultVC:@{}];
                } else {
                    [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{}];
                }
            }
            cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark
- (UIImageView *)bannerImgView {
    if (!_bannerImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _bannerImgView = imageView;
    }
    return _bannerImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"ms_introduction_t1", @"CoolCash为您提供一整套便捷的商户服务，包括商户KHQR收款码、每日收款统计、收款到账语音播报、退款、资金转账等服务");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)sectionLabel {
    if (!_sectionLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"ms_open_procedure", @"开通流程");
        _sectionLabel = label;
    }
    return _sectionLabel;
}

- (SAInfoView *)oneInfoView {
    if (!_oneInfoView) {
        SAInfoView *infoView = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = PNLocalizedString(@"ms_open_1", @"1、提交商户服务开通申请；");
        model.keyColor = HDAppTheme.PayNowColor.c999999;
        model.keyFont = HDAppTheme.PayNowFont.standard14;
        model.keyNumbersOfLines = 0;
        model.leftImage = [UIImage imageNamed:@"pn_ms_opne_1"];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), 0, kRealWidth(8), kRealWidth(15));
        model.lineWidth = 0;
        infoView.model = model;
        _oneInfoView = infoView;
    }
    return _oneInfoView;
}

- (SAInfoView *)twoInfoView {
    if (!_twoInfoView) {
        SAInfoView *infoView = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = PNLocalizedString(@"ms_open_2", @"2、CoolCash审核商户信息；");
        model.keyColor = HDAppTheme.PayNowColor.c999999;
        model.keyFont = HDAppTheme.PayNowFont.standard14;
        model.keyNumbersOfLines = 0;
        model.leftImage = [UIImage imageNamed:@"pn_ms_opne_2"];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), 0, kRealWidth(8), kRealWidth(15));
        model.lineWidth = 0;
        infoView.model = model;
        _twoInfoView = infoView;
    }
    return _twoInfoView;
}

- (SAInfoView *)threeInfoView {
    if (!_threeInfoView) {
        SAInfoView *infoView = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = PNLocalizedString(@"ms_open_3", @"3、完成开通");
        model.keyColor = HDAppTheme.PayNowColor.c999999;
        model.keyFont = HDAppTheme.PayNowFont.standard14;
        model.keyNumbersOfLines = 0;
        model.leftImage = [UIImage imageNamed:@"pn_ms_opne_3"];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), 0, kRealWidth(8), kRealWidth(15));
        model.lineWidth = 0;
        infoView.model = model;
        _threeInfoView = infoView;
    }
    return _threeInfoView;
}

- (HDUIButton *)openBtn {
    if (!_openBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"ms_want_open", @"我要开通商户") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if ([self checkUserLevel]) {
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesApplyOpenVC:@{}];
            }
        }];

        _openBtn = button;
    }
    return _openBtn;
}

- (HDUIButton *)bindBtn {
    if (!_bindBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4) borderWidth:PixelOne borderColor:HDAppTheme.PayNowColor.mainThemeColor];
        };

        [button setTitle:PNLocalizedString(@"ms_want_correlation", @"已有商户，我要关联") forState:0];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if ([self checkUserLevel]) {
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesPreBindVC:@{}];
            }
        }];

        _bindBtn = button;
    }
    return _bindBtn;
}

@end
