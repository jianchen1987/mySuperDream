//
//  HDAuxiliaryToolHomeWindow.h
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAuxiliaryToolHomeWindow : UIWindow
@property (nonatomic, strong) UINavigationController *nav;
+ (instancetype)shared;

- (void)openPlugin:(UIViewController *)vc;

- (void)show;

- (void)hide;
@end

NS_ASSUME_NONNULL_END
