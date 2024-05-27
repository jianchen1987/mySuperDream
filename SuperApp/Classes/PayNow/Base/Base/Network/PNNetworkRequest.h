//
//  PNNetworkRequest.h
//  SuperApp
//
//  Created by seeu on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDServiceKit/HDServiceKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PNRspModel;

typedef void (^PNNetworkSuccessBlock)(PNRspModel *rspModel);
typedef void (^PNNetworkSuccessVoidBlock)(void);
typedef void (^PNNetworkFailureBlock)(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error);


@interface PNNetworkRequest : SANetworkRequest

@property (nonatomic, assign) BOOL isNeedLogin; ///< 是否需要登录

/** 单个接口是否显示日志，默认 DEBUG 开，否则关 */
@property (nonatomic, assign) BOOL logEnabled;

/** 是否打印 response json string，默认 DEBUG 开，否则关，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldPrintRspJsonString;

/** 是否打印 params json string，默认 DEBUG 开，否则关，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldPrintParamJsonString;

/** 是否打印 headerFileds json string，默认 DEBUG 开，否则关，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldPrintHeaderFieldJsonString;

/** 除特定 code 外是否弹窗显示错误内容（特殊的指定 code 全局做处理，比如密码错误、异设备登录等），默认开启，caller 可自行设置 */
@property (nonatomic, assign) BOOL shouldAlertErrorMsgExceptSpecCode;

/** 是否需要sessionKey，默认关闭，某些接口需要传 session 至 headerField 中 */
@property (nonatomic, assign) BOOL needSessionKey;

@end

NS_ASSUME_NONNULL_END
