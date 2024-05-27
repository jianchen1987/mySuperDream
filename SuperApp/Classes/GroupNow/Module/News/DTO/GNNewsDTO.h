//
//  GNNewsDTO.h
//  SuperApp
//
//  Created by wmz on 2021/7/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "GNNewsPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNNewsDTO : GNModel

/// 获取消息列表
/// @param page 页码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getMessageListWithPage:(NSUInteger)page success:(void (^)(GNNewsPagingRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 修改消息为已读
/// @param sendSerialNumber 消息发送流水号（传空全部已读）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)updateMessageStatusToReadWithSendSerialNumber:(NSString *_Nullable)sendSerialNumber
                                                            success:(void (^_Nullable)(void))successBlock
                                                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 查询未读消息
/// @param successBlock 回调
- (void)getUnreadSystemMessageCountBlock:(void (^)(NSUInteger station))successBlock;

@end

NS_ASSUME_NONNULL_END
