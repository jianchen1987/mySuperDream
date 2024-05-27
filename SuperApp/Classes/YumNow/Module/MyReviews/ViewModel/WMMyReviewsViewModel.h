//
//  WMMyReviewsViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductReviewListRspModel.h"
#import "WMViewModel.h"

@class WMStoreProductDetailRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMMyReviewsViewModel : WMViewModel
/// 成功刷新
@property (nonatomic, copy) void (^successGetNewDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource, BOOL hasNextPage);
/// 成功加载更多
@property (nonatomic, copy) void (^successLoadMoreDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource, BOOL hasNextPage);
/// 刷新失败
@property (nonatomic, copy) void (^failedGetNewDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource);
/// 加载更多失败
@property (nonatomic, copy) void (^failedLoadMoreDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource);

/// 刷新
- (void)getNewData;

/// 加载更多
- (void)loadMoreData;

/// 查询商品详情
/// @param goodsId 商品id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getStoreProductDetailInfoWithGoodsId:(NSString *)goodsId success:(void (^)(WMStoreProductDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
