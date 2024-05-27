//
//  PNBillSupplierListViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillSupplierListViewModel.h"
#import "PNBillSupplierInfoModel.h"
#import "PNRspModel.h"
#import "PNWaterDTO.h"


@interface PNBillSupplierListViewModel ()
@property (nonatomic, strong) PNWaterDTO *waterDTO;
@end


@implementation PNBillSupplierListViewModel

/// 查询供应商列表
- (void)getBillerSupplierList {
    [self.view showloading];
    @HDWeakify(self);
    [self.waterDTO getBillerSupplierListWithType:self.paymentCategory success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        NSDictionary *dict = rspModel.data;
        self.dataSourceArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:PNBillSupplierInfoModel.class json:[dict objectForKey:@"list"]]];
        self.showDataSourceArray = [self.dataSourceArray mutableCopy];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNWaterDTO *)waterDTO {
    return _waterDTO ?: ({ _waterDTO = [[PNWaterDTO alloc] init]; });
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end
