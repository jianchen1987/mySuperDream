//
//  PNNetworkRequest.m
//  SuperApp
//
//  Created by seeu on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNNetworkRequest.h"
#import "HDReflushTokenRspModel.h"
#import "LKDataRecord.h"
#import "PNRspModel.h"
#import "PNUtilMacro.h"
#import "SAAppEnvManager.h"
#import "SAGeneralUtil.h"
#import "SAGuardian.h"
#import "SARefreshAccessTokenRspModel.h"
#import "SAUser.h"
#import "SAVersionAlertManager.h"
#import "SAVersionAlertViewConfig.h"
#import "SAVersionBaseAlertView.h"
#import "SAWindowManager.h"
#import "VipayUser.h"
#import <HDUIKit/NAT.h>

/// 换取支付token
static NSString *const kExchangeToken = @"/login/exchangeToken.do";
/// 刷新 accessToken URI [中台的]
static NSString *const kRefreshAccessTokenURI = @"/authcenter/token/refresh.do";


@interface PNNetworkRequest ()

// 以下 block 用于刷新 accessToken 后重新发起业务请求
@property (nonatomic, copy, nullable) HDRequestProgressBlock pn_uploadProgress;
@property (nonatomic, copy, nullable) HDRequestProgressBlock pn_downloadProgress;
@property (nonatomic, copy, nullable) HDRequestCacheBlock pn_cacheBlock;
@property (nonatomic, copy, nullable) HDRequestSuccessBlock pn_successBlock;
@property (nonatomic, copy, nullable) HDRequestFailureBlock pn_failureBlock;

@end


@implementation PNNetworkRequest

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        self.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.payServiceURL;
        self.requestMethod = HDRequestMethodPOST;

#ifdef DEBUG
        self.logEnabled = true;
#else
        self.logEnabled = false;
#endif

        self.shouldPrintHeaderFieldJsonString = NO;
        self.shouldPrintParamJsonString = NO;
        self.shouldPrintRspJsonString = NO;

        // 默认需要登录
        self.isNeedLogin = true;
        // 默认显示弹窗
        self.shouldAlertErrorMsgExceptSpecCode = YES;
        self.requestTimeoutInterval = 20;
        // 设置重试间隔
        self.retryInterval = 3;
        // 设置重试步进
        self.isRetryProgressive = YES;
        // 默认不需要sessionKey
        self.needSessionKey = YES;

        // 监听线路切换
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeAppEnvSuccess) name:kNotificationNameChangeAppEnvSuccess object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameChangeAppEnvSuccess object:self];
}

#pragma mark - Notification
- (void)changeAppEnvSuccess {
    self.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.payServiceURL;
}

#pragma mark - override
- (void)startWithUploadProgress:(HDRequestProgressBlock)uploadProgress
               downloadProgress:(HDRequestProgressBlock)downloadProgress
                          cache:(HDRequestCacheBlock)cache
                        success:(HDRequestSuccessBlock)success
                        failure:(HDRequestFailureBlock)failure {
    //    if (![self.requestURI isEqualToString:kExchangeToken]) {
    self.pn_uploadProgress = uploadProgress;
    self.pn_downloadProgress = downloadProgress;
    self.pn_cacheBlock = cache;
    self.pn_successBlock = success;
    self.pn_failureBlock = failure;

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:self.requestParameter];
    [paramDict setObject:@"userApp" forKey:@"appType"];

    /// 业务参数里面如果已经有了 loginName 则不再设置
    if ([VipayUser shareInstance].loginName.length > 0) {
        [paramDict setValue:[VipayUser shareInstance].loginName forKey:@"loginName"];
        [paramDict setValue:VipayUser.shareInstance.userNo forKey:@"userNo"];
    }
    self.requestParameter = paramDict;
    //    }

#ifdef DEBUG
    if (self.shouldPrintParamJsonString) {
        HDLog(@"%@", self.requestParameter);
    }
#endif
    [super startWithUploadProgress:uploadProgress downloadProgress:downloadProgress cache:cache success:success failure:failure];
}

