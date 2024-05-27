//
//  NSURLRequest+SABody.h
//  SuperApp
//
//  Created by Tia on 2022/7/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSURLRequest (SABody)
/// POST请求取回body
- (NSMutableURLRequest *)sa_bodyForPost;

@end

NS_ASSUME_NONNULL_END
