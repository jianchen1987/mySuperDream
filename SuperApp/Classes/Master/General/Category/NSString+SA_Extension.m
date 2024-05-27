//
//  NSString+SA_Extension.m
//  SuperApp
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "NSString+SA_Extension.h"


@implementation NSString (SA_Extension)
- (NSString *)verticalString {
    NSMutableString *str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i = 1; i < count; i++) {
        [str insertString:@"\n" atIndex:i * 2 - 1];
    }
    return str;
}

- (NSString *)SA_desensitize {
    if (self.length == 1) {
        return @"***";
    } else if (self.length == 2) {
        return [NSString stringWithFormat:@"%@***", [self substringToIndex:1]];
    } else {
        return [self stringByReplacingCharactersInRange:NSMakeRange(1, self.length - 2) withString:@"***"];
    }
}

- (NSString *)sa_855PhoneFormat {
    NSString *phone = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableString *mutablePhone = [NSMutableString stringWithString:phone];
    if ([mutablePhone hasPrefix:@"855"]) {
        if (mutablePhone.length > 9) {
            [mutablePhone insertString:@" " atIndex:9];
        }
    }
    if (mutablePhone.length > 6) {
        [mutablePhone insertString:@" " atIndex:6];
    }
    if (mutablePhone.length > 3) {
        [mutablePhone insertString:@" " atIndex:3];
    }
    return mutablePhone;
}

- (NSDate *)dateWithFormat:(NSString *)format {
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:format];
    [formatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    return [formatter1 dateFromString:self];
}


@end
