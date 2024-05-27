//
//  NSString+AES.h
//  testCamera
//
//  Created by 陈剑 on 16/1/28.
//  Copyright © 2016年 翼支付. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <Foundation/Foundation.h>


@interface NSString (AES)

// AES128加解密
- (NSString *)AES128CBCEncryptWithKey:(NSString *)key andVI:(NSString *)vi;
- (NSString *)AES128CBCDecryptWithKey:(NSString *)key andVI:(NSString *)vi;

//+ (NSString *)ThreeDES:(NSString *)text encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key;

// AES256加解密
- (NSString *)aesEncryptWithKey:(NSString *)transferKey;
- (NSString *)aesDecryptWithKey:(NSString *)transferKey;

- (NSString *)getRealKey;

@end
