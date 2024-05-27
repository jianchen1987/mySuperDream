//
//  SAOperationButton.m
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOperationButton.h"
#import "SAAppTheme.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIImage+HDKitCore.h>
#import <HDUIKit/HDAppTheme.h>


@implementation SAOperationButton

#pragma mark - life cycle
+ (instancetype)buttonWithStyle:(SAOperationButtonStyle)style {
    SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
    [button applyPropertiesWithStyle:style];
    if (style == SAOperationButtonStyleHollow) {
        button.borderWidth = 1;
        button.layer.borderColor = HDAppTheme.color.sa_C1.CGColor;
    }
    return button;
}

- (void)op_commonInit {
    self.titleLabel.font = HDAppTheme.font.standard2Bold;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    // 默认 solid
    [self applyPropertiesWithStyle:SAOperationButtonStyleSolid];
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
        [self applyPropertiesWithStyle:SAOperationButtonStyleSolid];
    } else {
        [self applyPropertiesWithStyle:SAOperationButtonStyleHollow];
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

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;

    self.layer.borderColor = borderColor.CGColor;
}

#pragma mark - public methods
- (void)applyPropertiesWithBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.normalBackgroundColor = backgroundColor;
    self.highLightBackgroundColor = [self.normalBackgroundColor colorWithAlphaComponent:0.5];
    self.disableBackgroundColor = [self.normalBackgroundColor colorWithAlphaComponent:0.3];
}

- (void)applyPropertiesWithStyle:(SAOperationButtonStyle)style {
    UIColor *backgroundColor = style == SAOperationButtonStyleSolid ? HDAppTheme.color.sa_C1 : UIColor.whiteColor;
    UIColor *titleColor = style == SAOperationButtonStyleSolid ? UIColor.whiteColor : HDAppTheme.color.sa_C1;
    [self applyPropertiesWithBackgroundColor:backgroundColor];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    if (style == SAOperationButtonStyleHollow) {
        self.borderWidth = 1;
        self.layer.borderColor = HDAppTheme.color.sa_C1.CGColor;
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
