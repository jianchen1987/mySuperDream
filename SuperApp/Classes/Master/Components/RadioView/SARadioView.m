//
//  SARadioView.m
//  SuperApp
//
//  Created by Chaos on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARadioView.h"


@implementation SARadioViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.size = CGSizeMake(18, 18);
        self.margin = 4;
        self.borderWidth = PixelOne;
        self.selectedBorderWidth = 1;
        self.color = HDAppTheme.color.G3;
        self.selectedColor = HDAppTheme.color.mainColor;
    }
    return self;
}

@end


@interface SARadioView ()

/// 外圈
@property (nonatomic, strong) UIView *outLineView;
/// 内圈
@property (nonatomic, strong) UIView *inCircleView;

@end


@implementation SARadioView

- (instancetype)initWithConfig:(SARadioViewConfig *)config {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.outLineView];
    [self addSubview:self.inCircleView];
}

- (void)updateConstraints {
    [self.outLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.size.mas_equalTo(self.config.size);
    }];
    [self.inCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.outLineView).offset(self.config.margin);
        make.right.bottom.equalTo(self.outLineView).offset(-self.config.margin);
    }];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, size.width, size.height);

    [super updateConstraints];
}

#pragma mark - private methods
- (void)updateUI {
    if (self.isSelected) {
        self.outLineView.layer.borderColor = self.config.selectedColor.CGColor;
        self.outLineView.layer.borderWidth = self.config.selectedBorderWidth;
        self.outLineView.layer.cornerRadius = self.config.size.height * 0.5;

        self.inCircleView.hidden = false;
        self.inCircleView.backgroundColor = self.config.selectedColor;
        self.inCircleView.layer.cornerRadius = (self.config.size.height - self.config.margin * 2) * 0.5;
    } else {
        self.outLineView.layer.borderColor = self.config.color.CGColor;
        self.outLineView.layer.borderWidth = self.config.borderWidth;
        self.outLineView.layer.cornerRadius = self.config.size.height * 0.5;

        self.inCircleView.hidden = true;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - setter
- (void)setConfig:(SARadioViewConfig *)config {
    _config = config;
    [self updateUI];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self updateUI];
}

#pragma mark - lazy load
- (UIView *)outLineView {
    if (!_outLineView) {
        _outLineView = UIView.new;
        _outLineView.layer.borderColor = self.config.color.CGColor;
        _outLineView.layer.borderWidth = self.config.borderWidth;
        _outLineView.layer.cornerRadius = self.config.size.height * 0.5;
    }
    return _outLineView;
}

- (UIView *)inCircleView {
    if (!_inCircleView) {
        _inCircleView = UIView.new;
        _inCircleView.hidden = true;
        _inCircleView.backgroundColor = self.config.selectedColor;
        _inCircleView.layer.cornerRadius = (self.config.size.height - self.config.margin * 2) * 0.5;
    }
    return _inCircleView;
}

@end
