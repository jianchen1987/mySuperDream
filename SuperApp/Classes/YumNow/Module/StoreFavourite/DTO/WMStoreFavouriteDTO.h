//
//  WMStoreFavouriteDTO.h
//  SuperApp
//
//  Created by Chaos on 2020/12/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMSearchStoreRspModel;


@interface WMStoreFavouriteDTO : WMModel

/// 收藏门店
/// @param storeNo 门店编号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)addFavouriteWithStoreNo:(NSString *)storeNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消收藏门店
/// @param storeNos 门店编号数组
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)removeFavouriteWithStoreNos:(NSArray<NSString *> *)storeNos success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询用户收藏的门店
/// @param pageNum 页码
/// @param pageSize 每页数量
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getFavouriteStoreListWithPageNum:(NSInteger)pageNum
                                              pageSize:(NSInteger)pageSize
                                               success:(void (^)(WMSearchStoreRspModel *rspModel))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