- (void)hd_redirection:(void (^)(HDRequestRedirection))redirection response:(HDNetworkResponse *)response {
    // 自定义重定向，根据实际业务修改逻辑
    NSDictionary *responseDic = response.responseObject;

    if (responseDic) {
        PNRspModel *rspModel = [PNRspModel yy_modelWithJSON:responseDic];
        if ([rspModel.code isEqualToString:PNResponseTypeSuccess]) {
            redirection(HDRequestRedirectionSuccess);
            return;
        } else {
#pragma mark 特殊异常code
            if ([rspModel.code isEqualToString:@"O1001"] && [self.requestURI isEqualToString:kExchangeToken]) { //中台token失效
                /// 能进入这里的基本只有 在调用 exchangeToken ，中台报 accessToken失效
                [self pn_dealingWithRefreshAccessTokenRedirection:redirection response:response];
                return;
            } else if (([rspModel.code isEqualToString:@"G1083"] || [rspModel.code isEqualToString:@"G1085"] || [rspModel.code isEqualToString:@"G1017"] || [rspModel.code isEqualToString:@"G1086"] || [rspModel.code isEqualToString:@"G1083"])
                       && ![self.requestURI isEqualToString:kExchangeToken]) {
                /// 换取支付toekn
                [self dealingWithExchangeTokenRedirection:redirection response:response];
                return;
            } else {
                response.errorType = CMResponseErrorTypeBusinessDataError;
            }
        }
    }

    // 处理错误的状态码
    BOOL needSwitch = NO;
    if (response.error) {
        CMResponseErrorType errorType;
        switch (response.error.code) {
            case NSURLErrorTimedOut:
                errorType = CMResponseErrorTypeTimedOut;
                needSwitch = YES;
                break;
            case NSURLErrorCancelled:
                errorType = CMResponseErrorTypeCancelled;
                break;
            case NSURLErrorCannotConnectToHost:
                errorType = CMResponseErrorTypeCanNotContectToServer;
                needSwitch = YES;
                break;
            case NSURLErrorNotConnectedToInternet:
                errorType = CMResponseErrorTypeNoNetwork;
                break;
            case NSURLErrorCannotFindHost:
                errorType = CMResponseErrorTypeCanNotContectToServer;
                needSwitch = YES;
                break;
            default:
                errorType = CMResponseErrorTypeUnknown;
                break;
        }
        response.errorType = errorType;
    }

    redirection(HDRequestRedirectionFailure);
}

- (AFHTTPRequestSerializer *)requestSerializer {
    AFHTTPRequestSerializer *requestSerializer = [super requestSerializer];
    return requestSerializer;
}

- (NSString *)hd_preprocessURLString:(NSString *)urlString {
    NSString *fullURL = self.baseURI;
    if (HDIsStringNotEmpty(self.requestURI)) {
        fullURL = [fullURL stringByAppendingString:self.requestURI];
    }
    return fullURL;
}

- (NSDictionary *)hd_preprocessParameter:(NSDictionary *)parameter {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[super hd_preprocessParameter:parameter]];
    if (self.isNeedLogin && [VipayUser isLogin]) {
        [params addEntriesFromDictionary:@{@"loginName": VipayUser.shareInstance.loginName}];
    }
    return params;
}

- (void)hd_preprocessSuccessInChildThreadWithResponse:(HDNetworkResponse *)response {
    PNRspModel *rspModel = [PNRspModel yy_modelWithJSON:response.responseObject];
    response.extraData = rspModel;
    if (self.logEnabled) {
        if (self.shouldPrintRspJsonString) {
            // 把得到的字典转成JSON数据传出，方便快速建模
            NSData *responseData = [NSJSONSerialization dataWithJSONObject:response.responseObject options:NSJSONWritingPrettyPrinted error:nil];
            // 转 json string
            NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

            [self logMessageString:[NSString stringWithFormat:@"响应:%@", jsonString]];
        }

        [self logMessageString:[NSString stringWithFormat:@"请求成功！[%@][%@]🎉🎉🎉", self.requestURI, rspModel.code]];
    }
}

