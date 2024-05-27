//
//  WMReviewsDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMReviewsDTO.h"
#import "WMProductReviewCountRspModel.h"
#import "WMProductReviewListRspModel.h"
#import "WMStoreReviewCountRspModel.h"
#import "WMStoreScoreRepModel.h"
#import "WMUserReviewStoreInfoModel.h"


@interface WMReviewsDTO ()
/// 我的评论
@property (nonatomic, strong) CMNetworkRequest *queryMyReviewListRequest;
/// 获取门店评论列表
@property (nonatomic, strong) CMNetworkRequest *queryStoreReviewListRequest;
/// 获取商品评论列表
@property (nonatomic, strong) CMNetworkRequest *queryStoreProductReviewListRequest;
/// 获取门店评论数量
@property (nonatomic, strong) CMNetworkRequest *queryStoreReviewCountRequest;
/// 获取商品评论数量
@property (nonatomic, strong) CMNetworkRequest *queryStoreProductReviewCountRequest;
/// 订单评论
@property (nonatomic, strong) CMNetworkRequest *orderEvaluationRequest;
/// 获取门店评分
@property (nonatomic, strong) CMNetworkRequest *storeScoreRequest;

@end


@implementation WMReviewsDTO
- (void)dealloc {
    [_queryMyReviewListRequest cancel];
    [_queryStoreReviewListRequest cancel];
    [_queryStoreProductReviewListRequest cancel];
    [_queryStoreReviewCountRequest cancel];
    [_queryStoreProductReviewCountRequest cancel];
}

- (CMNetworkRequest *)queryMyReviewListWithPageSize:(NSUInteger)pageSize
                                            pageNum:(NSUInteger)pageNum
                                            success:(void (^_Nullable)(WMProductReviewListRspModel *rspModel))successBlock
                                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    self.queryMyReviewListRequest.requestParameter = params;
    [self.queryMyReviewListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMProductReviewListRspModel *model = [WMProductReviewListRspModel yy_modelWithJSON:rspModel.data];
        for (WMStoreProductReviewModel *reviewModel in model.list) {
            // 绑定门店信息
            for (WMUserReviewStoreInfoModel *storeInfoModel in model.stores.res) {
                if ([reviewModel.storeNo isEqualToString:storeInfoModel.storeNo]) {
                    reviewModel.storeInfo = storeInfoModel;
                }
            }
        }
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryMyReviewListRequest;
}

