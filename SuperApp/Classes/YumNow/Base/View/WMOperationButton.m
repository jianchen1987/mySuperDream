//
//  WMOperationButton.m
//  SuperApp
//
//  Created by Chaos on 2020/8/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOperationButton.h"
#import "WMAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIImage+HDKitCore.h>
#import <HDUIKit/HDAppTheme.h>


@implementation WMOperationButton

#pragma mark - life cycle
+ (instancetype)buttonWithStyle:(WMOperationButtonStyle)style {
    WMOperationButton *button = [WMOperationButton buttonWithType:UIButtonTypeCustom];
    [button applyPropertiesWithStyle:style];
    if (style == WMOperationButtonStyleHollow) {
        button.borderWidth = 1;
        button.layer.borderColor = HDAppTheme.color.mainColor.CGColor;
    }
    return button;
}

- (void)op_commonInit {
    self.titleLabel.font = HDAppTheme.font.standard2Bold;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    // 默认 solid
    [self applyPropertiesWithStyle:WMOperationButtonStyleSolid];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self op_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self op_commonInit];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    if (highlighted) {
        self.backgroundColor = self.highLightBackgroundColor;
    } else {
        self.backgroundColor = self.normalBackgroundColor;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (selected) {
        [self applyPropertiesWithStyle:WMOperationButtonStyleSolid];
    } else {
        [self applyPropertiesWithStyle:WMOperationButtonStyleHollow];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];

    if (enabled) {
        self.backgroundColor = self.normalBackgroundColor;
    } else {
        self.backgroundColor = self.disableBackgroundColor;
    }
}

#pragma mark - public methods
- (void)applyPropertiesWithBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.normalBackgroundColor = backgroundColor;
    self.highLightBackgroundColor = [self.normalBackgroundColor colorWithAlphaComponent:0.5];
    self.disableBackgroundColor = [self.normalBackgroundColor colorWithAlphaComponent:0.3];
}

- (void)applyPropertiesWithStyle:(WMOperationButtonStyle)style {
    UIColor *backgroundColor = style == WMOperationButtonStyleSolid ? HDAppTheme.color.mainColor : UIColor.whiteColor;
    UIColor *titleColor = style == WMOperationButtonStyleSolid ? UIColor.whiteColor : HDAppTheme.color.mainColor;
    [self applyPropertiesWithBackgroundColor:backgroundColor];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    if (style == WMOperationButtonStyleHollow) {
        self.borderWidth = 1;
        self.layer.borderColor = HDAppTheme.color.mainColor.CGColor;
    }
}

- (void)applyHollowPropertiesWithTintColor:(UIColor *)tintColor {
    UIColor *backgroundColor = UIColor.whiteColor;
    [self applyPropertiesWithBackgroundColor:backgroundColor];
    [self setTitleColor:tintColor forState:UIControlStateNormal];
    self.borderWidth = 1;
    self.layer.borderColor = tintColor.CGColor;
}
@end
