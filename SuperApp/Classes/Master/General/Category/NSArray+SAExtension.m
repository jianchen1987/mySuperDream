//
//  NSArray+SAExtension.m
//  SuperApp
//
//  Created by VanJay on 2020/6/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "NSArray+SAExtension.h"


@implementation NSArray (SAExtension)
- (BOOL)isSetFormatEqualTo:(NSArray *)array {
    if (self.count != array.count) {
        return NO;
    }
    for (NSString *str in self) {
        if (![array containsObject:str]) {
            return NO;
        }
    }
    return YES;
}
@end
