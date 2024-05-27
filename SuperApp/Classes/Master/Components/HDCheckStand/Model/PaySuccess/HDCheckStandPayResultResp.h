//
//  HDCheckStandPayResultResp.h
//  SuperApp
//
//  Created by VanJay on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HDCheckStandPayResultErrorType) {
    HDCheckStandPayResultErrorTypeAppNotInstalled = -998,   ///< App未安装
    HDCheckStandPayResultErrorTypeAppApiNotSupport = -999,  ///< App API 版本不支持
    HDCheckStandPayResultErrorTypeAppParamsInValid = -1000, ///< 支付参数无效
    HDCheckStandPayResultErrorTypeStatusUnknown = -2000     ///< 支付状态未知
};

/// 支付成功
@interface HDCheckStandPayResultResp : SAModel
/** 错误码 */
@property (nonatomic, assign) HDCheckStandPayResultErrorType errCode;
/** 错误提示字符串 */
@property (nonatomic, copy) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
