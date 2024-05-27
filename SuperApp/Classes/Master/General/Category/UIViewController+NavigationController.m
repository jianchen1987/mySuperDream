//
//  UIViewController+NavigationController.m
//  SuperApp
//
//  Created by seeu on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UIViewController+NavigationController.h"


@implementation UIViewController (NavigationController)
- (void)remoteViewControllerWithSpecifiedClass:(Class)exceptClass {
    if (!self.navigationController) {
        return;
    }
    NSMutableArray<UIViewController *> *controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:exceptClass]) {
            [controllers removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [NSArray arrayWithArray:controllers];
}
@end
