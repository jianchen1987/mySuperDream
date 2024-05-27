//
//  HDAuxiliaryToolSliderView.m
//  SuperApp
//
//  Created by VanJay on 2019/11/24.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolSliderView.h"
#import "Masonry.h"


@interface HDAuxiliaryToolSliderView ()
@property (nonatomic, copy) NSString *title;       ///< 标题
@property (nonatomic, strong) UILabel *titleLabel; ///< 标题
@property (nonatomic, strong) UISlider *slider;    ///< 滑动
@end


@implementation HDAuxiliaryToolSliderView

- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value {
    if (self = [super init]) {
        self.value = value;
        self.title = title;
        [self commonInit];
    }
    return self;
}

#pragma mark - life cycle
- (void)commonInit {
    [self addSubview:self.titleLabel];
    self.titleLabel.text = self.title;
    [self addSubview:self.slider];
    self.slider.value = self.value;
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

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self).offset(10);
        make.right.equalTo(self.slider.mas_left).offset(-10);
    }];

    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self).offset(10);
        make.width.equalTo(self).multipliedBy(0.4);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

#pragma mark - event response
- (void)sliderChangedHandler {
    !self.sliderValueChangedHandler ?: self.sliderValueChangedHandler(self.slider.value);
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _titleLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = UISlider.new;
        [_slider addTarget:self action:@selector(sliderChangedHandler) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

@end
