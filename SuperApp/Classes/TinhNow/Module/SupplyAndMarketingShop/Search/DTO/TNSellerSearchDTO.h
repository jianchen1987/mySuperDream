//
//  TNSellerSearchDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNSearchSortFilterModel.h"
@class TNSellerProductRspModel;
@class TNSellerStoreRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNSellerSearchDTO : TNModel

/// 搜索选品中心商品数据
/// @param pageNo 页码
/// @param pageSize 数量
/// @param filterModel 筛选模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryProductCenterProductsWithPageNo:(NSUInteger)pageNo
                                    pageSize:(NSUInteger)pageSize
                                 filterModel:(TNSearchSortFilterModel *)filterModel
                                     success:(void (^_Nullable)(TNSellerProductRspModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 搜索选品店铺列表
/// @param pageNo 页码
/// @param pageSize 数量
/// @param keyword 关键字
/// @param successBlock 成功回调
/// @param failureBlock  失败回调
- (void)queryProductCenterStoresWithPageNo:(NSUInteger)pageNo
                                  pageSize:(NSUInteger)pageSize
                                   keyWord:(NSString *)keyword
                                   success:(void (^_Nullable)(TNSellerStoreRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 搜索微店店铺商品数据
/// @param pageNo 页码
/// @param pageSize 数量
/// @param filterModel 筛选模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryMicroShopProductsWithPageNo:(NSUInteger)pageNo
                                pageSize:(NSUInteger)pageSize
                             filterModel:(TNSearchSortFilterModel *)filterModel
                                 success:(void (^_Nullable)(TNSellerProductRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
