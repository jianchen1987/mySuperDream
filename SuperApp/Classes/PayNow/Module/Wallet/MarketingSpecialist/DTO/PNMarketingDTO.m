//
//  PNMarketingDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNMarketingDTO.h"
#import "VipayUser.h"
#import "PNRspModel.h"
#import "PNMarketingDetailInfoModel.h"
#import "PNMarketingListItemModel.h"
#import "PNCheckMarketingRspModel.h"


@implementation PNMarketingDTO

/// 绑定推广专员
- (void)bindMarketing:(NSString *)mobile
    promoterLoginName:(NSString *)promoterLoginName
              success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
              failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/promoterFriendApp/bind";

    /// promoterLoginName   推广专员手机号
    /// friendLoginName    好友手机号
    request.requestParameter = @{
        @"promoterLoginName": promoterLoginName,
        @"friendLoginName": mobile,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 通过手机号码反查 账号信息
- (void)getCCAmountWithMobile:(NSString *)mobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/promoterFriendApp/queryKyc";
    request.requestParameter = @{
        @"payeeMobile": mobile,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 是否为推广专员
- (void)isPromoterAndBind:(void (^_Nullable)(PNCheckMarketingRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/promoterFriendApp/isPromoterAndBind";
    request.requestParameter = @{
        @"promoterLoginName": VipayUser.shareInstance.loginName,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNCheckMarketingRspModel *model = [PNCheckMarketingRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 是否已绑定推广专员
- (void)isBinded:(void (^_Nullable)(PNCheckMarketingRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/promoterFriendApp/isbinded";
    request.requestParameter = @{
        @"friendLoginName": VipayUser.shareInstance.loginName,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNCheckMarketingRspModel *model = [PNCheckMarketingRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询推广专员详情
- (void)queryPromoterDetail:(NSString *)mobile successBlock:(void (^_Nullable)(PNMarketingDetailInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/promoterFriendApp/queryPromoterDetail";
    request.requestParameter = @{
        @"promoterLoginName": VipayUser.shareInstance.loginName,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMarketingDetailInfoModel *model = [PNMarketingDetailInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询推广专员绑定的好友列表（需要脱敏）
- (void)queryPromoterFriendPage:(NSInteger)pageNo
              promoterLoginName:(NSString *)promoterLoginName
                   successBlock:(void (^_Nullable)(NSArray<PNMarketingListItemModel *> *rspModel))successBlock
                        failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/promoterFriendApp/queryPromoterFriendPage";
    request.requestParameter = @{@"promoterLoginName": promoterLoginName, @"pageNum": @(pageNo), @"pageSize": @(20)};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        if ([rspModel.data isKindOfClass:NSDictionary.class]) {
            NSDictionary *dict = rspModel.data;
            if ([dict.allKeys containsObject:@"list"]) {
                NSArray *arr = [NSArray yy_modelArrayWithClass:PNMarketingListItemModel.class json:rspModel.data[@"list"]];
                !successBlock ?: successBlock(arr);
            } else {
                !successBlock ?: successBlock(@[]);
            }
        } else {
            !successBlock ?: successBlock(@[]);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
