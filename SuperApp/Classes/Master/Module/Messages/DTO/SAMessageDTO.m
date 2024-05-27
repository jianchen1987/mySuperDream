//
//  SAMessageDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMessageDTO.h"
#import "SAGetUnreadInnerMessageCountRspModel.h"
#import "SAMessageDetailRspModel.h"
#import "SANotificationConst.h"
#import "SASystemMessageModel.h"
#import <KSInstantMessagingKit/KSCore.h>
#import "SAMessageCenterListModel.h"


@interface SAMessageDTO ()

@property (nonatomic, strong) dispatch_group_t taskGroup; ///< 任务组

@end


@implementation SAMessageDTO

- (void)getMessageListWithClientType:(SAClientType)clientType
                                type:(SAAppInnerMessageType)type
                            pageSize:(NSUInteger)pageSize
                                page:(NSUInteger)page
                             success:(void (^)(SASystemMessageRspModel *_Nonnull))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = [clientType isEqualToString:SAClientTypeMaster] ? @"" : clientType;
    if (![SAAppInnerMessageTypeAll isEqualToString:type]) {
        params[@"businessMessageType"] = type;
    }
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(page);

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/app/stationLetter/list.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SASystemMessageRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getMessageDetailWithClientType:(SAClientType)clientType
                             messageNo:(NSString *)messageNo
                      sendSerialNumber:(NSString *)sendSerialNumber
                               success:(void (^)(SAMessageDetailRspModel *_Nonnull))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = [clientType isEqualToString:SAClientTypeMaster] ? @"" : clientType;
    params[@"messageNo"] = messageNo;
    params[@"sendSerialNumber"] = sendSerialNumber;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/app/stationLetter/detail.do";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAMessageDetailRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getUnreadInnerMessageCountGroupByTypeWithClientTyle:(SAClientType)clientType
                                                    success:(void (^)(SAGetUnreadInnerMessageCountRspModel *rspModel))success
                                                    failure:(CMNetworkFailureBlock _Nullable)failure {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/app/stationLetter/countUnreadMessage.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = [clientType isEqualToString:SAClientTypeMaster] ? @"" : clientType;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !success ?: success([SAGetUnreadInnerMessageCountRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failure ?: failure(response.extraData, response.errorType, response.error);
    }];
}

- (void)getUnreadStationMessageCountWithClientType:(SAClientType)clientType success:(void (^)(NSUInteger station, NSUInteger im))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    static NSUInteger unReadStation = 0;
    static NSUInteger unReadIM = 0;

    @HDWeakify(self);
    dispatch_group_enter(self.taskGroup);
    [self p_getUnreadStationMessageCountWithClientType:clientType finish:^(NSUInteger count) {
        @HDStrongify(self);
        unReadStation = count;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self p_getUnreadIMCountWithFinish:^(NSUInteger count) {
        @HDStrongify(self);
        unReadIM = count;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        !successBlock ?: successBlock(unReadStation, unReadIM);
    });
}

- (void)getUnreadSystemMessageCountWithClientType:(SAClientType)clientType success:(void (^)(NSUInteger station))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self p_getUnreadStationMessageCountWithClientType:clientType finish:^(NSUInteger count) {
        successBlock(count);
    }];
}

- (void)p_getUnreadStationMessageCountWithClientType:(SAClientType)clientType finish:(void (^)(NSUInteger))finishBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/app/stationLetter/count.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = [clientType isEqualToString:SAClientTypeMaster] ? @"" : clientType;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSUInteger unReadCount = [[((NSDictionary *)rspModel.data) valueForKey:@"unRendNumber"] integerValue];
        !finishBlock ?: finishBlock(unReadCount);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !finishBlock ?: finishBlock(0);
    }];
}

- (void)p_getUnreadIMCountWithFinish:(void (^)(NSUInteger))finishBlock {
    [KSInstMsgManager.share getConversationUnreadMsgCountWithCompletion:^(NSUInteger count) {
        !finishBlock ?: finishBlock(count);
    }];
}

- (void)updateMessageStatusToReadWithClientType:(SAClientType)clientType
                               sendSerialNumber:(NSString *)sendSerialNumber
                                        success:(void (^)(void))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    [self _updateMessageStatusToReadWithClientType:clientType sendSerialNumber:sendSerialNumber businessMessageType:nil success:successBlock failure:failureBlock];
}

- (void)updateMessageStatusToReadWithClientType:(SAClientType)clientType
                            businessMessageType:(NSString *)businessMessageType
                                        success:(void (^)(void))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    [self _updateMessageStatusToReadWithClientType:clientType sendSerialNumber:nil businessMessageType:businessMessageType success:successBlock failure:failureBlock];
}

- (void)_updateMessageStatusToReadWithClientType:(SAClientType)clientType
                                sendSerialNumber:(NSString *)sendSerialNumber
                             businessMessageType:(NSString *)businessMessageType
                                         success:(void (^)(void))successBlock
                                         failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = [clientType isEqualToString:SAClientTypeMaster] ? @"" : clientType;
    params[@"sendSerialNumber"] = sendSerialNumber;
    params[@"businessMessageType"] = businessMessageType;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/app/stationLetter/updateReadStatus.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getMessageListForMessageCenterWithClientType:(SAClientType)clientType
                                             success:(nonnull void (^)(NSArray<SAMessageCenterListModel *> *_Nonnull))successBlock
                                             failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessLine"] = [clientType isEqualToString:SAClientTypeMaster] ? @"" : clientType;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/app/stationLetter/listGroupByBusinessMessageType.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAMessageCenterListModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - lazy load

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

@end
