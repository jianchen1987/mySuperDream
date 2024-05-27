//
//  TNRefundDetailsViewModel.m
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundDetailsViewModel.h"
#import "TNRefundDTO.h"
#import "TNRefundDetailsItemCell.h"
#import "TNRefundDetailsModel.h"


@interface TNRefundDetailsViewModel ()
///
@property (nonatomic, strong) TNRefundDetailsModel *refundDetailsModel;
///
@property (nonatomic, strong) TNRefundDTO *refundDTO;

@end


@implementation TNRefundDetailsViewModel

- (void)getData:(NSString *)orderNo {
    [self.view showloading];
    @HDWeakify(self);
    [self.refundDTO getRefundDetailsWithOrderNo:orderNo success:^(TNRefundDetailsModel *_Nonnull refundDetailsModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refundDetailsModel = refundDetailsModel;
        [self listData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)listData {
    NSMutableArray<HDTableViewSectionModel *> *dataSource = NSMutableArray.new;
    HDTableViewSectionModel *section = [[HDTableViewSectionModel alloc] init];


    NSMutableArray *listArray = [NSMutableArray array];
    if (self.refundDetailsModel.userRefundFlow) {
        TNRefundDetailsItemCellModel *itemsModel = TNRefundDetailsItemCellModel.new;
        itemsModel.model = self.refundDetailsModel.userRefundFlow;
        itemsModel.model.iconStr = @"tn_refund_details_canceled";
        [listArray addObject:itemsModel];
        section.list = listArray;
        [dataSource addObject:section];
    }


    if (self.refundDetailsModel.orderRefundFlow) {
        listArray = [NSMutableArray array];
        section = [[HDTableViewSectionModel alloc] init];
        TNRefundDetailsItemCellModel *itemsModel = TNRefundDetailsItemCellModel.new;
        itemsModel.model = self.refundDetailsModel.orderRefundFlow;
        itemsModel.model.iconStr = @"tn_refund_details_platform";
        [listArray addObject:itemsModel];
        section.list = listArray;
        [dataSource addObject:section];
    }

    if (self.refundDetailsModel.orderRefundDTO) {
        listArray = [NSMutableArray array];
        section = [[HDTableViewSectionModel alloc] init];
        TNRefundDetailsItemCellModel *itemsModel = TNRefundDetailsItemCellModel.new;
        itemsModel.model = self.refundDetailsModel.orderRefundDTO;
        itemsModel.model.iconStr = @"tn_refund_details_apply";
        [listArray addObject:itemsModel];
        section.list = listArray;
        [dataSource addObject:section];
    }


    self.dataSource = [NSArray arrayWithArray:dataSource];
    self.refreshFlag = !self.refreshFlag;
}

#pragma mark -
- (TNRefundDTO *)refundDTO {
    if (!_refundDTO) {
        _refundDTO = [[TNRefundDTO alloc] init];
    }
    return _refundDTO;
}


@end
