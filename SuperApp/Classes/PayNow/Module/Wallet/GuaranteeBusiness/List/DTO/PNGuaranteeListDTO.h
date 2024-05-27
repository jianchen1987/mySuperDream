//
//  PNGuaranteeListDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNGuaranteeRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNGuaranteeListDTO : PNModel

/// 订单列表接口
- (void)getGuarateenRecordList:(NSDictionary *)paramDic success:(void (^_Nullable)(PNGuaranteeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
