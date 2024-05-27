//
//  PNInterTransferIndexDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
@class PNInterTransferRecordRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferIndexDTO : PNModel
/// 获取最近转账列表
- (void)queryInterTransferRecentRecordListWithPageNum:(NSInteger)pageNum
                                             pageSize:(NSInteger)pageSize
                                              success:(void (^_Nullable)(PNInterTransferRecordRspModel *rspModel))successBlock
                                              failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
