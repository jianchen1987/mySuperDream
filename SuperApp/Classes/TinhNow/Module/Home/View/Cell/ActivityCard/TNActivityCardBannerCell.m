//
//  TNActivityCardBannerCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardBannerCell.h"


@interface TNActivityCardBannerCell ()
/// 横幅
@property (strong, nonatomic) UIImageView *banner;
@end


@implementation TNActivityCardBannerCell
- (void)hd_setupViews {
    [super hd_setupViews];
    [self.baseView addSubview:self.banner];
    self.banner.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClick:)];
    [self.banner addGestureRecognizer:tap];
}
- (void)setCardModel:(TNActivityCardModel *)cardModel {
    [super setCardModel:cardModel];
    if (!HDIsArrayEmpty(cardModel.bannerList)) {
        TNActivityCardBannerItem *item = cardModel.bannerList.firstObject;
        [HDWebImageManager setImageWithURL:item.bannerUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth - kRealWidth(40), kRealWidth(130)) logoWidth:kRealWidth(80)]
                                 imageView:self.banner];
    }
    [self setNeedsUpdateConstraints];
}
- (void)bannerClick:(UITapGestureRecognizer *)tap {
    if (!HDIsArrayEmpty(self.cardModel.bannerList)) {
        TNActivityCardBannerItem *item = self.cardModel.bannerList.firstObject;
        if (HDIsStringNotEmpty(item.jumpLink)) {
            [SAWindowManager openUrl:item.jumpLink withParameters:@{@"funnel": self.cardModel.scene == TNActivityCardSceneIndex ? @"[电商]首页_点击广告位" : @""}];
        }
        NSString *eventName = self.cardModel.scene == TNActivityCardSceneIndex ? @"[电商]首页_点击广告位" : @"[电商]普通专题广告位";
        [SATalkingData trackEvent:eventName label:@"" parameters:@{@"排序": @(0), @"名称": item.title, @"路由": item.jumpLink, @"类型": @"横幅"}];
    }
}
- (void)updateConstraints {
    [super updateConstraints];
    CGFloat padding = (self.cardModel.scene == TNActivityCardSceneTopic && !self.cardModel.isSpecialStyleVertical) ? 10 : 0;
    [self.banner mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.cardModel.scene == TNActivityCardSceneTopic) {
            make.top.equalTo(self.headerView.mas_bottom);
        } else {
            make.top.equalTo(self.baseView.mas_top);
        }
        make.left.equalTo(self.baseView.mas_left).offset(padding);
        make.right.equalTo(self.baseView.mas_right).offset(-padding);
        make.height.mas_equalTo(self.cardModel.imageViewHeight);
    }];
}
- (UIImageView *)banner {
    if (!_banner) {
        _banner = [[UIImageView alloc] init];
        _banner.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            if (self.cardModel.scene == TNActivityCardSceneTopic) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:8];
            }
        };
    }
    return _banner;
}
@end