- (CMNetworkRequest *)queryStoreProductReviewListWithStoreNo:(NSString *)storeNo
                                                        type:(WMReviewFilterType)type
                                          hasDetailCondition:(WMReviewFilterConditionHasDetail)hasDetailCondition
                                                    pageSize:(NSUInteger)pageSize
                                                     pageNum:(NSUInteger)pageNum
                                                     success:(void (^_Nullable)(WMProductReviewListRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"storeReviewType"] = type;
    params[@"hasReviewDetail"] = hasDetailCondition;
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    self.queryStoreReviewListRequest.requestParameter = params;
    [self.queryStoreReviewListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMProductReviewListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryStoreReviewListRequest;
}

- (CMNetworkRequest *)queryStoreProductReviewListWithGoodsId:(NSString *)goodsId
                                                        type:(WMReviewFilterType)type
                                          hasDetailCondition:(WMReviewFilterConditionHasDetail)hasDetailCondition
                                                    pageSize:(NSUInteger)pageSize
                                                     pageNum:(NSUInteger)pageNum
                                                     success:(void (^_Nullable)(WMProductReviewListRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"itemId"] = goodsId;
    params[@"itemReviewType"] = type;
    params[@"hasReviewDetail"] = hasDetailCondition;
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    self.queryStoreProductReviewListRequest.requestParameter = params;
    [self.queryStoreProductReviewListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMProductReviewListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryStoreProductReviewListRequest;
}

- (CMNetworkRequest *)queryStoreReviewCountInfoWithStoreNo:(NSString *)storeNo
                                                   success:(void (^_Nullable)(WMStoreReviewCountRspModel *rspModel))successBlock
                                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    self.queryStoreReviewCountRequest.requestParameter = params;
    [self.queryStoreReviewCountRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMStoreReviewCountRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryStoreReviewCountRequest;
}

- (CMNetworkRequest *)queryStoreProductReviewCountInfoWithGoodsId:(NSString *)goodsId
                                                          success:(void (^_Nullable)(WMProductReviewCountRspModel *rspModel))successBlock
                                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"itemId"] = goodsId;
    self.queryStoreProductReviewCountRequest.requestParameter = params;
    [self.queryStoreProductReviewCountRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMProductReviewCountRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryStoreProductReviewCountRequest;
}

- (CMNetworkRequest *)orderEvaluationWithOrderNo:(NSString *)orderNo
                                         storeNo:(NSString *)storeNo
                                      riderScore:(double)riderScore
                                      storeScore:(double)storeScore
                                 deliveryContent:(NSString*)deliveryContent
                                         content:(nonnull NSString *)content
                                       anonymous:(WMReviewAnonymousState)anonymous
                                          images:(nonnull NSArray *)images
                                    businessline:(nonnull NSString *)businessline
                           itemReviewInfoReqDTOS:(nonnull NSArray *)itemReviewInfoReqDTOS
                                         success:(nonnull void (^)(void))successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    params[@"orderNo"] = orderNo;
    params[@"deliveryScore"] = @(riderScore);
    params[@"storeScore"] = @(storeScore);
    params[@"content"] = content;
    if(deliveryContent){
        params[@"deliveryContent"] = deliveryContent;
    }
    params[@"anonymous"] = @(anonymous);
    params[@"businessline"] = businessline;
    params[@"itemReviewInfoReqDTOS"] = itemReviewInfoReqDTOS;
    params[@"imageUrls"] = images;
    self.orderEvaluationRequest.requestParameter = params;
    [self.orderEvaluationRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.orderEvaluationRequest;
}

- (void)getStoreReviewsScoreWithStoreNo:(NSString *)storeNo success:(void (^)(WMStoreScoreRepModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    self.storeScoreRequest.requestParameter = params;
    [self.storeScoreRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMStoreScoreRepModel *model = [WMStoreScoreRepModel yy_modelWithJSON:rspModel.data];
        // 生成数据源
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - lazy load

- (CMNetworkRequest *)queryMyReviewListRequest {
    if (!_queryMyReviewListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/app/mobile-app-composition/comment/list/v1";
        request.isNeedLogin = true;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _queryMyReviewListRequest = request;
    }
    return _queryMyReviewListRequest;
}

- (CMNetworkRequest *)queryStoreReviewListRequest {
    if (!_queryStoreReviewListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/discovery/review/queryStoreReview.do";
        request.isNeedLogin = NO;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _queryStoreReviewListRequest = request;
    }
    return _queryStoreReviewListRequest;
}

- (CMNetworkRequest *)queryStoreProductReviewListRequest {
    if (!_queryStoreProductReviewListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/discovery/review/queryItemReview.do";
        request.isNeedLogin = NO;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _queryStoreProductReviewListRequest = request;
    }
    return _queryStoreProductReviewListRequest;
}

- (CMNetworkRequest *)queryStoreReviewCountRequest {
    if (!_queryStoreReviewCountRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/discovery/review/queryStoreReviewCount.do";
        request.isNeedLogin = NO;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _queryStoreReviewCountRequest = request;
    }
    return _queryStoreReviewCountRequest;
}

- (CMNetworkRequest *)queryStoreProductReviewCountRequest {
    if (!_queryStoreProductReviewCountRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/discovery/review/queryItemReviewCount.do";
        request.isNeedLogin = NO;
        _queryStoreProductReviewCountRequest = request;
    }
    return _queryStoreProductReviewCountRequest;
}

- (CMNetworkRequest *)orderEvaluationRequest {
    if (!_orderEvaluationRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/discovery/review/orderRewiew/add.do";
        request.isNeedLogin = YES;
        _orderEvaluationRequest = request;
    }
    return _orderEvaluationRequest;
}

- (CMNetworkRequest *)storeScoreRequest {
    if (!_storeScoreRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/discovery/review/queryScore.do";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        request.isNeedLogin = NO;
        _storeScoreRequest = request;
    }
    return _storeScoreRequest;
}

@end
