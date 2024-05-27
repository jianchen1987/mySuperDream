//
//  PNMSVoucherViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherViewModel.h"
#import "PNCommonUtils.h"
#import "PNMSVoucherDTO.h"
#import "PNMSVoucherInfoModel.h"
#import "PNMSVoucherRspModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@interface PNMSVoucherViewModel ()
@property (nonatomic, strong) PNMSVoucherDTO *voucherDTO;
@end


@implementation PNMSVoucherViewModel

- (void)getNewData:(BOOL)isShowLoading success:(void (^)(PNMSVoucherRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    if (isShowLoading) {
        [self.view showloading];
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    /// 开始日期 结束日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *tempStartDate = @"";
    if (WJIsStringEmpty(self.filterModel.startDate)) {
        tempStartDate = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy" withDate:[PNCommonUtils getNewDateByDay:-31 Month:0 Year:0 fromDate:[NSDate new]]];
    } else {
        tempStartDate = self.filterModel.startDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempStartDate stringByAppendingString:@" 00:00:00"]] timeIntervalSince1970] * 1000] forKey:@"startDate"];

    NSString *tempEndDate = @"";
    if (WJIsStringEmpty(self.filterModel.endDate)) {
        tempEndDate = [PNCommonUtils getCurrentDateStrByFormat:@"dd/MM/yyyy"];
    } else {
        tempEndDate = self.filterModel.endDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempEndDate stringByAppendingString:@" 23:59:59"]] timeIntervalSince1970] * 1000] forKey:@"endDate"];

    [dic setObject:self.filterModel.storeNo forKey:@"storeNo"];

    NSString *operatorsStr = [@[self.filterModel.operatorValue] componentsJoinedByString:@","];

    [dic setObject:operatorsStr forKey:@"operators"];
    [dic setObject:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [dic setObject:@(self.currentPage) forKey:@"pageNum"];
    [dic setValue:@(20) forKey:@"pageSize"];

    @HDWeakify(self);
    [self.voucherDTO getVoucherList:dic success:^(PNMSVoucherRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        !successBlock ?: successBlock(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

- (void)saveVoucher:(NSDictionary *)paramDic success:(void (^)(PNMSVoucherInfoModel *rspModel))successBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.voucherDTO saveVoucher:paramDic success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        PNMSVoucherInfoModel *model = [PNMSVoucherInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)getVoucherDetail {
    [self.view showloading];
    @HDWeakify(self);
    [self.voucherDTO getVoucherDetail:self.voucherId success:^(PNMSVoucherInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.voucherInfoModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNMSVoucherDTO *)voucherDTO {
    if (!_voucherDTO) {
        _voucherDTO = [[PNMSVoucherDTO alloc] init];
    }
    return _voucherDTO;
}
@end
