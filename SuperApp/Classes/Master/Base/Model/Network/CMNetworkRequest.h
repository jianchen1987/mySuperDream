//
//  CMNetworkRequest.h
//  SuperApp
//
//  Created by VanJay on 2020/3/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDNetworkResponse+CM.h"
#import <HDServiceKit/HDServiceKit.h>

@class SARspModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^CMNetworkSuccessBlock)(SARspModel *rspModel);
typedef void (^CMNetworkSuccessVoidBlock)(void);
typedef void (^_Nullable CMNetworkFailureBlock)(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error);


@interface CMNetworkRequest : SANetworkRequest

@property (nonatomic, assign) BOOL isNeedLogin; ///< 是否需要登录

/** 单个接口是否显示日志，默认 DEBUG 开，否则关 */
@property (nonatomic, assign) BOOL logEnabled;

/** 是否打印 response json string，默认 DEBUG 开，否则关，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldPrintRspJsonString;

/** 是否打印 params json string，默认 DEBUG 开，否则关，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldPrintParamJsonString;

/** 是否打印 headerFileds json string，默认 DEBUG 开，否则关，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldPrintHeaderFieldJsonString;

///< 是否打印详细请求日志， 默认关
@property (nonatomic, assign) BOOL shouldPrintNetworkDetailLog;

/** 除特定 code 外是否弹窗显示错误内容（特殊的指定 code 全局做处理，比如密码错误、异设备登录等），默认开启，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldAlertErrorMsgExceptSpecCode;

///< 是否需要记录埋点,默认记录
@property (nonatomic, assign) BOOL shouldRecordAndReport;

@end

NS_ASSUME_NONNULL_END
