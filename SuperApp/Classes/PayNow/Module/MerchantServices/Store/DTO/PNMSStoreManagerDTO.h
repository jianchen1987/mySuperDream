//
//  PNMSStoreManagerDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSStoreInfoModel;
@class PNMSStoreOperatorInfoModel;
@class PNMSStoreOperatorRspModel;
@class PNMSStoreAllOperatorModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreManagerDTO : PNModel
/// 获取门店列表数据
- (void)getStoreListData:(void (^)(NSArray<PNMSStoreInfoModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取门店详情
- (void)getStoreDetailWithStoreNo:(NSString *)storeNo success:(void (^)(PNMSStoreInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 新增或者编辑 门店信息
- (void)saveOrUpdateStore:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取操作员列表
- (void)getOperatorListWithStoreNo:(NSString *)storeNo success:(void (^)(PNMSStoreOperatorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取门店操作员列表 - 带page
- (void)getOperatorListWithStoreNo:(NSString *)storeNo
                       currentPage:(NSInteger)currentPage
                           success:(void (^)(PNMSStoreOperatorRspModel *rspModel))successBlock
                           failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查找门店操作员详情
- (void)getStoreOperatorDetail:(NSString *)storeOperatorId success:(void (^)(PNMSStoreOperatorInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 保存编辑门店操作员
- (void)saveOrUpdateStoreOperator:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 通过手机号码反查 账号信息
- (void)getCCAmountWithMobile:(NSString *)mobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询所有门店和操作员
- (void)getStoreAllOperator:(void (^_Nullable)(NSArray<PNMSStoreAllOperatorModel *> *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
