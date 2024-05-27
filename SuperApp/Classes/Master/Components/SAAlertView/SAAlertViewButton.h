//
//  SAAlertViewButton.h
//  SuperApp
//
//  Created by Tia on 2022/9/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SAAlertViewButtonType) { SAAlertViewButtonTypeDefault = 0, SAAlertViewButtonTypeCustom, SAAlertViewButtonTypeCancel };

@class SAAlertView;
@class SAAlertViewButton;

typedef void (^SAAlertViewButtonHandler)(SAAlertView *alertView, SAAlertViewButton *button);


@interface SAAlertViewButton : UIButton

@property (nonatomic, assign) SAAlertViewButtonType type;     ///< 类型
@property (nonatomic, weak) SAAlertView *alertView;           ///< 弹窗
@property (nonatomic, copy) SAAlertViewButtonHandler handler; ///< 回调

+ (instancetype)buttonWithTitle:(NSString *)title type:(SAAlertViewButtonType)type handler:(SAAlertViewButtonHandler)handler;
- (instancetype)initWithTitle:(NSString *)title type:(SAAlertViewButtonType)type handler:(SAAlertViewButtonHandler)handler;

@end

NS_ASSUME_NONNULL_END
