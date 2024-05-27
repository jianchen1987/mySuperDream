//
//  TNMicroShopDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNFirstLevelCategoryModel;
@class TNSeller;
@class TNMicroShopPricePolicyModel;
@class TNMicroShopDetailInfoModel;
@class TNProductSkuModel;
@class TNSellerProductModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopDTO : TNModel
/*
 * 请求微店一级分类数据
 */
- (void)queryMicroShopCategoryWithSupplierId:(NSString *)supplierId
                                     success:(void (^_Nullable)(NSArray<TNFirstLevelCategoryModel *> *list))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 获取自己微店信息
 */
- (void)queryMyMicroShopInfoDataSuccess:(void (^_Nullable)(TNSeller *info))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 获取加价策略
 */
- (void)querySellPricePolicyWithSupplierId:(NSString *)supplierId
                                   success:(void (^_Nullable)(TNMicroShopPricePolicyModel *policyModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 设置加价策略
 */
- (void)setSellPricePolicyWithSupplierId:(NSString *)supplierId
                             policyModel:(TNMicroShopPricePolicyModel *)policyModel
                                 success:(void (^_Nullable)(TNMicroShopPricePolicyModel *policyModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 加入微店销售
 */
- (void)addProductToSaleWithSupplierId:(NSString *)supplierId
                             productId:(NSString *)productId
                            categoryId:(NSString *)categoryId
                           policyModel:(TNMicroShopPricePolicyModel *)policyModel
                               success:(void (^_Nullable)(NSArray<TNSellerProductModel *> *))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 取消微店销售
 */
- (void)cancelProductSaleWithSupplierId:(NSString *)supplierId productId:(NSString *)productId success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/*
 * 批量取消微店销售
 */
- (void)cancelProductSaleWithParamsArr:(NSArray<NSDictionary *> *)paramsArr success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 通过卖家获取微店信息
 */
- (void)queryMicroShopInfoDataBySupplierId:(NSString *)supplierId success:(void (^_Nullable)(TNMicroShopDetailInfoModel *info))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 通过卖家id 和 商品id 查询微店销售商品的SKU
 */
- (void)queryProductSkuDataBySupplierId:(NSString *_Nullable)supplierId
                              productId:(NSString *)productId
                                success:(void (^_Nullable)(NSArray<TNProductSkuModel *> *))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 修改商品价格  type  0 单个商品手填价格改价  1.单个商品手填和批量sku改价   2.批量商品改价
 */
- (void)changeProductPriceByDictArray:(NSArray<NSDictionary *> *)dictArray type:(NSInteger)type success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/*
 * 微店设置商品热卖
 */
- (void)setProductHotSalesBySupplierId:(NSString *_Nullable)supplierId
                             productId:(NSString *)productId
                        enabledHotSale:(BOOL)enabledHotSale
                               success:(void (^_Nullable)(void))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
