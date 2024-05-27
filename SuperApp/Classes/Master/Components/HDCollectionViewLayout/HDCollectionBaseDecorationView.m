//
//  HDCollectionBaseDecorationView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import "HDCollectionBaseDecorationView.h"
#import "HDCollectionViewBackgroundViewLayoutAttributes.h"
#import <objc/runtime.h>


@implementation HDCollectionBaseDecorationView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    // 设置背景颜色
    HDCollectionViewBackgroundViewLayoutAttributes *myLayoutAttributes = (HDCollectionViewBackgroundViewLayoutAttributes *)layoutAttributes;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([self class], &methodCount);
    if ([myLayoutAttributes isKindOfClass:[HDCollectionViewBackgroundViewLayoutAttributes class]] && myLayoutAttributes.eventName != nil && myLayoutAttributes.eventName.length > 0) {
        for (int i = 0; i < methodCount; i++) {
            Method method = methods[i];
            SEL sel = method_getName(method);
            const char *name = sel_getName(sel);
            NSString *methodName = [NSString stringWithUTF8String:name];
            if ([methodName isEqualToString:myLayoutAttributes.eventName]) {
                SEL selector = NSSelectorFromString(myLayoutAttributes.eventName);
                IMP imp = [self methodForSelector:selector];
                if ([self respondsToSelector:selector]) {
                    if (myLayoutAttributes.parameter) {
                        void (*func)(id, SEL, id) = (void *)imp;
                        func(self, selector, myLayoutAttributes.parameter);
                    } else {
                        void (*func)(id, SEL) = (void *)imp;
                        func(self, selector);
                    }
                }
                break;
            };
        }
    }
    free(methods);
}
@end
