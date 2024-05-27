//
//  WMOrderRefundDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderRefundDTO.h"
#import "WMOrderCancelReasonModel.h"


@interface WMOrderRefundDTO ()

/// 用户售后申请
@property (nonatomic, strong) CMNetworkRequest *orderRefundApplyRequest;

@end


@implementation WMOrderRefundDTO

- (void)dealloc {
    [_orderRefundApplyRequest cancel];
}

- (CMNetworkRequest *)orderRefundApplyWithOrderNo:(NSString *)orderNo
                                        applyDesc:(NSString *)applyDesc
                                     cancelReason:(nullable WMOrderCancelReasonModel *)model
                                           reason:(NSString *)reason
                                         pictures:(NSArray<NSString *> *)pictures
                                          success:(void (^)(void))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    NSMutableString *eventDesc = [NSMutableString string];
    if (HDIsStringNotEmpty(applyDesc)) {
        [eventDesc appendString:applyDesc];
    }
    if (HDIsStringNotEmpty(reason)) {
        [eventDesc appendString:@","];
        [eventDesc appendString:reason];
    }
    if (model) {
        NSMutableDictionary *mdic = NSMutableDictionary.new;
        if (model.ids) {
            [mdic setObject:model.ids forKey:@"id"];
        }
        if (model.cancellation) {
            [mdic setObject:model.cancellation forKey:@"cancellation"];
        }
        if (model.nameEn) {
            [mdic setObject:model.nameEn forKey:@"nameEn"];
        }
        if (model.nameKm) {
            [mdic setObject:model.nameKm forKey:@"nameKm"];
        }
        if (model.nameZh) {
            [mdic setObject:model.nameZh forKey:@"nameZh"];
        }
        if (model.operationCode) {
            [mdic setObject:model.operationCode forKey:@"operationCode"];
        }
        if (model.operatorStr) {
            [mdic setObject:model.operatorStr forKey:@"operator"];
        }
        [mdic setObject:@"10" forKey:@"operatePlatform"];
        params[@"cancelReasonReqDTO"] = mdic;
    }
    params[@"eventDesc"] = eventDesc;
    params[@"relatedPictureIds"] = pictures;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    self.orderRefundApplyRequest.requestParameter = params;
    [self.orderRefundApplyRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.orderRefundApplyRequest;
}

- (CMNetworkRequest *)orderRefundApplyWithOrderNo:(NSString *)orderNo
                                        applyDesc:(NSString *)applyDesc
                                           reason:(NSString *)reason
                                         pictures:(NSArray<NSString *> *)pictures
                                          success:(void (^)(void))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    return [self orderRefundApplyWithOrderNo:orderNo applyDesc:applyDesc cancelReason:nil reason:reason pictures:pictures success:successBlock failure:failureBlock];
}

#pragma mark - lazy load
- (CMNetworkRequest *)orderRefundApplyRequest {
    if (!_orderRefundApplyRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-order/app/user/refund/apply";

        _orderRefundApplyRequest = request;
    }
    return _orderRefundApplyRequest;
}

@end
