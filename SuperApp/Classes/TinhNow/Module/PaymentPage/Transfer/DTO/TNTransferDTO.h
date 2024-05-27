//
//  TNTransferDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNGuideRspModel;
@class TNTransferRspModel;
@class TNTransferSubmitModel;
@class TNContactCustomerServiceModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNTransferDTO : TNModel
/// 获取流程指导之类的数据
/// @param advId 类型id   如何转账传50004
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryGuideDataByAdvId:(NSString *)advId Success:(void (^_Nullable)(TNGuideRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取转账付款数据
/// @param orderNo 订单id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryTransferDataByOrderNo:(NSString *)orderNo Success:(void (^_Nullable)(TNTransferRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 提交转账凭证
/// @param submitModel 参数模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)saveTransferCredentiaDataBySubmitModel:(TNTransferSubmitModel *)submitModel Success:(void (^_Nullable)(BOOL isSuccess))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取联系客服数据
/// @param successBlock 返回客服字典 key 取值 PhoneCall-电话客服 Telegram-电报客服 Other-其他方式
/// @param failureBlock 失败回调
- (void)queryContactCustomerServiceWithSuccess:(void (^_Nullable)(TNContactCustomerServiceModel *model))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
