//
//  TNGoodsDTO.h
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNSearchSortFilterModel;
@class TNQueryGoodsRspModel;
@class TNGoodsModel;
@class TNGoodInfoModel;


@interface TNGoodsDTO : TNModel

/// 查询商品列表
/// @param pageNo 页码
/// @param pageSize 分页大小
/// @param filterModel 筛选模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryGoodsListWithPageNo:(NSUInteger)pageNo
                        pageSize:(NSUInteger)pageSize
                     filterModel:(TNSearchSortFilterModel *)filterModel
                         success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取推荐商品列表
/// @param pageNo 页码
/// @param pageSize 分页大小
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryRecommendGoodsListWithPageNo:(NSUInteger)pageNo
                                 pageSize:(NSUInteger)pageSize
                                  success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                  failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取分类热销商品列表
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryHotGoodsListWithCategoryId:(NSString *)categoryId success:(void (^_Nullable)(NSArray<TNGoodsModel *> *goods))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询专题商品列表
/// @param pageNo 页码
/// @param pageSize 分页大小
/// @param hotType 是否热卖  热卖为1  推荐为2  分类的列表为0  即 热卖和普通列表都会展示
/// @param filterModel 筛选模型 必须要有specialId
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)querySpecailActivityListWithPageNo:(NSUInteger)pageNo
                                  pageSize:(NSUInteger)pageSize
                                   hotType:(NSInteger)hotType
                               filterModel:(TNSearchSortFilterModel *)filterModel
                                   success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 查询专题热销商品列表
/// @param filterModel 筛选模型 必须要有specialId
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)querySpecailHotActivityListWithFilterModel:(TNSearchSortFilterModel *)filterModel
                                           success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                           failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取商品sku数据
/// @param productId 商品id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryGoodSkuDataWithProductId:(NSString *)productId success:(void (^_Nullable)(TNGoodInfoModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 搜索排行
- (void)searchRank:(void (^)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 搜索发现
- (void)searchFind:(void (^)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
