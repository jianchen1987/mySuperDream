//
//  NSString+Random.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "NSString+Random.h"


@implementation NSString (Random)

+ (NSString *)getRandomStringWithNum:(NSInteger)num {
    NSString *string = [[NSString alloc] init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        } else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}
@end
