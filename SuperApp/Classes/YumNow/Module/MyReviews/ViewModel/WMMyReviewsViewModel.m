//
//  WMMyReviewsViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMyReviewsViewModel.h"
#import "WMReviewsDTO.h"
#import "WMStoreProductDetailDTO.h"
#import "WMStoreReviewCountRspModel.h"


@interface WMMyReviewsViewModel ()
/// 数据源
@property (nonatomic, strong) NSMutableArray<WMStoreProductReviewModel *> *dataSource;
/// 评论 DTO
@property (nonatomic, strong) WMReviewsDTO *reviewDTO;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 商品详情 DTO
@property (nonatomic, strong) WMStoreProductDetailDTO *productDetailDTO;

@end


@implementation WMMyReviewsViewModel
- (void)getNewData {
    self.currentPageNo = 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)getDataForPageNo:(NSInteger)pageNo {
    @HDWeakify(self);
    [self.reviewDTO queryMyReviewListWithPageSize:10 pageNum:pageNo success:^(WMProductReviewListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        // 修正 number
        self.currentPageNo = rspModel.pageNum;
        NSArray<WMStoreProductReviewModel *> *list = rspModel.list;
        if (pageNo == 1) {
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
        pageNo == 1 ? (!self.failedGetNewDataBlock ?: self.failedGetNewDataBlock(self.dataSource)) : (!self.failedLoadMoreDataBlock ?: self.failedLoadMoreDataBlock(self.dataSource));
    }];
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

#pragma mark - lazy load
- (WMReviewsDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = WMReviewsDTO.new;
    }
    return _reviewDTO;
}

- (WMStoreProductDetailDTO *)productDetailDTO {
    if (!_productDetailDTO) {
        _productDetailDTO = WMStoreProductDetailDTO.new;
    }
    return _productDetailDTO;
}

- (NSMutableArray<WMStoreProductReviewModel *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.array; });
}
@end
