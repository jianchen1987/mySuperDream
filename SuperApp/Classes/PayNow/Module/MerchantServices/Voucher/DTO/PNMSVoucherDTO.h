//
//  PNMSVoucherDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSVoucherInfoModel;
@class PNMSVoucherRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSVoucherDTO : PNModel

/// 查询门店上传凭证纪录列表
/// 查询门店上传凭证纪录列表
- (void)getVoucherList:(NSDictionary *)param success:(void (^)(PNMSVoucherRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 新增一条门店上传凭证记录
- (void)saveVoucher:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取凭证详情
- (void)getVoucherDetail:(NSString *)voucherId success:(void (^)(PNMSVoucherInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
