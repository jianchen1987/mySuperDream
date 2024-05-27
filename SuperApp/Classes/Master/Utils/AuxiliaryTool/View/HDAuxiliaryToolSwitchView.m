//
//  HDAuxiliaryToolSwitchView.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolSwitchView.h"
#import "Masonry.h"


@interface HDAuxiliaryToolSwitchView ()
@property (nonatomic, copy) NSString *title;         ///< 标题
@property (nonatomic, strong) UILabel *titleLabel;   ///< 标题
@property (nonatomic, strong) UISwitch *onOffSwitch; ///< 开关
@end


@implementation HDAuxiliaryToolSwitchView

- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn {
    if (self = [super init]) {
        self.on = isOn;
        self.title = title;
        [self commonInit];
    }
    return self;
}

#pragma mark - life cycle
- (void)commonInit {
    [self addSubview:self.titleLabel];
    self.titleLabel.text = self.title;
    [self addSubview:self.onOffSwitch];
    self.onOffSwitch.on = self.isOn;
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
        make.right.equalTo(self.onOffSwitch.mas_left).offset(-10);
    }];

    [self.onOffSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self).offset(10);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

#pragma mark - event response
- (void)switchChangedHandler {
    !self.switchValueChangedHandler ?: self.switchValueChangedHandler(self.onOffSwitch.isOn);
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

- (UISwitch *)onOffSwitch {
    if (!_onOffSwitch) {
        _onOffSwitch = UISwitch.new;
        [_onOffSwitch addTarget:self action:@selector(switchChangedHandler) forControlEvents:UIControlEventValueChanged];
    }
    return _onOffSwitch;
}
@end
