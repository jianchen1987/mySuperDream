//
//  HDPayOrderRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/9.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDPayOrderRspModel.h"
#import "HDQrCodePaymentResultQueryRsp.h"
#import "PNCommonUtils.h"
#import "PNEnum.h"
#import "PNUtilMacro.h"


@implementation HDPayOrderRspModel

- (void)setStatus:(NSNumber *)status {
    _status = status;

    if (status.integerValue == 12) {
        _payOrderStatus = PNOrderStatusSuccess;
    } else if (status.integerValue == 13) {
        _payOrderStatus = PNOrderStatusFailure;
    } else if (status.integerValue == 11) {
        _payOrderStatus = PNOrderStatusProcessing;
    }
}

- (BOOL)parse {
    if ([super parse]) {
        if ([self.rspCd isEqualToString:RSP_SUCCESS_CODE]) {
            self.couponList = [[NSMutableArray alloc] init];
            NSDictionary *data = self.data;
            if (![data isEqual:[NSNull null]]) {
                //                self.amt = [NSNumber numberWithDouble:[[data valueForKey:@"amt"] integerValue] / 100.0];
                self.amt = [NSNumber numberWithDouble:[PNCommonUtils fenToyuan:[data valueForKey:@"amt"]].doubleValue];
                self.cy = [data valueForKey:@"cy"];
                //                self.fee = [NSNumber numberWithDouble:[[data valueForKey:@"fee"] integerValue] / 100.0];
                self.fee = [NSNumber numberWithDouble:[PNCommonUtils fenToyuan:[data valueForKey:@"fee"]].doubleValue];
                self.mark = [data valueForKey:@"mark"];
                self.payeeName = [data valueForKey:@"payeeName"];
                self.payeeNo = [data valueForKey:@"payeeNo"];
                self.status = [data valueForKey:@"status"];
                self.tradeNo = [data valueForKey:@"tradeNo"];
                self.tradeType = (PNTransType)[data valueForKey:@"tradeType"];
                self.date = [data valueForKey:@"date"];
                self.exchangeRate = [data valueForKey:@"exchangeRate"];
                //                self.payeeAmt = [NSNumber numberWithDouble:[[data valueForKey:@"payeeAmt"] integerValue] / 100.0];
                self.payeeAmt = [NSNumber numberWithDouble:[PNCommonUtils fenToyuan:[data valueForKey:@"payeeAmt"]].doubleValue];
                self.payeeCy = [data valueForKey:@"payeeCy"];
                self.symbol = [data valueForKey:@"symbol"];

                NSArray *arr = [data objectForKey:@"couponList"];
                if (arr && ![arr isEqual:[NSNull null]]) {
                    for (id obj in arr) {
                        PayHDCouponModel *model = [PayHDCouponModel yy_modelWithJSON:obj];
                        [self.couponList addObject:model];
                    }
                }
            }
        }

        return YES;
    }
    return NO;
}

+ (instancetype)modelFromTradeSubmitPaymentRspModel:(PayHDTradeSubmitPaymentRspModel *)model {
    return [[self alloc] initFromTradeSubmitPaymentRspModel:model];
}

- (instancetype)initFromTradeSubmitPaymentRspModel:(PayHDTradeSubmitPaymentRspModel *)model {
    if (self = [super init]) {
        self.amt = [NSNumber numberWithDouble:[model.payAmt.cent doubleValue]];
        self.cy = model.payAmt.cy;
        self.fee = [NSNumber numberWithDouble:[model.feeAmt.cent doubleValue]];
        self.mark = model.mark;
        self.payeeNo = model.payeeNo;
        self.payeeName = model.payeeName;
        self.payeeAmt = [NSNumber numberWithDouble:[model.payeeAmt.cent doubleValue]];
        self.payeeCy = model.payeeAmt.cy;
        self.orderAmt = [NSNumber numberWithDouble:[model.orderAmt.cent doubleValue]];
        self.orderCy = model.orderAmt.cy;
        self.status = [NSNumber numberWithInteger:model.status];
        self.payOrderStatus = model.status;
        self.tradeNo = model.tradeNo;
        self.tradeType = model.tradeType;
        self.date = model.date;
        self.exchangeRate = model.exchangeRate;
        self.symbol = model.symbol;
        self.userFeeAmt = model.userFeeAmt;

        NSMutableArray *couponList = [NSMutableArray arrayWithCapacity:model.couponList.count];
        for (PayHDTradeSubmitPreferentialModel *pModel in model.couponList) {
            PayHDCouponModel *cModel = [[PayHDCouponModel alloc] init];
            cModel.cy = pModel.couponAmt.cy;
            cModel.amt = [NSNumber numberWithDouble:[pModel.couponAmt.cent doubleValue]];
            cModel.type = [NSNumber numberWithInteger:pModel.type];
            [couponList addObject:cModel];
        }
        self.couponList = couponList;
    }
    return self;
}

