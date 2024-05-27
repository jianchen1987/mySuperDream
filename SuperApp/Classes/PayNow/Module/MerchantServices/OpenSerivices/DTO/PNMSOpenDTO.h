//
//  PNMSOpenDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSCategoryRspModel;
@class PNMSOpenModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOpenDTO : PNModel

/// 获取经营品类
- (void)getCategory:(void (^)(PNMSCategoryRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 开通商户
- (void)openMerchantServices:(NSDictionary *)paramDict
                  merchantNo:(NSString *)merchantNo
                     success:(void (^)(PNMSCategoryRspModel *rspModel))successBlock
                     failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取审核失败商户信息 【用于拒绝后填充数据】
- (void)getMMSApplyDetailsWithMerchantNo:(NSString *)merchantNo success:(void (^)(PNMSOpenModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
