//
//  WMFoodCustomizeButton.m
//  SuperApp
//
//  Created by VanJay on 2020/6/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMFoodCustomizeButton.h"
#import "SAView.h"


@interface WMFoodCustomizeButton ()
/// 数量
@property (nonatomic, strong) SALabel *countLB;
@end


@implementation WMFoodCustomizeButton

+ (instancetype)buttonWithStyle:(WMOperationButtonStyle)style {
    WMFoodCustomizeButton *button = [super buttonWithType:UIButtonTypeCustom];
    return button;
}

#pragma mark - life cycle
- (void)commonInit {
    [self addSubview:self.countLB];
    self.countLB.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        view.layer.cornerRadius = view.height / 2.0;
    };
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

#pragma mark - public methods
- (void)updateUIWithCount:(NSUInteger)count storeStatus:(WMStoreStatus)storeStatus {
    self.countLB.hidden = [storeStatus isEqualToString:WMStoreStatusResting] || count <= 0;
    if (!self.countLB.isHidden) {
        self.countLB.text = [NSString stringWithFormat:@"%zd", count];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.countLB.isHidden) {
        [self.countLB sizeToFit];
        [self.countLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            if (self.countLB.width < self.countLB.height) {
                make.width.hd_equalTo(self.countLB.height);
            }
            make.centerX.hd_equalTo(self.width).offset(-kRealWidth(4));
            make.centerY.hd_equalTo(0);
        }];
    }
}

#pragma mark - lazy load
- (SALabel *)countLB {
    if (!_countLB) {
        SALabel *label = SALabel.new;
        label.hidden = true;
        label.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
        label.layer.borderWidth = 1;
        label.layer.borderColor = UIColor.whiteColor.CGColor;
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        label.hd_edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        label.numberOfLines = 1;
        _countLB = label;
    }
    return _countLB;
}
@end