+ (instancetype)modelFromPaymentCodeQueryRspModel:(HDQrCodePaymentResultQueryRsp *)model {
    return [[self alloc] initFromPaymentCodeQueryRspModel:model];
}

- (instancetype)initFromPaymentCodeQueryRspModel:(HDQrCodePaymentResultQueryRsp *)model {
    if (self = [super init]) {
        self.orderAmt = [NSNumber numberWithDouble:[model.orderAmt.cent doubleValue]];
        self.orderCy = model.orderAmt.cy;
        self.amt = [NSNumber numberWithDouble:[model.payAmt.cent doubleValue]];
        self.cy = model.payAmt.cy;
        self.status = [NSNumber numberWithInteger:model.status];
        self.payOrderStatus = model.status;
        self.tradeNo = model.tradeNo;
        self.date = model.date;
        self.mark = @"-";
        self.payeeName = model.storeName;
        self.tradeType = model.tradeType;
        self.payeeNo = model.merchantNo;
        self.userFeeAmt = model.userFeeAmt;

        NSMutableArray *couponList = [NSMutableArray arrayWithCapacity:model.couponList.count];
        for (HDPaymentCodeCouponModel *pModel in model.couponList) {
            PayHDCouponModel *cModel = [[PayHDCouponModel alloc] init];
            cModel.cy = pModel.couponAmt.cy;
            cModel.amt = [NSNumber numberWithDouble:[pModel.couponAmt.cent doubleValue]];
            cModel.type = [NSNumber numberWithInteger:pModel.type];
            cModel.incomeFlag = pModel.incomeFlag;
            cModel.merchantAmt = pModel.merchantAmt.cent.integerValue;
            [couponList addObject:cModel];
        }
        self.couponList = couponList;
    }
    return self;
}

+ (instancetype)modelFromRemoteNotificationModel:(HDRemoteNotificationModel *)model {
    return [[self alloc] initFromRemoteNotificationModel:model];
}

- (instancetype)initFromRemoteNotificationModel:(HDRemoteNotificationModel *)model {
    if (self = [super init]) {
        self.orderAmt = [NSNumber numberWithDouble:[model.orderAmount doubleValue]];
        self.orderCy = model.orderAmountCurrency;
        self.amt = [NSNumber numberWithDouble:[model.payAmount doubleValue]];
        self.cy = model.payAmountCurrency;
        // 默认成功
        self.status = [NSNumber numberWithInteger:PNOrderStatusSuccess];
        self.payOrderStatus = PNOrderStatusSuccess;
        self.tradeNo = model.businessNo;
        self.mark = model.incomeFlag;
        self.payeeName = model.payeeName;
        self.tradeType = model.businessType;
        self.payeeNo = model.merchantNo;
        self.userFeeAmt = [SAMoneyModel modelWithAmount:model.userFeeAmount currency:model.userFeeCurrency];

        NSMutableArray *couponList = [NSMutableArray arrayWithCapacity:model.couponList.count];
        for (HDPaymentCodeCouponModel *pModel in model.couponList) {
            PayHDCouponModel *cModel = [[PayHDCouponModel alloc] init];
            cModel.cy = pModel.couponAmt.cy;
            cModel.amt = [NSNumber numberWithDouble:[pModel.couponAmt.cent doubleValue]];
            cModel.type = [NSNumber numberWithInteger:pModel.type];
            cModel.incomeFlag = pModel.incomeFlag;
            cModel.merchantAmt = pModel.merchantAmt.cent.integerValue;
            [couponList addObject:cModel];
        }
        self.couponList = couponList;
    }
    return self;
}
@end
