//
//  TNNewIncomeViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeViewModel.h"
#import "SAWindowManager.h"
#import "TNNewIncomeDTO.h"


@interface TNNewIncomeViewModel ()
@property (strong, nonatomic) TNNewIncomeDTO *incomeDTO; ///

@end


@implementation TNNewIncomeViewModel
- (void)getProfitIncomeDataCompletion:(void (^)(BOOL))completion {
    @HDWeakify(self);
    [self.incomeDTO queryProfitIncomeDataSuccess:^(TNNewProfitIncomeModel *_Nonnull model) {
        @HDStrongify(self);
        self.profitModel = model;
        !completion ?: completion(YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(NO);
    }];
}
- (void)checkUserOpenedWallet {
    [self.incomeDTO queryCheckUserOpenedSuccess:^(TNCheckWalletOpenedModel *_Nonnull model) {
        if (!model.walletCreated || !model.isVerifiedRealName) {
            [NAT showAlertWithMessage:TNLocalizedString(@"JGYtII7J", @"请先开通WN钱包及实名认证后再查看收益数据") buttonTitle:TNLocalizedString(@"bYACqNTz", @"去开通")
                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismiss];
                                  [SAWindowManager openUrl:@"SuperApp://SuperApp/wallet" withParameters:@{}];
                              }];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
- (void)getIncomeSettlementSumCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.incomeDTO queryIncomeSettlementSumWithFilterModel:self.filterModel success:^(TNIncomeCommissionSumModel *model) {
        @HDStrongify(self);
        self.commissionSumModel = model;
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
- (void)getNewListDataWithLoading:(BOOL)loading {
    self.currentPage = 1;
    [self queryListDataWithLoadMoreData:NO loading:loading];
}
- (void)loadMoreListData {
    self.currentPage += 1;
    [self queryListDataWithLoadMoreData:YES loading:NO];
}
- (void)queryListDataWithLoadMoreData:(BOOL)isLoadMoreData loading:(BOOL)loading {
    @HDWeakify(self);
    if (loading) {
        [self.view showloading];
    }
    [self.incomeDTO queryIncomeListWithPageNum:self.currentPage pageSize:20 filterModel:self.filterModel success:^(TNNewIncomeRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (self.currentPage == 1) {
            [self.list removeAllObjects];
        }
        [self.list addObjectsFromArray:rspModel.list];
        self.hasNextPage = rspModel.hasNextPage;
        self.incomeRefreshFlag = !self.incomeRefreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (self.currentPage == 1) {
            !self.getNewDataFaild ?: self.getNewDataFaild();
        } else {
            !self.loadMoreDataFaild ?: self.loadMoreDataFaild();
        }
    }];
}
/** @lazy incomeDTO */
- (TNNewIncomeDTO *)incomeDTO {
    if (!_incomeDTO) {
        _incomeDTO = [[TNNewIncomeDTO alloc] init];
    }
    return _incomeDTO;
}
/** @lazy list */
- (NSMutableArray<TNNewIncomeItemModel *> *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
/** @lazy filterModel */
- (TNIncomeListFilterModel *)filterModel {
    if (!_filterModel) {
        _filterModel = [[TNIncomeListFilterModel alloc] init];
        _filterModel.supplierType = TNSellerIdentityTypeNormal;
        _filterModel.queryMode = 1;
    }
    return _filterModel;
}
@end
