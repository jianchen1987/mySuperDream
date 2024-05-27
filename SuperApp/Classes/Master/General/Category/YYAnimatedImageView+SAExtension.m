//
//  YYAnimatedImageView+SAExtension.m
//  SuperApp
//
//  Created by Chaos on 2020/10/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "YYAnimatedImageView+SAExtension.h"
#import <objc/runtime.h>


@implementation YYAnimatedImageView (SAExtension)

+ (void)load {
    // hook：钩子函数
    Method method1 = class_getInstanceMethod(self, @selector(displayLayer:));

    Method method2 = class_getInstanceMethod(self, @selector(dx_displayLayer:));
    method_exchangeImplementations(method1, method2);
}

- (void)dx_displayLayer:(CALayer *)layer {
    if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
        [super displayLayer:layer];
    }
}
@end
