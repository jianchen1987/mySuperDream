//
//  PNInterTransferReciverDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferReciverDTO.h"
#import "PNCAMNetworRequest.h"
#import "PNInterTransferReciverModel.h"
#import "PNInterTransferRelationModel.h"
#import "PNRspModel.h"


@implementation PNInterTransferReciverDTO

/// 查询收款人列表
- (void)queryAllReciverListWithChannel:(PNInterTransferThunesChannel)channel success:(void (^)(NSArray<PNInterTransferReciverModel *> *list))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/fxBeneficiaryInfo/searchFxBeneficiaryInfoList";
    request.isNeedLogin = YES;
    request.requestParameter = @{
        @"channel": @(channel),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[PNInterTransferReciverModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 通过收款人id 查询收款人数据
- (void)queryReciverByReciverIds:(NSArray *)ids success:(void (^_Nullable)(NSArray<PNInterTransferReciverModel *> *list))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/fxBeneficiaryInfo/queryFxBeneficiaryInfoByIds";
    request.isNeedLogin = YES;
    request.requestParameter = @{@"ids": ids};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[PNInterTransferReciverModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询关系列表
- (void)queryRelationListSuccess:(void (^)(NSArray<PNInterTransferRelationModel *> *list))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/fxBeneficiaryRelationInfo/queryAll";
    request.isNeedLogin = YES;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[PNInterTransferRelationModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 保存收款人
- (void)saveReciverInfoWithModel:(PNInterTransferReciverModel *)reciverModel
                         channel:(PNInterTransferThunesChannel)channel
                         success:(void (^)(void))successBlock
                         failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    if (channel == PNInterTransferThunesChannel_Wechat) {
        request.requestURI = @"/fxt/app/fxBeneficiaryInfo/weChat/addFxBeneficiaryInfo";
    } else {
        request.requestURI = @"/fxt/app/fxBeneficiaryInfo/addFxBeneficiaryInfo";
    }
    request.isNeedLogin = YES;
    NSDictionary *dict = [reciverModel yy_modelToJSONObject];
    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 修改收款人
- (void)updateReciverInfoWithModel:(PNInterTransferReciverModel *)reciverModel
                           channel:(PNInterTransferThunesChannel)channel
                           success:(void (^)(void))successBlock
                           failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    if (channel == PNInterTransferThunesChannel_Wechat) {
        request.requestURI = @"/fxt/app/fxBeneficiaryInfo/weChat/updateFxBeneficiaryInfo";
    } else {
        request.requestURI = @"/fxt/app/fxBeneficiaryInfo/updateFxBeneficiaryInfo";
    }
    request.isNeedLogin = YES;
    NSDictionary *dict = [reciverModel yy_modelToJSONObject];
    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 删除收款人
- (void)deleteReciverInfoWithModel:(PNInterTransferReciverModel *)reciverModel success:(void (^)(void))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/fxBeneficiaryInfo/deleteFxBeneficiaryInfo";
    request.isNeedLogin = YES;
    if (HDIsStringNotEmpty(reciverModel.reciverId)) {
        request.requestParameter = @{@"ids": @[reciverModel.reciverId]};
    }

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
