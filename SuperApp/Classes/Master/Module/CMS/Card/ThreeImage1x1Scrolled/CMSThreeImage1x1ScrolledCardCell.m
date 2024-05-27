//
//  CMSThreeImageScrolled1_1CardCell.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSThreeImage1x1ScrolledCardCell.h"
#import "CMSThreeImage1x1ItemConfig.h"


@interface CMSThreeImage1x1ScrolledCardCell ()

/// 广告图
@property (nonatomic, strong) SDAnimatedImageView *adIconView;

@end


@implementation CMSThreeImage1x1ScrolledCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.adIconView];
}

#pragma mark - setter
- (void)setModel:(CMSThreeImage1x1ItemConfig *)model {
    _model = model;
    [HDWebImageManager setGIFImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(123), kRealWidth(123))] imageView:self.adIconView];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.adIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)adIconView {
    if (!_adIconView) {
        _adIconView = [[SDAnimatedImageView alloc] init];
        _adIconView.contentMode = UIViewContentModeScaleAspectFill;
        _adIconView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _adIconView;
}
@end
