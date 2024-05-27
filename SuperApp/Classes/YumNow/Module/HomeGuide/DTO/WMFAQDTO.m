//
//  WMFAQDTO.m
//  SuperApp
//
//  Created by wmz on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMFAQDTO.h"


@implementation WMFAQDTO

- (CMNetworkRequest *)yumNowQueryGuideLinkWithKey:(NSString *)key success:(void (^_Nullable)(WMFAQRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-faq-link";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{@"key": key};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMFAQRspModel *model = [WMFAQRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}

- (CMNetworkRequest *)yumNowQueryGuideContentWithKey:(NSString *)key
                                                code:(NSString *)code
                                             success:(void (^_Nullable)(WMFAQDetailRspModel *rspModel))successBlock
                                             failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-faq-content";
    NSMutableDictionary *params = NSMutableDictionary.new;
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        params[@"language"] = @"zh";
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        params[@"language"] = @"km";
    } else {
        params[@"language"] = @"en";
    }
    params[@"key"] = key;
    params[@"code"] = code;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMFAQDetailRspModel *model = [WMFAQDetailRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}

- (CMNetworkRequest *)yumNowGuideFeedBackWithCode:(NSString *)code parrse:(BOOL)parse success:(CMNetworkSuccessBlock _Nullable)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/feedback-faq";
    request.requestParameter = @{@"code": code, @"isSupport": parse ? @"true" : @"false"};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(response.extraData);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}

@end
