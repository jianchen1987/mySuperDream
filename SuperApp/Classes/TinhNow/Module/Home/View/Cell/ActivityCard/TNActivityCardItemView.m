//
//  TNActivityCardItemView.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardItemView.h"
#import "SATalkingData.h"


@interface TNActivityCardItemView ()
/// 图片
@property (strong, nonatomic) UIImageView *imageView;
/// 文本
@property (strong, nonatomic) UILabel *textLabel;
@end


@implementation TNActivityCardItemView
- (void)hd_setupViews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [self addGestureRecognizer:tap];
}
- (void)setItem:(TNActivityCardBannerItem *)item {
    _item = item;
    [HDWebImageManager setImageWithURL:item.bannerUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(self.imageViewWidth, self.imageViewHeight)] imageView:self.imageView];
    self.textLabel.text = item.title;
    [self setNeedsUpdateConstraints];
}
//- (void)setRectCorner:(TNActivityCardRectCorner)rectCorner {
//    _rectCorner = rectCorner;
//}
- (void)setScene:(TNActivityCardScene)scene {
    _scene = scene;
}
- (void)itemClick:(UITapGestureRecognizer *)tap {
    if (HDIsStringNotEmpty(self.item.jumpLink)) {
        [SAWindowManager openUrl:self.item.jumpLink withParameters:@{@"funnel": self.scene == TNActivityCardSceneIndex ? @"[电商]首页_点击广告位" : @""}];
    }
    NSString *eventName = self.scene == TNActivityCardSceneIndex ? @"[电商]首页_点击广告位" : @"[电商]普通专题广告位";
    [SATalkingData trackEvent:eventName label:@"" parameters:@{@"排序": @(self.item.index), @"名称": self.item.title, @"路由": self.item.jumpLink, @"类型": self.item.cardType}];
}
- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(self.imageViewHeight);
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom);
        if (HDIsStringNotEmpty(self.item.title)) {
            make.height.mas_equalTo(kRealWidth(30));
        } else {
            make.height.mas_equalTo(kRealWidth(0));
        }
    }];
    [super updateConstraints];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            //            if (self.rectCorner == TNActivityCardRectCornerTop) {
            //                [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:4];
            //            } else if (self.rectCorner == TNActivityCardRectCornerAll) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
            //            }
        };
    }
    return _imageView;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _textLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _textLabel;
}
@end
