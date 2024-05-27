//
//  PNOutletViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNOutletViewModel.h"
#import "PNAgentInfoModel.h"
#import "PNOutletDTO.h"
#import "PNRspModel.h"


@interface PNOutletViewModel ()
@property (nonatomic, strong) PNOutletDTO *outletDTO;
@end


@implementation PNOutletViewModel

/// 搜索附近的网点
- (void)searchNearCoolCashMerchant {
    [self.view showloading];

    @HDWeakify(self);
    [self.outletDTO searchNearCoolCashMerchantWithLongitude:self.selectCoordinate.longitude latitude:self.selectCoordinate.latitude distance:2 successBlock:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self.coolcashDataSourceArray removeAllObjects];
        self.coolcashDataSourceArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:PNAgentInfoModel.class json:rspModel.data]];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

#pragma mark
- (PNOutletDTO *)outletDTO {
    if (!_outletDTO) {
        _outletDTO = [[PNOutletDTO alloc] init];
    }
    return _outletDTO;
}

- (NSMutableArray *)coolcashDataSourceArray {
    if (!_coolcashDataSourceArray) {
        _coolcashDataSourceArray = [NSMutableArray array];
    }
    return _coolcashDataSourceArray;
}
@end
