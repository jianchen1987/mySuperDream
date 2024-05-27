//
//  WMStoreReviewsViewModel.m
//  SuperApp
//
//  Created by Chaos on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreReviewsViewModel.h"
#import "WMProductReviewListRspModel.h"
#import "WMReviewsDTO.h"
#import "WMStoreProductDetailDTO.h"
#import "WMStoreReviewCountRspModel.h"
#import "WMStoreScoreRepModel.h"


@interface WMStoreReviewsViewModel ()

/// 数据源
@property (nonatomic, strong) NSMutableArray<WMStoreProductReviewModel *> *dataSource;
/// 数据模型
@property (nonatomic, strong) HDTableViewSectionModel *sectionModel;
/// 评分
@property (nonatomic, strong) WMStoreScoreRepModel *scoreModel;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 是否正在加载
@property (nonatomic, assign) BOOL isLoading;
/// 数量信息
@property (nonatomic, strong) WMStoreReviewCountRspModel *countRspModel;
/// DTO
@property (nonatomic, strong) WMReviewsDTO *reviewDTO;
/// 商品详情 DTO
@property (nonatomic, strong) WMStoreProductDetailDTO *productDetailDTO;

@end


@implementation WMStoreReviewsViewModel

- (instancetype)init {
    if (self = [super init]) {
        _hasDetailCondition = WMReviewFilterConditionHasDetailRequired;
    }
    return self;
}

- (void)getNewData {
    self.currentPageNo = 1;
    [self getStoreReviewsWithPage:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo++;
    [self getStoreReviewsWithPage:self.currentPageNo];
}

- (void)getStoreReviewsWithPage:(NSInteger)page {
    if (page == 1) {
        self.isLoading = YES;
    }

    @HDWeakify(self);
    [self.reviewDTO queryStoreProductReviewListWithStoreNo:self.storeNo type:self.filterType hasDetailCondition:self.hasDetailCondition pageSize:8 pageNum:page
        success:^(WMProductReviewListRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.isLoading = false;
            // 修正 number
            self.currentPageNo = rspModel.pageNum;
            NSArray<WMStoreProductReviewModel *> *list = rspModel.list;
            if (page == 1) {
                [self.dataSource removeAllObjects];
                if (list.count) {
                    [self.dataSource addObjectsFromArray:list];
                }
                !self.successGetNewDataBlock ?: self.successGetNewDataBlock(self.dataSource, rspModel.hasNextPage);
            } else {
                if (list.count) {
                    [self.dataSource addObjectsFromArray:list];
                }
                !self.successLoadMoreDataBlock ?: self.successLoadMoreDataBlock(self.dataSource, rspModel.hasNextPage);
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.isLoading = false;
            page == 1 ? (!self.failedGetNewDataBlock ?: self.failedGetNewDataBlock(self.dataSource)) : (!self.failedLoadMoreDataBlock ?: self.failedLoadMoreDataBlock(self.dataSource));
        }];
}

- (void)queryCountInfo {
    @HDWeakify(self);
    [self.reviewDTO queryStoreReviewCountInfoWithStoreNo:self.storeNo success:^(WMStoreReviewCountRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.countRspModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:nil];
}

- (void)queryStoreScore {
    @HDWeakify(self);
    [self.reviewDTO getStoreReviewsScoreWithStoreNo:self.storeNo success:^(WMStoreScoreRepModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.scoreModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:nil];
}

- (void)getStoreProductDetailInfoWithGoodsId:(NSString *)goodsId success:(void (^)(WMStoreProductDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.productDetailDTO getStoreProductDetailInfoWithGoodsId:goodsId success:^(WMStoreProductDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self.isBusinessDataError) {
            self.isBusinessDataError = false;
        }
        !successBlock ?: successBlock(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (errorType == CMResponseErrorTypeBusinessDataError) {
            self.isBusinessDataError = true;
        } else {
            self.isNetworkError = true;
        }
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

#pragma mark - getter
- (double)score {
    return self.scoreModel.score;
}

- (double)rate {
    return self.scoreModel.rate * 100;
}

#pragma mark - lazy load

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (WMReviewsDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = [[WMReviewsDTO alloc] init];
    }
    return _reviewDTO;
}

- (WMStoreProductDetailDTO *)productDetailDTO {
    if (!_productDetailDTO) {
        _productDetailDTO = WMStoreProductDetailDTO.new;
    }
    return _productDetailDTO;
}

@end
