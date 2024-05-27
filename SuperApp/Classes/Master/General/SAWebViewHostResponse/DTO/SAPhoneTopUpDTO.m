//
//  SAPhoneTopUpDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/7/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPhoneTopUpDTO.h"
#import "SAMoneyModel.h"
#import "WMOrderSubmitRspModel.h"


@implementation SAPhoneTopUpDTO

- (void)submitPhoneTopUpOrderWithPaymentType:(SAOrderPaymentType)paymentType
                                 amountModel:(SAMoneyModel *)amountModel
                                 topUpNumber:(NSString *)topUpNumber
                                  merchantNo:(NSString *)merchantNo
                                     success:(void (^_Nullable)(WMOrderSubmitRspModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"payType"] = @(paymentType);
    params[@"totalTrialPrice"] = amountModel.centFace;
    params[@"businessLine"] = SAClientTypePhoneTopUp;
    // 总的折扣金额，为空传 0 ，后端说需要，搞不懂
    params[@"discountAmount"] = @"0.0";
    params[@"currency"] = amountModel.cy;

    params[@"totalCommodityPrice"] = amountModel.centFace;
    params[@"userName"] = SAUser.shared.loginName;
    params[@"userId"] = SAUser.shared.loginName;
    params[@"storeNo"] = merchantNo;
    params[@"returnUrl"] = [NSString stringWithFormat:@"SuperApp://SuperApp/CashierResult?businessLine=%@&orderNo=", SAClientTypePhoneTopUp];
    params[@"autoCreatePayOrder"] = @"false";
    // 业务参数
    NSMutableDictionary *businessParams = [NSMutableDictionary dictionary];

    businessParams[@"currency"] = amountModel.cy;
    businessParams[@"deviceNo"] = [HDDeviceInfo getUniqueId];
    businessParams[@"merNo"] = merchantNo;
    businessParams[@"orderAmt"] = @{@"amount": amountModel.centFace, @"cent": amountModel.cent, @"centFactor": @"100", @"currency": amountModel.cy, @"md5": @"", @"rsa": @""};
    businessParams[@"payType"] = @(paymentType);
    businessParams[@"topUpNumber"] = topUpNumber;
    businessParams[@"totalCommodityPrice"] = amountModel.centFace;
    businessParams[@"totalTrialPrice"] = @"";
    businessParams[@"userNo"] = SAUser.shared.loginName;

    params[@"businessParams"] = businessParams;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/shop/order/save";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderSubmitRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
