//
//  SATabBarButton.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATabBarButton.h"
#import "SALabel.h"
#import "SALotAnimationView.h"
#import "SAStorkeColorLabel.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/HDKitCore.h>
#import <HDVendorKit/HDWebImageManager.h>


@interface SATabBarButton ()
@property (nonatomic, strong) SDAnimatedImageView *animatedImageView; ///< 图片
@property (nonatomic, assign) UIControlState priorState;              ///< 状态
@property (nonatomic, strong) SAStorkeColorLabel *storkeColorLabel;   ///< 角标
@property (nonatomic, strong) SALotAnimationView *lotAnimationView;   ///< lottieView

@end


@implementation SATabBarButton
#pragma mark - life cycle
- (void)commonInit {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.animatedImageView];

    self.priorState = UIControlStateNormal;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self addSubview:self.lotAnimationView];

    [self addSubview:self.storkeColorLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - override
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    UIImage *resizedImage = [image hd_imageResizedInLimitedSize:CGSizeMake(40, 40)];
    [super setImage:resizedImage forState:state];
}

//取消高亮
- (void)setHighlighted:(BOOL)highlighted {
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    CGFloat scale = UIScreen.mainScreen.scale;
    self.animatedImageView.hidden = false;
    self.lotAnimationView.hidden = true;
    [self.lotAnimationView stop];
    if (selected) {
        if (HDIsStringEmpty(self.config.selectedLocalImage)) {
            if (!HDIsObjectNil(self.config.imageSelected)) { //新版本逻辑
                if ([self.config.imageSelected.type isEqualToString:@"json"]) {
                    [self.lotAnimationView setAnimationFromURL:self.config.imageSelected.url];
                    self.animatedImageView.hidden = true;
                    self.lotAnimationView.hidden = false;
                    [self.lotAnimationView play];
                } else {
                    [HDWebImageManager setGIFImageWithURL:self.config.imageSelected.url size:CGSizeMake(40 * scale, 40 * scale)
                                         placeholderImage:[HDHelper placeholderImageWithCornerRadius:10.0f size:CGSizeMake(40 * scale, 40 * scale)
                                                                                            logoSize:CGSizeMake(30 * scale, 30 * scale)] //[self imageForState:UIControlStateSelected]
                                                imageView:self.animatedImageView];
                }
            } else { //兼容旧版本
                [HDWebImageManager setGIFImageWithURL:self.config.selectedImageUrl size:CGSizeMake(40 * scale, 40 * scale)
                                     placeholderImage:[HDHelper placeholderImageWithCornerRadius:10.0f size:CGSizeMake(40 * scale, 40 * scale)
                                                                                        logoSize:CGSizeMake(30 * scale, 30 * scale)] //[self imageForState:UIControlStateSelected]
                                            imageView:self.animatedImageView];
            }
        } else {
            self.animatedImageView.image = [UIImage imageNamed:self.config.selectedLocalImage];
        }
    } else {
        if (HDIsStringEmpty(self.config.localImage)) {
            if (!HDIsObjectNil(self.config.imageNormal)) {
                if ([self.config.imageNormal.type isEqualToString:@"json"]) {
                    [self.lotAnimationView setAnimationFromURL:self.config.imageNormal.url];
                    self.animatedImageView.hidden = true;
                    self.lotAnimationView.hidden = false;
                    [self.lotAnimationView play];
                } else {
                    [HDWebImageManager setGIFImageWithURL:self.config.imageNormal.url size:CGSizeMake(40 * scale, 40 * scale)
                                         placeholderImage:[HDHelper placeholderImageWithCornerRadius:10.0f size:CGSizeMake(40 * scale, 40 * scale)
                                                                                            logoSize:CGSizeMake(30 * scale, 30 * scale)] //[self imageForState:UIControlStateSelected]
                                                imageView:self.animatedImageView];
                }
            } else {
                [HDWebImageManager setGIFImageWithURL:self.config.imageUrl size:CGSizeMake(40 * scale, 40 * scale)
                                     placeholderImage:[HDHelper placeholderImageWithCornerRadius:10.0f size:CGSizeMake(40 * scale, 40 * scale)
                                                                                        logoSize:CGSizeMake(30 * scale, 30 * scale)] //[self imageForState:UIControlStateSelected]
                                            imageView:self.animatedImageView];
            }
        } else {
            self.animatedImageView.image = [UIImage imageNamed:self.config.localImage];
        }
    }
}

