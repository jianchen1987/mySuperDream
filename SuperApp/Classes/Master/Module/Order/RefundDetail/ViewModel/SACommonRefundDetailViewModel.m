//
//  SACommonRefundDetailViewModel.m
//  SuperApp
//
//  Created by Tia on 2022/5/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonRefundDetailViewModel.h"
#import "SACommonRefundDetailDTO.h"


@interface SACommonRefundDetailViewModel ()
/// 刷新标志
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否正在加载
@property (nonatomic, assign) BOOL isLoading;
/// 数据源
@property (nonatomic, strong) NSArray<SACommonRefundInfoModel *> *dataSource;

@end


@implementation SACommonRefundDetailViewModel

- (void)queryOrdeDetailInfo {
    self.isLoading = true;
    [SACommonRefundDetailDTO getRefundOrderDetailWithOrderNo:self.aggregateOrderNo success:^(NSArray<SACommonRefundInfoModel *> *objArr) {
        self.isLoading = false;
        if (self.isBusinessDataError) {
            self.isBusinessDataError = false;
        }
        self.dataSource = objArr;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.isLoading = false;
        if (errorType == CMResponseErrorTypeBusinessDataError) {
            self.isBusinessDataError = true;
        } else {
            self.isNetworkError = true;
        }
        self.refreshFlag = !self.refreshFlag;
    }];
}

@end
