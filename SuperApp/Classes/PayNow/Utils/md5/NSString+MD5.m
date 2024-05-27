//
//  NSString+MD5.m
//  FanXing
//
//  Created by Wilson on 14/12/3.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MD5)
- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;
}

- (NSString *)md5To16 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];

    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return [output substringWithRange:NSMakeRange(8, 16)];
}

+ (NSString *)fileMD5:(NSString *)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (handle == nil)
        return nil;

    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);

    BOOL done = NO;
    while (!done) {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if ([fileData length] == 0)
            done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *filemd5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                   digest[0],
                                                   digest[1],
                                                   digest[2],
                                                   digest[3],
                                                   digest[4],
                                                   digest[5],
                                                   digest[6],
                                                   digest[7],
                                                   digest[8],
                                                   digest[9],
                                                   digest[10],
                                                   digest[11],
                                                   digest[12],
                                                   digest[13],
                                                   digest[14],
                                                   digest[15]];
    return filemd5;
}

+ (NSString *)MD5Hash:(NSString *)fileName {
    if (fileName == nil)
        return nil;
    const char *cStr = [fileName UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);

    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                                      result[0],
                                      result[1],
                                      result[2],
                                      result[3],
                                      result[4],
                                      result[5],
                                      result[6],
                                      result[7],
                                      result[8],
                                      result[9],
                                      result[10],
                                      result[11],
                                      result[12],
                                      result[13],
                                      result[14],
                                      result[15]];
}

- (NSString *)encodeWithMD5:(NSString *)key {
    NSString *encodeStr = [NSString stringWithFormat:@"%@%@", self, key];
    const char *cStr = [encodeStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);

    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                     result[0],
                                                     result[1],
                                                     result[2],
                                                     result[3],
                                                     result[4],
                                                     result[5],
                                                     result[6],
                                                     result[7],
                                                     result[8],
                                                     result[9],
                                                     result[10],
                                                     result[11],
                                                     result[12],
                                                     result[13],
                                                     result[14],
                                                     result[15]];
    NSRange range = NSMakeRange(8, 16);
    return [md5String substringWithRange:range];
}

- (NSString *)encodeMD5WithKey:(NSString *)key {
    NSString *encodeStr = [NSString stringWithFormat:@"%@%@", self, key];
    const char *cStr = [encodeStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);

    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                     result[0],
                                                     result[1],
                                                     result[2],
                                                     result[3],
                                                     result[4],
                                                     result[5],
                                                     result[6],
                                                     result[7],
                                                     result[8],
                                                     result[9],
                                                     result[10],
                                                     result[11],
                                                     result[12],
                                                     result[13],
                                                     result[14],
                                                     result[15]];
    return md5String;
}

@end
