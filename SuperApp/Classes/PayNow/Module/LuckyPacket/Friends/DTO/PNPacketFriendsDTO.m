//
//  PNPacketFriendsDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsDTO.h"
#import "CMNetworkRequest.h"
#import "HDNetworkResponse.h"
#import "PNPacketCoolCashUserModel.h"
#import "PNPacketFriendsUserModel.h"
#import "PNPacketWOWNOWUserRspModel.h"
#import "PNRspModel.h"
#import "SARspModel.h"
#import "VipayUser.h"


@implementation PNPacketFriendsDTO
/// 近期与往来人员列表接口
- (void)getgetNearTransList:(void (^_Nullable)(NSArray<PNPacketFriendsUserModel *> *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/lucky-packet/records/app/getNearTransList";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:PNPacketFriendsUserModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查找中台的收用户
- (void)searchUserForWOWNOW:(NSString *)mobile
                     pageNo:(NSInteger)pageNo
                   pageSize:(NSInteger)pageSize
                    success:(void (^_Nullable)(PNPacketWOWNOWUserRspModel *rspModel))successBlock
                    failure:(HDRequestFailureBlock)failure {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/operator/info/query/user/list";

    request.requestParameter = @{
        @"mobile": mobile,
        @"pageNum": @(pageNo),
        @"pageSize": @(pageSize),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNPacketWOWNOWUserRspModel yy_modelWithJSON:rspModel.data]);
    } failure:failure];
}

/// 查找支付的用户
- (void)searchUserForCoolCash:(NSString *)loginNames success:(void (^_Nullable)(NSArray<PNPacketFriendsUserModel *> *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/status/query.do";

    /// 7000 红包
    request.requestParameter = @{
        @"businessCode": @(7000),
        @"loginNames": loginNames,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:PNPacketCoolCashUserModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
