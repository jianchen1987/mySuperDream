//
//  WMStoreDetailHeaderView.m
//  SuperApp
//
//  Created by wmz on 2023/2/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMStoreDetailHeaderView.h"
#import "GNEvent.h"
#import "HDMediator+GroupOn.h"
#import "LKDataRecord.h"
#import "SACaculateNumberTool.h"
#import "WMPromotionLabel.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreDetailRspModel.h"
#import <HDUIKit/HDAnnouncementView.h>
#import "SACollectionViewCell.h"
#import "SDAnimatedImageView.h"

@interface WMStoreDetailHeaderViewVideoCollectionViewCell : SACollectionViewCell

@property (nonatomic, copy) void (^videoPlayClickCallBack)(NSURL *url);        ///< 播放视频点击
@property (nonatomic, copy) void (^videoAutoPlayCallBack)(NSURL *url);         ///< 视频自动播放回调
@property (nonatomic, strong) UIImageView *videoContentView; ///< 图片
/// 播放按钮
@property (strong, nonatomic) UIImageView *playIV;

@property (copy, nonatomic) NSString *videoUrl;


@end

@implementation WMStoreDetailHeaderViewVideoCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.videoContentView];
    [self.videoContentView addSubview:self.playIV];
//    [self.contentView addSubview:self.playIV];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
//    [self.playIV addGestureRecognizer:tap];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
    [self.videoContentView addGestureRecognizer:tap];
}

- (void)updateConstraints {
    
    [self.videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.playIV sizeToFit];
    [self.playIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoContentView);
        make.centerY.mas_equalTo(10);
    }];

    [super updateConstraints];
}

- (void)playClick {
    if (self.videoPlayClickCallBack) {
        self.videoPlayClickCallBack([NSURL URLWithString:self.videoUrl]);
    }
}



#pragma mark - 获取视频的第一帧截图, 返回UIImage (需要导入AVFoundation.h)
- (void)videoImageWithvideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    //先从缓存中查找是否有图片
    SDImageCache *cache =  [SDImageCache sharedImageCache];
    UIImage *memoryImage =  [cache imageFromMemoryCacheForKey:videoURL.absoluteString];
    if (memoryImage) {
        self.videoContentView.image = memoryImage;
        return;
    }else{
        //再从磁盘中查找是否有图片
        UIImage *diskImage =  [cache imageFromDiskCacheForKey:videoURL.absoluteString];
        if (diskImage) {
            self.videoContentView.image = diskImage;
            return;
        }
    }
    if (!time) {
        time = 1;
    }
    //如果都不存在，开启异步线程截取对应时间点的画面，转成图片缓存至磁盘
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SDImageCache * cache =  [SDImageCache sharedImageCache];
            [cache storeImage:thumbnailImage forKey:videoURL.absoluteString toDisk:YES completion:nil];
            self.videoContentView.image = thumbnailImage;
        });
    });
}

#pragma mark - getters and setters
- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    [self videoImageWithvideoURL:[NSURL URLWithString:videoUrl] atTime:1];
    
    //自动播放  延迟一下
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setAutoPlay];
    });
}

- (void)setAutoPlay {
    HDReachability *reachability = [HDReachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus == ReachableViaWiFi) {
        if (self.videoAutoPlayCallBack) {
            self.videoAutoPlayCallBack([NSURL URLWithString:self.videoUrl]);
        }
    }
}


/** @lazy playIV */
- (UIImageView *)playIV {
    if (!_playIV) {
        _playIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_video_play"]];
//        _playIV.userInteractionEnabled = YES;
    }
    return _playIV;
}
#pragma mark - lazy load
- (UIImageView *)videoContentView {
    if (!_videoContentView) {
        _videoContentView = UIImageView.new;
//        _videoContentView.contentMode = UIViewContentModeScaleAspectFill;
        _videoContentView.backgroundColor = UIColor.blackColor;
        _videoContentView.userInteractionEnabled = YES;
    }
    return _videoContentView;
}

@end


