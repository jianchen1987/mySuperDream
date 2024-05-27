//
//  HDAuxiliaryToolBaseWindow.h
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAuxiliaryToolBaseWindow : UIWindow

+ (HDAuxiliaryToolBaseWindow *)shared;

// 需要子类重写
- (void)addRootVc;

- (void)show;

- (void)hide;
@end

NS_ASSUME_NONNULL_END
