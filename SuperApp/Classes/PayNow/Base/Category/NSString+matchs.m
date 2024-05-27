//
//  NSString+matchs.m
//  National Wallet
//
//  Created by 陈剑 on 2018/5/17.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "NSString+matchs.h"


@implementation NSString (matchs)

- (BOOL)matches:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)checkString:(NSString *)string matchingRule:(NSString *)matchingRule {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:matchingRule] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}
@end