@interface WMStoreDetailHeaderView ()<HDCyclePagerViewDelegate, HDCyclePagerViewDataSource>
/// 模型
@property (nonatomic, strong) WMStoreDetailRspModel *detailModel;
/// 门店信息背景（用来点击）
@property (nonatomic, strong) UIControl *storeBgControl;
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// 店名
@property (nonatomic, strong) SALabel *titleLB;
/// 评分、已售、评价
@property (nonatomic, strong) YYLabel *ratingAndReviewLB;
/// 距离、配送费
@property (nonatomic, strong) YYLabel *distanceAndDeliveryFeeLB;
/// 优惠信息
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 公告
@property (nonatomic, strong) HDAnnouncementView *announcementView;
/// 领取优惠券
@property (nonatomic, strong) YYLabel *gotCouponsLB;
/// 团购View
@property (nonatomic, strong) UIView *groupView;
/// 团购View
@property (nonatomic, strong) UIImageView *groupIcon;
/// 团购View
@property (nonatomic, strong) HDLabel *groupLB;
/// 团购View
@property (nonatomic, strong) HDLabel *groupGoLB;
/// maxFloatWidth
@property (nonatomic, assign) CGFloat maxFloatWidth;

@property (nonatomic, strong) UIView *videoBannerView;
/// 轮播数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// banner
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// pageControl
@property (nonatomic, strong) HDPageControl *pageControl;

@property (nonatomic, assign) BOOL hasAutoPlay;
@end


@implementation WMStoreDetailHeaderView

- (void)hd_setupViews {
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        self.maxFloatWidth = kScreenWidth - kRealWidth(70);
    } else {
        self.maxFloatWidth = kScreenWidth - kRealWidth(84);
    }
    [self addSubview:self.videoBannerView];
    [self.videoBannerView addSubview:self.bannerView];
    [self.videoBannerView addSubview:self.pageControl];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.storeBgControl];
    [self.bgView addSubview:self.logoIV];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.ratingAndReviewLB];
    [self.bgView addSubview:self.distanceAndDeliveryFeeLB];
    [self.bgView addSubview:self.floatLayoutView];
    [self.bgView addSubview:self.gotCouponsLB];
    [self.bgView addSubview:self.moreBtn];

    [self addSubview:self.announcementView];
    [self addSubview:self.groupView];
    [self.groupView addSubview:self.groupIcon];
    [self.groupView addSubview:self.groupLB];
    [self.groupView addSubview:self.groupGoLB];
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        [self addSubview:self.storeInfoView];
        [self addSubview:self.moreBtn];
    }
    self.logoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 8;
        view.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.1000].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 2);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 6;
    };
}

- (void)updateMoreBtnSelect:(BOOL)select {
    self.moreBtn.selected = select;
}

- (void)setShowDetail:(BOOL)showDetail {
    if (_showDetail != showDetail) {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            if (self.storeInfoView.viewModel.repModel != self.model) {
                self.storeInfoView.viewModel.repModel = self.model;
            }
            self.storeInfoView.hidden = !showDetail;
            [self setNeedsUpdateConstraints];
        }
    }
    _showDetail = showDetail;
}

- (void)changeAlpah:(CGFloat)alpah {
    self.storeInfoView.alpha = alpah;
    self.announcementView.alpha = self.gotCouponsLB.alpha = self.floatLayoutView.alpha = (1 - alpah);
}

#pragma mark - setter
- (void)setModel:(WMStoreDetailRspModel *)model {
    _model = model;

    self.titleLB.text = model.storeName.desc;

    self.detailModel = model;

    [HDWebImageManager setImageWithURL:model.logo placeholderImage:HDHelper.circlePlaceholderImage imageView:self.logoIV];
    [self updateRatingLabelContent];
    [self updateDeliveryFeeLabelContent];

    self.announcementView.hidden = HDIsStringEmpty(model.announcement.desc);
    if (!self.announcementView.isHidden) {
        HDAnnouncementViewConfig *config = HDAnnouncementViewConfig.new;
        config.trumpetImage = [UIImage imageNamed:@"yn_store_no"];
        config.text = model.announcement.desc;
        config.backgroundColor = HDAppTheme.WMColor.bg3;
        config.textColor = HDAppTheme.WMColor.B6;
        config.textFont = [HDAppTheme.WMFont wm_ForSize:12];
        config.trumpetToTextMargin = kRealWidth(4);
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            config.contentInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(4), 0);
            config.rate = CGFLOAT_MIN;
        } else {
            config.contentInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(12));
        }
        self.announcementView.config = config;
    }
    [self configPromotions];
    [self congifGotCoupon];
    self.groupView.hidden = !model.grouponStoreNo;
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        self.groupView.hidden = YES;
        self.backgroundColor = UIColor.whiteColor;
    } else {
        self.backgroundColor = UIColor.clearColor;
    }
    
    self.videoBannerView.hidden = !model.videoUrls.count;
    self.pageControl.hidden = YES;
    if(!self.videoBannerView.hidden) {
        [self.dataSource removeAllObjects];
        if (!HDIsArrayEmpty(model.videoUrls)) {
            [self.dataSource addObjectsFromArray:model.videoUrls];
        }
        if(self.dataSource.count > 1){
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = self.dataSource.count;
        }
        [self.bannerView reloadData];
    }
    
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods

