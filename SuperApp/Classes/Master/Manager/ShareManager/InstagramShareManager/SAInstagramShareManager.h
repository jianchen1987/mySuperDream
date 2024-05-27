//
//  SAInstagramShareManager.h
//  SuperApp
//
//  Created by Chaos on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAShareObject.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAInstagramShareManager : NSObject

+ (instancetype)sharedManager;

- (void)sendShare:(SAShareObject *)shareObject completion:(void (^__nullable)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
