//
//  SJReachabilityObserver.h
//  Project
//
//  Created by 畅三江 on 2018/12/28.
//  Copyright © 2018 changsanjiang. All rights reserved.
//

#import "SJReachabilityDefines.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SJReachability : NSObject <SJReachability>
+ (instancetype)shared;
@end
NS_ASSUME_NONNULL_END