#pragma mark - 领取优惠券 | 券包
- (void)congifGotCoupon {
    self.gotCouponsLB.hidden = !self.model.shouGiveCouponActivity && HDIsArrayEmpty(self.model.couponPackageCodes);

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    UIImage *starImage = [UIImage imageNamed:@"yn_home_coupon"];
    UIFont *font = [HDAppTheme.WMFont wm_boldForSize:14];
    NSMutableAttributedString *appendingStr = [NSMutableAttributedString yy_attachmentStringWithContent:starImage contentMode:UIViewContentModeCenter
                                                                                         attachmentSize:CGSizeMake(starImage.size.width, kRealWidth(20))
                                                                                            alignToFont:font
                                                                                              alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:appendingStr];

    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                      attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                                                           alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:spaceText];
    [self configCouponPackgeUI:text];
    [self configCouponGotUI:text];
    self.gotCouponsLB.attributedText = text;
}

///领取优惠券UI
- (void)configCouponGotUI:(NSMutableAttributedString *)text {
    if (self.model.shouGiveCouponActivity) {
        UIFont *font = [HDAppTheme.WMFont wm_boldForSize:14];
        NSMutableAttributedString *couponsStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"wm_storecoupon", @"门店优惠券")];
        couponsStr.yy_color = HDAppTheme.WMColor.mainRed;
        couponsStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightMedium];
        YYTextBorder *couponBorder = YYTextBorder.new;
        couponBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(4), -kRealWidth(4), -kRealWidth(4));
        couponBorder.fillColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1];
        couponBorder.cornerRadius = kRealWidth(2);
        couponsStr.yy_textBackgroundBorder = couponBorder;

        UIImage *lineImage = [UIImage imageNamed:@"yn_get_line"];

        NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                          attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                             alignToFont:[UIFont systemFontOfSize:0]
                                                                                               alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:spaceText];

        NSMutableAttributedString *lineStr = [NSMutableAttributedString yy_attachmentStringWithContent:lineImage contentMode:UIViewContentModeCenter
                                                                                        attachmentSize:CGSizeMake(lineImage.size.width, kRealWidth(20))
                                                                                           alignToFont:font
                                                                                             alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:lineStr];

        spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                  alignToFont:[UIFont systemFontOfSize:0]
                                                                    alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:spaceText];

        NSString *state = WMLocalizedString(@"wm_coupon_give", @"wm_coupon_getting");
        if (self.model.shouGiveCouponActivity == 2) {
            state = SALocalizedString(@"userRefundBill_check", @"查看");
        }
        NSMutableAttributedString *getStr = [[NSMutableAttributedString alloc] initWithString:state];
        getStr.yy_color = UIColor.whiteColor;
        getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightBold];
        YYTextBorder *getBorder = YYTextBorder.new;
        getBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(8), -kRealWidth(4), -kRealWidth(8));
        getBorder.fillColor = HDAppTheme.WMColor.mainRed;
        getBorder.cornerRadius = kRealWidth(2);
        getStr.yy_textBackgroundBorder = getBorder;
        [couponsStr appendAttributedString:getStr];

        spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                  alignToFont:[UIFont systemFontOfSize:0]
                                                                    alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:spaceText];
        [text appendAttributedString:couponsStr];

        ///领取优惠券
        NSRange range = [text.string rangeOfString:couponsStr.string];
        YYTextHighlight *layHightlight = [[YYTextHighlight alloc] init];
        layHightlight.tapAction = ^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
            [self getCouponAction];
        };
        [text yy_setTextHighlight:layHightlight range:range];
    }
}

