//
//  PNMSHomeDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSInfoModel;
@class PNMSBalanceInfoModel;
@class PNMSBaseInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSHomeDTO : PNModel

/// 用户绑定商户信息概览【overall】
- (void)getMerchantServicesInfo:(void (^)(PNMSInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 商户服务-商户服务首页【balance】
- (void)getMSHomeBalance:(void (^)(NSArray<PNMSBalanceInfoModel *> *rspList))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 商户基本信息
- (void)getMerchantServicesBaseInfo:(void (^)(PNMSBaseInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 解除跟商户绑定
- (void)unBindMerchantServiceWithMerchantNo:(NSString *)merchantNo
                                 operatorNo:(NSString *)operatorNo
                                      index:(NSString *)index
                                        pwd:(NSString *)pwd
                                    success:(void (^)(PNRspModel *rspModel))successBlock
                                    failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
