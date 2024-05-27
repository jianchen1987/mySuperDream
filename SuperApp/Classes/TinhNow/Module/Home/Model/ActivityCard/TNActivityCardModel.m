//
//  TNActivityCardModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardModel.h"


@implementation TNActivityCardModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cardStyle": @"advertiseType"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bannerList": [TNActivityCardBannerItem class]};
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.scene = TNActivityCardSceneIndex;
    }
    return self;
}
- (void)setScene:(TNActivityCardScene)scene {
    _scene = scene;
    if (scene == TNActivityCardSceneTopic) {
        self.headerHeight = kRealWidth(10);
    } else {
        if (HDIsStringNotEmpty(self.advertiseName)) {
            self.headerHeight = kRealWidth(40);
        } else {
            self.headerHeight = 0;
        }
    }
    if (self.cardStyle == TNActivityCardStyleBanner && self.scene == TNActivityCardSceneIndex) {
        self.titlePosition = TNActivityCardTitlePositionBottom;
    } else {
        self.titlePosition = TNActivityCardTitlePositionTop;
    }
}
- (void)setIsSpecialStyleVertical:(BOOL)isSpecialStyleVertical {
    _isSpecialStyleVertical = isSpecialStyleVertical;
}

- (CGFloat)imageViewHeight {
    CGFloat height = 0;
    if (self.cardStyle == TNActivityCardStyleBanner) {
        //横幅
        if (!HDIsArrayEmpty(self.bannerList)) {
            height += self.scene == TNActivityCardSceneIndex ? kRealWidth(150) : (self.isSpecialStyleVertical ? kRealWidth(110) : kRealWidth(130));
        }
    } else if (self.cardStyle == TNActivityCardStyleScorllItem) {
        //滚动列表
        if (!HDIsArrayEmpty(self.bannerList)) {
            height += self.isSpecialStyleVertical ? kRealWidth(80) : kRealWidth(100);
        }
    } else if (self.cardStyle == TNActivityCardStyleSixItem) {
        if (!HDIsArrayEmpty(self.bannerList)) {
            CGFloat imageWidth = self.isSpecialStyleVertical ? (kScreenWidth - kRealWidth(75) - kRealWidth(20)) / 3 : (kScreenWidth - kRealWidth(60)) / 3;
            height += imageWidth;
        }
    } else if (self.cardStyle == TNActivityCardStyleMultipleBanners) {
        if (!HDIsArrayEmpty(self.bannerList)) {
            height += self.isSpecialStyleVertical ? kRealWidth(118) : kRealWidth(138);
        }
    } else if (self.cardStyle == TNActivityCardStyleSquareScorllItem) {
        if (!HDIsArrayEmpty(self.bannerList)) {
            height += kRealWidth(70);
        }
    }
    return height;
}
- (CGFloat)cellHeight {
    CGFloat height = 0;
    switch (self.cardStyle) {
        case TNActivityCardStyleText:
            height += self.isSpecialStyleVertical ? kRealWidth(50) : kRealWidth(60);
            break;
        case TNActivityCardStyleBanner:
            //头部
            height += self.headerHeight;
            //横幅
            height += self.imageViewHeight;
            break;
        case TNActivityCardStyleScorllItem:
            //头部
            height += self.headerHeight;
            //图片高度
            height += self.imageViewHeight;
            //文本高度 如果滚动的列表 只要有一个配置有文字  就都要留出文本的高度
            BOOL hasText = [self checkBannerListHasText:self.bannerList];
            if (hasText) {
                height += kRealWidth(30);
            }
            break;
        case TNActivityCardStyleSixItem:
            //头部
            height += self.headerHeight;
            //六宫格
            if (!HDIsArrayEmpty(self.bannerList)) {
                if (self.bannerList.count > 3) { //最多两行
                    //第一行
                    NSArray *firstLineArr = [self.bannerList subarrayWithRange:NSMakeRange(0, 3)];
                    //图片高度
                    height += self.imageViewHeight;
                    //文本高度 如果滚动的列表 只要有一个配置有文字  就都要留出文本的高度
                    BOOL hasText = [self checkBannerListHasText:firstLineArr];
                    if (hasText) {
                        height += kRealWidth(30);
                    }
                    //间隔
                    height += self.isSpecialStyleVertical ? kRealWidth(5) : kRealWidth(15);
                    //第二行
                    NSArray *lastArr = [self.bannerList subarrayWithRange:NSMakeRange(3, self.bannerList.count - 3)];
                    //图片高度
                    height += self.imageViewHeight;
                    //文本高度 如果滚动的列表 只要有一个配置有文字  就都要留出文本的高度
                    BOOL lastLineHasText = [self checkBannerListHasText:lastArr];
                    if (lastLineHasText) {
                        height += kRealWidth(30);
                    }
                } else {
                    //一行  图片高度
                    height += self.imageViewHeight;
                    //文本高度 如果滚动的列表 只要有一个配置有文字  就都要留出文本的高度
                    BOOL hasText = [self checkBannerListHasText:self.bannerList];
                    if (hasText) {
                        height += kRealWidth(30);
                    }
                }
            }
            break;
        case TNActivityCardStyleMultipleBanners:
            //头部
            height += self.headerHeight;
            //横幅高度
            height += self.imageViewHeight;
            break;
        case TNActivityCardStyleSquareScorllItem: {
            //头部
            height += self.headerHeight;
            //横幅高度
            height += self.imageViewHeight;
            break;
        }
        default:
            break;
    }
    //底部间距
    if (self.titlePosition == TNActivityCardTitlePositionTop && self.scene != TNActivityCardSceneTopic) {
        height += kRealWidth(15);
    }
    return height;
}
///验证卡片数据源是否配置有文本
- (BOOL)checkBannerListHasText:(NSArray *)list {
    // 专题的广告  全部不要显示底部文本
    if (self.scene == TNActivityCardSceneTopic) {
        return NO;
    }
    BOOL hasText = NO;
    if (!HDIsArrayEmpty(list)) {
        for (TNActivityCardBannerItem *item in list) {
            if (HDIsStringNotEmpty(item.title)) {
                hasText = YES;
                break;
            }
        }
    }
    return hasText;
}
@end