- (void)hd_preprocessFailureInChildThreadWithResponse:(HDNetworkResponse *)response {
    // 子线程预处理 responseObject 和 extraData
    PNRspModel *rspModel = [PNRspModel yy_modelWithJSON:response.responseObject];
    if ([rspModel.rspType isEqualToString:@"1"]) {
        // 拿 data 里面的 key 值 替换 rspInf 下 {key}
        NSDictionary *pairs = (NSDictionary *)rspModel.data;
        if (pairs.count > 0) {
            NSArray *keys = pairs.allKeys;
            for (NSString *key in keys) {
                NSString *patternStr = [NSString stringWithFormat:@"{%@}", key];
                if ([rspModel.msg rangeOfString:patternStr].location != NSNotFound) {
                    NSString *value = [pairs valueForKey:key];
                    if ([value isKindOfClass:NSNumber.class]) {
                        value = ((NSNumber *)value).stringValue;
                    }
                    NSString *errorMsg = [rspModel.msg stringByReplacingOccurrencesOfString:patternStr withString:value];
                    rspModel.msg = errorMsg;
                }
            }
            response.responseObject = [rspModel yy_modelToJSONObject];
        }
    } else if (![rspModel.code isEqualToString:PNResponseTypeSuccess]) {
        if (rspModel.data) {
            NSArray<PNRspInfoModel *> *errorInfoList = [NSArray yy_modelArrayWithClass:PNRspInfoModel.class json:rspModel.data];
            if (!HDIsArrayEmpty(errorInfoList)) {
                // 取出第一个错误信息对象
                PNRspInfoModel *firstErrorInfo = errorInfoList.firstObject;
                rspModel.msg = firstErrorInfo.msg;
                rspModel.code = firstErrorInfo.code;
                response.responseObject = [rspModel yy_modelToJSONObject];
            }
        }
    }

    response.extraData = rspModel;
}

