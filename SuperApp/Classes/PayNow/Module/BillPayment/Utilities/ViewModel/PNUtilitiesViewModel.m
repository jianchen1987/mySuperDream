//
//  PNUtilitiesViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUtilitiesViewModel.h"
#import "HDAppTheme+PayNow.h"
#import "PNBillCategoryItemModel.h"
#import "PNFunctionCellModel.h"
#import "PNRecentBillListItemModel.h"
#import "PNRspModel.h"
#import "PNWaterDTO.h"
#import "SACollectionReusableViewModel.h"
#import "SACollectionViewSectionModel.h"


@interface PNUtilitiesViewModel ()

@property (nonatomic, strong) PNWaterDTO *waterDTO;

@property (nonatomic, strong) SACollectionViewSectionModel *recentSectionModel;
@property (nonatomic, strong) SACollectionViewSectionModel *utilitiesSectionModel;
@end


@implementation PNUtilitiesViewModel
/// 查询所有账单分类
- (void)getAllBillCategory {
    [self.view showloading];
    @HDWeakify(self);
    [self.waterDTO getAllBillCategory:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        NSArray *categoryArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:PNBillCategoryItemModel.class json:rspModel.data]];
        if (![self.dataSource containsObject:self.utilitiesSectionModel]) {
            [self.dataSource insertObject:self.utilitiesSectionModel atIndex:0];
        }
        self.utilitiesSectionModel.list = categoryArray;
        self.refreshFlag = !self.refreshFlag;

        //查最近账单
        [self queryRecentBillList];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
        [self.view dismissLoading];
    }];
}

/// 查询最近的交易账单记录
- (void)queryRecentBillList {
    [self.waterDTO queryRecentBillList:^(PNRspModel *_Nonnull rspModel) {
        NSArray *recentDataSource = [NSArray yy_modelArrayWithClass:PNRecentBillListItemModel.class json:rspModel.data];
        if (recentDataSource.count > 0) {
            self.recentSectionModel.list = recentDataSource;

            if (![self.dataSource containsObject:self.recentSectionModel]) {
                [self.dataSource addObject:self.recentSectionModel];
            }
        } else {
            [self.dataSource removeObject:self.recentSectionModel];
        }
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        self.refreshFlag = !self.refreshFlag;
    }];
}

#pragma mark
- (PNWaterDTO *)waterDTO {
    return _waterDTO ?: ({ _waterDTO = [[PNWaterDTO alloc] init]; });
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (SACollectionViewSectionModel *)recentSectionModel {
    if (!_recentSectionModel) {
        SACollectionViewSectionModel *sectionModel = SACollectionViewSectionModel.new;
        [sectionModel hd_bindObjectWeakly:Tag_recent_payment forKey:kUtilitiesTag];
        SACollectionReusableViewModel *headerModel = [[SACollectionReusableViewModel alloc] init];
        headerModel.title = PNLocalizedString(@"recent_bill", @"Rencent bill");
        headerModel.titleFont = [HDAppTheme.PayNowFont fontSemibold:15];
        headerModel.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        sectionModel.headerModel = headerModel;

        _recentSectionModel = sectionModel;
    }
    return _recentSectionModel;
}

- (SACollectionViewSectionModel *)utilitiesSectionModel {
    if (!_utilitiesSectionModel) {
        SACollectionViewSectionModel *sectionModel = SACollectionViewSectionModel.new;
        [sectionModel hd_bindObjectWeakly:Tag_utilities forKey:kUtilitiesTag];
        SACollectionReusableViewModel *headerModel = [[SACollectionReusableViewModel alloc] init];
        headerModel.title = PNLocalizedString(@"Bill_classification", @"账单分类");
        headerModel.titleFont = [HDAppTheme.PayNowFont fontSemibold:15];
        headerModel.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        sectionModel.headerModel = headerModel;

        _utilitiesSectionModel = sectionModel;
    }
    return _utilitiesSectionModel;
}
@end
