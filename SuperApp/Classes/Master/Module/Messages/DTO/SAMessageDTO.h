//
//  SAMessageDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASystemMessageRspModel.h"
#import "SAViewModel.h"

@class SAMessageDetailRspModel;
@class SAGetUnreadInnerMessageCountRspModel;
@class SAMessageCenterListModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageDTO : SAViewModel

/// 获取消息列表
/// @param clientType 客户端类型
/// @param type 类型
/// @param pageSize 分页大小
/// @param page 页码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getMessageListWithClientType:(SAClientType)clientType
                                type:(SAAppInnerMessageType)type
                            pageSize:(NSUInteger)pageSize
                                page:(NSUInteger)page
                             success:(void (^)(SASystemMessageRspModel *rspModel))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询站内信详情
/// @param clientType 客户端类型
/// @param messageNo 消息id
/// @param sendSerialNumber 消息发送流水号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getMessageDetailWithClientType:(SAClientType)clientType
                             messageNo:(NSString *_Nullable)messageNo
                      sendSerialNumber:(NSString *)sendSerialNumber
                               success:(void (^)(SAMessageDetailRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询未读消息数量(站内信，im）
/// @param clientType 客户端类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
//- (void)getUnreadStationMessageCountWithClientType:(SAClientType)clientType success:(void (^)(NSUInteger station, NSUInteger im))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询未读站内信
/// @param clientType 业务线
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
//- (void)getUnreadSystemMessageCountWithClientType:(SAClientType)clientType success:(void (^)(NSUInteger station))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取未读消息数，按类型分组
/// @param clientType 业务线
/// @param success 成功回调
/// @param failure 失败回调
- (void)getUnreadInnerMessageCountGroupByTypeWithClientTyle:(SAClientType)clientType
                                                    success:(void (^)(SAGetUnreadInnerMessageCountRspModel *rspModel))success
                                                    failure:(CMNetworkFailureBlock _Nullable)failure;

/// 修改消息为已读
/// @param clientType 客户端类型
/// @param sendSerialNumber 消息发送流水号（传空全部已读）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)updateMessageStatusToReadWithClientType:(SAClientType)clientType
                               sendSerialNumber:(NSString *_Nullable)sendSerialNumber
                                        success:(void (^_Nullable)(void))successBlock
                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 修改消息为已读
/// @param clientType 客户端类型
/// @param businessMessageType  10-营销消息,11- 个人消息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)updateMessageStatusToReadWithClientType:(SAClientType)clientType
                            businessMessageType:(NSString *_Nullable)businessMessageType
                                        success:(void (^_Nullable)(void))successBlock
                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取消息列表
/// @param clientType 客户端类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getMessageListForMessageCenterWithClientType:(SAClientType)clientType success:(void (^)(NSArray<SAMessageCenterListModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
