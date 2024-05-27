//
//  PNMSMapAddressDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/7/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSMapAddressModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSMapAddressDTO : PNModel

/// 商户省份列表
- (void)getProvinces:(void (^)(NSArray<PNMSMapAddressModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
