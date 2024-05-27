//
//  PNGuarateenInitDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNGuarateenDetailModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenInitDTO : PNModel
/// 下单接口
- (void)buildOrder:(NSDictionary *)paramDic success:(void (^_Nullable)(PNGuarateenDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 通过手机号码反查 账号信息
- (void)getCCAmountWithMobile:(NSString *)mobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
