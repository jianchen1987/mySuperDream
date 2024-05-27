//
//  SAStartupAdController.m
//  SuperApp
//
//  Created by Chaos on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAStartupAdController.h"
#import "SAStartupAdModel.h"
#import "SAStartupAdSkipView.h"
#import "SAStartupAdVideoView.h"
#import "SATalkingData.h"
#import "SAShakeManager.h"
#import "LKDataRecord.h"


@interface SAStartupAdController ()

/// logo
//@property (nonatomic, strong) UIImageView *logoIV;
/// 广告图
@property (nonatomic, strong) UIImageView *bannerIV;
/// 视频广告
@property (nonatomic, strong) SAStartupAdVideoView *videoView;
/// 跳过按钮
@property (nonatomic, strong) SAStartupAdSkipView *skipView;
/// 点击视图
@property (nonatomic, strong) UIView *clickView;

@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) SALabel *tipsLabel;

/// 摇一摇icon
@property (nonatomic, strong) SDAnimatedImageView *shakeIV;
/// 摇一摇有惊喜
@property (nonatomic, strong) SALabel *shakeTipLabel;
/// 摇动跳转至第三方应用
//@property (nonatomic, strong) SALabel *shakeSubTipLabel;

@end


@implementation SAStartupAdController

- (void)hd_setupViews {
    [super hd_setupViews];
    //    [self.view addSubview:self.logoIV];
    [self.view addSubview:self.bannerIV];
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.clickView];
    [self.view addSubview:self.skipView];
    [self.view addSubview:self.tipsLabel];

    [self.view addSubview:self.shakeIV];
    [self.view addSubview:self.shakeTipLabel];
//    [self.view addSubview:self.shakeSubTipLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 未设置广告，直接关闭
    if (HDIsObjectNil(self.adModel)) {
        !self.closeBlock ?: self.closeBlock(self.routeForClose);
        return;
    }

    [self.skipView startTimer];
    if ([self.adModel.mediaType isEqualToString:SAStartupAdTypeVideo]) {
        [self.videoView startVideoPlayer];
    }
    [self showAdWithModel:self.adModel];
}

- (void)updateViewConstraints {
    //    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.view);
    //        make.size.mas_equalTo(self.logoIV.image.size);
    //        make.bottom.equalTo(self.view).offset(-kRealWidth(25 + kiPhoneXSeriesSafeBottomHeight));
    //    }];
    [self.bannerIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.left.right.top.equalTo(self.view);
        //        make.bottom.equalTo(self.logoIV.mas_top).offset(-kRealWidth(25));
        make.edges.equalTo(self.view);
    }];
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bannerIV);
    }];
    [self.clickView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bannerIV);
    }];
    [self.skipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kRealWidth(kStatusBarH + 12));
        make.right.equalTo(self.view).offset(-kRealWidth(17));
        make.height.mas_equalTo(kRealWidth(24));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bannerIV).offset(-48);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-kRealWidth(34) * 2);
    }];


    [self.shakeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-80 - kiPhoneXSeriesSafeBottomHeight);
        make.size.mas_equalTo(CGSizeMake(112, 112));
        make.centerX.equalTo(self.view);
    }];

    [self.shakeTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.shakeIV.mas_bottom).offset(6);
        make.height.mas_equalTo(20);
        make.width.equalTo(self.view).offset(-24);
    }];

//    [self.shakeSubTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.shakeTipLabel.mas_bottom).offset(6);
//        make.width.equalTo(self.view).offset(-24);
//        make.height.mas_equalTo(18);
//    }];

    [super updateViewConstraints];
}

