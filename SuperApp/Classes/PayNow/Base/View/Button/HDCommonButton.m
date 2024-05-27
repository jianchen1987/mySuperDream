//
//  HDCommonButton.m
//  customer
//
//  Created by VanJay on 2019/4/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonButton.h"
#import "HDCommonDefines.h"
#import "HDHelperFunction.h"
#import "HDKitCore/HDFrameLayout.h"
#import "UIImage+HDKitCore.h"
#import "UIView+HD_Extension.h"


@interface HDCommonButton ()
@property (nonatomic, strong) UIView *iconViewContainer; ///< 图片 view 容器
@property (nonatomic, strong) UIImage *hd_currentImage;  ///< 当前图片
@end


@implementation HDCommonButton
#pragma mark - life cycle
- (void)commonInit {
    // 默认
    _type = HDCommonButtonImageLLabelR;
    _textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textAlignment = _textAlignment;

    self.imageView.contentMode = UIViewContentModeCenter;
    self.adjustsImageWhenDisabled = false;
    self.adjustsImageWhenHighlighted = false;
    self.isTextAlignmentCenterToWhole = false;
    self.clipsToBounds = true;
    self.minusHeightForIncorrectSystemCalcalateSize = 5.0;
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

#pragma mark - getters and setters
- (void)setType:(HDCommonButtonType)type {
    if (_type == type)
        return;

    _type = type;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment)
        return;

    _textAlignment = textAlignment;

    self.titleLabel.textAlignment = textAlignment;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setImageViewEdgeInsets:(UIEdgeInsets)imageViewEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_imageViewEdgeInsets, imageViewEdgeInsets))
        return;

    _imageViewEdgeInsets = imageViewEdgeInsets;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_labelEdgeInsets, labelEdgeInsets))
        return;

    _labelEdgeInsets = labelEdgeInsets;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setImageViewContainerColor:(UIColor *)imageViewContainerColor {
    if (_imageViewContainerColor == imageViewContainerColor)
        return;

    _imageViewContainerColor = imageViewContainerColor;

    [self.iconViewContainer removeFromSuperview];
    self.iconViewContainer = nil;
    _iconViewContainer = [[UIView alloc] init];
    _iconViewContainer.backgroundColor = imageViewContainerColor;
    [self insertSubview:_iconViewContainer belowSubview:self.imageView];

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (CGSize)appropriateSizeWithWidth:(CGFloat)width {
    const CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(width, 10)];
    CGSize imageSize = self.currentImage.size;
    if (!CGSizeIsEmpty(self.imageViewSize)) {
        imageSize = self.imageViewSize;
    }
    if (self.type == HDCommonButtonImageULabelD || self.type == HDCommonButtonImageDLabelU) { // 垂直
        if (self.isTitleEmpty) {
            return CGSizeMake(MAX(titleSize.width + self.labelEdgeInsets.left + self.labelEdgeInsets.right, imageSize.width + self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right),
                              imageSize.height + self.verticalMinimumMinusMargin);
        }
        return CGSizeMake(MAX(titleSize.width + self.labelEdgeInsets.left + self.labelEdgeInsets.right, imageSize.width + self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right),
                          titleSize.height + imageSize.height + self.verticalMinimumMinusMargin);

    } else if (self.type == HDCommonButtonImageLLabelR || self.type == HDCommonButtonImageRLabelL) { // 水平
        if (self.isTitleEmpty) {
            return CGSizeMake(imageSize.width + self.horizontalMinimumMinusMargin,
                              MAX(titleSize.height + self.labelEdgeInsets.top + self.labelEdgeInsets.bottom, imageSize.height + self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom));
        }
        return CGSizeMake(titleSize.width + imageSize.width + self.horizontalMinimumMinusMargin,
                          MAX(titleSize.height + self.labelEdgeInsets.top + self.labelEdgeInsets.bottom, imageSize.height + self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom));
    }
    return CGSizeZero;
}

- (void)setImageViewSize:(CGSize)imageViewSize {
    _imageViewSize = imageViewSize;

    // 防止多次生成
    if (!CGSizeIsEmpty(imageViewSize) && !CGSizeEqualToSize(self.imageView.image.size, imageViewSize)) {
        // 重新生成图片
        UIImage *image = [[self imageForState:self.state] hd_imageResizedInLimitedSize:self.imageViewSize resizingMode:HDUIImageResizingModeScaleAspectFit scale:UIScreen.mainScreen.scale];
        [self setImage:image forState:self.state];
    }
}

- (CGSize)appropriateSize {
    return [self appropriateSizeWithWidth:CGFLOAT_MAX];
}

#pragma mark - override system methods
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    self.hd_currentImage = image;

    [super setImage:image forState:state];
}

#pragma mark - private methods
/** 水平方向最小补偿间距 */
- (CGFloat)horizontalMinimumMinusMargin {
    if (self.type == HDCommonButtonImageULabelD || self.type == HDCommonButtonImageDLabelU) {
        return MAX(self.labelEdgeInsets.left + self.labelEdgeInsets.right, self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right);
    }

    return self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right + self.labelEdgeInsets.left + self.labelEdgeInsets.right;
}

/** 垂直方向最小补偿间距 */
- (CGFloat)verticalMinimumMinusMargin {
    if (self.type == HDCommonButtonImageLLabelR || self.type == HDCommonButtonImageRLabelL) {
        return MAX(self.labelEdgeInsets.top + self.labelEdgeInsets.bottom, self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom) + self.minusHeightForIncorrectSystemCalcalateSize;
    }

    return self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom + self.labelEdgeInsets.top + self.labelEdgeInsets.bottom + self.minusHeightForIncorrectSystemCalcalateSize;
}

