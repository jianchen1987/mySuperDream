//
//  SAMessageManager.m
//  SuperApp
//
//  Created by seeu on 2021/8/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageManager.h"
#import "SAGeneralUtil.h"
#import "SAGetUnreadInnerMessageCountRspModel.h"
#import "SAMessageDTO.h"
#import <KSInstantMessagingKit/KSCore.h>


@interface SAMessageManager () <KSInstMsgChatProtocol, KSInstMsgConversationProtocol>
@property (nonatomic, strong) NSMutableArray<id<SAMessageManagerDelegate>> *listeners; ///< 监听者
@property (nonatomic, strong) SAMessageDTO *msgDTO;                                    ///<
@property (nonatomic, assign) NSTimeInterval minimumFetchInterval;                     ///< 最小拉取间隔
@property (nonatomic, strong) dispatch_group_t taskGroup;                              ///< 队列组
@property (nonatomic, strong) NSDate *lastSuccessDate;                                 ///< 上次更新时间
@end

static NSUInteger _MarketingMessageCount = 0;
static NSUInteger _PersonalMessageCount = 0;
static NSUInteger _ChatMessageCount = 0;
static SAMessageManager *_Instance = nil;


@implementation SAMessageManager

+ (instancetype)share {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _Instance = [[super allocWithZone:NULL] init];
        _Instance.minimumFetchInterval = 3;
        [KSInstMsgManager.share addChatListener:_Instance];
        [KSInstMsgManager.share addConversationListener:_Instance];
    });
    return _Instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self share];
}

