//
//  TNFavoritesDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNGoodFavoritesRspModel;
@class TNStoreFavoritesRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNFavoritesDTO : TNModel

/// 请求商品收藏数据
- (void)queryGoodFavoritesListWithPageNum:(NSUInteger)pageNum
                                 pageSize:(NSUInteger)pageSize
                                  success:(void (^_Nullable)(TNGoodFavoritesRspModel *rspModel))successBlock
                                  failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 请求店铺收藏数据
- (void)queryStoreFavoritesListWithPageNum:(NSUInteger)pageNum
                                  pageSize:(NSUInteger)pageSize
                                   success:(void (^_Nullable)(TNStoreFavoritesRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 删除商品收藏
- (void)removeGoodFavoriteByID:(NSString *)favoriteId supplierId:(NSString *)supplierId success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 删除店铺收藏
/// @param favoriteId 收藏id
/// @param storeType 店铺类型,0:普通店铺,1:微店
/// @param supplierId 微店id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)removeStoreFavoriteByID:(NSString *)favoriteId
                      storeType:(NSInteger)storeType
                     supplierId:(NSString *)supplierId
                        success:(void (^_Nullable)(void))successBlock
                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
