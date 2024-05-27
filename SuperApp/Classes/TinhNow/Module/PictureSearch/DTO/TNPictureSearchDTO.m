//
//  TNPictureSearchDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNPictureSearchDTO.h"


@interface TNPictureSearchDTO ()
/////
//@property (strong, nonatomic) TNNetworkRequest *createRequest;
/////
//@property (strong, nonatomic) TNNetworkRequest *queryRequest;
@end


@implementation TNPictureSearchDTO

- (void)queryProductSimilarSearchWithPicUrl:(NSString *)picUrl
                                     pageNo:(NSInteger)pageNo
                                   pageSize:(NSInteger)pageSize
                                    success:(void (^)(TNPictureSearchRspModel *_Nonnull))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"picUrl"] = picUrl;

    TNNetworkRequest *request = [[TNNetworkRequest alloc] init];
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/product/similarSearch";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNPictureSearchRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
//- (void)dealloc {
//    [self cancel];
//}
//
//- (void)cancel {
//    [self.createRequest cancel];
//    [self.queryRequest cancel];
//}
//
//- (void)createSimilarSearchJobWithPicUrl:(NSString *)picUrl
//                                  pageNo:(NSInteger)pageNo
//                                pageSize:(NSInteger)pageSize
//                                 success:(void (^)(TNPictureSearchRspModel *_Nonnull))successBlock
//                                 failure:(CMNetworkFailureBlock)failureBlock {
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"page"] = [NSNumber numberWithUnsignedInteger:pageNo];
//    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
//    params[@"picUrl"] = picUrl;
//
//    self.createRequest.requestParameter = params;
//    [self.createRequest
//        startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
//            SARspModel *rspModel = response.extraData;
//            !successBlock ?: successBlock([TNPictureSearchRspModel yy_modelWithJSON:rspModel.data]);
//        }
//        failure:^(HDNetworkResponse *_Nonnull response) {
//            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
//        }];
//}
//
//- (void)querySimilarSearchJobWithTaskId:(NSString *)taskId success:(void (^)(TNPictureSearchRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"taskId"] = taskId;
//    if ([SAUser hasSignedIn]) {
//        params[@"operatorNo"] = [SAUser shared].operatorNo;
//    }
//    self.queryRequest.requestParameter = params;
//    [self.queryRequest
//        startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
//            SARspModel *rspModel = response.extraData;
//            !successBlock ?: successBlock([TNPictureSearchRspModel yy_modelWithJSON:rspModel.data]);
//        }
//        failure:^(HDNetworkResponse *_Nonnull response) {
//            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
//        }];
//}
//
///** @lazy createRequest */
//- (TNNetworkRequest *)createRequest {
//    if (!_createRequest) {
//        _createRequest = [[TNNetworkRequest alloc] init];
//        _createRequest.retryCount = 2;
//        _createRequest.requestURI = @"/tapi/sales/product/createSimilarSearchJob";
//        _createRequest.shouldAlertErrorMsgExceptSpecCode = NO;
//    }
//    return _createRequest;
//}
///** @lazy createRequest */
//- (TNNetworkRequest *)queryRequest {
//    if (!_queryRequest) {
//        _queryRequest = [[TNNetworkRequest alloc] init];
//        _queryRequest.retryCount = 2;
//        _queryRequest.requestURI = @"/tapi/sales/product/querySimilarSearchJob";
//        _queryRequest.shouldAlertErrorMsgExceptSpecCode = NO;
//    }
//    return _queryRequest;
//}

@end
