//
//  PNWaterViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWaterViewModel.h"
#import "PNBillPayInfoModel.h"
#import "PNCreateAggregateOrderRspModel.h"
#import "PNRspModel.h"
#import "PNWaterBillModel.h"
#import "PNWaterDTO.h"
#import "SAOrderDTO.h"


@interface PNWaterViewModel ()
@property (nonatomic, strong) PNWaterDTO *waterDTO;
///< 订单
@property (nonatomic, strong) SAOrderDTO *orderDTO;

@end


@implementation PNWaterViewModel

/// 查询账单编号查询账单
- (void)queryBillInfo:(void (^)(PNWaterBillModel *resultModel))successBlock {
    [self.view showloading];

    @HDWeakify(self);
    [self.waterDTO queryBillWithBillCode:self.billerCode customerCode:self.customerCode categoryType:self.paymentCategoryType currency:self.currency apiCredential:self.apiCredential
        billAmount:self.amount
        customerPhone:self.customerPhone
        notes:self.notes success:^(PNRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            PNWaterBillModel *model = [PNWaterBillModel yy_modelWithJSON:rspModel.data];
            !successBlock ?: successBlock(model);
            self.refreshFlag = !self.refreshFlag;
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
}

/// 提交下单账单信息
- (void)submitBillOrder:(NSDictionary *)param success:(void (^)(PNCreateAggregateOrderRspModel *rspModel))successBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.waterDTO submitBillWithParam:param success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        PNCreateAggregateOrderRspModel *model = [PNCreateAggregateOrderRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)queryOrderInfoWithAggregationOrderNo:(NSString *_Nonnull)aggregationOrderNo completion:(void (^)(SAQueryOrderInfoRspModel *_Nullable rspModel))completion {
    [self.orderDTO queryOrderInfoWithOrderNo:aggregationOrderNo outPayOrderNo:nil success:^(SAQueryOrderInfoRspModel *_Nonnull rspModel) {
        !completion ?: completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

/// 支付结果查询
- (void)queryPaymentResult:(BOOL)isShowLoading {
    if (isShowLoading) {
        [self.view showloading];
    }

    dispatch_group_t taskGroup = dispatch_group_create();

    dispatch_group_enter(taskGroup);
    @HDWeakify(self);
    [self.waterDTO queryPaymentResultWithOrderNo:self.orderNo tradeNo:self.tradeNo success:^(PNRspModel *_Nonnull rspModel) {
        self.payInfoModel = [PNBillPayInfoModel yy_modelWithJSON:rspModel.data];
        dispatch_group_leave(taskGroup);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        dispatch_group_leave(taskGroup);
    }];

    ///有聚合订单号再查询
    if (HDIsStringNotEmpty(self.orderNo)) {
        dispatch_group_enter(taskGroup);
        [self.orderDTO queryOrderDetailsWithOrderNo:self.orderNo success:^(SAQueryOrderDetailsRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            dispatch_group_leave(taskGroup);
            self.payInfoModel.payDiscountAmount = rspModel.payDiscountAmount;
            self.payInfoModel.payActualPayAmount = rspModel.payActualPayAmount;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            dispatch_group_leave(taskGroup);
        }];
    }

    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        [self.view dismissLoading];

        if (WJIsStringNotEmpty(self.payInfoModel.billNo)) {
            self.refreshFlag = !self.refreshFlag;
        }
    });
}

#pragma mark
- (PNWaterDTO *)waterDTO {
    return _waterDTO ?: ({ _waterDTO = [[PNWaterDTO alloc] init]; });
}

- (SAOrderDTO *)orderDTO {
    return _orderDTO ?: ({ _orderDTO = [[SAOrderDTO alloc] init]; });
}

@end
