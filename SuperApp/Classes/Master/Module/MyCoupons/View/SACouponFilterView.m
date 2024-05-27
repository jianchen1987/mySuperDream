//
//  SACouponFilterView.m
//  SuperApp
//
//  Created by seeu on 2021/8/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponFilterView.h"


@implementation SACouponFilterViewConfig

@end


@interface SACouponFilterView ()

@property (nonatomic, strong) NSMutableArray<HDUIGhostButton *> *buttons; /// < 按钮
/// 筛选按钮
@property (nonatomic, strong) HDUIButton *filterBtn;
/// 渐变view
@property (nonatomic, strong) UIView *transparentView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end


@implementation SACouponFilterView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = NO;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self addSubview:self.filterBtn];
    [self addSubview:self.transparentView];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

    UIView *left = nil;
    for (HDUIGhostButton *button in self.buttons) {
        [button sizeToFit];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!left) {
                make.left.mas_offset(HDAppTheme.value.padding.left);
            } else {
                make.left.equalTo(left.mas_right).offset(HDAppTheme.value.padding.left);
            }
            make.centerY.equalTo(self.scrollViewContainer.mas_centerY);
            if (button == self.buttons.lastObject) {
                make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
            }
        }];
        left = button;
    }

    if (!self.filterBtn.hidden) {
        [self.filterBtn sizeToFit];
        [self.filterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.left.equalTo(self.scrollView.mas_right);
        }];

        [self.transparentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.filterBtn.mas_left);
            make.top.bottom.equalTo(self.filterBtn);
            make.width.mas_equalTo(kRealWidth(20));
        }];
    } else {
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    [super updateConstraints];
}

#pragma mark - action
- (void)clickOnButton:(HDUIGhostButton *)button {
    NSUInteger idx = [self.buttons indexOfObject:button];
    [self setButtonSelectedWithIndex:idx];
    !self.clickOnFilterItemBlock ?: self.clickOnFilterItemBlock(self.configs[idx]);
}

- (void)clickedScreenBTNHandler {
    !self.filterBlock ?: self.filterBlock();
}

#pragma mark - setter
- (void)setConfigs:(NSArray<SACouponFilterViewConfig *> *)configs {
    _configs = configs;
    [self.buttons enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj removeFromSuperview];
    }];

    for (SACouponFilterViewConfig *config in configs) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] initWithGhostType:HDUIGhostButtonColorWhite];
        [button setTitle:config.name.desc forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        [button addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [[UIColor hd_colorWithHexString:@"#999999"] colorWithAlphaComponent:0.1];
        button.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];

        [self.scrollViewContainer addSubview:button];
        [self.buttons addObject:button];
    }

    [self setNeedsUpdateConstraints];
}

- (void)setIsHiddenFilterBtn:(BOOL)isHiddenFilterBtn {
    _isHiddenFilterBtn = isHiddenFilterBtn;
    self.filterBtn.hidden = isHiddenFilterBtn;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self setButtonSelectedWithIndex:selectedIndex];
}

#pragma mark - private methods
- (void)setButtonSelectedWithIndex:(NSInteger)index {
    NSInteger btnCount = self.buttons.count;

    if (index >= btnCount)
        return;

    if (index < 0) { //为负数的情况全部按钮变成非选中状态
        for (HDUIGhostButton *btn in self.buttons) {
            btn.selected = NO;
            btn.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];
            btn.borderWidth = 0;
            btn.backgroundColor = [[UIColor hd_colorWithHexString:@"#999999"] colorWithAlphaComponent:0.1];
        }
    } else {
        HDUIGhostButton *button = self.buttons[index];

        for (HDUIGhostButton *btn in self.buttons) {
            if ([btn isEqual:button]) {
                [btn setSelected:YES];
                btn.ghostColor = HDAppTheme.color.sa_C1;
                btn.borderWidth = 1;
                btn.backgroundColor = [HDAppTheme.color.sa_C1 colorWithAlphaComponent:0.06];
            } else {
                [btn setSelected:NO];
                btn.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];
                btn.borderWidth = 0;
                btn.backgroundColor = [[UIColor hd_colorWithHexString:@"#999999"] colorWithAlphaComponent:0.1];
            }
        }
    }

    _selectedIndex = index;
}

#pragma mark - lazy load
- (NSMutableArray<HDUIGhostButton *> *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

- (HDUIButton *)filterBtn {
    if (!_filterBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColor.whiteColor;
        [button setImage:[UIImage imageNamed:@"coupon_filter"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        [button addTarget:self action:@selector(clickedScreenBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _filterBtn = button;
    }
    return _filterBtn;
}

- (UIView *)transparentView {
    if (!_transparentView) {
        _transparentView = UIView.new;

        @HDWeakify(self);
        _transparentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            if (self.gradientLayer) {
                [self.gradientLayer removeFromSuperlayer];
                self.gradientLayer = nil;
            }
            self.gradientLayer.frame = view.bounds;
            [view.layer addSublayer:self.gradientLayer];
        };
        _transparentView.userInteractionEnabled = NO;
    }
    return _transparentView;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.0].CGColor,
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor
        ];
        _gradientLayer.locations = @[@0.0, @1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }
    return _gradientLayer;
}

@end
