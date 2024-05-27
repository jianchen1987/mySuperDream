//
//  SASuggestionViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASuggestionViewModel.h"


@interface SASuggestionViewModel ()
/// 发布建议与反馈
@property (nonatomic, strong) CMNetworkRequest *publishSuggestionRequest;

@end


@implementation SASuggestionViewModel

- (void)dealloc {
    [_publishSuggestionRequest cancel];
}

- (CMNetworkRequest *)publishSuggestionWithContent:(NSString *)content images:(NSArray<NSString *> *)images success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(content)) {
        [params setValue:content forKey:@"suggestContent"];
    }
    if (!HDIsArrayEmpty(images)) {
        [params setValue:images forKey:@"imageUrls"];
    }
    self.publishSuggestionRequest.requestParameter = params;
    [self.publishSuggestionRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.publishSuggestionRequest;
    ;
}

- (void)querySuggestionDetail {
    CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
    request.retryCount = 2;
    request.requestURI = @"/app/config/suggestion/detail";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = SAUser.shared.loginName;
    params[@"suggestionInfoId"] = self.suggestionInfoId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        if (rspModel.data) {
            self.model = [SASuggestionDetailModel yy_modelWithJSON:rspModel.data];
        }
    } failure:^(HDNetworkResponse *_Nonnull response){

    }];
}

- (void)clientUpdateStatusWithAgree:(BOOL)agree success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
    request.retryCount = 2;
    request.requestURI = @"/app/config/suggestion/clientUpdateStatus";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = SAUser.shared.loginName;
    params[@"suggestionInfoId"] = self.suggestionInfoId;
    params[@"solutionStatus"] = agree ? @"11" : @"10";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (CMNetworkRequest *)publishSuggestionRequest {
    if (!_publishSuggestionRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/app/config/suggestion/add";

        _publishSuggestionRequest = request;
    }
    return _publishSuggestionRequest;
}

@end