///券包UI
- (void)configCouponPackgeUI:(NSMutableAttributedString *)text {
    if (!HDIsArrayEmpty(self.detailModel.couponPackageCodes)) {
        UIFont *font = [HDAppTheme.WMFont wm_boldForSize:14];
        NSMutableAttributedString *couponsStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"wm_food_delivery_coupons", @"外卖优惠券包")];
        couponsStr.yy_color = HDAppTheme.WMColor.mainRed;
        couponsStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightMedium];
        YYTextBorder *couponBorder = YYTextBorder.new;
        couponBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(4), -kRealWidth(4), -kRealWidth(4));
        couponBorder.fillColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1];
        couponBorder.cornerRadius = kRealWidth(2);
        couponsStr.yy_textBackgroundBorder = couponBorder;

        UIImage *lineImage = [UIImage imageNamed:@"yn_get_line"];

        NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                          attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                             alignToFont:[UIFont systemFontOfSize:0]
                                                                                               alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:spaceText];

        NSMutableAttributedString *lineStr = [NSMutableAttributedString yy_attachmentStringWithContent:lineImage contentMode:UIViewContentModeCenter
                                                                                        attachmentSize:CGSizeMake(lineImage.size.width, kRealWidth(20))
                                                                                           alignToFont:font
                                                                                             alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:lineStr];

        spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                  alignToFont:[UIFont systemFontOfSize:0]
                                                                    alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:spaceText];

        NSMutableAttributedString *getStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"wm_BUY", @"购")];
        getStr.yy_color = UIColor.whiteColor;
        getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightBold];
        YYTextBorder *getBorder = YYTextBorder.new;
        getBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(8), -kRealWidth(4), -kRealWidth(8));
        getBorder.fillColor = HDAppTheme.WMColor.mainRed;
        getBorder.cornerRadius = kRealWidth(2);
        getStr.yy_textBackgroundBorder = getBorder;
        [couponsStr appendAttributedString:getStr];

        spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                  alignToFont:[UIFont systemFontOfSize:0]
                                                                    alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:spaceText];

        spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                  alignToFont:[UIFont systemFontOfSize:0]
                                                                    alignment:YYTextVerticalAlignmentCenter];
        [couponsStr appendAttributedString:spaceText];

        [text appendAttributedString:couponsStr];

        ///跳转券包
        NSRange range = [text.string rangeOfString:couponsStr.string];
        YYTextHighlight *layHightlight = [[YYTextHighlight alloc] init];
        layHightlight.tapAction = ^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
            [HDMediator.sharedInstance
                navigaveToWebViewViewController:@{@"path": [NSString stringWithFormat:@"/mobile-h5/marketing/coupon-package/coupon-list?lon=%@&&lat=%@", self.model.longitude, self.model.latitude]}];
        };
        [text yy_setTextHighlight:layHightlight range:range];
    }
}

- (void)configPromotions {
    ///详情的标签列表不展示 展示在顶部
    BOOL hasFastService = NO;
    self.floatLayoutView.hidden = HDIsArrayEmpty(self.model.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    if (!self.floatLayoutView.isHidden) {
        [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSMutableArray *mArr =
            [WMStoreDetailPromotionModel configPromotions:self.model.promotions productPromotion:self.model.productPromotions hasFastService:hasFastService shouldAddStoreCoupon:NO].mutableCopy;
        if (self.model.serviceLabel.count) {
            [mArr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.model.serviceLabel]];
        }
        [mArr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [self.floatLayoutView addSubview:obj];
        }];
    }

    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        self.moreBtn.hidden = NO;
        self.floatLayoutView.maxRowCount = 1;
    } else {
        if (self.model.numberOfLinesOfPromotion < 0) {
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(self.maxFloatWidth, CGFLOAT_MAX)];
            self.model.moreHidden = size.height < kRealWidth(30);
            self.model.numberOfLinesOfPromotion = 1;
        }
        self.moreBtn.hidden = self.model.moreHidden;
        self.floatLayoutView.maxRowCount = self.model.numberOfLinesOfPromotion;
    }
}