#pragma mark - 埋点函数
// 展示广告埋点
- (void)showAdWithModel:(SAStartupAdModel *)model {
}
// 点击广告埋点 shownTime已展示时长
- (void)clickAdWithModel:(SAStartupAdModel *)model shownTime:(NSUInteger)shownTime {
    [SATalkingData SATrackEvent:@"广告点击" label:@"" parameters:@{
        @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
        @"bannerId": model.adNo,
        @"bannerLocation": [NSNumber numberWithUnsignedInteger:SAWindowLocationWowNowStartUpAd],
        @"bannerTitle": @"",
        @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
        @"link": model.jumpLink,
        @"imageUrl": model.url,
        @"businessLine": SAClientTypeMaster
    }];
    
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    parameters[@"adNo"] = model.adNo;
    parameters[@"jumpLink"] = model.jumpLink;
    
    [LKDataRecord.shared traceEvent:@"click_launch_page_advertisement" name:@"" parameters:parameters];
    
}
// 关闭广告埋点 shownTime已展示时长
- (void)closeAdWithModel:(SAStartupAdModel *)model shownTime:(NSUInteger)shownTime {
}

#pragma mark - event response
- (void)clickBannerHandler {
    if (HDIsStringEmpty(self.adModel.jumpLink)) {
        return;
    }
    [self.skipView stopTimer];
    [self.videoView stopVideoPlayer];
    [self clickAdWithModel:self.adModel shownTime:self.skipView.shownTime];
    !self.clickAdBlock ?: self.clickAdBlock(self.adModel.jumpLink);
}

#pragma mark - setter
- (void)setAdModel:(SAStartupAdModel *)adModel {
    _adModel = adModel;

    self.skipView.skipTime = adModel.adPlayTime;
    if ([self.adModel.mediaType isEqualToString:SAStartupAdTypeImage]) {
        self.bannerIV.hidden = false;
        self.videoView.hidden = true;
        UIImage *bannerImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@", DocumentsPath, adModel.imagePath]];
        self.bannerIV.image = bannerImage;

    } else if ([self.adModel.mediaType isEqualToString:SAStartupAdTypeVideo]) {
        self.bannerIV.hidden = true;
        self.videoView.hidden = false;
        self.videoView.contentURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", DocumentsPath, adModel.videoPath]];
    }

    //        self.adModel.adGuide = @"立即查看";
    self.tipsLabel.hidden = true;

    if ([self.adModel.jumpType isEqualToString:@"shake"]) {
        self.shakeIV.hidden = self.shakeTipLabel.hidden = false;
        
        NSShadow *shadowMsg = NSShadow.new;
        shadowMsg.shadowBlurRadius = 10.0;
        shadowMsg.shadowOffset = CGSizeMake(0, 0);
        shadowMsg.shadowColor = UIColor.sa_C333;
        NSAttributedString *attrStringNsg = [[NSAttributedString alloc]initWithString:self.adModel.adGuide attributes:@{NSShadowAttributeName:shadowMsg}];
        self.shakeTipLabel.attributedText = attrStringNsg;
        [SAShakeManager.shaked startMonitorShake];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(shareNoti) name:SHAKE_NOTIFY object:nil];
    } else if (HDIsStringNotEmpty(self.adModel.adGuide)) {
        if (SAMultiLanguageManager.isCurrentLanguageKH) {
            self.tipsLabel.font = [HDAppTheme.font sa_fontNotoSansKhmerUI_Bold:22];
        }
        self.tipsLabel.text = self.adModel.adGuide;
        self.tipsLabel.hidden = false;
    }

    [self.view setNeedsUpdateConstraints];
}

- (void)shareNoti {
    //    [SAShakeManager.shaked stopMonitorShake];
    HDLog(@"收到摇一摇");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self clickBannerHandler];
    });
}

- (void)dealloc {
    [SAShakeManager.shaked stopMonitorShake];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - lazy load
//- (UIImageView *)logoIV {
//    if (!_logoIV) {
//        _logoIV = UIImageView.new;
//        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
//            _logoIV.image = [UIImage imageNamed:@"ad_bottom_logo_cn"];
//        } else {
//            _logoIV.image = [UIImage imageNamed:@"ad_bottom_logo"];
//        }
//
//        _logoIV.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _logoIV;
//}

- (UIImageView *)bannerIV {
    if (!_bannerIV) {
        _bannerIV = UIImageView.new;
        _bannerIV.contentMode = UIViewContentModeScaleAspectFill;
        _bannerIV.clipsToBounds = true;
    }
    return _bannerIV;
}

- (SAStartupAdSkipView *)skipView {
    if (!_skipView) {
        _skipView = SAStartupAdSkipView.new;
        @HDWeakify(self);
        _skipView.skipBlock = ^(BOOL isClick, NSUInteger shownTime) {
            @HDStrongify(self);
            [self.videoView stopVideoPlayer];
            [self closeAdWithModel:self.adModel shownTime:shownTime];
            !self.closeBlock ?: self.closeBlock(self.routeForClose);
        };
    }
    return _skipView;
}

- (UIView *)clickView {
    if (!_clickView) {
        _clickView = UIView.new;
        _clickView.backgroundColor = UIColor.clearColor;
        [_clickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBannerHandler)]];
    }
    return _clickView;
}

