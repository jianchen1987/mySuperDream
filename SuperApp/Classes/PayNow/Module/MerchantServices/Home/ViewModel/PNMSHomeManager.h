//
//  PNMSHomeManager.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNMSHomeManager : NSObject

+ (void)adjustCheckMerchantServicesCompletion:(void (^)(BOOL isSuccess, NSString *merchantNo, NSString *merchantName, NSString *operatorNo, PNMSRoleType role, NSArray *merchantMenus,
                                                        NSArray *permission, NSString *storeNo, NSString *storeName))completion;

@end

NS_ASSUME_NONNULL_END
