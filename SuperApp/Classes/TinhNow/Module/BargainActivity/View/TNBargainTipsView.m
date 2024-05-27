//
//  TNBargainTipsView.m
//  SuperApp
//
//  Created by xixi on 2021/3/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainTipsView.h"


@interface TNBargainTipsView ()
/// 大logo
@property (nonatomic, strong) UIImageView *iconImgView;
///
@property (nonatomic, strong) UIView *contentBgView;
/// 内容
@property (nonatomic, strong) UILabel *contentLabel;
/// 大logo显示位置
@property (nonatomic, assign) CGRect logoFrame;
/// 箭头
@property (nonatomic, strong) TNTriangleView *arrowView;
@end


@implementation TNBargainTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor hd_colorWithHexString:@"0x000000"] colorWithAlphaComponent:0.5f];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.contentLabel];
    [self addSubview:self.arrowView];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.left.equalTo(@(self.logoFrame.origin.x));
        make.top.equalTo(@(self.logoFrame.origin.y));
    }];

    [self.contentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(30.f);
        make.right.mas_equalTo(self.mas_right).offset(-20.f);
        make.bottom.mas_equalTo(self.iconImgView.mas_top).offset(-24.f);
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(10.f);
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(-10.f);
        make.top.mas_equalTo(self.contentBgView.mas_top).offset(13.f);
        make.bottom.mas_equalTo(self.contentBgView.mas_bottom).offset(-13.f);
    }];

    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.f, 14.f));
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(-10.f);
        make.top.mas_equalTo(self.contentBgView.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setConfig:(TNBargainTipsViewConfig *)config {
    _config = config;
    self.iconImgView.image = [UIImage imageNamed:config.logoName];
    self.logoFrame = config.logoFrame;
    self.contentLabel.text = config.contentStr;
    self.contentLabel.font = config.contentFont;
    self.contentLabel.textColor = config.contentTitleColor;
    self.contentBgView.backgroundColor = config.contentBackgroundColor;
    self.arrowView.triangleColor = config.contentBackgroundColor;
    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.layer.cornerRadius = 4.f;
    }
    return _contentBgView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (TNTriangleView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[TNTriangleView alloc] init];
    }
    return _arrowView;
}

#pragma mark -
- (void)dismissView {
    [self removeFromSuperview];
}

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)inView {
    if (inView != nil) {
        [inView addSubview:self];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

@end


@implementation TNBargainTipsViewConfig

@end


@implementation TNTriangleView

- (void)drawRect:(CGRect)rect {
    //倒三角形🔻
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width * 0.5f, rect.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextClosePath(context);
    [self.triangleColor setStroke];
    [self.triangleColor setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
