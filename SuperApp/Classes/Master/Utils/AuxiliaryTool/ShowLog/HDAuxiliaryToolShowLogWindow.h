//
//  HDAuxiliaryToolShowLogWindow.h
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolBaseWindow.h"
#import "HDAuxiliaryToolShowLogViewController.h"
#import <HDKitCore/HDLog.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAuxiliaryToolShowLogWindow : HDAuxiliaryToolBaseWindow <HDLoggerDelegate>
+ (instancetype)shared;
@property (nonatomic, strong, readonly) HDAuxiliaryToolShowLogViewController *vc; ///< 控制器
@end

NS_ASSUME_NONNULL_END
