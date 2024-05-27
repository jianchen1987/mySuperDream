//
//  PNMarketingManager.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PNCheckMarketingRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMarketingManager : NSObject

+ (void)checkUser:(void (^)(PNCheckMarketingRspModel *rspModel))completion;

@end

NS_ASSUME_NONNULL_END
