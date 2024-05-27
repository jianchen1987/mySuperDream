//
//  WMStoreProductDetailViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartStoreItem.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreDetailRspModel.h"
#import "WMStoreProductDetailRspModel.h"
#import "WMStoreProductReviewModel.h"
#import "WMStoreShoppingCartDTO.h"
#import "WMViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductDetailViewModel : WMViewModel
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 商品 id
@property (nonatomic, copy) NSString *goodsId;
/// 刷新标志
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 门店详情信息
@property (nonatomic, strong, readonly) WMStoreDetailRspModel *storeDetailInfoModel;
/// 详情模型
@property (nonatomic, strong, readonly) WMStoreProductDetailRspModel *productDetailRspModel;
/// 数据源
@property (nonatomic, copy, readonly) NSArray<HDTableViewSectionModel *> *dataSource;
/// 商品试算返回模型
@property (nonatomic, strong, readonly) WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel;
/// 该店在购物车中的购物项
@property (nonatomic, strong, readonly) WMShoppingCartStoreItem *shopppingCartStoreItem;
/// 门店购物车 DTO
@property (nonatomic, strong, readonly) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 更新商品购物信息回调
@property (nonatomic, copy) void (^refreshProductShoppingInfoBlock)(void);
/// 是否已获取初始化数据
@property (nonatomic, assign) BOOL hasGotInitializedData;
/// 今日可购买特价商品数量
@property (nonatomic, assign) NSUInteger availableBestSaleCount;
/// 当前起送价
@property (nonatomic, strong, readonly) SAMoneyModel *requiredPrice;
/// 起送价是否因为特殊原因不一致 有的话不为nil 提示语
@property (nonatomic, copy, nullable) NSString *requiredDiffStr;


/// 获取初始化数据
- (void)getInitializedData;

/// 重拿购物车数据
- (void)reGetShoppingCartItems;

/// 重拿购物车数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)reGetShoppingCartItemsSuccess:(void (^_Nullable)(WMShoppingCartStoreItem *storeItem))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 添加商品进购物车
/// @param addDelta 数量
/// @param goodsId 商品 id
/// @param goodsSkuId 规格 id
/// @param propertyIds 属性 id
/// @param inEffectVersionId 商品快照 id
- (void)addShoppingGoodsWithAddDelta:(NSUInteger)addDelta
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId;

/// 更新购物车存量商品数量
/// @param count 数量
/// @param goodsId id
/// @param goodsSkuId skuid
/// @param propertyIds 属性值
/// @param inEffectVersionId 快照ID
- (void)updateShoppingGoodsWithCount:(NSUInteger)count
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId;
@end

NS_ASSUME_NONNULL_END