- (void)updateRatingLabelContent {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];

    UIImage *starImage = [UIImage imageNamed:@"yn_home_store_star"];
    UIFont *font = [HDAppTheme.WMFont wm_boldForSize:14];

    NSMutableAttributedString *appendingStr = [NSMutableAttributedString yy_attachmentStringWithContent:starImage contentMode:UIViewContentModeCenter
                                                                                         attachmentSize:CGSizeMake(starImage.size.width, font.lineHeight)
                                                                                            alignToFont:font
                                                                                              alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:appendingStr];

    // 空格
    NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];

    // 拼接分数
    NSString *score = [NSString stringWithFormat:@"%.1f", self.detailModel.reviewScore];
    if (self.detailModel.reviewScore == 0)
        score = WMLocalizedString(@"wm_no_ratings_yet", @"暂无评分");

    appendingStr =
        [[NSMutableAttributedString alloc] initWithString:score
                                               attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Bold"]}];

    [text appendAttributedString:whiteSpace];
    [text appendAttributedString:appendingStr];
    // 截止到分数的字符串
    NSAttributedString *scoreStr = text.mutableCopy;

    // 拼接评价
    UIFont *refont = [HDAppTheme.WMFont wm_ForSize:14];
    NSString *countStr;
    if (self.detailModel.reviewCount <= 10000) {
        countStr = [NSString stringWithFormat:@"%zd", self.detailModel.reviewCount];
    } else {
        NSUInteger integeCount = self.detailModel.reviewCount / 10000;
        countStr = [NSString stringWithFormat:@"%zdk+", integeCount];
    }
    NSString *commments = [NSString stringWithFormat:@" (%@ %@)", countStr, WMLocalizedString(@"reviews", @"条评价")];
    appendingStr = [[NSMutableAttributedString alloc] initWithString:commments attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: refont}];
    [text appendAttributedString:whiteSpace];
    [text appendAttributedString:appendingStr];

    @HDWeakify(self);
    [text yy_setTextHighlightRange:NSMakeRange(scoreStr.length, text.length - scoreStr.length) color:HDAppTheme.color.G2 backgroundColor:UIColor.clearColor
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             @HDStrongify(self);
                             [HDMediator.sharedInstance navigaveToStoreReviewsAndInfoController:@{@"detailModel": self.detailModel, @"defaultSelectedIndex": @(0)}];
                         }];
    self.ratingAndReviewLB.attributedText = text;
}

- (void)updateDeliveryFeeLabelContent {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    UIFont *font = [HDAppTheme.WMFont wm_ForSize:14];
    // 空格
    NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];

    UIImage *clockImage = [UIImage imageNamed:@"yn_home_store_loction"];
    NSMutableAttributedString *appendingStr = [NSMutableAttributedString yy_attachmentStringWithContent:clockImage contentMode:UIViewContentModeCenter
                                                                                         attachmentSize:CGSizeMake(clockImage.size.width, font.lineHeight)
                                                                                            alignToFont:font
                                                                                              alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:appendingStr];
    [text appendAttributedString:whiteSpace];

    NSString *distanceAndTimeStr = [NSString stringWithFormat:@"%@ %zdmins",
                                                              [SACaculateNumberTool distanceStringFromNumber:self.detailModel.distance toFixedCount:0 roundingMode:SANumRoundingModeOnlyUp],
                                                              self.detailModel.estimatedDeliveryTime];
    appendingStr = [[NSMutableAttributedString alloc] initWithString:distanceAndTimeStr attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: font}];

    [text appendAttributedString:appendingStr];
    //    NSAttributedString *lineSpace = [[NSMutableAttributedString alloc] initWithString:@" | " attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: font}];
    //    [text appendAttributedString:lineSpace];
    //
    //    appendingStr = [[NSMutableAttributedString alloc] initWithString:self.detailModel.showDeliveryStr attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName:
    //    font}]; if (appendingStr)
    //        [text appendAttributedString:appendingStr];

    ///慢必赔
    if (self.model.slowPayMark.boolValue) {
        WMUIButton *fastBTN = [WMPromotionLabel createFastServiceBtn];
        NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                          attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                             alignToFont:[UIFont systemFontOfSize:0]
                                                                                               alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:spaceText];
        NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:fastBTN contentMode:UIViewContentModeCenter attachmentSize:fastBTN.frame.size alignToFont:font
                                                                                            alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:objStr];
    }

    self.distanceAndDeliveryFeeLB.attributedText = text;
}

