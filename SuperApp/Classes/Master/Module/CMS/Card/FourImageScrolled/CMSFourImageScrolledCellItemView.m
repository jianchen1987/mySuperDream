//
//  CMSFourImageScrolledCellItemView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSFourImageScrolledCellItemView.h"
#import "CMSFourImageScrolledItemConfig.h"
#import "SAShadowBackgroundView.h"


@interface CMSFourImageScrolledCellItemView ()

/// 图片
@property (nonatomic, strong) SDAnimatedImageView *imageView;
/// 背景
@property (nonatomic, strong) SAShadowBackgroundView *bgView;
@end


@implementation CMSFourImageScrolledCellItemView

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.imageView];
    [self addGestureRecognizer:self.hd_tapRecognizer];

    [self.imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    !self.clickedBlock ?: self.clickedBlock(self.model);
}

#pragma mark - setter
- (void)setModel:(CMSFourImageScrolledItemConfig *)model {
    _model = model;

    [HDWebImageManager setGIFImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(168, 116)] imageView:self.imageView];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
        _imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(168, 116)];
    }
    return _imageView;
}

- (SAShadowBackgroundView *)bgView {
    if (!_bgView) {
        SAShadowBackgroundView *view = SAShadowBackgroundView.new;
        view.backgroundColor = UIColor.clearColor;
        _bgView = view;
    }
    return _bgView;
}
@end