- (BOOL)isTitleEmpty {
    return HDIsStringEmpty(self.titleLabel.text) && HDIsStringEmpty(self.titleLabel.attributedText.string);
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    const CGSize size = self.frame.size;

    if (CGSizeIsEmpty(size))
        return;

    CGFloat w = size.width, h = size.height;

    switch (_type) {
        case HDCommonButtonImageLLabelR: {
            if (self.isTitleEmpty) {
                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.centerX.equalToValue(w * 0.5);
                    make.centerY.equalToValue(h * 0.5);
                }];
            } else {
                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.left.hd_equalTo(self.imageViewEdgeInsets.left);
                    make.centerY.hd_equalTo(h * 0.5);
                }];

                if (self.textAlignment == NSTextAlignmentCenter && self.isTextAlignmentCenterToWhole) {
                    self.titleLabel.width = w - _labelEdgeInsets.right - _labelEdgeInsets.left;
                    self.titleLabel.height = h;
                    self.titleLabel.left = _labelEdgeInsets.left;
                    self.titleLabel.centerY = h * 0.5;
                } else {
                    self.titleLabel.width = w - self.imageView.right - _imageViewEdgeInsets.right - UIEdgeInsetsGetHorizontalValue(_labelEdgeInsets);
                    self.titleLabel.height = h;
                    self.titleLabel.left = self.imageView.right + _imageViewEdgeInsets.right + _labelEdgeInsets.left;
                    self.titleLabel.centerY = h * 0.5;
                }
            }
        } break;

        case HDCommonButtonImageRLabelL: {
            if (self.isTitleEmpty) {
                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.centerX.equalToValue(w * 0.5);
                    make.centerY.equalToValue(h * 0.5);
                }];
            } else {
                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.left.hd_equalTo(w - self.imageView.width - self.imageViewEdgeInsets.right);
                    make.centerY.hd_equalTo(h * 0.5);
                }];

                if (self.textAlignment == NSTextAlignmentCenter && self.isTextAlignmentCenterToWhole) {
                    self.titleLabel.width = w - _labelEdgeInsets.left - _labelEdgeInsets.right;
                } else {
                    self.titleLabel.width = self.imageView.left - _imageViewEdgeInsets.left - _labelEdgeInsets.left - _labelEdgeInsets.right;
                }

                [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                    make.top.hd_equalTo(0);
                    make.height.hd_equalTo(h);
                    make.left.hd_equalTo(self.labelEdgeInsets.left);
                }];
            }
        } break;
        case HDCommonButtonImageULabelD: {
            if (self.isTitleEmpty) {
                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.centerX.equalToValue(w * 0.5);
                    make.centerY.equalToValue(h * 0.5);
                }];
            } else {
                [self.titleLabel sizeToFit];
                CGFloat labelW = self.titleLabel.bounds.size.width;
                CGFloat labelH = self.titleLabel.bounds.size.height;

                [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                    make.size.equalToValue(CGSizeMake(labelW, labelH + self.minusHeightForIncorrectSystemCalcalateSize));
                    make.centerX.equalToValue(w * 0.5);
                    make.top.hd_equalTo(h - self.labelEdgeInsets.bottom - labelH - self.minusHeightForIncorrectSystemCalcalateSize);
                }];

                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.centerX.equalToValue(w * 0.5);
                    make.top.hd_equalTo(self.imageViewEdgeInsets.top);
                }];
            }
        } break;
        case HDCommonButtonImageDLabelU: {
            if (self.isTitleEmpty) {
                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.centerX.equalToValue(w * 0.5);
                    make.centerY.equalToValue(h * 0.5);
                }];
            } else {
                [self.titleLabel sizeToFit];

                CGFloat labelW = self.titleLabel.bounds.size.width;
                CGFloat labelH = self.titleLabel.bounds.size.height;
                [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                    make.size.equalToValue(CGSizeMake(labelW, labelH + self.minusHeightForIncorrectSystemCalcalateSize));
                    make.centerX.equalToValue(w * 0.5);
                    make.top.hd_equalTo(self.labelEdgeInsets.top);
                }];

                [self fixImageViewSize:^(HDFrameLayoutMaker *make) {
                    make.centerX.equalToValue(w * 0.5);
                    make.top.hd_equalTo(self.titleLabel.bottom + self.labelEdgeInsets.bottom + self.imageViewEdgeInsets.top);
                }];
            }
        } break;

        default:
            break;
    }
    // 设置图片容器 frame
    if (_iconViewContainer) {
        if (_type == HDCommonButtonImageLLabelR) {
            _iconViewContainer.frame = CGRectMake(0, 0, self.imageView.width + self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right, self.height);
        } else if (_type == HDCommonButtonImageRLabelL) {
            _iconViewContainer.frame
                = CGRectMake(self.imageView.left - self.imageViewEdgeInsets.left, 0, self.imageView.width + self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right, self.height);
        } else if (_type == HDCommonButtonImageULabelD) {
            _iconViewContainer.frame = CGRectMake(0, 0, self.width, self.imageView.height + +self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom);
        } else if (_type == HDCommonButtonImageDLabelU) {
            _iconViewContainer.frame
                = CGRectMake(0, self.imageView.top - self.imageViewEdgeInsets.top, self.width, self.imageView.height + self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom);
        }
    }
    // 圆角
    if (self.heightFullRounded) {
        [self setRoundedCorners:UIRectCornerAllCorners radius:h * 0.5];
    } else {
        if (self.cornerRadius > 0) {
            [self setRoundedCorners:UIRectCornerAllCorners radius:self.cornerRadius];
        }
    }
}

- (void)fixImageViewSize:(void (^)(HDFrameLayoutMaker *make))layout {
    [self.imageView sizeToFit];
    [self.imageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        !layout ?: layout(make);
    }];
}
@end
