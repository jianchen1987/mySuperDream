//
//  UIViewController+NavigationController.h
//  SuperApp
//
//  Created by seeu on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (NavigationController)

- (void)remoteViewControllerWithSpecifiedClass:(Class)exceptClass;

@end

NS_ASSUME_NONNULL_END
