//
//  WMOperationButton.h
//  SuperApp
//
//  Created by Chaos on 2020/8/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WMOperationButtonStyle) {
    WMOperationButtonStyleSolid, ///< 实心
    WMOperationButtonStyleHollow ///< 空心
};


@interface WMOperationButton : HDUIGhostButton
+ (instancetype)buttonWithStyle:(WMOperationButtonStyle)style;
@property (nullable, nonatomic, strong) UIColor *normalBackgroundColor;
@property (nullable, nonatomic, strong) UIColor *highLightBackgroundColor;
@property (nullable, nonatomic, strong) UIColor *disableBackgroundColor;

- (void)applyPropertiesWithBackgroundColor:(UIColor *)backgroundColor;
- (void)applyPropertiesWithStyle:(WMOperationButtonStyle)style;
- (void)applyHollowPropertiesWithTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