#pragma mark - private methods
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.imageView removeFromSuperview];

    const CGFloat h = self.height, w = self.width, imageViewWH = 22;

    if (HDIsStringEmpty([self titleForState:self.state])) {
        [self.animatedImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(h * 0.7, h * 0.7));
            make.centerX.hd_equalTo(self.width * 0.5);
            make.centerY.hd_equalTo(self.height * 0.5);
        }];

        [self.lotAnimationView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(h * 0.7, h * 0.7));
            make.centerX.hd_equalTo(self.width * 0.5);
            make.centerY.hd_equalTo(self.height * 0.5);
        }];

    } else {
        if (isLandscape) {
            [self.titleLabel sizeToFit];
            CGFloat labelW = self.titleLabel.width;
            const CGFloat margin = 5;

            if (imageViewWH + labelW + margin > w) {
                labelW = w - margin - imageViewWH;
            }

            [self.animatedImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(CGSizeMake(imageViewWH, imageViewWH));
                make.left.hd_equalTo((w - margin - imageViewWH - labelW) * 0.5);
                make.centerY.hd_equalTo(h * 0.5);
            }];

            [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.centerY.hd_equalTo(h * 0.5);
                make.left.hd_equalTo(self.animatedImageView.right + margin);
                make.width.hd_equalTo(labelW);
            }];

            [self.lotAnimationView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(CGSizeMake(imageViewWH, imageViewWH));
                make.left.hd_equalTo((w - margin - imageViewWH - labelW) * 0.5);
                make.centerY.hd_equalTo(h * 0.5);
            }];
        } else {
            CGFloat const vMargin = 5;
            [self.titleLabel sizeToFit];

            [self.animatedImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(CGSizeMake(imageViewWH, imageViewWH));
                make.centerX.hd_equalTo(self.width * 0.5);
                make.top.hd_equalTo(7);
            }];

            [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.top.hd_equalTo(self.animatedImageView.bottom).offset(vMargin);
                make.centerX.hd_equalTo(self.width * 0.5);
                make.width.hd_equalTo(self.width);
            }];

            [self.lotAnimationView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(CGSizeMake(imageViewWH, imageViewWH));
                make.centerX.hd_equalTo(self.width * 0.5);
                make.top.hd_equalTo(7);
            }];
        }
    }
    // 设置角标位置
    if (!self.storkeColorLabel.isHidden) {
        // 最大不超过图片宽度
        const CGFloat maxBadgeLabelWidth = CGRectGetWidth(self.frame);
        [self.storkeColorLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo([self.storkeColorLabel sizeThatFits:CGSizeMake(maxBadgeLabelWidth, MAXFLOAT)]);
            make.left.hd_equalTo(self.animatedImageView.right).offset(-5);
            make.centerY.hd_equalTo(self.animatedImageView.top).offset(3);
        }];
    }
}

#pragma mark - setter
- (void)setConfig:(SATabBarItemConfig *)config {
    _config = config;
    NSString *title = HDIsStringNotEmpty(config.name.desc) ? config.name.desc : config.localName.desc;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:config.hideTextWhenSelected ? @"" : title forState:UIControlStateSelected];
    [self setTitle:config.hideTextWhenSelected ? @"" : title forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:config.localImage] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:config.selectedLocalImage] forState:UIControlStateSelected];
    [self setTitleColor:config.titleColor forState:UIControlStateNormal];
    [self setTitleColor:config.selectedTitleColor forState:UIControlStateSelected];

    self.titleLabel.font = config.titleFont;
    if (HDIsStringNotEmpty(config.badgeValue)) {
        self.storkeColorLabel.badgeNumberLB.text = config.badgeValue;
        self.storkeColorLabel.hidden = false;
    } else {
        self.storkeColorLabel.badgeNumberLB.text = @"";
        self.storkeColorLabel.hidden = true;
    }
    if (config.badgeFont) {
        self.storkeColorLabel.badgeNumberLB.font = config.badgeFont;
    }
    [self setSelected:self.selected];
    [self setNeedsLayout];
}

#pragma mark - public methods
- (void)updateBadgeValue:(NSString *)badgeValue {
    self.config.badgeValue = badgeValue;
    self.storkeColorLabel.hidden = HDIsStringEmpty(badgeValue);
    if (!self.storkeColorLabel.badgeNumberLB.isHidden && [badgeValue isKindOfClass:NSString.class]) {
        self.storkeColorLabel.badgeNumberLB.text = badgeValue;
        [self setNeedsLayout];
    }
}

- (void)updateBadgeColor:(UIColor *)badgeColor {
    if (!self.storkeColorLabel.isHidden) {
        self.storkeColorLabel.badgeNumberLB.textColor = badgeColor;
    }
}

- (void)updateBackgroundColor:(UIColor *)backgroundColor {
    if (!self.storkeColorLabel.isHidden) {
        self.storkeColorLabel.badgeNumberLB.backgroundColor = backgroundColor;
    }
}

- (void)addCustomAnimation:(CAAnimation *)anim forKey:(NSString *)key {
    if (!self.lotAnimationView.hidden) {
        [self.lotAnimationView.layer addAnimation:anim forKey:key];
    } else {
        [self.animatedImageView.layer addAnimation:anim forKey:key];
    }
}

#pragma mark - lazy load
- (SDAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        _animatedImageView = SDAnimatedImageView.new;
        _animatedImageView.runLoopMode = NSRunLoopCommonModes;
    }
    return _animatedImageView;
}

- (SAStorkeColorLabel *)storkeColorLabel {
    if (!_storkeColorLabel) {
        _storkeColorLabel = [[SAStorkeColorLabel alloc] initWidthContentEdgeInsets:UIEdgeInsetsMake(1.5, 1.5, 1.5, 1.5)];
        _storkeColorLabel.hidden = true;
    }
    return _storkeColorLabel;
}

- (SALotAnimationView *)lotAnimationView {
    if (!_lotAnimationView) {
        _lotAnimationView = [SALotAnimationView new];
        _lotAnimationView.userInteractionEnabled = false;
        _lotAnimationView.hidden = true;
    }
    return _lotAnimationView;
}

@end
