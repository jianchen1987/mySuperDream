//
//  PNBillModifyAccountDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillModifyAmountDTO.h"
#import "PNCAMNetworRequest.h"


@implementation PNBillModifyAmountDTO

/// 修改账单金额
- (void)billModifyAccountWithPaymentToken:(NSString *)paymentToken
                                   amount:(NSString *)amount
                                   billNo:(NSString *)billNo
                                 currency:(NSString *)currency
                                  success:(void (^)(PNRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/billingInformation/editPaymentAmount";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{
        @"currency": currency,
        @"paymentToken": paymentToken,
        @"amount": @(amount.doubleValue * 100), //精确到分
        @"billNo": billNo
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