- (SAStartupAdVideoView *)videoView {
    if (!_videoView) {
        //        _videoView = [[SAStartupAdVideoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kRealWidth(50 + kiPhoneXSeriesSafeBottomHeight) -
        //        self.logoIV.image.size.height)];
        _videoView = [[SAStartupAdVideoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kRealWidth(50 + kiPhoneXSeriesSafeBottomHeight))];
        _videoView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        @HDWeakify(self);
        _videoView.videoPlayerFailBlock = ^{
            @HDStrongify(self);
            [self.skipView stopTimer];
            [self closeAdWithModel:self.adModel shownTime:0];
            !self.closeBlock ?: self.closeBlock(self.routeForClose);
        };
    }
    return _videoView;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = SALabel.new;
        _tipsLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBlack];
        _tipsLabel.textColor = UIColor.whiteColor;
        _tipsLabel.hd_edgeInsets = UIEdgeInsetsMake(14, 20, 14, 20);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0];
        };
        _tipsLabel.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

- (SDAnimatedImageView *)shakeIV {
    if (!_shakeIV) {
        _shakeIV = SDAnimatedImageView.new;
//        _shakeIV.contentMode = UIViewContentModeCenter;
//        _shakeIV.backgroundColor = [UIColor hd_colorWithHexString:@"#171717"];
        _shakeIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:56];
        };
        _shakeIV.clipsToBounds = YES;
        _shakeIV.hidden = YES;
        
        SDAnimatedImage *animatedImage = [SDAnimatedImage imageNamed:@"ad_share.gif"];
        _shakeIV.image = animatedImage;
    }
    return _shakeIV;
}

- (SALabel *)shakeTipLabel {
    if (!_shakeTipLabel) {
        _shakeTipLabel = SALabel.new;
//        _shakeTipLabel.font = HDAppTheme.font.sa_standard14SB;
        _shakeTipLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        _shakeTipLabel.textColor = UIColor.whiteColor;
        _shakeTipLabel.textAlignment = NSTextAlignmentCenter;
        _shakeTipLabel.numberOfLines = 0;

        
//        NSShadow *shadowMsg = NSShadow.new;
//        shadowMsg.shadowBlurRadius = 10.0;
//        shadowMsg.shadowOffset = CGSizeMake(0, 0);
//        shadowMsg.shadowColor = UIColor.sa_C333;
//        NSAttributedString *attrStringNsg = [[NSAttributedString alloc]initWithString:SALocalizedString(@"ad_shake_tip", @"摇一摇有惊喜") attributes:@{NSShadowAttributeName:shadowMsg}];
//        _shakeTipLabel.attributedText = attrStringNsg;
        _shakeTipLabel.hidden = YES;
    }
    return _shakeTipLabel;
}

//- (SALabel *)shakeSubTipLabel {
//    if (!_shakeSubTipLabel) {
//        _shakeSubTipLabel = SALabel.new;
//        _shakeSubTipLabel.font = HDAppTheme.font.sa_standard12;
//        _shakeSubTipLabel.textColor = UIColor.whiteColor;
//        _shakeSubTipLabel.text = @"摇动跳转至第三方应用";
//        _shakeSubTipLabel.textAlignment = NSTextAlignmentCenter;
//        _shakeSubTipLabel.numberOfLines = 0;
//        _shakeSubTipLabel.hidden = YES;
//    }
//    return _shakeSubTipLabel;
//}

@end