- (void)showAnnouncementDetailAlertView {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerMinHeight = kScreenHeight * 0.3;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), kRealWidth(15), kRealWidth(15));
    config.title = WMLocalizedString(@"store_info", @"公告");
    config.style = HDCustomViewActionViewStyleClose;
    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    config.contentHorizontalEdgeMargin = 10;
    const CGFloat width = kScreenWidth - config.contentHorizontalEdgeMargin * 2;

    UILabel *textLabel = UILabel.new;
    textLabel.text = self.detailModel.announcement.desc;
    textLabel.numberOfLines = 0;
    textLabel.font = HDAppTheme.font.standard3;
    textLabel.textColor = HDAppTheme.color.G2;
    textLabel.frame = (CGRect){0, 0, [textLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)]};

    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:(id)textLabel config:config];
    [actionView show];
}

///跳转团购
- (void)pushGroupAction {
    [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": self.detailModel.grouponStoreNo}];
}

#pragma mark - event response
- (void)storeInfoClick:(UIControl *)control {
    [HDMediator.sharedInstance navigaveToStoreReviewsAndInfoController:@{@"detailModel": self.detailModel, @"defaultSelectedIndex": @(1)}];
}

- (void)getCouponAction {
    [GNEvent eventResponder:self target:self.gotCouponsLB key:@"showBottomCouponAction"];
}

#pragma mark - layout
- (void)updateConstraints {
    [super updateConstraints];
    CGFloat lessBottom = kRealWidth(-1);
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        lessBottom = 0;
    }
    
    
    [self.videoBannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(-kNavigationBarH);
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.videoBannerView.mas_width).multipliedBy(210/375.0);
    }];
    
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pageControl.isHidden) {
            make.width.centerX.equalTo(self.videoBannerView);
            make.height.mas_equalTo(5);
            make.bottom.equalTo(self.videoBannerView).offset(-25);
        }
    }];
    
    
    __block UIView *lastView = self.bgView;
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            if(!self.videoBannerView.hidden){
                make.top.mas_equalTo(self.videoBannerView.mas_bottom).offset(-20);
            }else{
                make.top.mas_equalTo(0);
            }
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            if (self.storeInfoView.isHidden) {
                make.bottom.mas_lessThanOrEqualTo(lessBottom);
            }
        } else {
            if(!self.videoBannerView.hidden){
                make.top.mas_equalTo(self.videoBannerView.mas_bottom).offset(-20);
            }else{
                make.top.mas_equalTo(kRealWidth(8));
            }
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.bottom.mas_lessThanOrEqualTo(lessBottom);
        }
    }];

    [self.storeBgControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!SAMultiLanguageManager.isCurrentLanguageCN) {
            make.left.top.right.equalTo(self.bgView);
            make.bottom.equalTo(self.distanceAndDeliveryFeeLB.mas_bottom);
        }
    }];

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(kRealWidth(12));
        make.right.equalTo(self.bgView).offset(-kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(60), kRealWidth(60)));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV);
        make.left.mas_equalTo(kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.right.equalTo(self.logoIV.mas_left).offset(-kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.ratingAndReviewLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.right.lessThanOrEqualTo(self.logoIV).offset(-kRealWidth(12));
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(9));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.distanceAndDeliveryFeeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(12));
        make.right.equalTo(self.bgView).offset(-kRealWidth(12));
        make.top.greaterThanOrEqualTo(self.ratingAndReviewLB.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.gotCouponsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.gotCouponsLB.isHidden) {
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
            make.left.equalTo(self.bgView).offset(kRealWidth(12));
            make.right.mas_lessThanOrEqualTo(-kRealWidth(12));
            make.top.greaterThanOrEqualTo(self.distanceAndDeliveryFeeLB.mas_bottom).offset(kRealWidth(12));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        }
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            if (self.gotCouponsLB.isHidden) {
                make.top.equalTo(self.distanceAndDeliveryFeeLB.mas_bottom).offset(kRealWidth(10));
            } else {
                make.top.equalTo(self.gotCouponsLB.mas_bottom).offset(kRealWidth(10));
            }
            make.left.mas_equalTo(kRealWidth(32));
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(self.maxFloatWidth, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
        }
    }];

    [self.moreBtn sizeToFit];
    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.moreBtn.isHidden) {
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(kRealWidth(20));
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(6), kRealWidth(4), kRealWidth(16))];
                if (!self.storeInfoView.isHidden) {
                    make.top.equalTo(self.storeInfoView.mas_top);
                } else {
                    make.bottom.mas_lessThanOrEqualTo(lessBottom);
                }
                make.height.mas_equalTo(kRealWidth(34));
            } else {
                make.top.equalTo(self.floatLayoutView);
            }
        }
    }];

    [self.announcementView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.announcementView.isHidden) {
            CGFloat offset = kRealWidth(8);
            CGFloat sonHeight = kRealWidth(34);
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                offset = 0;
                sonHeight = kRealWidth(26);
            }
            make.top.equalTo(lastView.mas_bottom).offset(offset);
            make.left.equalTo(self.bgView);
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                make.right.mas_equalTo(-kRealWidth(52));
            } else {
                make.right.equalTo(self.bgView);
            }
            make.height.mas_equalTo(sonHeight);
            if (self.storeInfoView.isHidden) {
                make.bottom.mas_lessThanOrEqualTo(lessBottom);
            }
            lastView = self.announcementView;
        }
    }];

    [self.groupView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.groupView.isHidden) {
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(8));
            make.left.width.equalTo(self.bgView);
            make.height.mas_equalTo(kRealWidth(34));
            make.bottom.mas_lessThanOrEqualTo(lessBottom);
            lastView = self.groupView;
        }
    }];

    [self.groupIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.groupView.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(self.groupIcon.image.size);
        }
    }];

    [self.groupGoLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.groupView.isHidden) {
            make.right.mas_equalTo(-kRealWidth(12));
            make.centerY.mas_equalTo(0);
        }
    }];

    [self.groupLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.groupView.isHidden) {
            make.left.equalTo(self.groupIcon.mas_right).offset(kRealWidth(4));
            make.centerY.mas_equalTo(0);
            make.right.equalTo(self.groupGoLB.mas_left).offset(-kRealWidth(4));
        }
    }];

    if ([self.subviews containsObject:self.storeInfoView] && SAMultiLanguageManager.isCurrentLanguageCN) {
        [self.storeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.storeInfoView.isHidden) {
                make.left.right.mas_equalTo(0);
                make.top.equalTo(self.distanceAndDeliveryFeeLB.mas_bottom).offset(kRealWidth(10));
                make.bottom.mas_lessThanOrEqualTo(lessBottom);
            }
        }];
    }

    [self.groupLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.groupLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [self.gotCouponsLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.gotCouponsLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    [self.moreBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moreBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.bgView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.bgView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)moreClickAction {
    self.moreBtn.selected = !self.moreBtn.isSelected;
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        [GNEvent eventResponder:self target:self.moreBtn key:@"expandAction" indexPath:nil info:@{@"expand": @(self.moreBtn.isSelected)}];
    } else {
        self.model.numberOfLinesOfPromotion = self.moreBtn.isSelected ? 0 : 1;
        UIView *view = self;
        while (view.superview) {
            if ([view isKindOfClass:UITableView.class]) {
                UITableView *tableView = (UITableView *)view;
                [tableView reloadData];
                break;
            }
            view = view.superview;
        }
    }
}


#pragma mark - HDCylePageViewDelegate
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSString *videoUrl = self.dataSource[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    WMStoreDetailHeaderViewVideoCollectionViewCell *cell = [WMStoreDetailHeaderViewVideoCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    cell.videoContentView.contentMode = UIViewContentModeScaleAspectFill;
    @HDWeakify(self);
    
    cell.videoPlayClickCallBack = ^(NSURL *_Nonnull url) {
        @HDStrongify(self);
        if (self.videoTapClick) {
            self.videoTapClick(pagerView, indexPath, url);
        }
    };
    
    cell.videoAutoPlayCallBack = ^(NSURL *url) {
        @HDStrongify(self);
        if(!self.hasAutoPlay){
            self.hasAutoPlay = YES;
            if (self.videoTapClick) {
                self.videoTapClick(pagerView, indexPath, url);
            }
        }
    };
    
    cell.videoUrl = videoUrl;
    return cell;

}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {

}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = self.bannerView.size.width;
    const CGFloat height = self.bannerView.size.height;
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);

    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}


