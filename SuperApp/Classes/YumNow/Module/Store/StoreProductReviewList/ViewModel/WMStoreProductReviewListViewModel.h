//
//  WMStoreProductReviewListViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductReviewCountRspModel.h"
#import "WMProductReviewListRspModel.h"
#import "WMViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductReviewListViewModel : WMViewModel
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 商品 id
@property (nonatomic, copy) NSString *goodsId;
/// 过滤类型
@property (nonatomic, copy) WMReviewFilterType filterType;
/// 是否必须有内容
@property (nonatomic, copy) WMReviewFilterConditionHasDetail hasDetailCondition;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;
/// 数量信息
@property (nonatomic, strong, readonly) WMProductReviewCountRspModel *countRspModel;
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
@end

NS_ASSUME_NONNULL_END
