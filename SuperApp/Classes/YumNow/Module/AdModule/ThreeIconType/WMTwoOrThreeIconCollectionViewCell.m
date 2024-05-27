//
//  WMTwoOrThreeIconCollectionViewCell.m
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMThreeIconCollectionViewCell.h"
#import "WMWindowItemModel.h"


@interface WMThreeIconCollectionViewCell ()

/// 广告图
@property (nonatomic, strong) SDAnimatedImageView *adIconView;

@end


@implementation WMThreeIconCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.adIconView];
}

#pragma mark - setter
- (void)setModel:(WMWindowItemModel *)model {
    _model = model;

    [HDWebImageManager setGIFImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(150, 148)] imageView:self.adIconView];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.adIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.width.equalTo(self.contentView.mas_height).multipliedBy(1 / 1.0);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)adIconView {
    if (!_adIconView) {
        _adIconView = [[SDAnimatedImageView alloc] init];
        _adIconView.contentMode = UIViewContentModeScaleAspectFill;
        _adIconView.image = [HDHelper placeholderImageWithSize:CGSizeMake(150, 148)];
        _adIconView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _adIconView;
}
@end
