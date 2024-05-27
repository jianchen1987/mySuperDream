//
//  TNShoppingCarDTO.h
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNQueryUserShoppingCarRspModel;
@class TNAddItemToShoppingCarRspModel;
@class TNItemModel;
@class TNShoppingCarItemModel;
@class TNCalcTotalPayFeeTrialRspModel;
@class TNShoppingCarCountModel;


@interface TNShoppingCarDTO : TNModel

- (void)queryUserShoppingTotalCountSuccess:(void (^_Nullable)(TNShoppingCarCountModel *model))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 查询用户购物车
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryUserShoppingCarBySalesType:(TNSalesType)salesType success:(void (^_Nullable)(TNQueryUserShoppingCarRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 添加商品到购物车，返回购物车商品对象
/// @param item 商品对象
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addItem:(TNItemModel *)item toShoppingCarSuccess:(void (^_Nullable)(TNAddItemToShoppingCarRspModel *item))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除购物车商品
/// @param item 购物车商品对象
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)deleteItem:(TNShoppingCarItemModel *)item fromShoppingCarSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 批量删除规格
/// @param items 规格数组
/// @param merchantDisplayNo 门店展示号
/// @param successBlock 成功回调
/// @param failureBlock 成功回调
- (void)batchDeleteStoreItems:(NSArray<TNShoppingCarItemModel *> *)items
            merchantDisplayNo:(NSString *)merchantDisplayNo
       fromShoppingCarSuccess:(void (^_Nullable)(void))successBlock
                      failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 增加购物车商品数量
/// @param item 购物车商品对象
/// @param quantify 数量
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)increaseQuantifyOfItem:(TNShoppingCarItemModel *)item
                      quantify:(NSNumber *)quantify
                     salesType:(TNSalesType)salesType
          inShoppingCarSuccess:(void (^_Nullable)(void))successBlock
                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 减少购物车商品数量
/// @param item 购物车商品对象
/// @param quantify 数量
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)decreaseQuantifyOfItem:(TNShoppingCarItemModel *)item
                      quantify:(NSNumber *)quantify
                     salesType:(TNSalesType)salesType
          inShoppingCarSuccess:(void (^_Nullable)(void))successBlock
                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 清空购物车
/// @param storeDisplayNo 门店展示号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)clearShoppingCarWithStoreDisplayNo:(NSString *)storeDisplayNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)calcShoppingCarTotalPriceWithItems:(NSArray<TNShoppingCarItemModel *> *)items
                                   success:(void (^_Nullable)(TNCalcTotalPayFeeTrialRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 批量删除规格
/// @param items 规格数组
/// @param successBlock 成功回调
/// @param failureBlock 成功回调
- (void)batchDeleteShopCartItems:(NSArray<NSDictionary *> *)items fromShoppingCarSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
