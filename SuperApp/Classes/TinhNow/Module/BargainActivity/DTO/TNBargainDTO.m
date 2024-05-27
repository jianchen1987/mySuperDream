//
//  TNBargainDTO.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainDTO.h"
#import "TNBargainDetailModel.h"
#import "TNBargainGoodListRspModel.h"
#import "TNBargainPeopleRecordRspModel.h"
#import "TNBargainRecordModel.h"
#import "TNBargainRuleModel.h"
#import "TNBargainSuccessModel.h"
#import "TNCreateBargainTaskModel.h"
#import "TNProductDetailsRspModel.h"


@implementation TNBargainDTO

- (void)queryBargainListWithPage:(NSUInteger)page size:(NSUInteger)size success:(void (^)(TNBargainGoodListRspModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain/activity/findListByPage";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"size"] = @(size);
    params[@"page"] = @(page);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNBargainGoodListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBargainCategoryListWithCategoryId:(NSString *)categoryId
                                          page:(NSUInteger)page
                                          size:(NSUInteger)size
                                       success:(void (^)(TNBargainGoodListRspModel *_Nonnull))successBlock
                                       failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain/activity/findListByPageV2";
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"size"] = @(size);
    params[@"page"] = @(page);
    params[@"rootCategoryId"] = categoryId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNBargainGoodListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBargainUnderwayTaskListSuccess:(void (^)(NSArray<TNBargainRecordModel *> *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-task/findUnderwayTaskList";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNBargainRecordModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)createBargainTaskWithModel:(TNCreateBargainTaskModel *)taskModel Success:(void (^)(NSString *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-task/createBargainTask";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSDictionary *params = [taskModel yy_modelToJSONObject];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNBargainDetailModel *model = [TNBargainDetailModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model.taskId);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBargainDetailWithTaskId:(NSString *)taskId pageType:(NSInteger)pageType Success:(void (^)(TNBargainDetailModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-task/findDetailById";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = taskId;
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"pageType"] = @(pageType);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNBargainDetailModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryGoodSkuSpecWithActivityId:(NSString *)activityId Success:(void (^_Nullable)(TNProductDetailsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-goods-stock/queryActivitySpecDetail";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activityId"] = activityId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNProductDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBargainSuccessTaskListSuccess:(void (^)(NSArray<TNBargainSuccessModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-task/findBargainSuccessTaskList";
    request.isNeedLogin = NO;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNBargainSuccessModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryMyBargainTaskListWithPage:(NSUInteger)page size:(NSUInteger)size success:(void (^)(TNBargainRecordListRspModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-task/findBargainActivityPage";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"size"] = @(size);
    params[@"page"] = @(page);
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNBargainRecordListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBargainRulesSuccess:(void (^)(TNBargainRuleModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-rules/queryRuleByLocale";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = @(1000000000000001);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNBargainRuleModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBargainBannerSuccess:(void (^)(NSString *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-rules/queryBargainActivityImage";
    request.isNeedLogin = NO;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *dic = (NSDictionary *)rspModel.data;
        !successBlock ?: successBlock(dic[@"image"]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)helpBargainWithTaskId:(NSString *)taskId activityId:(NSString *)activityId Success:(void (^)(TNHelpBargainModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-details/saveBargainDetails";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"taskId"] = taskId;
    params[@"activityId"] = activityId;
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"userNickname"] = SAUser.shared.nickName;
    params[@"userPortrait"] = SAUser.shared.headURL;
    params[@"createdBy"] = SAUser.shared.loginName;
    params[@"loginName"] = SAUser.shared.loginName;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNHelpBargainModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBargainActivityListActivityId:(NSString *)activityId
                                categoryId:(NSString *)categoryId
                                      page:(NSUInteger)page
                                      size:(NSUInteger)size
                                   success:(void (^)(TNBargainGoodListRspModel *_Nonnull))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/productSpecial/productsActivity";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(size);
    params[@"pageNum"] = @(page);
    if (HDIsStringNotEmpty(activityId)) {
        params[@"id"] = activityId;
    }
    if (HDIsStringNotEmpty(categoryId)) {
        params[@"categoryId"] = categoryId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNBargainGoodListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryHelpPeopleRecordByTaskId:(NSString *)taskId
                                 page:(NSUInteger)page
                                 size:(NSUInteger)size
                              success:(void (^)(TNBargainPeopleRecordRspModel *_Nonnull))successBlock
                              failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain/rank_list/get";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"size"] = @(size);
    params[@"page"] = @(page);
    if (HDIsStringNotEmpty(taskId)) {
        params[@"taskId"] = taskId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNBargainPeopleRecordRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

///砍价商品详情
- (void)queryBargainProductDetailsWithActivityId:(NSString *)activityId success:(void (^_Nullable)(TNProductDetailsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-goods-stock/queryActivitySpecDetailV2";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activityId"] = activityId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNProductDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
