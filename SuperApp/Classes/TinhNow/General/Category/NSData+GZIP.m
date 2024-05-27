//
//  UIView+GZIP.m
//  SuperApp
//
//  Created by 张杰 on 2023/3/23.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "NSData+GZIP.h"
#import <HDKitCore/HDKitCore.h>
#import <zlib.h>
#pragma clang diagnostic ignored "-Wcast-qual"


@implementation NSData (GZIP)

- (NSData *)compressDataWithWindowBits:(NSInteger)windowBits level:(float)level {
    if (self.length == 0 || [self isGzippedData]) {
        return self;
    }
    //    HDLog(@"压缩前的大小 size =  %ld", self.length);
    //    NSTimeInterval startTime = [[NSDate new] timeIntervalSince1970];
    //    HDLog(@"压缩开始 -- %.4f", startTime);

    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)self.length;
    stream.next_in = (Bytef *)(void *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    static const NSUInteger ChunkSize = 16384;

    NSMutableData *output = nil;
    int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)(roundf(level * 9));
    //    windowBits为 31 时 deflate() 方法生成 gzip 格式。当取值为 -15 ~ -8 时，deflate() 生成纯 deflate 算法压缩数据
    if (deflateInit2(&stream, compression, Z_DEFLATED, windowBits, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0) {
            if (stream.total_out >= output.length) {
                output.length += ChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }
    //    NSTimeInterval endTime = [[NSDate new] timeIntervalSince1970];
    //    HDLog(@"压缩结束 -- %.4f", endTime);
    //    HDLog(@"压缩耗时 -- %.4fs --- 线程- %@", endTime - startTime, [NSThread currentThread]);
    //    HDLog(@"压缩后的大小 size = %ld", output.length);
    return output;
}

- (NSData *)gzippedDataWithCompressionLevel:(float)level {
    return [self compressDataWithWindowBits:31 level:level];
}

- (NSData *)gzippedData {
    return [self gzippedDataWithCompressionLevel:-1.0f];
}
- (NSData *)deflatedDataWithCompressionLevel:(float)level {
    return [self compressDataWithWindowBits:-15 level:level];
}
- (NSData *)deflatedData {
    return [self deflatedDataWithCompressionLevel:-1.0f];
}

- (NSData *)gunzippedData {
    if (self.length == 0 || ![self isGzippedData]) {
        return self;
    }

    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)self.length;
    stream.next_in = (Bytef *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    NSMutableData *output = nil;
    if (inflateInit2(&stream, 47) == Z_OK) {
        int status = Z_OK;
        output = [NSMutableData dataWithCapacity:self.length * 2];
        while (status == Z_OK) {
            if (stream.total_out >= output.length) {
                output.length += self.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            status = inflate(&stream, Z_SYNC_FLUSH);
        }
        if (inflateEnd(&stream) == Z_OK) {
            if (status == Z_STREAM_END) {
                output.length = stream.total_out;
            }
        }
    }

    return output;
}

- (BOOL)isGzippedData {
    const UInt8 *bytes = (const UInt8 *)self.bytes;
    return (self.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

@end
