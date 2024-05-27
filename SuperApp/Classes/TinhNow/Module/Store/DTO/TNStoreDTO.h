//
//  TNStoreDTO.h
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNStoreInfoRspModel;
@class TNFavoritedStoreRspModel;
@class TNCategoryModel;
@class TNStoreSceneRspModel;
@class TNFirstLevelCategoryModel;


@interface TNStoreDTO : TNModel

/// 获取门店信息
/// @param storeNo 门店号
/// @param operatorNo 操作员No
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryStoreInfoWithStoreNo:(NSString *)storeNo
                       operatorNo:(NSString *)operatorNo
                          success:(void (^_Nullable)(TNStoreInfoRspModel *rspModel))successBlock
                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 添加收藏 区分普通店铺收藏和微店收藏
/// @param storeNo 门店号
/// @param storeType 店铺类型,0:普通店铺,1:微店
/// @param supplierId 微店id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addStoreFavoritesWithStoreNo:(NSString *)storeNo
                           storeType:(NSInteger)storeType
                          supplierId:(NSString *)supplierId
                             success:(void (^_Nullable)(void))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消收藏
/// @param storeNo 门店号
/// @param storeType 店铺类型,0:普通店铺,1:微店
/// @param supplierId 微店id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)cancelStoreFavoriteWithStoreNo:(NSString *)storeNo
                             storeType:(NSInteger)storeType
                            supplierId:(NSString *)supplierId
                               success:(void (^_Nullable)(void))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///  获取门店主页推荐分类数据
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryStoreRecommendCategoryWithStoreNo:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///  获取门店实景数据
/// @param storeNo 门店号
/// @param pageNum 页码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryStoreRealSceneWithStoreNo:(NSString *)storeNo
                               pageNum:(NSInteger)pageNum
                               success:(void (^_Nullable)(TNStoreSceneRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///  获取门店所有分类数据
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryStoreAllCategoryWithStoreNo:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNFirstLevelCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
