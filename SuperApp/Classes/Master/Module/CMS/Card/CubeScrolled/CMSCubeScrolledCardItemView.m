//
//  CMSCubeScrolledCardItemView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSCubeScrolledCardItemView.h"
#import "CMSCubeScrolledItemConfig.h"


@interface CMSCubeScrolledCardItemView ()

/// 图片
@property (strong, nonatomic) UIImageView *imageView;

@end


@implementation CMSCubeScrolledCardItemView

- (void)hd_setupViews {
    [self addSubview:self.imageView];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - setter
- (void)setModel:(CMSCubeScrolledItemConfig *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(105), kRealWidth(105))] imageView:self.imageView];
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _imageView;
}

@end
