//
//  SAOperationButton.h
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIGhostButton.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAOperationButtonStyle) {
    SAOperationButtonStyleSolid, ///< 实心
    SAOperationButtonStyleHollow ///< 空心
};


@interface SAOperationButton : HDUIGhostButton
+ (instancetype)buttonWithStyle:(SAOperationButtonStyle)style;
@property (nullable, nonatomic, strong) UIColor *normalBackgroundColor;
@property (nullable, nonatomic, strong) UIColor *highLightBackgroundColor;
@property (nullable, nonatomic, strong) UIColor *disableBackgroundColor;
@property (nonatomic, strong) UIColor *borderColor;


- (void)applyPropertiesWithBackgroundColor:(UIColor *)backgroundColor;
- (void)applyPropertiesWithStyle:(SAOperationButtonStyle)style;
- (void)applyHollowPropertiesWithTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
