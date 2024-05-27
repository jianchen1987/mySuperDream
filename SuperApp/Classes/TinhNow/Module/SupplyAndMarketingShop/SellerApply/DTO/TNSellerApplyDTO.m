//
//  TNSellerApplyDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerApplyDTO.h"
#import "TNCommonAdvRspModel.h"
#import "TNSellerApplyModel.h"


@implementation TNSellerApplyDTO

- (void)querySellerApplyAdvById:(NSString *)advId success:(void (^)(TNCommonAdvRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/common/adv";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"advId"] = advId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNCommonAdvRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)querySellerApplyDataSuccess:(void (^)(TNSellerApplyModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/user/supplier_apply/isSupplierAndInfo";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"userName"] = [SAUser shared].loginName;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNSellerApplyModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)postSellerApplyByModel:(TNSellerApplyModel *)applyModel success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/user/supplier_apply/addOrUpdate";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"userName"] = [SAUser shared].loginName;
    NSDictionary *dict = [applyModel yy_modelToJSONObject];
    [params addEntriesFromDictionary:dict];
    [params removeObjectForKey:@"status"];
    [params removeObjectForKey:@"sellerChannelValue"];
    [params removeObjectForKey:@"dicValues"];
    [params removeObjectForKey:@"customerChannelTypes"];
    [params removeObjectForKey:@"customerChannelType"];
    [params removeObjectForKey:@"customerGroups"];
    [params removeObjectForKey:@"customerGroup"];
    if (![applyModel.sellerApplyChannels isEqualToString:@"channel5"]) {
        [params removeObjectForKey:@"sellerApplyChannelsContent"];
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //            SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
