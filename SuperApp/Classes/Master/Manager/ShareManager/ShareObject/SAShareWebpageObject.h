//
//  SAShareWebpageObject.h
//  SuperApp
//
//  Created by Chaos on 2020/12/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShareObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAShareWebpageObject : SAShareObject

/// 网页的url地址
@property (nonatomic, copy) NSString *webpageUrl;

/// facebook分享的url地址
@property (nonatomic, copy) NSString *facebookWebpageUrl;

@end

NS_ASSUME_NONNULL_END
