//
//  PNWalletLogOutManager.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletLogOutManager : NSObject

+ (instancetype)sharedInstance;

- (void)start;
@end

NS_ASSUME_NONNULL_END
