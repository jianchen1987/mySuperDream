//
//  TNLeftCircleImageButton.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNLeftCircleImageButton.h"
#import "HDAppTheme+TinhNow.h"
#import "NSString+HD_Size.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry.h>


@interface TNLeftCircleImageButton ()
@property (strong, nonatomic) UIImageView *imageView;
///
@property (strong, nonatomic) UILabel *titleLabel;
@end


@implementation TNLeftCircleImageButton
- (instancetype)init {
    self = [super init];
    if (self) {
        self.leftSpace = 5;
        self.rightSpace = 5;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:13];
    };
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}
- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.titleLabel.font = textFont;
}
- (void)setLeftCircleImage:(UIImage *)leftCircleImage {
    _leftCircleImage = leftCircleImage;
    self.imageView.image = leftCircleImage;
    //    [self setNeedsUpdateConstraints];
}
- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
    //    [self setNeedsUpdateConstraints];
}
- (void)setLeftSpace:(CGFloat)leftSpace {
    _leftSpace = leftSpace;
    //    [self setNeedsUpdateConstraints];
}
- (void)setRightSpace:(CGFloat)rightSpace {
    _rightSpace = rightSpace;
    //    [self setNeedsUpdateConstraints];
}
- (void)click {
    !self.addTouchUpInsideHandler ?: self.addTouchUpInsideHandler(self);
}
- (void)updateConstraints {
    [self.imageView sizeToFit];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.imageView.mas_right).offset(self.leftSpace);
        make.right.equalTo(self.mas_right).offset(-self.rightSpace);
    }];
    [super updateConstraints];
}
- (CGSize)getSizeFits {
    [self layoutIfNeeded];
    CGFloat height = self.leftCircleImage.size.height;
    CGFloat textWidth = [self.text boundingAllRectWithSize:CGSizeMake(kScreenWidth, height) font:self.textFont].width;
    CGFloat width = textWidth + self.leftCircleImage.size.width + self.leftSpace + self.rightSpace;
    return CGSizeMake(width, height);
}
/** @lazy imageView */
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
    }
    return _titleLabel;
}
@end