- (void)hd_preprocessFailureInMainThreadWithResponse:(HDNetworkResponse *)response {
    PNRspModel *rspModel = response.extraData;
    CMResponseErrorType errorType = response.errorType;
    if (errorType == CMResponseErrorTypeMockError) {
        [NAT showToastWithTitle:nil content:rspModel.msg type:HDTopToastTypeError];
        return;
    }
    NSString *errorCode = @"";
    if (response.error) {
        // 网络异常
        errorCode = [NSString stringWithFormat:@"(%zd)%@", response.error.code, response.error.localizedDescription];

#ifdef DEBUG

#else
        [LKDataRecord.shared traceEvent:@"@DEBUG" name:[NSString stringWithFormat:@"[%zd]%@", response.error.code, response.error.localizedDescription] parameters:@{
            @"url": self.requestURI,
            @"cost": [NSString stringWithFormat:@"%.4f", [[NSDate new] timeIntervalSince1970] - self.startTime],
            @"carriers": [HDDeviceInfo getCarrierName],
            @"network": [HDDeviceInfo getNetworkType]
        }
                                    SPM:[LKSPM SPMWithPage:@"" parent:@"" child:@"" stayTime:0]];
#endif

        if (self.logEnabled) {
            if (self.shouldPrintRspJsonString) {
                [self logMessageString:[NSString stringWithFormat:@"响应:%@ \nerror:(%ld) %@", response.responseObject, response.error.code, response.error.localizedDescription]];
            }
            [self logMessageString:[NSString stringWithFormat:@"请求失败! [%@]【%zd】%@ ☠️☠️☠️", self.requestURI, response.error.code, response.error.localizedDescription]];
        }
    } else {
        // 业务异常
        if (self.logEnabled) {
            if (self.shouldPrintRspJsonString) {
                [self logMessageString:[NSString stringWithFormat:@"响应:%@ \nerror:(%ld) %@", response.responseObject, response.error.code, response.error.localizedDescription]];
            }
            [self logMessageString:[NSString stringWithFormat:@"请求失败! [%@]【%@】%@ ☠️☠️☠️", self.requestURI, rspModel.code, rspModel.msg]];
        }
    }

    if (errorType == CMResponseErrorTypeNoNetwork) {
        [NAT showToastWithTitle:nil content:[errorCode stringByAppendingString:SALocalizedString(@"network_not_available", @"网络异常，请稍后重试。")] type:HDTopToastTypeError];
        return;
    }
    if (errorType == CMResponseErrorTypeCanNotContectToServer) {
        [NAT showToastWithTitle:nil content:[errorCode stringByAppendingString:SALocalizedString(@"network_connect_server_failed", @"连接服务器失败")] type:HDTopToastTypeError];
        return;
    }
    if (errorType == CMResponseErrorTypeTimedOut) {
        [NAT showToastWithTitle:nil content:[errorCode stringByAppendingString:SALocalizedString(@"network_timeout", @"连接超时")] type:HDTopToastTypeError];
        return;
    }
    if (errorType != CMResponseErrorTypeBusinessDataError) {
        HDLog(@"网络开小差 - %@", self.requestURI);
        [NAT showToastWithTitle:nil content:SALocalizedString(@"network_no_network", @"网络开小差啦") type:HDTopToastTypeError];
        return;
    }
    PNResponseType code = rspModel.code;

    if ([code isEqualToString:@"O2052"] || [code isEqualToString:@"G1016"]) { // 异设备
        [NAT showAlertWithMessage:rspModel.msg buttonTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismissCompletion:^{
                // 去登录页
                [self checkMSHomeVC:^(BOOL isExistMSHome, BOOL isExistWalletHome) {
                    if (isExistMSHome && isExistWalletHome) {
                        [self popToRoot];
                    }
                    HDLog(@"开始清除");
                    [SAUser logout];
                    [VipayUser.shareInstance logout];
                    [SAWindowManager switchWindowToLoginViewControllerCompletion:nil];
                }];
            }];
        }];
    } else if ([code isEqualToString:@"G1017"] || [code isEqualToString:@"G1086"] || [code isEqualToString:@"G1083"] || [code isEqualToString:@"O2053"]) { // session 失效
        HDLog(@"立即登录: %@", self.requestURI);

        [NAT showAlertWithMessage:rspModel.msg buttonTitle:SALocalizedStringFromTable(@"login_right_now", @"立即登录", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismissCompletion:^{
                // 去登录页
                [self checkMSHomeVC:^(BOOL isExistMSHome, BOOL isExistWalletHome) {
                    if (isExistMSHome && isExistWalletHome) {
                        [self popToRoot];
                    }
                    HDLog(@"开始清除");
                    [SAUser logout];
                    [VipayUser.shareInstance logout];
                    [SAWindowManager switchWindowToLoginViewControllerCompletion:nil];
                }];
            }];
        }];

    } else if ([code isEqualToString:@"G1010"] || [code isEqualToString:@"G1011"] || [code isEqualToString:@"G1012"] || [code isEqualToString:@"V1056"] || [code isEqualToString:@"G1105"] ||
               [code isEqualToString:@"G1106"] || [code isEqualToString:@"U5010"]) { // 黑名单 冻结退出

        [NAT showAlertWithMessage:rspModel.msg buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [SAUser logout];
            [VipayUser.shareInstance logout];
            [alertView dismissCompletion:^{
                [SAWindowManager switchWindowToLoginViewController];
            }];
        }];

    } else if ([code isEqualToString:@"70001"]) {
        HDLog(@"服务器开小差了 - %@", self.requestURI);
        [NAT showAlertWithMessage:SALocalizedString(@"network_error", @"服务器开小差了") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [alertView dismiss];
                          }];
    } else if ([code isEqualToString:@"G1098"] || [code isEqualToString:@"G1097"]) {
        SAVersionAlertViewConfig *config = SAVersionAlertViewConfig.new;
        if (rspModel.data) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)rspModel.data];
            config.updateVersion = [dic valueForKey:@"version"];
            config.updateInfo = [dic valueForKey:@"versionInfo"];
        } else {
            config.updateInfo = rspModel.msg;
        }
        // G1098 强制更新    G1097 普通更新
        if ([code isEqualToString:@"G1098"]) {
            config.updateModel = SAVersionUpdateModelCoerce;
        } else {
            config.updateModel = SAVersionUpdateModelCommon;
        }
        config.ignoreCache = YES;

        if ([SAVersionAlertManager versionShouldAlert:config]) {
            SAVersionBaseAlertView *alert = [SAVersionAlertManager alertViewWithConfig:config];
            alert.didDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
                if ([config.updateModel isEqualToString:SAVersionUpdateModelCoerce]) {
                    //                    [SAUser logout];
                    //                    [VipayUser.shareInstance logout];
                }
            };
            [alert show];
        }
        return;
    } else if ([code isEqualToString:@"M3034"]) {
        /// 没权限  - 是商户服务
        [NAT showAlertWithMessage:rspModel.msg buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismissCompletion:^{
                // 去钱包首页
                [self checkMSHomeVC:^(BOOL isExistMSHome, BOOL isExistWalletHome) {
                    if (isExistWalletHome) {
                        [self popToWalletHome];
                    } else {
                        [self popToRoot];
                    }
                }];
            }];
        }];
    } else {
        if (self.shouldAlertErrorMsgExceptSpecCode) {
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    }
}

