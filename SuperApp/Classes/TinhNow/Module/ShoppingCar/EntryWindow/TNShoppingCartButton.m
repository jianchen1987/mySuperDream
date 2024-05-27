//
//  WMShoppingCartButton.m
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCartButton.h"
#import "TNView.h"
#import <HDLabel.h>


@interface TNShoppingCartButton ()
/// 指示器图
@property (nonatomic, strong) HDLabel *indicatorLabel;
@end


@implementation TNShoppingCartButton
#pragma mark - life cycle
- (void)commonInit {
    [self addSubview:self.indicatorLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(1, 3, 1, 3);
        self.offsetX = 12;
        self.offsetY = 10;
        self.indicatorFont = [HDAppTheme.TinhNowFont fontSemibold:9];
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
- (void)setIndicatorFont:(UIFont *)indicatorFont {
    _indicatorFont = indicatorFont;
    self.indicatorLabel.font = indicatorFont;
}
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    self.indicatorLabel.hd_edgeInsets = self.edgeInsets;
}
- (void)updateConstraints {
    if (!self.indicatorLabel.hidden) {
        [self.indicatorLabel sizeToFit];
        [self.indicatorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.indicatorLabel.frame.size.height);
            make.width.mas_greaterThanOrEqualTo(self.indicatorLabel.frame.size.height);
            make.centerX.equalTo(self.mas_right).offset(-self.offsetX);
            make.centerY.equalTo(self.mas_top).offset(self.offsetY);
        }];
    }

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

#pragma mark - public methods
- (void)updateIndicatorDotWithCount:(NSUInteger)count {
    if (count > 99) {
        self.indicatorLabel.text = @"99+";
    } else {
        self.indicatorLabel.text = [NSString stringWithFormat:@"%ld", count];
    }
    self.indicatorLabel.hidden = count <= 0;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDLabel *)indicatorLabel {
    if (!_indicatorLabel) {
        _indicatorLabel = [[HDLabel alloc] init];
        _indicatorLabel.textColor = UIColor.whiteColor;
        _indicatorLabel.hd_edgeInsets = self.edgeInsets;
        _indicatorLabel.font = [HDAppTheme.TinhNowFont fontSemibold:9];

        _indicatorLabel.layer.borderWidth = 1;
        _indicatorLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        _indicatorLabel.backgroundColor = HDAppTheme.TinhNowColor.C3;
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2;
            view.layer.masksToBounds = YES;
        };
        _indicatorLabel.hidden = YES;
    }
    return _indicatorLabel;
}
@end
