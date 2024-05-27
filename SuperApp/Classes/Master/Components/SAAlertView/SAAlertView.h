//
//  SAAlertView.h
//  SuperApp
//
//  Created by Tia on 2022/9/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAlertViewButton.h"
#import "SAAlertViewConfig.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAAlertView : HDActionAlertView

+ (instancetype)alertViewWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message config:(HDAlertViewConfig *__nullable)config;
- (instancetype)initWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message config:(HDAlertViewConfig *__nullable)config;
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title contentView:(UIView *)contentView config:(HDAlertViewConfig *__nullable)config;
- (instancetype)initWithTitle:(NSString *__nullable)title contentView:(UIView *)contentView config:(HDAlertViewConfig *__nullable)config;
- (void)addButton:(SAAlertViewButton *)button;
- (void)addButtons:(NSArray<SAAlertViewButton *> *)buttons;

@end

NS_ASSUME_NONNULL_END
