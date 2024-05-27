//
//  HDScrollIndicatorView.m
//  SuperApp
//
//  Created by seeu on 2022/4/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDScrollIndicatorView.h"
#import <HDKitCore/HDKitCore.h>


@interface HDScrollIndicatorView ()

///< 背景
@property (nonatomic, strong) UIView *background;
///< dot
@property (nonatomic, strong) UIView *dot;

@end


@implementation HDScrollIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [[UIView alloc] initWithFrame:frame];
        self.background.layer.cornerRadius = frame.size.height / 2.0;
        self.background.layer.masksToBounds = YES;

        self.dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 3.0, frame.size.height)];
        self.dot.layer.cornerRadius = frame.size.height / 2.0;
        self.dot.layer.masksToBounds = YES;
        [self addSubview:self.background];
        [self.background addSubview:self.dot];

        self.dotColor = UIColor.blackColor;
        self.bgColor = [UIColor hd_colorWithHexString:@"#e4e5ea"];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    if (progress < 0) {
        _progress = 0;
    } else if (progress > 1) {
        _progress = 1;
    } else {
        _progress = progress;
    }
    CGFloat position = (self.background.frame.size.width - self.dot.frame.size.width) * _progress;
    CGFloat fix = self.dot.frame.size.width / 2.0;
    CGPoint center = self.dot.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.dot.center = CGPointMake(fix + position, center.y);
    }];
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    self.dot.backgroundColor = dotColor;
    [self setNeedsLayout];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.background.backgroundColor = bgColor;
    [self setNeedsLayout];
}

@end
