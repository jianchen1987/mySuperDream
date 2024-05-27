///
//  HDCollectionReusableView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import "HDCollectionReusableView.h"
#import "HDCollectionViewLayoutAttributes.h"


@interface HDCollectionReusableView ()
@property (nonatomic, strong) UIImageView *backgroundIV;
@end


@implementation HDCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backgroundIV];
        self.backgroundIV.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.backgroundIV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0
                                          constant:0.0],
            [NSLayoutConstraint constraintWithItem:self.backgroundIV attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0
                                          constant:0.0],
            [NSLayoutConstraint constraintWithItem:self.backgroundIV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0
                                          constant:0.0],
            [NSLayoutConstraint constraintWithItem:self.backgroundIV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0
                                          constant:0.0]
        ]];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    // 设置背景颜色
    HDCollectionViewLayoutAttributes *ecLayoutAttributes = (HDCollectionViewLayoutAttributes *)layoutAttributes;
    if (ecLayoutAttributes.color) {
        self.backgroundColor = ecLayoutAttributes.color;
    }
    if (ecLayoutAttributes.image) {
        self.backgroundIV.image = ecLayoutAttributes.image;
    }
}

- (UIImageView *)backgroundIV {
    if (!_backgroundIV) {
        _backgroundIV = [[UIImageView alloc] init];
        _backgroundIV.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundIV.backgroundColor = [UIColor clearColor];
    }
    return _backgroundIV;
}
@end
