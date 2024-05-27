//
//  WMReviewsDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMProductReviewListRspModel;
@class WMStoreReviewCountRspModel;
@class WMProductReviewCountRspModel;
@class WMStoreScoreRepModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMReviewsDTO : WMModel

/// 获取我的评论
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryMyReviewListWithPageSize:(NSUInteger)pageSize
                                            pageNum:(NSUInteger)pageNum
                                            success:(void (^_Nullable)(WMProductReviewListRspModel *rspModel))successBlock
                                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取门店评论列表
/// @param storeNo 门店号
/// @param type 类型
/// @param hasDetailCondition 对内容要求条件
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryStoreProductReviewListWithStoreNo:(NSString *)storeNo
                                                        type:(WMReviewFilterType)type
                                          hasDetailCondition:(WMReviewFilterConditionHasDetail)hasDetailCondition
                                                    pageSize:(NSUInteger)pageSize
                                                     pageNum:(NSUInteger)pageNum
                                                     success:(void (^_Nullable)(WMProductReviewListRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取商品评论列表
/// @param goodsId 商品 id
/// @param type 类型
/// @param hasDetailCondition 对内容要求条件
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryStoreProductReviewListWithGoodsId:(NSString *)goodsId
                                                        type:(WMReviewFilterType)type
                                          hasDetailCondition:(WMReviewFilterConditionHasDetail)hasDetailCondition
                                                    pageSize:(NSUInteger)pageSize
                                                     pageNum:(NSUInteger)pageNum
                                                     success:(void (^_Nullable)(WMProductReviewListRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 根据门店编号查询不同类型的评论数量信息
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryStoreReviewCountInfoWithStoreNo:(NSString *)storeNo
                                                   success:(void (^_Nullable)(WMStoreReviewCountRspModel *rspModel))successBlock
                                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 根据商品 id 查询不同类型评论数量信息
/// @param goodsId 商品 id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryStoreProductReviewCountInfoWithGoodsId:(NSString *)goodsId
                                                          success:(void (^_Nullable)(WMProductReviewCountRspModel *rspModel))successBlock
                                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 提交订单评论
/// @param orderNo 订单号
/// @param riderScore 骑手评分
/// @param storeScore 门店评分
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)orderEvaluationWithOrderNo:(NSString *)orderNo
                                         storeNo:(NSString *)storeNo
                                      riderScore:(double)riderScore
                                      storeScore:(double)storeScore
                                 deliveryContent:(NSString*)deliveryContent
                                         content:(NSString *)content
                                       anonymous:(WMReviewAnonymousState)anonymous
                                          images:(NSArray *)images
                                    businessline:(NSString *)businessline
                           itemReviewInfoReqDTOS:(NSArray *)itemReviewInfoReqDTOS
                                         success:(void (^)(void))successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取门店评分
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getStoreReviewsScoreWithStoreNo:(NSString *)storeNo success:(void (^)(WMStoreScoreRepModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
