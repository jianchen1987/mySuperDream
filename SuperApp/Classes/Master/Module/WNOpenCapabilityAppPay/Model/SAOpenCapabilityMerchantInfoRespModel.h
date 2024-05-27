//
//  SAOpenCapabilityMerchantInfoRespModel.h
//  SuperApp
//
//  Created by seeu on 2021/11/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOpenCapabilityMerchantInfoRespModel : SACodingModel

@property (nonatomic, copy) NSString *merchantNo;                        ///< 一级商户号
@property (nonatomic, strong) SAInternationalizationModel *merchantName; ///< 商户名
@property (nonatomic, copy) NSString *merchantType;                      ///< 商户类型
@property (nonatomic, copy) NSString *merLogo;                           ///< 商户logo

@end

NS_ASSUME_NONNULL_END
