//
//  PNPacketFriendsDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNPacketFriendsUserModel;
@class PNPacketWOWNOWUserRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketFriendsDTO : PNModel
/// 近期与往来人员列表接口
- (void)getgetNearTransList:(void (^_Nullable)(NSArray<PNPacketFriendsUserModel *> *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查找中台的收用户
- (void)searchUserForWOWNOW:(NSString *)mobile
                     pageNo:(NSInteger)pageNo
                   pageSize:(NSInteger)pageSize
                    success:(void (^_Nullable)(PNPacketWOWNOWUserRspModel *rspModel))successBlock
                    failure:(HDRequestFailureBlock)failure;

/// 查找支付的用户
- (void)searchUserForCoolCash:(NSString *)loginNames success:(void (^_Nullable)(NSArray<PNPacketFriendsUserModel *> *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
