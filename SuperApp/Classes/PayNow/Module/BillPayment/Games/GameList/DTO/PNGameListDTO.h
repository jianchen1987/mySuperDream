//
//  PNGameListDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
@class PNGameRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNGameListDTO : PNModel
/// 查询账单详情
- (void)queryGameListSuccess:(void (^)(PNGameRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
