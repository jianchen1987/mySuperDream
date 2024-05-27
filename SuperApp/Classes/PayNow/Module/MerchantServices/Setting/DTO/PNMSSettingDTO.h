//
//  PNMSSettingDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSAgreementDataModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSSettingDTO : PNModel

/// 商户协议地址
- (void)getMSAgreementDataWithMerchantNo:(NSString *)merchantNo success:(void (^)(NSArray<PNMSAgreementDataModel *> *rspList))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
