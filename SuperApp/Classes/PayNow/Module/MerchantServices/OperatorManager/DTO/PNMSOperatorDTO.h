//
//  PNMSOperatorDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSOperatorInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOperatorDTO : PNModel
/// 获取操作员列表数据
- (void)getOperatorListData:(void (^)(NSArray<PNMSOperatorInfoModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 保存/修改 商户服务操作员
- (void)saveOrUpdateOperator:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询商户服务操作员权限详情
- (void)getOperatorDetail:(NSString *)operatorMobile success:(void (^)(PNMSOperatorInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 重置操作员支付密码
- (void)reSetOperatorPwdSendSMS:(NSString *)operatorMobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 解除绑定 操作员
- (void)unBindOperator:(NSString *)operatorMobile success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 通过手机号码反查 账号信息
- (void)getCCAmountWithMobile:(NSString *)mobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
