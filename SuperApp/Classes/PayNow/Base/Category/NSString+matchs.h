//
//  NSString+matchs.h
//  National Wallet
//
//  Created by 陈剑 on 2018/5/17.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUM @"0123456789"
#define CharString @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define CharAndNumber @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define NumberString @"1234567890"


@interface NSString (matchs)

- (BOOL)matches:(NSString *)regex;

/**
 匹配只包含字符串

 @param string 字符
 @param matchingRule 匹配字符
 @return 结果
 */
- (BOOL)checkString:(NSString *)string matchingRule:(NSString *)matchingRule;
@end
