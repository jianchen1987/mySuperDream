//
//  UIView+GZIP.h
//  SuperApp
//
//  Created by 张杰 on 2023/3/23.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (GZIP)

- (nullable NSData *)gzippedDataWithCompressionLevel:(float)level;
- (nullable NSData *)gzippedData;
- (nullable NSData *)gunzippedData;
- (BOOL)isGzippedData;

// deflated 算法压缩
- (nullable NSData *)deflatedDataWithCompressionLevel:(float)level;
- (nullable NSData *)deflatedData;

@end
