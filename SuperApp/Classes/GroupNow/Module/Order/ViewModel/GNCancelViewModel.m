//
//  GNCancelViewModel.m
//  SuperApp
//
//  Created by wmz on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCancelViewModel.h"
#import "GNOrderDTO.h"


@interface GNCancelViewModel ()
/// DTO
@property (nonatomic, strong) GNOrderDTO *DTO;

@end


@implementation GNCancelViewModel
- (void)getCancelList {
    @HDWeakify(self)[self.DTO orderCancelListSuccess:^(NSArray<GNOrderCancelRspModel *> *_Nonnull rspModel) {
        @HDStrongify(self) self.cancelDataSource = rspModel;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) self.dataSource = nil;
        self.refreshType = GNRequestTypeBad;
    }];
}

- (void)orderCanceledWithState:(nonnull NSString *)cancelState remark:(nullable NSString *)remark completion:(void (^)(BOOL success))completion {
    [self.DTO orderCanceledRequestCustomerNo:SAUser.shared.operatorNo orderNo:self.orderNo cancelState:cancelState remark:remark success:^(SARspModel *_Nonnull rspModel) {
        if (completion) {
            completion(YES);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)setCancelDataSource:(NSArray<GNOrderCancelRspModel *> *)cancelDataSource {
    _cancelDataSource = cancelDataSource;
    self.dataSource = NSMutableArray.new;
    for (GNOrderCancelRspModel *rspModel in cancelDataSource) {
        GNCellModel *cellModel = GNCellModel.new;
        cellModel.businessData = rspModel;
        cellModel.cellClass = NSClassFromString(@"GNCancelListTableVIewCell");
        [self.dataSource addObject:cellModel];
    }
    self.refreshType = GNRequestTypeSuccess;
}

- (GNOrderDTO *)DTO {
    if (!_DTO) {
        _DTO = GNOrderDTO.new;
    }
    return _DTO;
}

@end
