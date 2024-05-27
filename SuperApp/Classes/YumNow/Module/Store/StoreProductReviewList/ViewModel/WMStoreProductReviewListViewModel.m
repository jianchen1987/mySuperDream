//
//  WMStoreProductReviewListViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductReviewListViewModel.h"
#import "WMReviewsDTO.h"


@interface WMStoreProductReviewListViewModel ()
/// 数据源
@property (nonatomic, strong) NSMutableArray<WMStoreProductReviewModel *> *dataSource;
/// 评论 DTO
@property (nonatomic, strong) WMReviewsDTO *reviewDTO;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 是否正在加载
@property (nonatomic, assign) BOOL isLoading;
/// 数量信息
@property (nonatomic, strong) WMProductReviewCountRspModel *countRspModel;

@end


@implementation WMStoreProductReviewListViewModel

- (instancetype)init {
    if (self = [super init]) {
        _hasDetailCondition = WMReviewFilterConditionHasDetailRequired;
    }
    return self;
}

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
    if (pageNo == 1) {
        self.isLoading = true;
    }
    [self.reviewDTO queryStoreProductReviewListWithGoodsId:self.goodsId type:self.filterType hasDetailCondition:self.hasDetailCondition pageSize:10 pageNum:pageNo
        success:^(WMProductReviewListRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.isLoading = false;
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
            self.isLoading = false;
            pageNo == 1 ? (!self.failedGetNewDataBlock ?: self.failedGetNewDataBlock(self.dataSource)) : (!self.failedLoadMoreDataBlock ?: self.failedLoadMoreDataBlock(self.dataSource));
        }];
}

- (void)queryCountInfo {
    @HDWeakify(self);
    [self.reviewDTO queryStoreProductReviewCountInfoWithGoodsId:self.goodsId success:^(WMProductReviewCountRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.countRspModel = rspModel;
    } failure:nil];
}

#pragma mark - lazy load
- (WMReviewsDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = WMReviewsDTO.new;
    }
    return _reviewDTO;
}

- (NSMutableArray<WMStoreProductReviewModel *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.array; });
}
@end
