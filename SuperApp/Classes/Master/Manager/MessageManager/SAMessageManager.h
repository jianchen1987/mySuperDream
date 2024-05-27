//
//  SAMessageManager.h
//  SuperApp
//
//  Created by seeu on 2021/8/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import <Foundation/Foundation.h>
#import "SAMessageCenterListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SAMessageManagerDelegate <NSObject>

@optional
- (void)unreadMessageCountChanged:(NSUInteger)count details:(NSDictionary<SAAppInnerMessageType, NSNumber *> *)details;
- (void)allMessageReaded;

@end


@interface SAMessageManager : NSObject

+ (__nonnull instancetype)share;

- (instancetype)init __attribute__((unavailable("Use +share instead.")));

- (void)getUnreadMessageCount:(nullable void (^)(NSUInteger count, NSDictionary<SAAppInnerMessageType, NSNumber *> *details))completion;

- (void)updateMessageReadStateWithMessageNo:(NSString *)messageNo messageType:(SAAppInnerMessageType)type;

- (void)updateMessageReadStateWithMessageType:(SAAppInnerMessageType)type;

/// 获取消息列表
/// @param clientType 客户端类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getMessageListForMessageCenterWithClientType:(SAClientType)clientType success:(void (^)(NSArray<SAMessageCenterListModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 所有消息置为已读
/// @param completion 成功回调
- (void)updateAllMessageReadedWithCompletion:(nullable void (^)(void))completion;

- (void)addListener:(id<SAMessageManagerDelegate>)listener;
- (void)removeListener:(id<SAMessageManagerDelegate>)listener;

@end

NS_ASSUME_NONNULL_END
