//
//  SACMSPageView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSPageView.h"
#import "CMSCubeScrolledCardView.h"
#import "CMSFourImageScrolledCardView.h"
#import "CMSImageListDataSourceCardView.h"
#import "CMSInfoGroupCardView.h"
#import "CMSKingKongAreaCardView.h"
#import "CMSMainEntranceCardView.h"
#import "CMSMuItipleIconDownTextUpMarqueeCardView.h"
#import "CMSMuItipleIconTextMarqueeCardView.h"
#import "CMSParentChildKingKongAreaCardView.h"
#import "CMSParentHalfChildHalfKingKongAreaCardView.h"
#import "CMSPlayerCardView.h"
#import "CMSSingleImage150x375ScrolledCardView.h"
#import "CMSSingleImage80x375ScrolledCardView.h"
#import "CMSSingleImageAutoScrollCardView.h"
#import "CMSSingleImageScrolledCardView.h"
#import "CMSSixImageCardView.h"
#import "CMSThreeImage1x1ScrolledCardView.h"
#import "CMSThreeImage3x2ScrolledCardView.h"
#import "CMSThreeImage7x3ScrolledCardView.h"
#import "CMSThreeImage7x3ScrolledDataSourceCardView.h"
#import "CMSTitleCardView.h"
#import "CMSToolsAreaCardView.h"
#import "CMSToolsAreaHorizontalScrolledCardView.h"
#import "CMSTwoImagePagedCardView.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SACMSCardView.h"
#import "SACMSCardViewConfig.h"
#import "SACMSFloatWindowPluginView.h"
#import "SACMSNavigationBarPlugin.h"
#import "SACMSPageViewConfig.h"
#import <HDVendorKit/HDWebImageManager.h>
#import "WMCMSBannerDataSourceCardView.h"
#import "WMCMSKingKongAreaDataSourceCardView.h"
#import "WMCMSBrandPromoDataSourceCardView.h"
#import "WMCMSStoreRecommendDataSourceCardView.h"
#import "WMCMSGoodsRecommendDataSourceCardView.h"
#import "WMCMSBannerAutoScrollDataSourceCardView.h"

@interface SACMSPageView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *backgroundImageView; ///< 背景图片

@property (nonatomic, strong) SACMSPageViewConfig *config;                ///< 配置
@property (nonatomic, strong) NSDictionary<NSString *, Class> *cardTable; ///< 卡片类型对应表
@property (nonatomic, copy) NSString *pageName;                           ///< 页面名称
@property (nonatomic, assign) CGFloat pageWidth;                          ///< 页面宽度

@end


@implementation SACMSPageView

- (instancetype)initWithWidth:(CGFloat)width config:(nonnull SACMSPageViewConfig *)config {
    self = [super init];
    if (self) {
        self.pageWidth = width;
        self.config = config;
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.backgroundImageView];
    [self.bgView addSubview:self.scrollView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([self.config getContentEdgeInsets]);
        make.width.mas_equalTo(self.width - UIEdgeInsetsGetHorizontalValue([self.config getContentEdgeInsets]));
    }];
    [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [super updateConstraints];
}

#pragma mark - public methods
- (CGFloat)getViewHeight {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return self.scrollView.contentSize.height;
}

- (NSArray<SACMSCardView *> *)cardViews {
    return self.scrollView.subviews;
}

- (NSString *)pageName {
    return self.config.pageName;
}

#pragma mark - setter
- (void)setConfig:(SACMSPageViewConfig *)config {
    _config = config;

    self.bgView.backgroundColor = [config getBackgroundColor];
    NSString *backgroundImage = [config getBackgroundImage];
    if (HDIsStringNotEmpty(backgroundImage)) {
        [HDWebImageManager setImageWithURL:backgroundImage placeholderImage:nil imageView:self.backgroundImageView];
    }

    [self.scrollView hd_removeAllSubviews];
    UIView *lastView = nil;
    for (SACMSCardViewConfig *cardConfig in config.cards) {
        // 透传地址模型，用于卡片的自定义请求
        cardConfig.addressModel = config.addressModel;
        // 透传页面宽度
        cardConfig.maxLayoutWidth = self.pageWidth;
        SACMSCardView *cardView = [self creatCardViewWithConfig:cardConfig];
        if (HDIsObjectNil(cardView)) {
            // 如果当前卡片无法识别，则跳过
            continue;
        }
        [self.scrollView addSubview:cardView];
        [cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.bgView);
            make.left.right.equalTo(self.scrollView);
            if (HDIsObjectNil(lastView)) {
                make.top.equalTo(self.scrollView);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            if ([config.cards indexOfObject:cardConfig] == config.cards.count - 1) {
                make.bottom.equalTo(self.scrollView);
            }
        }];
        lastView = cardView;
    }

    [self setNeedsUpdateConstraints];
}

- (void)setBackgroundImage:(NSString *)backgroundImage {
    _backgroundImage = backgroundImage;
    [HDWebImageManager setImageWithURL:backgroundImage placeholderImage:nil imageView:self.backgroundImageView];
}

