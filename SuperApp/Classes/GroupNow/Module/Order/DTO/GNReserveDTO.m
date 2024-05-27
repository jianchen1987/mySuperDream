//
//  GNReserveDTO.m
//  SuperApp
//
//  Created by wmz on 2022/9/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveDTO.h"


@implementation GNReserveDTO

- (void)getStoreNoBuinessTime:(nonnull NSString *)storeNo success:(nullable void (^)(GNReserveBuinessModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *param = NSMutableDictionary.new;
    [param setObject:storeNo forKey:@"storeNo"];
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/groupon-service/user/order/store/business";
    request.requestParameter = param;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNReserveBuinessModel *model = [GNReserveBuinessModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:GNReserveBuinessModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderReservationWithStoreNo:(nonnull NSString *)storeNo
                            orderNo:(nonnull NSString *)orderNo
                    reservationTime:(nonnull NSString *)reservationTime
                     reservationNum:(NSInteger)reservationNum
                    reservationUser:(nonnull NSString *)reservationUser
                   reservationPhone:(nonnull NSString *)reservationPhone
                            success:(nullable CMNetworkSuccessBlock)successBlock
                            failure:(nullable CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    NSMutableDictionary *param = NSMutableDictionary.new;
    [param setObject:storeNo forKey:@"storeNo"];
    [param setObject:orderNo forKey:@"orderNo"];
    [param setObject:reservationTime forKey:@"reservationTime"];
    [param setObject:@(reservationNum).stringValue forKey:@"reservationNum"];
    [param setObject:reservationUser forKey:@"reservationUser"];
    [param setObject:reservationPhone forKey:@"reservationPhone"];
    request.isNeedLogin = YES;
    request.requestURI = @"/groupon-service/user/order/reservation";
    request.requestParameter = param;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(response.extraData);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getOrderReservationInfoWithOrderNo:(nonnull NSString *)orderNo success:(nullable void (^)(GNReserveRspModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *param = NSMutableDictionary.new;
    [param setObject:orderNo forKey:@"orderNo"];
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/groupon-service/user/order/reservation/detail";
    request.requestParameter = param;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNReserveRspModel *model = [GNReserveRspModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:GNReserveRspModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