- (void)getUnreadMessageCount:(nullable void (^)(NSUInteger count, NSDictionary<SAAppInnerMessageType, NSNumber *> *details))completion {
    if ([SAGeneralUtil getDiffValueUntilNowForDate:self.lastSuccessDate] < self.minimumFetchInterval) {
        HDLog(@"⚠️⚠️⚠️ 小于最小刷新时间，不刷新。");
        //解决im更新数不及时问题
        [KSInstMsgManager.share getConversationUnreadMsgCountWithCompletion:^(NSUInteger unreadCount) {
            _ChatMessageCount = unreadCount;
            !completion ?:
                          completion(
                    _MarketingMessageCount + _PersonalMessageCount + _ChatMessageCount,
                    @{SAAppInnerMessageTypeMarketing: @(_MarketingMessageCount),
                      SAAppInnerMessageTypePersonal: @(_PersonalMessageCount),
                      SAAppInnerMessageTypeChat: @(_ChatMessageCount)});
        }];
        return;
    }

    if (![SAUser hasSignedIn]) {
        !completion ?: completion(0, @{SAAppInnerMessageTypeMarketing: @(0), SAAppInnerMessageTypePersonal: @(0), SAAppInnerMessageTypeChat: @(0)});
        return;
    }

    @HDWeakify(self);
    dispatch_group_enter(self.taskGroup);
    [self.msgDTO getUnreadInnerMessageCountGroupByTypeWithClientTyle:SAClientTypeMaster success:^(SAGetUnreadInnerMessageCountRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        dispatch_group_leave(self.taskGroup);
        _MarketingMessageCount = rspModel.marketingMessageUnReadNumber;
        _PersonalMessageCount = rspModel.personalMessageUnReadNumber;
        self.lastSuccessDate = NSDate.new;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [KSInstMsgManager.share getConversationUnreadMsgCountWithCompletion:^(NSUInteger unreadCount) {
        @HDStrongify(self);
        dispatch_group_leave(self.taskGroup);
        _ChatMessageCount = unreadCount;
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        !completion ?:
                      completion(
                _MarketingMessageCount + _PersonalMessageCount + _ChatMessageCount,
                @{SAAppInnerMessageTypeMarketing: @(_MarketingMessageCount),
                  SAAppInnerMessageTypePersonal: @(_PersonalMessageCount),
                  SAAppInnerMessageTypeChat: @(_ChatMessageCount)});
        [self pushUnreadContChanged];
    });
}

- (void)updateMessageReadStateWithMessageNo:(NSString *)messageNo messageType:(SAAppInnerMessageType)type {
    @HDWeakify(self);
    [self.msgDTO updateMessageStatusToReadWithClientType:SAClientTypeMaster sendSerialNumber:messageNo success:^{
        @HDStrongify(self);
        if ([SAAppInnerMessageTypePersonal isEqualToString:type]) {
            _PersonalMessageCount = (_PersonalMessageCount - 1) < 0 ? 0 : (_PersonalMessageCount - 1);
        } else if ([type isEqualToString:SAAppInnerMessageTypeMarketing]) {
            _MarketingMessageCount = (_MarketingMessageCount - 1) < 0 ? 0 : (_MarketingMessageCount - 1);
        }

        [self pushUnreadContChanged];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

- (void)updateMessageReadStateWithMessageType:(SAAppInnerMessageType)type {
    @HDWeakify(self);
    [self.msgDTO updateMessageStatusToReadWithClientType:SAClientTypeMaster businessMessageType:type success:^{
        @HDStrongify(self);
        if ([SAAppInnerMessageTypePersonal isEqualToString:type]) {
            _PersonalMessageCount = 0;
        } else if ([type isEqualToString:SAAppInnerMessageTypeMarketing]) {
            _MarketingMessageCount = 0;
        }
        [self pushUnreadContChanged];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

- (void)updateAllMessageReadedWithCompletion:(nullable void (^)(void))completion {
    [self.msgDTO updateMessageStatusToReadWithClientType:SAClientTypeMaster sendSerialNumber:nil success:^{
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];

    [self p_updateAllChatReaded];
    [self pushRealAllMessage];
}

- (void)getMessageListForMessageCenterWithClientType:(SAClientType)clientType
                                             success:(void (^)(NSArray<SAMessageCenterListModel *> *_Nonnull))successBlock
                                             failure:(CMNetworkFailureBlock)failureBlock {
    [self.msgDTO getMessageListForMessageCenterWithClientType:clientType success:^(NSArray<SAMessageCenterListModel *> *_Nonnull list) {
        for (SAMessageCenterListModel *model in list) {
            if ([model.businessMessageType isEqualToString:SAAppInnerMessageTypeMarketing]) {
                _MarketingMessageCount = model.unReadNumber;
            } else if ([model.businessMessageType isEqualToString:SAAppInnerMessageTypePersonal]) {
                _PersonalMessageCount = model.unReadNumber;
            }
        }
        [self pushUnreadContChanged];
        !successBlock ?: successBlock(list);
    } failure:failureBlock];
}

- (void)p_updateAllChatReaded {
    [KSInstMsgManager.share readAllMessage:nil];
}

- (void)addListener:(id<SAMessageManagerDelegate>)listener {
    [self.listeners addObject:listener];
}
- (void)removeListener:(id<SAMessageManagerDelegate>)listener {
    [self.listeners removeObject:listener];
}


#pragma mark KSInstMsgChatProtocol
- (void)receivedMessages:(NSArray<KSMessageModel *> *)messages {
    @HDWeakify(self);
    //单独根据im未读数更新
    [KSInstMsgManager.share getConversationUnreadMsgCountWithCompletion:^(NSUInteger unreadCount) {
        @HDStrongify(self);
        _ChatMessageCount = unreadCount;
        [self pushUnreadContChanged];
    }];
}

#pragma mark - private methods
- (void)pushUnreadContChanged {
    for (id<SAMessageManagerDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(unreadMessageCountChanged:details:)]) {
            [listener unreadMessageCountChanged:(_MarketingMessageCount + _PersonalMessageCount + _ChatMessageCount) details:@{
                SAAppInnerMessageTypeMarketing: @(_MarketingMessageCount),
                SAAppInnerMessageTypePersonal: @(_PersonalMessageCount),
                SAAppInnerMessageTypeChat: @(_ChatMessageCount)
            }];
        }
    }
}

- (void)pushRealAllMessage {
    _PersonalMessageCount = 0;
    _MarketingMessageCount = 0;
    _ChatMessageCount = 0;
    for (id<SAMessageManagerDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(allMessageReaded)]) {
            [listener allMessageReaded];
        }
    }

    [self pushUnreadContChanged];
}

#pragma mark - KSInstMsgConversationProtocol
- (void)conversationTotalCountChanged:(NSInteger)unreadCount {
    _ChatMessageCount = unreadCount;
    [self pushUnreadContChanged];
}

#pragma mark - lazy load
/** @lazy listeners */
- (NSMutableArray<id<SAMessageManagerDelegate>> *)listeners {
    if (!_listeners) {
        _listeners = [[NSMutableArray alloc] init];
    }
    return _listeners;
}

/** @lazy msgdto */
- (SAMessageDTO *)msgDTO {
    if (!_msgDTO) {
        _msgDTO = [[SAMessageDTO alloc] init];
    }
    return _msgDTO;
}

/** @lazy taskgroup */
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}
@end