#pragma mark - private methods
- (SACMSCardView *)creatCardViewWithConfig:(SACMSCardViewConfig *)cardConfig {
    // 过滤敏感数据
    NSString *blackJsonStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchCmsBlackList];
    NSArray<NSString *> *blackList = @[];
    if (HDIsStringNotEmpty(blackJsonStr)) {
        blackList = [NSJSONSerialization JSONObjectWithData:[blackJsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    NSArray<SACMSNode *> *newNodes = [cardConfig.nodes hd_filterWithBlock:^BOOL(SACMSNode *_Nonnull item) {
        return ![blackList containsObject:item.name];
    }];
    cardConfig.nodes = newNodes;

    Class cardClass = self.cardTable[cardConfig.identify];
    if (!cardClass) {
        return nil;
    }
    SACMSCardView *cardView = [[cardClass alloc] initWithConfig:cardConfig];
    cardView.page = self;
    @HDWeakify(self);
    cardView.refreshCard = ^(SACMSCardView *_Nonnull card) {
        @HDStrongify(self);
        if ([self.delegate respondsToSelector:@selector(pageViewDidRefresh:cardView:)]) {
            [self.delegate pageViewDidRefresh:self cardView:card];
        }
    };
    cardView.clickNode = ^(SACMSCardView *_Nonnull card, SACMSNode *_Nonnull node, NSString *_Nullable link, NSString *_Nullable spm) {
        @HDStrongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickedOnPageView:cardView:node:link:spm:)]) {
            [self.delegate didClickedOnPageView:self cardView:card node:node link:link
                                            spm:[NSString stringWithFormat:@"%@.%@@%zd.%@", self.config.pageName, cardConfig.cardName, [self.config.cards indexOfObject:cardConfig], spm]];

            [LKDataRecord.shared traceClickEvent:HDIsStringNotEmpty(node.name) ? node.name : @"" parameters:@{@"route": link}
                                             SPM:[LKSPM SPMWithPage:self.config.pageName area:[NSString stringWithFormat:@"%@@%zd", cardConfig.cardName, [self.config.cards indexOfObject:cardConfig]]
                                                               node:spm]];
        }
    };
    return cardView;
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = UIImageView.new;
    }
    return _backgroundImageView;
}

- (NSDictionary<NSString *, Class> *)cardTable {
    if (_cardTable) {
        return _cardTable;
    }
    _cardTable = @{
        CMSCardIdentifyKingkongAreaCard: CMSKingKongAreaCardView.class,
        CMSCardIdentifySingleImageScrolledCard: CMSSingleImageScrolledCardView.class,
        CMSCardIdentifyThreeImage1X1ScrolledCard: CMSThreeImage1x1ScrolledCardView.class,
        CMSCardIdentifyThreeImage3X2ScrolledCard: CMSThreeImage3x2ScrolledCardView.class,
        CMSCardIdentifyThreeImage7X3ScrolledCard: CMSThreeImage7x3ScrolledCardView.class,
        CMSCardIdentifyThreeImage7x3ScrolledDataSourceCard: CMSThreeImage7x3ScrolledDataSourceCardView.class,
        CMSCardIdentifyToolsAreaCard: CMSToolsAreaCardView.class,
        CMSCardIdentifyParentChildKingkongAreaCard: CMSParentChildKingKongAreaCardView.class,
        CMSCardIdentifyTwoImagePagedCard: CMSTwoImagePagedCardView.class,
        CMSCardIdentifyFourImageScrolledCard: CMSFourImageScrolledCardView.class,
        CMSCardIdentify80x375SingleImageScrolledCard: CMSSingleImage80x375ScrolledCardView.class,
        CMSCardIdentify150x375SingleImageScrolledCard: CMSSingleImage150x375ScrolledCardView.class,
        CMSCardIdentifySixImageCard: CMSSixImageCardView.class,
        CMSCardIdentifyMuItipleIconTextMarqueeCard: CMSMuItipleIconTextMarqueeCardView.class,
        CMSCardIdentifyTitleCard: CMSTitleCardView.class,
        CMSCardIdentifyCubeScrolledCard: CMSCubeScrolledCardView.class,
        CMSCardIdentifyListGroupCard: CMSInfoGroupCardView.class,
        CMSCardIdentifyImageListDataSourceCard: CMSImageListDataSourceCardView.class,
        CMSCardIdentifyToolsAreaHorizontalScrolledCard: CMSToolsAreaHorizontalScrolledCardView.class,
        CMSCardIdentifyMainEntranceCard: CMSMainEntranceCardView.class,
        CMSCardIdentifySingleImageAutoScrollCard: CMSSingleImageAutoScrollCardView.class,
        CMSCardIdentifyImageTextScrolledDataSourceCard: CMSMuItipleIconDownTextUpMarqueeCardView.class,
        CMSCardIdentifyYumNowKingKongAreaDataSourceCard: WMCMSKingKongAreaDataSourceCardView.class,
        CMSCardIdentifyYumNowBannerDataSourceCard: WMCMSBannerDataSourceCardView.class,
        CMSCardIdentifyYumNowBrandPromoDataSourceCard: WMCMSBrandPromoDataSourceCardView.class,
        CMSCardIdentifyYumNowBannerAutoScrollDataSourceCard: WMCMSBannerAutoScrollDataSourceCardView.class,
        CMSCardIdentifyYumNowGoodsRecommendDataSourceCard: WMCMSGoodsRecommendDataSourceCardView.class,
        CMSCardIdentifyYumNowStoreRecommendDataSourceCard: WMCMSStoreRecommendDataSourceCardView.class,
    };
    return _cardTable;
}

@end
