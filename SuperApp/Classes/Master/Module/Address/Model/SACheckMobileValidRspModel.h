//
//  SACheckMobileValidRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACheckMobileValidRspModel : SACodingModel

@property (nonatomic, assign) BOOL isNeedSms;       ///< 是否需要短信校验
@property (nonatomic, assign) NSUInteger smsReason; ///< 校验原因

@end

NS_ASSUME_NONNULL_END
