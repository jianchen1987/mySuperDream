//
//  NSString+MD5.h
//  FanXing
//
//  Created by Wilson on 14/12/3.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (MD5)
- (NSString *)md5;
- (NSString *)MD5;
- (NSString *)md5To16;
+ (NSString *)fileMD5:(NSString *)filePath;

+ (NSString *)MD5Hash:(NSString *)fileName;
- (NSString *)encodeWithMD5:(NSString *)key;
- (NSString *)encodeMD5WithKey:(NSString *)key;
@end
