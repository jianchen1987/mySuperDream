//
//  TNShoppingCar.h
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNQueryUserShoppingCarRspModel;
@class TNAddItemToShoppingCarRspModel;
@class TNItemModel;
@class TNShoppingCarItemModel;
@class TNShoppingCar;
@class TNCalcTotalPayFeeTrialRspModel;
@class TNShoppingCarStoreModel;


@interface TNShoppingCar : TNCodingModel
/// 单买列表数据源
@property (nonatomic, strong) NSMutableArray<TNShoppingCarStoreModel *> *singleShopCardataSource;
///
@property (nonatomic, assign) BOOL singleRefreshFlag;
/// 批量列表数据源
@property (nonatomic, strong) NSMutableArray<TNShoppingCarStoreModel *> *batchShopCardataSource;
@property (nonatomic, assign) BOOL batchRefreshFlag;
/// 购物车总商品数
@property (nonatomic, assign, readonly) NSUInteger totalGoodsCount;
/// 购物车单买商品数
@property (nonatomic, assign, readonly) NSUInteger singleTotalCount;
/// 购物车批量商品数
@property (nonatomic, assign, readonly) NSUInteger batchTotalCount;
@property (nonatomic, assign) BOOL hasUpdateSingleTotalCount;
@property (nonatomic, assign) BOOL hasUpdateBatchTotalCount;

// 专题底部购物车得位置
@property (nonatomic, assign) CGPoint activityBottomCartPoint;
// 专题抖动
@property (nonatomic, assign) BOOL activityShake;


///// 再次购买 的订单 需要自动勾选的skuID数组  勾选后  要清理
@property (strong, nonatomic) NSArray *_Nullable reBuySkuIds;

+ (TNShoppingCar *)share;

- (NSArray<TNShoppingCarStoreModel *> *)findStoreCarsWithStoreNo:(NSString *_Nullable)storeNo;

/// 查询用户购物车数量
- (void)queryUserShoppingTotalCountSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 查询用户单买购物车
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)querySingleUserShoppingCarSuccess:(void (^_Nullable)(TNQueryUserShoppingCarRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询用户批量购物车
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryBatchUserShoppingCarSuccess:(void (^_Nullable)(TNQueryUserShoppingCarRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 添加商品到购物车
/// @param item 商品
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addItemToShoppingCarWithItem:(TNItemModel *)item success:(void (^_Nullable)(TNAddItemToShoppingCarRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除购物车商品
/// @param item 商品
/// @param successBlock 成功回调
/// @param failureBlock 失败
- (void)deleteItemFromShoppingCarWithItem:(TNShoppingCarItemModel *)item success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 批量删除门店购物车规格
/// @param items 商品数组
/// @param merchantDisplayNo 门店展示号
/// @param successBlock 成功回调
/// @param failureBlock 失败
- (void)batchDeleteStoreItemFromShoppingCarWithItems:(NSArray<TNShoppingCarItemModel *> *)items
                                   merchantDisplayNo:(NSString *)merchantDisplayNo
                                             success:(void (^_Nullable)(void))successBlock
                                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 批量删除门店购物车规格
/// @param items 商品数组
/// @param salesType 单买还是批量
/// @param successBlock 成功回调
/// @param failureBlock 失败
- (void)batchDeleteItemsFromShoppingCarWithItems:(NSArray<NSDictionary *> *)items
                                       salesType:(TNSalesType)salesType
                                         success:(void (^_Nullable)(void))successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 增加购物车商品数量
/// @param item 商品
/// @param quantity 数量
/// @param salesType 单买还是批量
/// @param successBlock 成功
/// @param failureBlock 失败
- (void)increaseItemQuantityWithItem:(TNShoppingCarItemModel *)item
                            quantity:(NSNumber *)quantity
                           salesType:(TNSalesType)salesType
                             success:(void (^_Nullable)(void))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 减少购物车商品数量
/// @param item 商品
/// @param quantity 数量
/// @param salesType 单买还是批量
/// @param successBlock 成功
/// @param failureBlock 失败
- (void)decreaseItemQuantityWithItem:(TNShoppingCarItemModel *)item
                            quantity:(NSNumber *)quantity
                           salesType:(TNSalesType)salesType
                             success:(void (^_Nullable)(void))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除门店购物车
/// @param storeDisplayNo 门店展示号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)clearShoppingWithStoreDisplayNo:(NSString *)storeDisplayNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 购物车商品试算
/// @param items 当前选中的商品
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)calcShoppingCarTotalPriceWithItems:(NSArray<TNShoppingCarItemModel *> *)items
                                   success:(void (^_Nullable)(TNCalcTotalPayFeeTrialRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 减少购物车商品总数
- (void)increaseShoppingCarGoodTotalCount:(NSInteger)count;
- (void)clean;

// 转换位置
- (void)convertCartPointByTargetView:(UIView *)targetView;
- (void)activityCartShake;
@end

NS_ASSUME_NONNULL_END
