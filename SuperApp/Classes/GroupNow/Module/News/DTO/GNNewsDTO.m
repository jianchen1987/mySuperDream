//
//  GNNewsDTO.m
//  SuperApp
//
//  Created by wmz on 2021/7/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsDTO.h"
#import "SAMessageDetailRspModel.h"
#import "SASystemMessageModel.h"
#import "SAUser.h"


@interface GNNewsDTO ()
/// 消息列表
@property (nonatomic, strong) CMNetworkRequest *messageListRequest;
/// 更新阅读状态
@property (nonatomic, strong) CMNetworkRequest *updateMessageStatusRequest;
/// 查询未读数量
@property (nonatomic, strong) CMNetworkRequest *unreadStationRequest;

@end


@implementation GNNewsDTO

- (void)dealloc {
    [_messageListRequest cancel];
    [_unreadStationRequest cancel];
    [_updateMessageStatusRequest cancel];
}

- (CMNetworkRequest *)getMessageListWithPage:(NSUInteger)page success:(void (^)(GNNewsPagingRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = SAClientTypeGroupBuy;
    params[@"pageSize"] = @(10);
    params[@"pageNum"] = @(page);
    self.messageListRequest.requestParameter = params;
    [self.messageListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([GNNewsPagingRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.messageListRequest;
}

- (CMNetworkRequest *)updateMessageStatusToReadWithSendSerialNumber:(NSString *_Nullable)sendSerialNumber
                                                            success:(void (^_Nullable)(void))successBlock
                                                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = SAClientTypeGroupBuy;
    params[@"sendSerialNumber"] = sendSerialNumber;
    self.updateMessageStatusRequest.requestParameter = params;
    [self.updateMessageStatusRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.updateMessageStatusRequest;
}

- (void)getUnreadSystemMessageCountBlock:(void (^)(NSUInteger station))successBlock {
    if (!SAUser.hasSignedIn) {
        !successBlock ?: successBlock(0);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = SAClientTypeGroupBuy;
    self.unreadStationRequest.requestParameter = params;
    [self.unreadStationRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSUInteger unReadCount = [[((NSDictionary *)rspModel.data) valueForKey:@"unRendNumber"] integerValue];
        !successBlock ?: successBlock(unReadCount);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(0);
    }];
}

#pragma mark - lazy load
- (CMNetworkRequest *)messageListRequest {
    if (!_messageListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.isNeedLogin = YES;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        request.requestURI = @"/notification/app/stationLetter/list.do";
        _messageListRequest = request;
    }
    return _messageListRequest;
}

- (CMNetworkRequest *)updateMessageStatusRequest {
    if (!_updateMessageStatusRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.isNeedLogin = YES;
        request.requestURI = @"/notification/app/stationLetter/updateReadStatus.do";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _updateMessageStatusRequest = request;
    }
    return _updateMessageStatusRequest;
}

- (CMNetworkRequest *)unreadStationRequest {
    if (!_unreadStationRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.isNeedLogin = YES;
        request.requestURI = @"/notification/app/stationLetter/count.do";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _unreadStationRequest = request;
    }
    return _unreadStationRequest;
}

@end
