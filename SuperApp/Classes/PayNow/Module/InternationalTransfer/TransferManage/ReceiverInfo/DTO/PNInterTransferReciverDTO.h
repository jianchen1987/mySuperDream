//
//  PNInterTransferReciverDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
@class PNInterTransferRelationModel;
@class PNInterTransferReciverModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferReciverDTO : PNModel
/// 查询收款人列表
- (void)queryAllReciverListWithChannel:(PNInterTransferThunesChannel)channel success:(void (^)(NSArray<PNInterTransferReciverModel *> *list))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// 通过收款人id 查询收款人数据
- (void)queryReciverByReciverIds:(NSArray *)ids success:(void (^_Nullable)(NSArray<PNInterTransferReciverModel *> *list))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询关系列表
- (void)queryRelationListSuccess:(void (^_Nullable)(NSArray<PNInterTransferRelationModel *> *list))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 保存收款人
- (void)saveReciverInfoWithModel:(PNInterTransferReciverModel *)reciverModel
                         channel:(PNInterTransferThunesChannel)channel
                         success:(void (^_Nullable)(void))successBlock
                         failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 修改收款人
- (void)updateReciverInfoWithModel:(PNInterTransferReciverModel *)reciverModel
                           channel:(PNInterTransferThunesChannel)channel
                           success:(void (^_Nullable)(void))successBlock
                           failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 删除收款人
- (void)deleteReciverInfoWithModel:(PNInterTransferReciverModel *)reciverModel success:(void (^_Nullable)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
