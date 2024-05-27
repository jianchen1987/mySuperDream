//
//  NSURLRequest+SABody.m
//  SuperApp
//
//  Created by Tia on 2022/7/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "NSURLRequest+SABody.h"


@implementation NSURLRequest (SABody)

- (NSMutableURLRequest *)sa_bodyForPost {
    NSMutableURLRequest *mRequest = [self mutableCopy];
    if ([self.HTTPMethod isEqualToString:@"POST"]) {
        if (!self.HTTPBody) {
            NSInteger maxLength = 1024;
            uint8_t d[maxLength];
            NSInputStream *stream = self.HTTPBodyStream;
            NSMutableData *data = [NSMutableData data];
            [stream open];
            BOOL endOfStreamReached = NO;
            while (!endOfStreamReached) {
                NSInteger bytesRead = [stream read:d maxLength:maxLength];
                if (bytesRead <= 0) {
                    endOfStreamReached = YES;
                } else if (stream.streamError == nil) {
                    [data appendBytes:(void *)d length:bytesRead];
                }
            }
            mRequest.HTTPBody = [data copy];
            [stream close];
        }
    }
    return mRequest;
}

@end
