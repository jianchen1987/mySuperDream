//
//  PNMSReceiveCodeDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSStoreOperatorInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSReceiveCodeDTO : PNModel

/// 获取收款码
- (void)genQRCode:(NSDictionary *)params success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 根据loginName 查商户角色权限详情
- (void)getMerRoleDetail:(void (^)(PNMSStoreOperatorInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 检查qrData 是否可用
- (void)checkQRData:(NSString *)qrData success:(void (^)(BOOL rspValue))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
