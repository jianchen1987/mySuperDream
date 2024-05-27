//
//  SAHomeDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

@class TNQueryGoodsRspModel;
@class TNScrollContentRspModel;
@class TNActivityCardRspModel;
@class TNHomeCategoryModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNHomeDTO : TNModel

/// 查询精选数据
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryChoicenessInfoWithPageSize:(NSUInteger)pageSize
                                pageNum:(NSUInteger)pageNum
                                success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询为你推荐数据
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryRecommendListWithPageSize:(NSUInteger)pageSize
                               pageNum:(NSUInteger)pageNum
                               success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询首页文案数据源
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryHomeScrollTextSuccess:(void (^_Nullable)(TNScrollContentRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询活动卡片数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryHomeActivityCardSuccess:(void (^_Nullable)(TNActivityCardRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询分类数据
/// @param scene 场景ALL": 适全部1级分类 "BARGAIN_LIST": 砍价活动列表页 "GROUPON_LIST": 拼团活动列表页 "GOODS_SPECIAL": 商品专题页
/// @param successBlock 成功回调 返回分类数组
/// @param failureBlock 失败回调
- (void)queryProductCategoryWithScene:(TNProductCategoryScene)scene Success:(void (^_Nullable)(NSArray<TNHomeCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询分类数据 带专题id
/// @param scene 场景ALL": 适全部1级分类 "BARGAIN_LIST": 砍价活动列表页 "GROUPON_LIST": 拼团活动列表页 "GOODS_SPECIAL": 商品专题页
/// @param sourceId scene 传 "GOODS_SPECIAL" 时 id 字段代表专题id  没有可不传
/// @param successBlock 成功回调 返回分类数组
/// @param failureBlock 失败回调
- (void)queryProductCategoryWithScene:(TNProductCategoryScene)scene
                             sourceId:(NSString *)sourceId
                              Success:(void (^_Nullable)(NSArray<TNHomeCategoryModel *> *list))successBlock
                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
