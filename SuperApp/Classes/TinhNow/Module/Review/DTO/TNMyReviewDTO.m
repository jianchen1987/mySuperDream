//
//  TNMyReviewDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyReviewDTO.h"
#import "TNMyHadReviewListRspModel.h"
#import "TNMyNotReviewListRspModel.h"


@implementation TNMyReviewDTO

- (void)queryMyHadReviewListWithPageNum:(NSUInteger)pageNum
                               pageSize:(NSUInteger)pageSize
                                success:(void (^)(TNMyHadReviewListRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/review/mine";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [SAUser shared].loginName;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNMyHadReviewListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryMyNotReviewListWithPageNum:(NSUInteger)pageNum
                               pageSize:(NSUInteger)pageSize
                                success:(void (^)(TNMyNotReviewListRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/review/noReviewed/list";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [SAUser shared].loginName;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNMyNotReviewListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 发布评论
- (void)postReviewData:(NSString *)postData success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/review/add";

    NSString *encodeStr = [postData hd_URLEncodedString];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"data"] = encodeStr;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getReviewNoticeWithSuccess:(void (^)(NSDictionary *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/discovery/review/getReviewNotice.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ruleBusinessLine"] = SAClientTypeTinhNow;
    //    params[@"loginName"] = SAUser.shared.loginName;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock((NSDictionary *)rspModel.data);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
