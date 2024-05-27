//
//  TNWithdrawBindDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNWithdrawBindModel.h"
#import "TNWithdrawBindRequestModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawBindDTO : TNModel

/// 获取所有提现方式 及支付方式下的公司数据
- (void)queryPaymentWaySuccess:(void (^)(NSArray<TNWithdrawBindModel *> *))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 获取用户绑定支付信息
- (void)queryBindPayAcountSuccess:(void (^)(TNWithdrawBindRequestModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 提交提现申请
- (void)postWithDrawApplyWithModel:(TNWithdrawBindRequestModel *)requestModel success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
