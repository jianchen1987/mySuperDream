//
//  HDPopViewManager.h
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopViewConfig.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDPopViewManager : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (void)showPopTipInView:(UIView *__nullable)view fromView:(UIView *)fromView config:(HDPopViewConfig *__nullable)config;
+ (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopViewConfig *> *)configs;
+ (void)dismissAnimated:(BOOL)animated;
+ (void)setDissmissHandler:(void (^__nullable)(void))completion withKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
