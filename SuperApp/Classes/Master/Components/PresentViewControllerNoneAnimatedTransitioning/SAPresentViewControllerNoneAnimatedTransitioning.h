//
//  SAPresentViewControllerNoneAnimatedTransitioning.h
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat kHDPresentDefaultTransitionDuration;


@interface SAPresentViewControllerNoneAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
/// 点击了阴影
@property (nonatomic, copy) void (^tappedShadowHandler)(void);
@end

NS_ASSUME_NONNULL_END
