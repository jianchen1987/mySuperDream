//
//  NSString+AES.m
//  testCamera
//
//  Created by 陈剑 on 16/1/28.
//  Copyright © 2016年 翼支付. All rights reserved.
//

#import "GTMBase64.h"
#import "NSData+AES.h"
#import "NSString+AES.h"

//#define AES_SALT @"783d7d6f5df7eb4e"


@implementation NSString (AES)

- (NSString *)AES128CBCEncryptWithKey:(NSString *)key andVI:(NSString *)vi {
    //    NSString *realykey = [self getRealKey:key];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    NSData *result = [data AES128CBCEncryptWithKey:key andVI:vi];
    if (result && result.length > 0) {
        return [result base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }

    return nil;
}

- (NSString *)AES128CBCDecryptWithKey:(NSString *)key andVI:(NSString *)vi {
    //    NSString *realkey = [self getRealKey:key];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *result = [data AES128CBCDecryptWithKey:key andVI:vi];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }

    return nil;
}

+ (NSString *)ThreeDES:(NSString *)text encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key {
    const void *vplainText;
    const Byte myIv[8] = {50, 51, 52, 53, 54, 55, 56, 57};
    size_t plainTextBufferSize;

    if (encryptOrDecrypt == kCCDecrypt) //解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    } else //加密
    {
        NSData *contentData = [text dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger paddingLength = 8 - [contentData length] % 8;
        plainTextBufferSize = [contentData length] + paddingLength;

        vplainText = malloc((plainTextBufferSize + 1) * sizeof(Byte));
        bzero((void *)vplainText, plainTextBufferSize + 1);
        memcpy((void *)vplainText, [contentData bytes], [contentData length]);
        // vplainText = (const void *)[data bytes];
    }

    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    if (key.length < 32) {
        while (key.length < 32) {
            key = [key stringByAppendingString:@"0"];
        }
    } else if (key.length > 32) {
        key = [key substringWithRange:NSMakeRange(0, 32)];
    }
    //    BPLog(@"key:%@",key);
    NSData *data = [GTMBase64 decodeString:key];

    // NSData *data = [GTMBase64 webSafeDecodeString:key ];
    // NSData *data = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];

    const void *vkey = (const void *)[data bytes];

    CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt, kCCAlgorithm3DES, 0, vkey, kCCKeySize3DES, myIv, vplainText, plainTextBufferSize, (void *)bufferPtr, bufferPtrSize, &movedBytes);

    NSString *result;
    if (ccStatus == kCCSuccess) {
        if (encryptOrDecrypt == kCCDecrypt) {
            result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
        } else {
            NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
            result = [self hexStringFromString:[GTMBase64 stringByEncodingData:myData]];
        }

    } else {
        result = nil;
    }

    return result;
}

+ (NSString *)hexStringFromString:(NSString *)string {
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for (int i = 0; i < [myD length]; i++)

    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i] & 0xff]; /// 16进制数

        if ([newHexStr length] == 1)

            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];

        else

            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
    }
    return hexStr;
}

- (NSString *)aesEncryptWithKey:(NSString *)transferKey {
    //    NSString* realKey32 = [self getRealKey:transferKey];
    NSData *encrypyTextBytes = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *resultData = [encrypyTextBytes AES256ECBEncryptWithKey:transferKey];
    NSString *base64Result = [resultData base64EncodedStringWithOptions:0];
    return base64Result;
}

- (NSString *)aesDecryptWithKey:(NSString *)transferKey {
    //    NSString* realKey32 = [self getRealKey:transferKey];
    NSData *decryptTextData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *resultText = [[NSString alloc] initWithData:[decryptTextData AES256ECBDecryptWithKey:transferKey] encoding:NSUTF8StringEncoding];
    return [resultText stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
}

- (NSString *)getRealKey {
    NSData *oriData = [self dataUsingEncoding:NSUTF8StringEncoding];

    //解密传输密钥，还原真正的key
    NSString *realKey = [[NSString alloc] initWithData:[oriData base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
    //    HDLog(@"realkey:%@",realKey);
    while (realKey.length < 16) {
        realKey = [realKey stringByAppendingString:@"0"];
    }
    NSString *realKey32 = [realKey substringWithRange:NSMakeRange(0, 16)];
    //    HDLog(@"realkey32:%@",realKey32);
    return realKey32;
}

@end
