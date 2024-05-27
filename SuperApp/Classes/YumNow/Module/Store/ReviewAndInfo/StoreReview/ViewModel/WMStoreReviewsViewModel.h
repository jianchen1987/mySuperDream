//
//  WMStoreReviewsViewModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMViewModel.h"

@class WMStoreReviewsRepModel, WMStoreScoreRepModel, WMStoreProductReviewModel, WMStoreProductDetailRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreReviewsViewModel : WMViewModel

/// 商店id
@property (nonatomic, copy) NSString *storeNo;
/// 评分
@property (nonatomic, assign, readonly) double score;
/// 好评率
@property (nonatomic, assign, readonly) double rate;
/// 刷新标志
@property (nonatomic, assign) BOOL refreshFlag;
/// 详情模型
@property (nonatomic, strong, readonly) WMStoreReviewsRepModel *productDetailRspModel;
/// 数据源
@property (nonatomic, strong, readonly) NSMutableArray<WMStoreProductReviewModel *> *dataSource;
/// 是否必须有内容
@property (nonatomic, copy) WMReviewFilterConditionHasDetail hasDetailCondition;
/// 过滤类型
@property (nonatomic, copy) WMReviewFilterType filterType;

/// 成功刷新
@property (nonatomic, copy) void (^successGetNewDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource, BOOL hasNextPage);
/// 成功加载更多
@property (nonatomic, copy) void (^successLoadMoreDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource, BOOL hasNextPage);
/// 刷新失败失败
@property (nonatomic, copy) void (^failedGetNewDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource);
/// 加载更多失败
@property (nonatomic, copy) void (^failedLoadMoreDataBlock)(NSMutableArray<WMStoreProductReviewModel *> *dataSource);

/// 刷新
- (void)getNewData;

/// 加载更多
- (void)loadMoreData;

/// 查询数量信息
- (void)queryCountInfo;

/// 查询门店评分
- (void)queryStoreScore;

/// 查询商品详情
/// @param goodsId 商品id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getStoreProductDetailInfoWithGoodsId:(NSString *)goodsId success:(void (^)(WMStoreProductDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
