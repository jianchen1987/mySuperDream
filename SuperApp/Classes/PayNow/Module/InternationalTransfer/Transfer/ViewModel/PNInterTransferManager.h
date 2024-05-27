//
//  PNInterTransferManager.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferManager : NSObject

+ (void)adjustChecKInterTransferCompletion:(void (^)(BOOL isSuccess))completion;

@end

NS_ASSUME_NONNULL_END
