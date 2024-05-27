//
//  WMStoreDetailDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailDTO.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SACommonConst.h"
#import "WMOrderBriefRspModel.h"
#import "WMOrderEvaluationGoodsModel.h"
#import "WMSearchStoreRspModel.h"
#import "WMStoreDetailRspModel.h"
#import "SAAddressCacheAdaptor.h"

@interface WMStoreDetailDTO ()
/// 获取详情请求
@property (nonatomic, strong) CMNetworkRequest *getStoreDetailInfoRequest;
/// 获取订单评价简要信息
@property (nonatomic, strong) CMNetworkRequest *getOrderBriefInfoRequest;

@end


@implementation WMStoreDetailDTO
- (void)dealloc {
    [_getStoreDetailInfoRequest cancel];
    [_getOrderBriefInfoRequest cancel];
}

- (CMNetworkRequest *)getStoreDetailInfoWithStoreNo:(NSString *)storeNo success:(void (^)(WMStoreDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CLLocationCoordinate2D paramsCoordinate2D = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:paramsCoordinate2D];
    if (HDIsObjectNil(addressModel) || !isParamsCoordinate2DValid) {
        // 没有选择地址或选择的地址无效，使用定位地址
        params[@"location"] = @{
            @"lat": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.latitude].stringValue,
            @"lon": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.longitude].stringValue
        };
    } else {
        params[@"location"] = @{@"lat": addressModel.lat.stringValue, @"lon": addressModel.lon.stringValue};
    }
    if (SAUser.hasSignedIn) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    self.getStoreDetailInfoRequest.requestParameter = params;
    [self.getStoreDetailInfoRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMStoreDetailRspModel *model = [WMStoreDetailRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.getStoreDetailInfoRequest;
}

- (CMNetworkRequest *)getOrderBriefInfoWithOrderId:(NSString *)orderId success:(void (^)(WMOrderBriefRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderId;
    self.getOrderBriefInfoRequest.requestParameter = params;
    [self.getOrderBriefInfoRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOrderBriefRspModel *model = WMOrderBriefRspModel.new;
        NSArray<WMOrderEvaluationGoodsModel *> *list = [NSArray yy_modelArrayWithClass:WMOrderEvaluationGoodsModel.class json:rspModel.data];
        model.list = list;

        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getOrderBriefInfoRequest;
}

- (void)getSimilarStoreListWithStoreNo:(NSString *)storeNo
                               pageNum:(NSInteger)pageNum
                               success:(void (^)(WMSearchStoreRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/similar-store";
    //    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"pageSize"] = @"10";
    params[@"pageNum"] = @(pageNum ?: 1).stringValue;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            lat = HDLocationManager.shared.coordinate2D.latitude;
            lat = HDLocationManager.shared.coordinate2D.longitude;
        } else {
            lat = kDefaultLocationPhn.latitude;
            lon = kDefaultLocationPhn.longitude;
        }
    }
    params[@"location"] = @{@"lat": [NSString stringWithFormat:@"%f", lat], @"lon": [NSString stringWithFormat:@"%f", lon]};
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMSearchStoreRspModel *model = [WMSearchStoreRspModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMSearchStoreRspModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - lazy load
- (CMNetworkRequest *)getStoreDetailInfoRequest {
    if (!_getStoreDetailInfoRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-merchant/app/super-app/get";
        request.isNeedLogin = false;
        _getStoreDetailInfoRequest = request;
    }
    return _getStoreDetailInfoRequest;
}

- (CMNetworkRequest *)getOrderBriefInfoRequest {
    if (!_getOrderBriefInfoRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-order/app/user/order/commodities";
        _getOrderBriefInfoRequest = request;
    }
    return _getOrderBriefInfoRequest;
}

@end
