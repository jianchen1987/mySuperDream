//
//  PayHDCheckstandPaymentUserInfoModel.h
//  ViPay
//
//  Created by seeu on 2019/11/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDBaseCodingObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCheckstandPaymentUserInfoModel : HDBaseCodingObject

@property (nonatomic, copy) NSString *title; ///< 标题
@property (nonatomic, copy) NSString *desc;  ///< 描述

@end

NS_ASSUME_NONNULL_END
