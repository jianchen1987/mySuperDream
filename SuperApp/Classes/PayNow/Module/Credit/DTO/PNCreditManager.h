//
//  PNCreditManager.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/28.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNCreditManager : NSObject

+ (instancetype)sharedInstance;

- (void)checkCreditAuthorizationCompletion:(void (^)(BOOL needAuth, NSDictionary *rspData))completion;

@end

NS_ASSUME_NONNULL_END
