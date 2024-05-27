//
//  TNWithdrawDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNWithdrawModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawDTO : TNModel
// 收益详情接口
- (void)queryWithDrawDetailWithObjId:(NSString *)objId success:(void (^)(TNWithdrawModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
