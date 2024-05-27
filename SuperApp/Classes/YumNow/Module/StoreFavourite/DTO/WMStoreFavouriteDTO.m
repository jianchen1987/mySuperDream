//
//  WMStoreFavouriteDTO.m
//  SuperApp
//
//  Created by Chaos on 2020/12/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFavouriteDTO.h"
#import "WMSearchStoreRspModel.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SAAddressCacheAdaptor.h"

@implementation WMStoreFavouriteDTO

- (CMNetworkRequest *)addFavouriteWithStoreNo:(NSString *)storeNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-merchant/app/super-app/fav/add";
    request.isNeedLogin = true;
    request.shouldAlertErrorMsgExceptSpecCode = false;
    request.requestParameter = @{@"storeNo": storeNo, @"operatorNo": SAUser.shared.operatorNo ?: @""};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return request;
}

- (CMNetworkRequest *)removeFavouriteWithStoreNos:(NSArray<NSString *> *)storeNos success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-merchant/app/super-app/fav/remove";
    request.isNeedLogin = true;

    request.requestParameter = @{@"storeNos": storeNos, @"operatorNo": SAUser.shared.operatorNo ?: @""};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return request;
}

- (CMNetworkRequest *)getFavouriteStoreListWithPageNum:(NSInteger)pageNum
                                              pageSize:(NSInteger)pageSize
                                               success:(void (^)(WMSearchStoreRspModel *))successBlock
                                               failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-merchant/app/super-app/fav/list";
    request.isNeedLogin = true;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (HDIsObjectNil(addressModel) || ![HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)]) {
        !successBlock ?: successBlock(nil);
        return request;
    }
    params[@"location"] = @{@"lat": addressModel.lat.stringValue, @"lon": addressModel.lon.stringValue};
    params[@"pageNum"] = @(pageNum);
    params[@"pageSize"] = @(pageSize);
    params[@"operatorNo"] = SAUser.shared.operatorNo ?: @"";
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMSearchStoreRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return request;
}

@end
