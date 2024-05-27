//
//  WMStoreShoppingCartDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMShoppingCartDTO.h"

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

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreShoppingCartDTO : WMModel
/// 购物车 DTO
@property (nonatomic, strong) WMShoppingCartDTO *shoppingCartDTO;

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
/// @param goodsId 商品id
/// @param goodsSkuId 商品sku id(目前外卖可以理解为规格id)
/// @param propertyIds 属性项id集合
/// @param storeNo 门店号
/// @param inEffectVersionId 商品快照 id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addGoodsToShoppingCartWithClientType:(SABusinessType)businessType
                                    addDelta:(NSUInteger)addDelta
                                     goodsId:(NSString *)goodsId
                                  goodsSkuId:(NSString *)goodsSkuId
                                 propertyIds:(NSArray<NSString *> *)propertyIds
                                     storeNo:(NSString *)storeNo
                           inEffectVersionId:(NSString *_Nullable)inEffectVersionId
                                     success:(void (^)(WMShoppingCartAddGoodsRspModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 减少购物项数量接口
/// @param businessType 业务线
/// @param deleteDelta 购物车数量减少值
/// @param goodsSkuId 商品sku id
/// @param propertyValues 属性项集合
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)minusGoodsFromShopppingCartWithClientType:(SABusinessType)businessType
                                      deleteDelta:(NSUInteger)deleteDelta
                                       goodsSkuId:(NSString *)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *)propertyValues
                                          storeNo:(NSString *)storeNo
                                          success:(void (^)(WMShoppingCartMinusGoodsRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除购物项接口
/// @param businessType 业务线
/// @param storeNo 门店号
/// @param goodsSkuId 商品sku id
/// @param propertyValues 属性项集合
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)removeGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                          storeNo:(NSString *)storeNo
                                       goodsSkuId:(NSString *)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *)propertyValues
                                          success:(void (^)(WMShoppingCartRemoveGoodsRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除门店购物车接口
/// @param businessType 业务线
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)removeStoreGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
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

/// 查询门店购物车
/// @param businessType 业务线
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryStoreShoppingCartWithClientType:(SABusinessType)businessType
                                     storeNo:(NSString *)storeNo
                                     success:(void (^)(WMShoppingCartStoreItem *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 从本地离线购物车删除购物项
/// @param businessType 业务线
/// @param deleteDelta 购物车数量减少值
/// @param goodsSkuId 商品sku id
/// @param propertyValues 属性项集合
/// @param storeNo 门店号
- (void)minusGoodsFromLocalShopppingCartWithClientType:(SABusinessType)businessType
                                           deleteDelta:(NSUInteger)deleteDelta
                                            goodsSkuId:(NSString *)goodsSkuId
                                        propertyValues:(NSArray<NSString *> *)propertyValues
                                               storeNo:(NSString *)storeNo;
@end

NS_ASSUME_NONNULL_END