#pragma mark - lazy load
- (UIControl *)storeBgControl {
    if (!_storeBgControl) {
        _storeBgControl = [[UIControl alloc] init];
        [_storeBgControl addTarget:self action:@selector(storeInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeBgControl;
}

- (UIImageView *)logoIV {
    if (!_logoIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = HDHelper.circlePlaceholderImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = true;
        _logoIV = imageView;
    }
    return _logoIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        _titleLB = label;
    }
    return _titleLB;
}

- (YYLabel *)ratingAndReviewLB {
    if (!_ratingAndReviewLB) {
        _ratingAndReviewLB = YYLabel.new;
        _ratingAndReviewLB.numberOfLines = 0;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            _ratingAndReviewLB.userInteractionEnabled = false;
        } else {
            _ratingAndReviewLB.userInteractionEnabled = true;
        }
    }
    return _ratingAndReviewLB;
}

- (YYLabel *)gotCouponsLB {
    if (!_gotCouponsLB) {
        _gotCouponsLB = YYLabel.new;
        _gotCouponsLB.numberOfLines = 0;
        _gotCouponsLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(48);
    }
    return _gotCouponsLB;
}

- (YYLabel *)distanceAndDeliveryFeeLB {
    if (!_distanceAndDeliveryFeeLB) {
        _distanceAndDeliveryFeeLB = YYLabel.new;
        _distanceAndDeliveryFeeLB.numberOfLines = 0;
        _distanceAndDeliveryFeeLB.userInteractionEnabled = NO;
    }
    return _distanceAndDeliveryFeeLB;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 5);
    }
    return _floatLayoutView;
}