- (void)checkMSHomeVC:(void (^)(BOOL isExistMSHome, BOOL isExistWalletHome))completion {
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:SAWindowManager.visibleViewController.navigationController.viewControllers];
    BOOL isExistMSHome = NO;
    BOOL isExistWalletHome = NO;
    for (int i = 0; i < vcArray.count; i++) {
        UIViewController *vc = [vcArray objectAtIndex:i];

        if ([NSStringFromClass(vc.class) isEqualToString:@"PNMSHomeController"]) {
            isExistMSHome = YES;
        }

        if ([NSStringFromClass(vc.class) isEqualToString:@"PNWalletController"]) {
            isExistWalletHome = YES;
        }
    }

    !completion ?: completion(isExistMSHome, isExistWalletHome);
}

- (void)popToWalletHome {
    [SAWindowManager.visibleViewController.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletController") animated:YES];
}

- (void)popToRoot {
    [SAWindowManager.visibleViewController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Refresh AccessToken 、 exchange token
- (void)retryInMainQueue {
    // 回到主线程重新发起请求
    dispatch_async(dispatch_get_main_queue(), ^{
        HDLog(@"abc 回到主线程重新发起请求");
        [self preCheck];
        [self startWithUploadProgress:self.pn_uploadProgress downloadProgress:self.pn_downloadProgress cache:self.pn_cacheBlock success:self.pn_successBlock failure:self.pn_failureBlock];
    });
}

- (void)dealingWithExchangeTokenRedirection:(void (^)(HDRequestRedirection))redirection response:(HDNetworkResponse *)response {
    response.errorType = CMResponseErrorTypeaAccessTokenExpired;
    @HDWeakify(self);
    [VipayUser.shareInstance pn_lockSessionCompletion:^{
        @HDStrongify(self);
        if (VipayUser.shareInstance.pn_needUpdateMobileToken) {
            HDLog(@"发现没有mobileToken 走换取支付token");
            [self exchangeToken:redirection];
        } else {
            [VipayUser.shareInstance pn_unlockSession];
            // 重新发起请求
            HDLog(@"存在 mobileToken 重新发起请求");
            [self retryInMainQueue];
        }
    }];
}

- (void)exchangeToken:(void (^)(HDRequestRedirection))redirection {
    HDLog(@"触发换取支付token");
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = kExchangeToken;
    request.isNeedLogin = NO;
    request.needSessionKey = NO;

    request.requestParameter = @{
        @"loginName": [SAUser shared].loginName, //中台loginName
        @"token": [SAUser shared].accessToken,   //中台token
        @"deviceId": [HDDeviceInfo getUniqueId],
        @"appId": @"SuperApp",
        @"appNo": @"11",
    };

    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);

        PNRspModel *rspModel = response.extraData;

        HDReflushTokenRspModel *flushModel = [HDReflushTokenRspModel yy_modelWithJSON:rspModel.data];
        VipayUser.shareInstance.userNo = flushModel.userNo;
        VipayUser.shareInstance.sessionKey = flushModel.sessionKey;
        VipayUser.shareInstance.mobileToken = flushModel.mobileToken;
        VipayUser.shareInstance.loginName = flushModel.loginName;
        VipayUser.shareInstance.mobileUpdateTime = NSDate.new;

        [VipayUser.shareInstance pn_unlockSession];
        [self retryInMainQueue];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        [VipayUser.shareInstance pn_unlockSession];
        redirection(HDRequestRedirectionFailure);
    }];
}

