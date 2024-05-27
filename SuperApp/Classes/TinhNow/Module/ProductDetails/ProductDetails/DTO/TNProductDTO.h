//
//  TNSectionTableViewSceneDTO.h
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNProductDetailsRspModel;
@class TNDeliverInfoModel;
@class TNProductPurchaseTypeModel;
@class TNQueryGoodsRspModel;
@class TNDeliveryComponyModel;

@interface TNProductDTO : TNModel

/// 商品详情
/// @param productId 商品id
/// @param sp 供销专用码  卖家专有
/// @param detailType  卖家选品详情场景（其他待定）
/// @param sn  商品编码  没有商品id 就用商品编码查询
/// @param channel  商品来源渠道
/// @param supplierId  微店id  有微店id的都要传  用于标记商品归属哪个微店
/// @param successBlock 成功回调
/// @param failureBlock 失败
- (void)queryProductDetailsWithProductId:(NSString *)productId
                                      sp:(NSString *_Nullable)sp
                              detailType:(NSInteger)detailType
                                      sn:(NSString *)sn
                                 channel:(NSString *)channel
                              supplierId:(NSString *)supplierId
                                 success:(void (^_Nullable)(TNProductDetailsRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)addProductIntoFavoriteWithProductId:(NSString *)productId sp:(NSString *)sp success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
- (void)removeProdutFromFavoriteWithProductId:(NSString *)productId sp:(NSString *)sp success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///砍价商品详情
- (void)queryBargainProductDetailsWithActivityId:(NSString *)activityId Success:(void (^_Nullable)(TNProductDetailsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
///海外购配送信息
- (void)queryFreightDataWithStoreId:(NSString *)storeId Success:(void (^_Nullable)(TNDeliverInfoModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///获取海外购运费计费标准
- (void)queryFreightStandardCostsByStoreNo:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNDeliveryComponyModel *> *_Nonnull list))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///获取批量和单买说明
- (void)queryBuyPurchaseTypeSuccess:(void (^_Nullable)(TNProductPurchaseTypeModel *model))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// /获取商品详情新品推荐和店长推荐列表
/// @param productId 商品id
/// @param type 推荐类型 1:店长推荐,2:新品推荐
/// @param sp 有sp就是卖家微店的数据  没有就是普通店铺的数据
/// @param pageNo 页码
/// @param pageSize 页数
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryProductRecommondWithProductId:(NSString *)productId
                                      type:(NSInteger)type
                                        sp:(NSString *)sp
                                    pageNo:(NSUInteger)pageNo
                                  pageSize:(NSUInteger)pageSize
                                   success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
