
//
//  SAShoppingAddressDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressDTO.h"
#import "SACheckMobileValidRspModel.h"
#import "WMStoreModel.h"


@implementation SAShoppingAddressDTO

- (void)getShoppingAddressListSuccess:(void (^)(NSArray<SAShoppingAddressModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (!SAUser.hasSignedIn) {
        !successBlock ?: successBlock(nil);
        return;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/address/all.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAShoppingAddressModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getSearchAddressListWithLog:(double)lat lat:(double)lon Success:(void (^)(NSArray<SAShoppingAddressModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-user-addresses-on-search";
    if (!SAUser.hasSignedIn) {
        !successBlock ?: successBlock(nil);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    params[@"geoPointDTO"] = [@{@"lat": [NSString stringWithFormat:@"%f", lat], @"lon": [NSString stringWithFormat:@"%f", lon]} yy_modelToJSONObject];
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAShoppingAddressModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)addAddressWithModel:(SAShoppingAddressModel *)model
                    smsCode:(NSString *)smsCode
                    success:(void (^)(SAShoppingAddressModel *rspModel))successBlock
                    failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[model yy_modelToJSONObject]];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    params[@"latitude"] = model.latitude.stringValue;
    params[@"longitude"] = model.longitude.stringValue;
    if (HDIsStringNotEmpty(smsCode)) {
        params[@"isNeedSms"] = @1;
        params[@"verifyCode"] = smsCode;
    } else {
        params[@"isNeedSms"] = @0;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/address/addV2.do";
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAShoppingAddressModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)modifyAddressWithModel:(SAShoppingAddressModel *)model smsCode:(NSString *)smsCode success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[model yy_modelToJSONObject]];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    params[@"latitude"] = model.latitude.stringValue;
    params[@"longitude"] = model.longitude.stringValue;
    if (HDIsStringNotEmpty(smsCode)) {
        params[@"isNeedSms"] = @1;
        params[@"verifyCode"] = smsCode;
    } else {
        params[@"isNeedSms"] = @0;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/address/modifyV2.do";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getDefaultAddressSuccess:(void (^)(SAShoppingAddressModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (!SAUser.hasSignedIn) {
        !successBlock ?: successBlock(nil);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = SAUser.shared.operatorNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/address/default.do";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAShoppingAddressModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)removeAddressWithAddressNo:(NSString *)addressNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"addressNo"] = addressNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/address/delete.do";

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getUserAccessableShoppingAddressWithStoreNo:(NSString *)storeNo success:(void (^)(NSArray<SAShoppingAddressModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"operatorNo"] = SAUser.shared.operatorNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-user-addresses";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAShoppingAddressModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)checkConsigneeMobileIsValidWithMobile:(NSString *)mobile success:(void (^)(SACheckMobileValidRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/address/checkMobileSms.do";
    request.isNeedLogin = YES;
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SACheckMobileValidRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
