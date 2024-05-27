//
//  PNMSForgotPasswordVerifySMSCodeController.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    PNMSVerifySMSCodeType_Nor = 0,      ///< 用户商户自己操作 - 超管
    PNMSVerifySMSCodeType_Operator = 1, ///< 非超管
} PNMSVerifySMSCodeType;


@interface PNMSForgotPasswordVerifySMSCodeController : PNViewController

@end

NS_ASSUME_NONNULL_END
