//
//  PNMSCollectionDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSCollectionModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSCollectionDTO : PNModel
/// 商户 今日统计
- (void)getMSDayCountWithMerchantNo:(NSString *)merchantNo success:(void (^_Nullable)(PNMSCollectionModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