- (HDAnnouncementView *)announcementView {
    if (!_announcementView) {
        _announcementView = HDAnnouncementView.new;
        _announcementView.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
        if (!SAMultiLanguageManager.isCurrentLanguageCN) {
            _announcementView.layer.cornerRadius = kRealWidth(8);
        } else {
            _announcementView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        }
        @HDWeakify(self);
        _announcementView.tappedHandler = ^{
            @HDStrongify(self);
            if (!SAMultiLanguageManager.isCurrentLanguageCN) {
                [self showAnnouncementDetailAlertView];
            }
        };
    }
    return _announcementView;
}

- (UIView *)groupView {
    if (!_groupView) {
        _groupView = UIView.new;
        _groupView.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
        _groupView.layer.cornerRadius = kRealWidth(8);
        _groupView.hidden = YES;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushGroupAction)];
        [_groupView addGestureRecognizer:ta];
    }
    return _groupView;
}

- (UIImageView *)groupIcon {
    if (!_groupIcon) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"yn_store_groupbuy"];
        _groupIcon = imageView;
    }
    return _groupIcon;
}

- (HDLabel *)groupLB {
    if (!_groupLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.B6;
        label.text = WMLocalizedString(@"wm_groupbuy_tip", @"Discount for Dine-In");
        _groupLB = label;
    }
    return _groupLB;
}

- (HDLabel *)groupGoLB {
    if (!_groupGoLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.text = WMLocalizedString(@"wm_groupbuy_go", @"Book Now");
        _groupGoLB = label;
    }
    return _groupGoLB;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
        };
    }
    return _bgView;
}

- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_home_d"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_home_u"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.hidden = YES;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(6), 0, kRealWidth(16))];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self moreClickAction];
        }];
        _moreBtn = button;
    }
    return _moreBtn;
}

- (WMCNStoreInfoView *)storeInfoView {
    if (!_storeInfoView) {
        _storeInfoView = WMCNStoreInfoView.new;
        _storeInfoView.hidden = YES;
    }
    return _storeInfoView;
}

- (UIView *)videoBannerView {
    if(!_videoBannerView) {
        _videoBannerView = UIView.new;
        _videoBannerView.backgroundColor = UIColor.whiteColor;
        _videoBannerView.hidden = YES;
    }
    return _videoBannerView;
}

- (NSMutableArray *)dataSource {
    if(!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 0;
        _bannerView.isInfiniteLoop = NO;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:WMStoreDetailHeaderViewVideoCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(WMStoreDetailHeaderViewVideoCollectionViewCell.class)];
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(5 * 3, 5);
        _pageControl.pageIndicatorSize = CGSizeMake(5 * 2, 5);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.color.C1;
        _pageControl.pageIndicatorTintColor = HDAppTheme.color.G4;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end
