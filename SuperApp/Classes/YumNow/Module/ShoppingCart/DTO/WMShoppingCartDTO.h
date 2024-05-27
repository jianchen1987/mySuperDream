//
//  WMShoppingCartDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMGetUserShoppingCartRspModel;
@class WMShoppingCartAddGoodsRspModel;
@class WMShoppingCartMinusGoodsRspModel;
@class WMShoppingCartRemoveGoodsRspModel;
@class WMShoppingCartRemoveStoreGoodsRspModel;
@class WMShoppingItemsPayFeeTrialCalRspModel;
@class WMShoppingCartPayFeeCalItem;
@class WMShoppingCartOrderCheckItem;
@class WMShoppingCartStoreItem;
@class WMShoppingCartUpdateGoodsRspModel;
@class WMShoppingCartBatchDeleteItem;
@class WMCouponActivityContentModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartDTO : WMModel

/// 查询用户购物车接口
/// @param businessType 业务线
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getUserShoppingCartInfoWithClientType:(SABusinessType)businessType
                                      success:(void (^_Nullable)(WMGetUserShoppingCartRspModel *rspModel))successBlock
                                      failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)updateGoodsCountInShoppingCartWithClientType:(SABusinessType)businessType
                                               count:(NSUInteger)goodsCount
                                             goodsId:(NSString *)goodsId
                                          goodsSkuId:(NSString *)goodsSkuId
                                         propertyIds:(NSArray<NSString *> *)propertyIds
                                             storeNo:(NSString *)storeNo
                                   inEffectVersionId:(NSString *)inEffectVersionId
                                             success:(void (^)(WMShoppingCartUpdateGoodsRspModel *_Nonnull))successBlock
                                             failure:(CMNetworkFailureBlock)failureBlock;

/// 添加商品接口
/// @param businessType 业务线
/// @param addDelta 商品sku 增加的数量增量（例如往购物车新增3件，这里填3）
/// @param userDisplayNo 用户购物车展示号
/// @param merchantDisplayNo 门店购物车展示号
/// @param itemDisplayNo 购物项展示号
/// @param goodsId 商品id
/// @param goodsSkuId 商品sku id(目前外卖可以理解为规格id)
/// @param propertyIds 属性项id集合
/// @param storeNo 门店号
/// @param inEffectVersionId 快照id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addGoodsToShoppingCartWithClientType:(SABusinessType)businessType
                                    addDelta:(NSUInteger)addDelta
                               userDisplayNo:(NSString *)userDisplayNo
                           merchantDisplayNo:(NSString *)merchantDisplayNo
                               itemDisplayNo:(NSString *)itemDisplayNo
                                     goodsId:(NSString *_Nullable)goodsId
                                  goodsSkuId:(NSString *_Nullable)goodsSkuId
                                 propertyIds:(NSArray<NSString *> *_Nullable)propertyIds
                                     storeNo:(NSString *_Nullable)storeNo
                           inEffectVersionId:(NSString *)inEffectVersionId
                                     success:(void (^)(WMShoppingCartAddGoodsRspModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 减少购物项数量接口
/// @param businessType 业务线
/// @param deleteDelta 购物车数量减少值
/// @param itemDisplayNo 购物项展示id
/// @param goodsSkuId 商品sku id
/// @param propertyValues 属性项集合
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)minusGoodsFromShopppingCartWithClientType:(SABusinessType)businessType
                                      deleteDelta:(NSUInteger)deleteDelta
                                    itemDisplayNo:(NSString *)itemDisplayNo
                                       goodsSkuId:(NSString *_Nullable)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *_Nullable)propertyValues
                                          storeNo:(NSString *_Nullable)storeNo
                                          success:(void (^)(WMShoppingCartMinusGoodsRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除购物项接口
/// @param businessType 业务线
/// @param merchantDisplayNo 门店购物车展示号
/// @param itemDisplayNo 购物项展示号
/// @param storeNo 门店号
/// @param goodsSkuId 商品sku id
/// @param propertyValues 属性项集合
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)removeGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                merchantDisplayNo:(NSString *)merchantDisplayNo
                                    itemDisplayNo:(NSString *)itemDisplayNo
                                          storeNo:(NSString *)storeNo
                                       goodsSkuId:(NSString *)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *)propertyValues
                                          success:(void (^)(WMShoppingCartRemoveGoodsRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除门店购物车接口
/// @param businessType 业务线
/// @param merchantDisplayNo 门店购物车展示号
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)removeStoreGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                     merchantDisplayNo:(NSString *)merchantDisplayNo
                                               storeNo:(NSString *)storeNo
                                               success:(void (^)(WMShoppingCartRemoveStoreGoodsRspModel *rspModel))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 订单试算
/// @param items 所有 item 模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderPayFeeTrialCalculateWithItems:(NSArray<WMShoppingCartPayFeeCalItem *> *)items
                                   success:(void (^)(WMShoppingItemsPayFeeTrialCalRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 进入订单提交页前检查(下单检查)
/// @param storeNo 门店号
/// @param items 需要检查
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderCheckBeforeGoToOrderSubmitWithStoreNo:(NSString *)storeNo
                                             items:(NSArray<WMShoppingCartOrderCheckItem *> *)items
                                       activityNos:(NSArray<NSString *> *)activityNos
                                           success:(void (^)(SARspModel *rspModel))successBlock
                                           failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 批量删除购物项接口
/// @param deleteItems 删除商品的购物号数组
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)batchDeleteGoodsFromShoppingCartWithDeleteItems:(NSArray<WMShoppingCartBatchDeleteItem *> *)deleteItems
                                                success:(void (^)(void))successBlock
                                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取用户相关活动门店券-购物车
/// @param storeNos 门店id数组
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getActivityCouponShoppingCartWithStoreNos:(NSArray<NSString *> *)storeNos
                                          success:(void (^)(NSArray<WMCouponActivityContentModel *> *))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 检查商品状态
/// @param storeNo 门店号
/// @param productIds 需要检查
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)checkProductStatusWithStoreNo:(NSString *)storeNo
                           productIds:(NSArray<NSString *> *)productIds
                              success:(void (^)(NSDictionary *))successBlock
                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
