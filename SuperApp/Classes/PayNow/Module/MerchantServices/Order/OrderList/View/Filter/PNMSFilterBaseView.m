//
//  PNMSFilterBaseView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSFilterBaseView.h"
#import "PNMSBillFilterModel.h"
#import "PNMSStoreAllOperatorModel.h"
#import "PNMSStoreInfoModel.h"
#import "PNMSStoreManagerDTO.h"
#import "PNMSStoreOperatorInfoModel.h"


@interface PNMSFilterBaseView ()
@property (nonatomic, strong) NSMutableArray<PNMSStoreAllOperatorModel *> *allDataSource;
@property (nonatomic, strong) PNMSStoreManagerDTO *storeDTO;
@end


@implementation PNMSFilterBaseView

- (void)getStoreAllOperatorData:(void (^)(void))successBlock {
    @HDWeakify(self);
    [self.storeDTO getStoreAllOperator:^(NSArray<PNMSStoreAllOperatorModel *> *_Nonnull rspModel) {
        HDLog(@"%@", rspModel);
        self.allDataSource = [NSMutableArray arrayWithArray:rspModel];
        @HDStrongify(self);
        [self processStoreData:self.allDataSource complete:successBlock];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

- (void)processStoreData:(NSArray *)rspArray complete:(void (^)(void))successBlock {
    if (rspArray.count > 0) {
        [self.storeArray removeAllObjects];

        PNMSRoleType roleType = VipayUser.shareInstance.role;
        if (roleType == PNMSRoleType_MANAGEMENT || roleType == PNMSRoleType_OPERATOR) {
            PNMSBillFilterModel *model = PNMSBillFilterModel.new;
            model.titleName = PNLocalizedString(@"pn_all_store", @"全部门店");
            model.value = @"";

            self.filterModel.storeNo = model.value;
            self.filterModel.storeName = model.titleName;

            [self.storeArray addObject:model];

            for (PNMSStoreInfoModel *storeInfoModel in rspArray) {
                PNMSBillFilterModel *model = PNMSBillFilterModel.new;
                model.titleName = storeInfoModel.storeName;
                model.value = storeInfoModel.storeNo;
                [self.storeArray addObject:model];
            }

            [self getCurrentStoreOperatorData:successBlock];
        } else {
            PNMSStoreInfoModel *firstInfoModel = [rspArray firstObject];
            self.filterModel.storeNo = firstInfoModel.storeNo;
            self.filterModel.storeName = firstInfoModel.storeName;

            [self getCurrentStoreOperatorData:successBlock];
        }
    }
}

- (void)getCurrentStoreOperatorData:(void (^)(void))successBlock {
    if (WJIsStringNotEmpty(self.filterModel.storeNo)) {
        [self.operatorArray removeAllObjects];

        for (PNMSStoreAllOperatorModel *itemModel in self.allDataSource) {
            if ([itemModel.storeNo isEqualToString:self.filterModel.storeNo]) {
                if (itemModel.operatorArray.count > 0) {
                    PNMSBillFilterModel *model = PNMSBillFilterModel.new;
                    model.titleName = PNLocalizedString(@"pn_all", @"全部");
                    model.value = @"";
                    self.filterModel.operatorValue = model.value;
                    [self.operatorArray addObject:model];

                    for (PNMSStoreOperatorInfoModel *storeOperatorInfoModel in itemModel.operatorArray) {
                        PNMSBillFilterModel *model = PNMSBillFilterModel.new;
                        model.titleName = storeOperatorInfoModel.name;
                        model.value = storeOperatorInfoModel.operatorMobile;
                        [self.operatorArray addObject:model];
                    }
                }
            }
        }
        !successBlock ?: successBlock();
    } else {
        [self.operatorArray removeAllObjects];
        !successBlock ?: successBlock();
    }
}

#pragma mark
- (PNMSStoreManagerDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = [[PNMSStoreManagerDTO alloc] init];
    }
    return _storeDTO;
}

- (NSMutableArray<PNMSBillFilterModel *> *)storeArray {
    if (!_storeArray) {
        _storeArray = [NSMutableArray array];
    }
    return _storeArray;
}

- (NSMutableArray<PNMSBillFilterModel *> *)operatorArray {
    if (!_operatorArray) {
        _operatorArray = [NSMutableArray array];
    }
    return _operatorArray;
}
@end