/// 刷新 accessToken
- (void)pn_dealingWithRefreshAccessTokenRedirection:(void (^)(HDRequestRedirection))redirection response:(HDNetworkResponse *)response {
    response.errorType = CMResponseErrorTypeaAccessTokenExpired;
    @HDWeakify(self);
    [SAUser.shared lockSessionCompletion:^{
        @HDStrongify(self);
        if (SAUser.shared.needUpdateAccessToken) {
            [self logMessageString:@"PN错误码显示需要刷新 accessToken，且刷新间隔满足，开始刷新"];
            [self requestRiskTokenWithRedirection:redirection];
        } else {
            [self logMessageString:@"PN错误码虽然显示需要刷新 accessToken，但刷新间隔不满足，不刷新，触发原业务"];
            [SAUser.shared unlockSession];
            // 重新发起请求
            [self retryInMainQueue];
        }
    }];
}

- (void)requestRiskTokenWithRedirection:(void (^)(HDRequestRedirection))redirection {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:10000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self logMessageString:[NSString stringWithFormat:@"拿到易盾Token:%@, %zd %@", token, code, message]];
        [self refreshAccessTokenWithRiskToken:token redirection:redirection];
    }];
}

- (void)refreshAccessTokenWithRiskToken:(NSString *_Nonnull)riskToken redirection:(void (^)(HDRequestRedirection))redirection {
    HDLog(@"☠️☠️☠️支付 里面触发 中台token失效 重新刷新");
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = kRefreshAccessTokenURI;
    request.requestParameter = @{@"refreshToken": SAUser.shared.refreshToken, @"deviceInfo": [SAGeneralUtil getDeviceInfo], @"riskToken": riskToken};
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        SARefreshAccessTokenRspModel *model = [SARefreshAccessTokenRspModel yy_modelWithJSON:rspModel.data];
        SAUser.shared.accessToken = model.accessToken;
        SAUser.shared.accessTokenUpdateTime = NSDate.new;

        [self logMessageString:[NSString stringWithFormat:@"PN[%@]成功刷新 accessToken: %@，发起原业务请求", [NSThread currentThread], model.accessToken]];

        [SAUser.shared unlockSession];
        [self retryInMainQueue];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [self logMessageString:[NSString stringWithFormat:@"PN[%@]刷新 accessToken 失败，触发原业务请求失败", [NSThread currentThread]]];
        [SAUser.shared unlockSession];
        redirection(HDRequestRedirectionFailure);
    }];
}

- (void)preCheck {
    /// 更新最新的accessToken
    if ([self.requestURI isEqualToString:kExchangeToken]) {
        if ([self.requestParameter.allKeys containsObject:@"token"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.requestParameter];
            HDLog(@"替换之前：%@", [dict objectForKey:@"token"]);
            //替换成功
            [dict setValue:SAUser.shared.accessToken forKey:@"token"]; //中台token
            HDLog(@"替换之后：%@", [dict objectForKey:@"token"]);
            self.requestParameter = dict;
        }
    }
}

