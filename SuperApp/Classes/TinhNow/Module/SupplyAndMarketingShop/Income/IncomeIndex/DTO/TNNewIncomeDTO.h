//
//  TNNewIncomeDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCheckWalletOpenedModel.h"
#import "TNIncomeListFilterModel.h"
#import "TNNewIncomeDetailModel.h"
#import "TNNewIncomeRspModel.h"
#import "TNNewProfitIncomeModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNNewIncomeDTO : NSObject
// 查询用户是否开通钱包 以及是否实名
- (void)queryCheckUserOpenedSuccess:(void (^)(TNCheckWalletOpenedModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
// 查询卖家账户结算和预估金额
- (void)queryProfitIncomeDataSuccess:(void (^)(TNNewProfitIncomeModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
// 查询收益列表数据
- (void)queryIncomeListWithPageNum:(NSUInteger)pageNum
                          pageSize:(NSUInteger)pageSize
                       filterModel:(TNIncomeListFilterModel *)filterModel
                           success:(void (^)(TNNewIncomeRspModel *_Nonnull))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock;
// 查询收益总计
- (void)queryIncomeSettlementSumWithFilterModel:(TNIncomeListFilterModel *)filterModel success:(void (^)(TNIncomeCommissionSumModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;

// 收益详情接口
- (void)queryIncomeDeTailWithObjId:(NSString *)objId success:(void (^)(TNNewIncomeDetailModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
