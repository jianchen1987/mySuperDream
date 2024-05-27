//
//  PNInterTransferRecordDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
@class PNInterTransferRecordRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferRecordDTO : PNModel
///获取国际转账记录
- (void)queryInterTransferRecordListWithPageNum:(NSInteger)pageNum
                                       pageSize:(NSInteger)pageSize
                                        success:(void (^_Nullable)(PNInterTransferRecordRspModel *rspModel))successBlock
                                        failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