#pragma mark - private methods
- (void)logMessageString:(NSString *)message, ... {
    if (!self.logEnabled) {
        return;
    }
#ifdef DEBUG
    HDLog(@"🚀[%@][%.4fs][%@]%@", self.identifier, [[NSDate new] timeIntervalSince1970] - self.startTime, self.baseURI, message);
#endif
}

#pragma mark - overwrite
- (NSDictionary<NSString *, NSString *> *)sa_preprocessHeaderFields:(NSDictionary<NSString *, NSString *> *)headerFields {
    NSMutableDictionary<NSString *, NSString *> *header = [[NSMutableDictionary alloc] initWithDictionary:headerFields];
    [header addEntriesFromDictionary:@{
        @"appNo": @"11",
        @"termTyp": @"IOS",
        @"Accept-Language": SAMultiLanguageManager.currentLanguage,
        @"appVersion": HDDeviceInfo.appVersion,
        @"channel": @"AppStore",
        @"appId": @"SuperApp",
        @"projectName": @"ViPay",
        @"deviceId": [HDDeviceInfo getUniqueId],
        //支付
        @"md5": [self sa_customSignatureProcess],
    }];

    if (self.isNeedLogin && [VipayUser isLogin]) {
        [header addEntriesFromDictionary:@{@"accessToken": VipayUser.shareInstance.mobileToken}];
        [header addEntriesFromDictionary:@{@"loginName": VipayUser.shareInstance.loginName}];
    }

    if (self.needSessionKey) {
        [header addEntriesFromDictionary:@{@"tokenId": [VipayUser shareInstance].sessionKey}];
    }

    return header;
}

/** 对数组或者字典嵌套递归输出用于加密的字符串 */
- (NSString *)stringForRecursiveNestedObject:(id)object {
    NSString *jsonStr = object;

    if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *dictionary = (NSDictionary *)object;
        NSArray *keys = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            return (NSComparisonResult)[str1 compare:str2 options:NSNumericSearch];
        }];
        NSMutableString *oriSig = [[NSMutableString alloc] init];
        [oriSig appendString:@"{"];
        for (int i = 0; i < dictionary.count; i++) {
            [oriSig appendString:keys[i]];
            [oriSig appendString:@"="];
            id value = [dictionary objectForKey:keys[i]];

            value = [self stringForRecursiveNestedObject:value];
            [oriSig appendString:[NSString stringWithFormat:@"%@", value]];
            if (i < keys.count - 1) {
                [oriSig appendString:@"&"];
            }
        }
        [oriSig appendString:@"}"];
        jsonStr = oriSig;
    } else if ([object isKindOfClass:NSArray.class]) {
        jsonStr = @"[";
        NSArray *array = (NSArray *)object;
        for (NSInteger i = 0; i < array.count; ++i) {
            if (i != 0) {
                jsonStr = [jsonStr stringByAppendingString:@","];
            }
            id value = [self stringForRecursiveNestedObject:array[i]];
            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@", value]];
        }
        jsonStr = [jsonStr stringByAppendingString:@"]"];
    }
    return jsonStr;
}

- (NSString *)sa_customSignatureProcess {
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:self.requestParameter];

    NSArray *keys = [[requestDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return (NSComparisonResult)[str1 compare:str2 options:NSNumericSearch];
    }];
    NSMutableString *oriSign = [[NSMutableString alloc] init];

    if ([VipayUser isLogin] && self.isNeedLogin && WJIsStringNotEmpty(VipayUser.shareInstance.mobileToken)) {
        [oriSign appendString:[VipayUser shareInstance].mobileToken];
    } else {
        [oriSign appendString:@"chaos"];
    }

    for (NSString *key in keys) {
        id value = [requestDic valueForKey:key];
        [oriSign appendFormat:@"&%@=%@", key, [self stringForRecursiveNestedObject:value]];
    }

    //            HDLog(@"%@", self.requestURI);
    //            HDLog(@"原始字符串：%@", oriSign);
    NSString *md5 = [oriSign hd_md5];
    //            HDLog(@"生成 md5 ：%@", md5);

    return md5;
}

@end
