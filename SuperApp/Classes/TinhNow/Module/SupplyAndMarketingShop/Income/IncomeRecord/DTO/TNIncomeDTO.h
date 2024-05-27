//
//  TNIncomeDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeRspModel.h"
#import <Foundation/Foundation.h>

@class TNIncomeModel;
@class TNIncomeDetailModel;
@class TNIncomeCommissionSumModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeDTO : NSObject
// 获取卖家账户数据
- (void)queryIncomeDataSuccess:(void (^)(TNIncomeModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 收益记录 列表
/// @param pageNum 页码
/// @param pageSize 数量
/// @param supplierType 收益类型（0：未知，1：普通收益，2：兼职收益）
/// @param showAll 全部收益
/// @param dailyInterval 查询最近 x 天的数据，可选值 7/ 30
/// @param dateRangeStart 日期区间-开始日期 日期区间间隔不能超过 90天 格式为 dd/MM/yyyy
/// @param dateRangeEnd 日期区间-结束日期 日期区间间隔不能超过 90天 格式为 dd/MM/yyyy
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryIncomeListWithPageNum:(NSUInteger)pageNum
                          pageSize:(NSUInteger)pageSize
                      supplierType:(TNSellerIdentityType)supplierType
                           showAll:(BOOL)showAll
                     dailyInterval:(NSNumber *)dailyInterval
                    dateRangeStart:(NSString *)dateRangeStart
                      dateRangeEnd:(NSString *)dateRangeEnd
                           success:(void (^)(TNIncomeRspModel *_Nonnull))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock;

/// 获取收益统计
/// @param supplierType 收益类型（0：未知，1：普通收益，2：兼职收益）
/// @param dailyInterval 查询最近 x 天的数据，可选值 7/ 30
/// @param showAll 全部收益
/// @param dateRangeStart 日期区间-开始日期 日期区间间隔不能超过 90天 格式为 dd/MM/yyyy
/// @param dateRangeEnd 日期区间-结束日期 日期区间间隔不能超过 90天 格式为 dd/MM/yyyy
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryIncomeCommisionSumWithSupplierType:(TNSellerIdentityType)supplierType
                                        showAll:(BOOL)showAll
                                  dailyInterval:(NSNumber *)dailyInterval
                                 dateRangeStart:(NSString *)dateRangeStart
                                   dateRangeEnd:(NSString *)dateRangeEnd
                                        success:(void (^)(TNIncomeCommissionSumModel *_Nonnull))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock;

// 预估收益记录 列表
- (void)queryPreIncomeListWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize success:(void (^)(TNIncomeRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
// 收益详情接口
- (void)queryIncomeDeTailWithObjId:(NSString *)objId
                 commissionLogType:(NSInteger)commissionLogType
                           success:(void (^)(TNIncomeDetailModel *_Nonnull))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
