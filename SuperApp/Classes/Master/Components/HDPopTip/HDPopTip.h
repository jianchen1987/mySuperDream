//
//  HDPopTip.h
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopTipConfig.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDPopTip : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (void)showPopTipInView:(UIView *__nullable)view fromView:(UIView *)fromView config:(HDPopTipConfig *__nullable)config;
+ (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopTipConfig *> *)configs onlyInControllerClass:(Class __nullable)controllerClass;
+ (void)dismissAnimated:(BOOL)animated;
+ (void)setDissmissHandler:(void (^__nullable)(void))completion withKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
