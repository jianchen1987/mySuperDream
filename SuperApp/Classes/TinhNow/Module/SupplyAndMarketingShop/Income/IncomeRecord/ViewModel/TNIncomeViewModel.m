//
//  TNIncomeViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeViewModel.h"
#import "SAWindowManager.h"
#import "TNIncomeDTO.h"


@interface TNIncomeViewModel ()
@property (strong, nonatomic) TNIncomeDTO *incomeDTO; ///<

@end


@implementation TNIncomeViewModel

#pragma mark -收益数据
- (void)getIncomeData {
    @HDWeakify(self);
    [self.incomeDTO queryIncomeDataSuccess:^(TNIncomeModel *model) {
        @HDStrongify(self);
        self.incomeModel = model;
        self.incomeRefreshFlag = !self.incomeRefreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.incomeGetDataFaild ?: self.incomeGetDataFaild();
    }];
}
- (void)getCommissionSum {
    @HDWeakify(self);
    [self.incomeDTO queryIncomeCommisionSumWithSupplierType:self.filterModel.supplierType showAll:self.filterModel.showAll dailyInterval:self.filterModel.dailyInterval
                                             dateRangeStart:self.filterModel.dateRangeStart
                                               dateRangeEnd:self.filterModel.dateRangeEnd success:^(TNIncomeCommissionSumModel *model) {
                                                   @HDStrongify(self);
                                                   self.commissionSumModel = model;
                                                   self.commitionSumRefreshFlag = !self.commitionSumRefreshFlag;
                                               } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

                                               }];
}
#pragma mark -收益列表
- (void)recordGetNewData {
    [self recordGetNewDataWithLoading:NO];
}
- (void)recordGetNewDataWithLoading:(BOOL)isNeedLoading {
    if (isNeedLoading) {
        [self.view showloading];
    }
    self.recordCurrentPage = 1;
    [self queryRecordListDataWithLoadMoreData:NO];
}
- (void)recordLoadMoreData {
    self.recordCurrentPage += 1;
    [self queryRecordListDataWithLoadMoreData:YES];
}

- (void)queryRecordListDataWithLoadMoreData:(BOOL)isLoadMoreData {
    @HDWeakify(self);
    [self.incomeDTO queryIncomeListWithPageNum:self.recordCurrentPage pageSize:20 supplierType:self.filterModel.supplierType showAll:self.filterModel.showAll
        dailyInterval:self.filterModel.dailyInterval
        dateRangeStart:self.filterModel.dateRangeStart
        dateRangeEnd:self.filterModel.dateRangeEnd success:^(TNIncomeRspModel *rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            if (self.recordCurrentPage == 1) {
                [self.recordList removeAllObjects];
                [self.recordList addObjectsFromArray:rspModel.list];
            } else {
                [self.recordList addObjectsFromArray:rspModel.list];
            }
            self.recordHasNextPage = rspModel.hasNextPage;
            self.recordRefreshFlag = !self.recordRefreshFlag;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            if (self.recordCurrentPage == 1) {
                !self.recordListGetNewDataFaild ?: self.recordListGetNewDataFaild();
            } else {
                !self.recordListLoadMoreDataFaild ?: self.recordListLoadMoreDataFaild();
            }
        }];
}

#pragma mark -预估收益列表
- (void)preRecordGetNewData {
    self.preRecordCurrentPage = 1;
    [self queryPreRecordListDataWithLoadMoreData:NO];
}

- (void)preRecordLoadMoreData {
    self.preRecordCurrentPage += 1;
    [self queryPreRecordListDataWithLoadMoreData:YES];
}

- (void)queryPreRecordListDataWithLoadMoreData:(BOOL)isLoadMoreData {
    @HDWeakify(self);
    [self.incomeDTO queryPreIncomeListWithPageNum:self.preRecordCurrentPage pageSize:20 success:^(TNIncomeRspModel *rspModel) {
        @HDStrongify(self);
        if (self.preRecordCurrentPage == 1) {
            [self.preRecordList removeAllObjects];
            [self.preRecordList addObjectsFromArray:rspModel.list];
        } else {
            [self.preRecordList addObjectsFromArray:rspModel.list];
        }
        self.preRecordHasNextPage = rspModel.hasNextPage;
        self.preRecordRefreshFlag = !self.recordRefreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self.preRecordCurrentPage == 1) {
            !self.preRecordListGetNewDataFaild ?: self.preRecordListGetNewDataFaild();
        } else {
            !self.preRecordListLoadMoreDataFaild ?: self.preRecordListLoadMoreDataFaild();
        }
    }];
}

/** @lazy incomeDTO */
- (TNIncomeDTO *)incomeDTO {
    if (!_incomeDTO) {
        _incomeDTO = [[TNIncomeDTO alloc] init];
    }
    return _incomeDTO;
}
/** @lazy recordList */
- (NSMutableArray<TNIncomeRecordItemModel *> *)recordList {
    if (!_recordList) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}
/** @lazy preRecordList */
- (NSMutableArray<TNIncomeRecordItemModel *> *)preRecordList {
    if (!_preRecordList) {
        _preRecordList = [NSMutableArray array];
    }
    return _preRecordList;
}
/** @lazy filterModel */
- (TNIncomeListFilterModel *)filterModel {
    if (!_filterModel) {
        _filterModel = [[TNIncomeListFilterModel alloc] init];
        _filterModel.supplierType = TNSellerIdentityTypeNormal;
    }
    return _filterModel;
}
@end
