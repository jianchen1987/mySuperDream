//
//  NSData+AES.m
//  testCamera
//
//  Created by 陈剑 on 16/1/28.
//  Copyright © 2016年 翼支付. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "GTMBase64.h"


@implementation NSData (AES)

- (NSData *)AES128CBCEncryptWithKey:(NSString *)key andVI:(NSString *)vi {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];

    size_t bufferSize = dataLength + kCCKeySizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;

    NSData *initVector = [vi dataUsingEncoding:NSUTF8StringEncoding];

    CCCryptorStatus cryptStatus
        = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES128, initVector.bytes, [self bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);

    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)AES128CBCDecryptWithKey:(NSString *)key andVI:(NSString *)vi {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCKeySizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;

    NSData *initVector = [vi dataUsingEncoding:NSUTF8StringEncoding];

    CCCryptorStatus cryptStatus
        = CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES128, initVector.bytes, [self bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }

    free(buffer);
    return nil;
}

- (NSData *)AES256ECBEncryptWithKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];

    //填充模式 PaddingMode.Zeros，计算需要填充的位数
    NSUInteger paddingLength = dataLength % 16 == 0 ? 16 : 16 - (dataLength % 16);
    dataLength += paddingLength;

    Byte content[dataLength + 1];
    bzero(content, dataLength + 1);
    memcpy(content, [self bytes], self.length);

    size_t bufferSize = dataLength + kCCKeySizeAES256;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionECBMode, keyPtr, kCCKeySizeAES256, NULL, content, dataLength, buffer, bufferSize, &numBytesEncrypted);

    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)AES256ECBDecryptWithKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCKeySizeAES256;
    void *buffer = malloc(bufferSize);
    bzero(buffer, bufferSize);
    size_t numBytesDecrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionECBMode, keyPtr, kCCKeySizeAES256, NULL, [self bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }

    free(buffer);
    return nil;
}

@end
