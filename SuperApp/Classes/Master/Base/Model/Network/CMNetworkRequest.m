//
//  CMNetworkRequest.m
//  SuperApp
//
//  Created by VanJay on 2020/3/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "CMNetworkRequest.h"
#import "HDMediator+YumNow.h"
#import "LKDataRecord.h"
#import "SAAlertView.h"
#import "SAAppEnvManager.h"
#import "SAAppEnvMockDataModel.h"
#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import "SAGeneralUtil.h"
#import "SAGuardian.h"
#import "SAMultiLanguageManager.h"
#import "SARefreshAccessTokenRspModel.h"
#import "SARspModel.h"
#import "SAUser.h"
#import "SAVersionAlertManager.h"
#import "SAWindowManager.h"
#import <HDServiceKit/HDSystemCapabilityUtil.h>
#import <HDUIKit/NAT.h>
#import <YYModel/YYModel.h>

/// 刷新 accessToken URI
static NSString *const kRefreshAccessTokenURI = @"/authcenter/token/refresh.do";


@interface CMNetworkRequest ()
// 以下 block 用于刷新 accessToken 后重新发起业务请求
@property (nonatomic, copy, nullable) HDRequestProgressBlock cm_uploadProgress;
@property (nonatomic, copy, nullable) HDRequestProgressBlock cm_downloadProgress;
@property (nonatomic, copy, nullable) HDRequestCacheBlock cm_cacheBlock;
@property (nonatomic, copy, nullable) HDRequestSuccessBlock cm_successBlock;
@property (nonatomic, copy, nullable) HDRequestFailureBlock cm_failureBlock;
/// 所有的 mock 模型映射列表
@property (nonatomic, copy) NSArray<SAAppEnvMockDataModel *> *mockDataMapList;
/// 示例，记录防止频繁遍历数组
@property (nonatomic, strong) SAAppEnvMockDataModel *exampleMockDataModel;
///< 刷新Token次数
@property (nonatomic, assign) NSUInteger refreshTokenCount;
@end


@implementation CMNetworkRequest

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        NSString *cryptModel = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewNetworkCryptModel];
        if (!HDIsObjectNil(cryptModel) && HDIsStringNotEmpty(cryptModel) && [cryptModel.lowercaseString isEqualToString:@"on"]) {
            self.cipherMode = SANetworkRequestCipherModeMD5V2;
        } else {
            self.cipherMode = SANetworkRequestCipherModeMD5V1;
        }
        self.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.serviceURL;
        self.requestMethod = HDRequestMethodPOST;
#ifdef DEBUG
        self.logEnabled = YES;
        self.shouldPrintHeaderFieldJsonString = NO;
        self.shouldPrintParamJsonString = NO;
        self.shouldPrintRspJsonString = NO;
        self.shouldPrintNetworkDetailLog = NO;
#else
        self.logEnabled = NO;
        self.shouldPrintHeaderFieldJsonString = NO;
        self.shouldPrintParamJsonString = NO;
        self.shouldPrintRspJsonString = NO;
        self.shouldPrintNetworkDetailLog = NO;
#endif
        // 默认需要登录
        self.isNeedLogin = YES;
        // 默认显示弹窗
        self.shouldAlertErrorMsgExceptSpecCode = YES;
        // 默认记录埋点
        self.shouldRecordAndReport = YES;
        // 请求超时时间
        self.requestTimeoutInterval = 20;
        // 设置重试间隔
        self.retryInterval = 3;
        // 设置重试步进
        self.isRetryProgressive = YES;
        // 刷新token的次数
        self.refreshTokenCount = 0;
        // 监听线路切换
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeAppEnvSuccess) name:kNotificationNameChangeAppEnvSuccess object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameChangeAppEnvSuccess object:self];
    if (self.shouldPrintNetworkDetailLog) {
        [self logMessageString:[NSString stringWithFormat:@"请求销毁.[%@]✅", self.requestURI]];
    }
}

#pragma mark - Notification
- (void)changeAppEnvSuccess {
    self.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.serviceURL;
}

#pragma mark - override
- (void)startWithUploadProgress:(HDRequestProgressBlock)uploadProgress
               downloadProgress:(HDRequestProgressBlock)downloadProgress
                          cache:(HDRequestCacheBlock)cache
                        success:(HDRequestSuccessBlock)success
                        failure:(HDRequestFailureBlock)failure {
    if (![self.requestURI isEqualToString:kRefreshAccessTokenURI]) {
        self.cm_uploadProgress = uploadProgress;
        self.cm_downloadProgress = downloadProgress;
        self.cm_cacheBlock = cache;
        self.cm_successBlock = success;
        self.cm_failureBlock = failure;
    }

    // 判断是否 MOCK 环境
    if ([SAAppEnvManager.sharedInstance.appEnvConfig.type isEqualToString:SAAppEnvTypeMOCK]) {
        BOOL shouldMock = [self dealingWithShouldMockLogicSuccess:success failure:failure];
        if (shouldMock)
            return;
    }

    if (self.shouldPrintParamJsonString) {
        // 把得到的字典转成JSON数据传出，方便快速建模
        NSData *responseData = [NSJSONSerialization dataWithJSONObject:self.requestParameter ? self.requestParameter : @{} options:NSJSONWritingPrettyPrinted error:nil];
        // 转 json string
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [self logMessageString:[NSString stringWithFormat:@"参数：%@", jsonString]];
    }

    if (self.shouldPrintNetworkDetailLog) {
        [self logMessageString:[NSString stringWithFormat:@"请求开始:[%@] \n%@]", self.requestURI, self.requestParameter]];
    }

    [super startWithUploadProgress:uploadProgress downloadProgress:downloadProgress cache:cache success:success failure:failure];
}

- (void)hd_redirection:(void (^)(HDRequestRedirection))redirection response:(HDNetworkResponse *)response {
    // 自定义重定向，根据实际业务修改逻辑
    NSDictionary *responseDic = response.responseObject;

    if (responseDic) {
        SARspModel *rspModel = [SARspModel yy_modelWithJSON:responseDic];
        if ([rspModel.code isEqualToString:SAResponseTypeSuccess]) {
            redirection(HDRequestRedirectionSuccess);
            return;
        } else {
            // 处理 accessToken 需要刷新
            if ([rspModel.code isEqualToString:@"O2051"] && ![self.requestURI isEqualToString:kRefreshAccessTokenURI] && self.refreshTokenCount < 5) {
                [self dealingWithRefreshAccessTokenRedirection:redirection response:response];
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

    NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchAutoSwitchLine];
    if (HDIsStringNotEmpty(switchLine) && [switchLine.lowercaseString isEqualToString:@"on"] && needSwitch) {
        // 开始执行线路切换
        [self switchEnvAndRetryWithRedirection:redirection];
        return;
    }

    redirection(HDRequestRedirectionFailure);
}

- (AFHTTPRequestSerializer *)requestSerializer {
    AFHTTPRequestSerializer *requestSerializer = [super requestSerializer];
    if (self.shouldPrintHeaderFieldJsonString) {
        // 把得到的字典转成JSON数据传出，方便快速建模
        NSData *responseData = [NSJSONSerialization dataWithJSONObject:requestSerializer.HTTPRequestHeaders options:NSJSONWritingPrettyPrinted error:nil];
        // 转 json string
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [self logMessageString:[NSString stringWithFormat:@"请求头：%@", jsonString]];
    }

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
    if (self.isNeedLogin && [SAUser hasSignedIn]) {
        if (![params.allKeys containsObject:@"loginName"]) {
            [params addEntriesFromDictionary:@{@"loginName": SAUser.shared.loginName}];
        }
    }
    NSString *shortID = [SACacheManager.shared objectPublicForKey:kCacheKeyShortIDTrace];
    if (HDIsStringNotEmpty(shortID)) {
        params[@"shortId"] = shortID;
    }

    return params;
}

- (void)hd_preprocessSuccessInChildThreadWithResponse:(HDNetworkResponse *)response {
    SARspModel *rspModel = [SARspModel yy_modelWithJSON:response.responseObject];
    response.extraData = rspModel;

    if (self.shouldPrintRspJsonString) {
        // 把得到的字典转成JSON数据传出，方便快速建模
        NSData *responseData = [NSJSONSerialization dataWithJSONObject:response.responseObject options:NSJSONWritingPrettyPrinted error:nil];
        // 转 json string
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

        [self logMessageString:[NSString stringWithFormat:@"响应:%@", jsonString]];
    }

    if (self.shouldPrintNetworkDetailLog) {
        [self logMessageString:[NSString stringWithFormat:@"请求成功！[%@][%@]🎉🎉🎉", self.requestURI, rspModel.code]];
    }
}

- (void)hd_preprocessFailureInChildThreadWithResponse:(HDNetworkResponse *)response {
    // 子线程预处理 responseObject 和 extraData
    SARspModel *rspModel = [SARspModel yy_modelWithJSON:response.responseObject];

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
    } else if (![rspModel.code isEqualToString:SAResponseTypeSuccess]) {
        if (rspModel.data) {
            NSArray<SARspInfoModel *> *errorInfoList = [NSArray yy_modelArrayWithClass:SARspInfoModel.class json:rspModel.data];
            if (!HDIsArrayEmpty(errorInfoList)) {
                // 取出第一个错误信息对象
                SARspInfoModel *firstErrorInfo = errorInfoList.firstObject;
                rspModel.msg = firstErrorInfo.msg;
                rspModel.code = firstErrorInfo.code;
                response.responseObject = [rspModel yy_modelToJSONObject];
            }
        }
    }

    response.extraData = rspModel;
}

- (void)hd_preprocessFailureInMainThreadWithResponse:(HDNetworkResponse *)response {
    SARspModel *rspModel = response.extraData;
    CMResponseErrorType errorType = response.errorType;
    if (errorType == CMResponseErrorTypeMockError) {
        [self pShowToastWithTitle:nil content:rspModel.msg];
        return;
    }
    NSString *errorCode = @"";
    if (response.error) {
        // 网络异常
        errorCode = [NSString stringWithFormat:@"(%zd)", response.error.code];

        if (self.shouldRecordAndReport) {
            [LKDataRecord.shared traceEvent:@"@DEBUG" name:[NSString stringWithFormat:@"[%zd]%@", response.error.code, response.error.localizedDescription] parameters:@{
                @"url": self.requestURI,
                @"cost": [NSString stringWithFormat:@"%.4f", [[NSDate new] timeIntervalSince1970] - self.startTime],
                @"carriers": [HDDeviceInfo getCarrierName],
                @"network": [HDDeviceInfo getNetworkType],
                @"rspHeaders": [response.URLResponse.allHeaderFields yy_modelToJSONString],
                @"retryCnt": @(self.retryCount)
            }
                                        SPM:nil];
        }

        if (self.shouldPrintRspJsonString) {
            [self logMessageString:[NSString stringWithFormat:@"响应:%@ \nerror:(%ld) %@", response.responseObject, response.error.code, response.error.localizedDescription]];
        }

        [self logMessageString:[NSString stringWithFormat:@"网络请求失败! [%@]【%zd】%@ 💡 %@", self.requestURI, response.error.code, response.error.localizedDescription, response.responseObject]];
    } else {
        // 业务异常
        if (self.shouldPrintRspJsonString) {
            [self logMessageString:[NSString stringWithFormat:@"响应:%@ \nerror:(%ld) %@", response.responseObject, response.error.code, response.error.localizedDescription]];
        }
        [self logMessageString:[NSString stringWithFormat:@"请求失败! [%@]【%@】%@ ☠️☠️☠️ [%@]", self.requestURI, rspModel.code, rspModel.msg, self.requestParameter]];
    }

    if (errorType == CMResponseErrorTypeNoNetwork) {
        [self pShowToastWithTitle:nil content:[errorCode stringByAppendingString:SALocalizedString(@"network_not_available", @"无法连接网络，请检查WIFI或无线数据网络是否正常")]];
        return;
    }
    if (errorType == CMResponseErrorTypeCanNotContectToServer && self.shouldAlertErrorMsgExceptSpecCode) {
        [self pShowToastWithTitle:nil content:[errorCode stringByAppendingString:SALocalizedString(@"network_connect_server_failed", @"连接服务器失败")]];
        return;
    }
    if (errorType == CMResponseErrorTypeTimedOut && self.shouldAlertErrorMsgExceptSpecCode) {
        [self pShowToastWithTitle:nil content:[errorCode stringByAppendingString:SALocalizedString(@"network_timeout", @"连接超时")]];
        return;
    }
    if (errorType == CMResponseErrorTypeCancelled && self.shouldAlertErrorMsgExceptSpecCode) {
#ifdef DEBUG
        [self pShowToastWithTitle:nil content:[errorCode stringByAppendingString:@"请求被取消了"]];
#endif
        return;
    }

    if (errorType != CMResponseErrorTypeBusinessDataError && self.shouldAlertErrorMsgExceptSpecCode) {
        HDLog(@"网络开小差 - %@", self.requestURI);
        [self pShowToastWithTitle:nil content:[errorCode stringByAppendingString:SALocalizedString(@"network_no_network", @"网络开小差啦")]];
        return;
    }
    SAResponseType code = rspModel.code;

    if ([code isEqualToString:@"O2052"]) { // 异设备
        [NAT showAlertWithMessage:rspModel.msg buttonTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [SAUser logout];
            [alertView dismissCompletion:^{
                // 去登录页
                [SAWindowManager switchWindowToLoginViewControllerCompletion:nil];
            }];
        }];
    } else if ([code isEqualToString:@"G1017"] || [code isEqualToString:@"G1086"] || [code isEqualToString:@"G1083"] || [code isEqualToString:@"O2053"]) { // session 失效
        [NAT showAlertWithMessage:rspModel.msg buttonTitle:SALocalizedStringFromTable(@"login_right_now", @"立即登录", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [SAUser logout];
            [alertView dismissCompletion:^{
                // 去登录页
                [SAWindowManager switchWindowToLoginViewControllerCompletion:nil];
            }];
        }];

    } else if ([code isEqualToString:@"C0011"]) { // 余额不足
        [NAT showAlertWithMessage:rspModel.msg confirmButtonTitle:SALocalizedStringFromTable(@"goto_recharge", @"去充值", @"Buttons")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismissCompletion:^{
                }];
            }
            cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];

    } else if ([code isEqualToString:@"G1010"] || [code isEqualToString:@"G1011"] || [code isEqualToString:@"G1012"] || [code isEqualToString:@"V1056"] || [code isEqualToString:@"G1105"] ||
               [code isEqualToString:@"G1106"] || [code isEqualToString:@"U5010"]) { // 黑名单 冻结退出

        [NAT showAlertWithMessage:rspModel.msg buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [SAUser logout];
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
                    [SAUser logout];
                }
            };
            [alert show];
        }
    } else if ([code isEqualToString:@"U4005"]) { // 5次密码登录失败
        SAAlertView *alertView = [SAAlertView alertViewWithTitle:nil message:rspModel.msg config:nil];
        SAAlertViewButton *btn1 = [SAAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") type:SAAlertViewButtonTypeCancel
                                                             handler:^(SAAlertView *alertView, SAAlertViewButton *button) {
                                                                 [alertView dismiss];
                                                             }];
        SAAlertViewButton *btn2 = [SAAlertViewButton buttonWithTitle:SALocalizedString(@"login_new_SMSSignIn", @"SMS Sign In") type:SAAlertViewButtonTypeDefault
                                                             handler:^(SAAlertView *alertView, SAAlertViewButton *button) {
                                                                 [alertView dismiss];
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNamePushSMSLoginViewController object:nil];
                                                             }];
        [alertView addButtons:@[btn1, btn2]];
        [alertView show];
    } else {
        if (self.shouldAlertErrorMsgExceptSpecCode) {
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    }
}

- (void)switchEnvAndRetryWithRedirection:(void (^)(HDRequestRedirection))redirection {
    [SAAppEnvManager.sharedInstance envSwitchCompletion:^(BOOL hasSwitch) {
        if (hasSwitch) {
            [self logMessageString:@"切换线路，重新发起1次"];
            self.retryCount = 0;
            [self retryInMainQueue];

            // 埋点
            if (self.shouldRecordAndReport) {
                [LKDataRecord.shared
                    traceEvent:@"@DEBUG"
                          name:@"触发网络切换_成功"
                    parameters:@{@"envName": [SAAppEnvManager sharedInstance].appEnvConfig.name, @"carriers": [HDDeviceInfo getCarrierName], @"network": [HDDeviceInfo getNetworkType]}];
            }
        } else {
            [self logMessageString:@"无线路可切，返回失败"];
            redirection(HDRequestRedirectionFailure);
            if (self.shouldRecordAndReport) {
                [LKDataRecord.shared
                    traceEvent:@"@DEBUG"
                          name:@"触发网络切换_失败"
                    parameters:@{@"envName": [SAAppEnvManager sharedInstance].appEnvConfig.name, @"carriers": [HDDeviceInfo getCarrierName], @"network": [HDDeviceInfo getNetworkType]}];
            }
        }
    }];
}

#pragma mark - Refresh AccessToken
- (void)dealingWithRefreshAccessTokenRedirection:(void (^)(HDRequestRedirection))redirection response:(HDNetworkResponse *)response {
    response.errorType = CMResponseErrorTypeaAccessTokenExpired;
    @HDWeakify(self);
    self.refreshTokenCount = self.refreshTokenCount + 1;
    [SAUser.shared lockSessionCompletion:^{
        @HDStrongify(self);
        if (SAUser.shared.needUpdateAccessToken) {
            [self logMessageString:[NSString stringWithFormat:@"需要刷新 accessToken，且刷新间隔满足，开始刷新。[%@][刷新次数:%zd]", self.requestURI, self.refreshTokenCount]];
            [self requestRiskTokenWithRedirection:redirection];
        } else {
            [self logMessageString:[NSString stringWithFormat:@"需要刷新 accessToken，但刷新间隔不满足，不刷新，触发原业务。[%@][刷新次数:%zd]", self.requestURI, self.refreshTokenCount]];
            [SAUser.shared unlockSession];
            // 重新发起请求
            [self retryInMainQueue];
        }
    }];
}

- (void)retryInMainQueue {
    // 回到主线程重新发起请求
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startWithUploadProgress:self.cm_uploadProgress downloadProgress:self.cm_downloadProgress cache:self.cm_cacheBlock success:self.cm_successBlock failure:self.cm_failureBlock];
    });
}

- (void)requestRiskTokenWithRedirection:(void (^)(HDRequestRedirection))redirection {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:10000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self logMessageString:[NSString stringWithFormat:@"拿到易盾Token:%@", token]];
        [self refreshAccessTokenWithRiskToken:token redirection:redirection];
    }];
}

- (void)refreshAccessTokenWithRiskToken:(NSString *_Nonnull)riskToken redirection:(void (^)(HDRequestRedirection))redirection {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = kRefreshAccessTokenURI;
    request.requestParameter = @{@"refreshToken": SAUser.shared.refreshToken, @"deviceInfo": [SAGeneralUtil getDeviceInfo], @"riskToken": riskToken};
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        SARefreshAccessTokenRspModel *model = [SARefreshAccessTokenRspModel yy_modelWithJSON:rspModel.data];
        SAUser.shared.accessToken = model.accessToken;
        SAUser.shared.accessTokenUpdateTime = NSDate.new;

        [self logMessageString:[NSString stringWithFormat:@"[%@]成功刷新 accessToken: %@，发起原业务请求.[%@]", [NSThread currentThread], model.accessToken, self.requestURI]];
        [SAUser.shared unlockSession];

        // 强制上送
        [LKDataRecord.shared forcePush];

        [self retryInMainQueue];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [self logMessageString:[NSString stringWithFormat:@"[%@]刷新 accessToken 失败，触发原业务请求失败", [NSThread currentThread]]];
        [SAUser.shared unlockSession];
        redirection(HDRequestRedirectionFailure);
    }];
}

#pragma mark - private methods
- (void)logMessageString:(NSString *)message, ... {
    if (!self.logEnabled) {
        return;
    }
#ifdef DEBUG
    HDLog(@"🚀[%@][%.4fs][%@]%@", self.identifier, [[NSDate new] timeIntervalSince1970] - self.startTime, SAAppEnvManager.sharedInstance.appEnvConfig.type, message);
#endif
}

- (void)pShowToastWithTitle:(NSString *_Nullable)title content:(NSString *_Nonnull)content {
    NSString *key = [NSString stringWithFormat:@"%@%@", HDIsStringNotEmpty(title) ? title : @"", HDIsStringNotEmpty(content) ? content : @""];
    if (HDIsStringEmpty(key)) {
        return;
    }
    NSString *value = [SACacheManager.shared objectForKey:key type:SACacheTypeMemonryPublic];
    if (HDIsStringNotEmpty(value)) {
        HDLog(@"10s内弹过了，不弹了");
        return;
    }
    [NAT showToastWithTitle:title content:content type:HDTopToastTypeError];
    [SACacheManager.shared setObject:@"on" forKey:key duration:10 type:SACacheTypeMemonryPublic];
}

#pragma mark - Mock
- (BOOL)dealingWithShouldMockLogicSuccess:(HDRequestSuccessBlock)success failure:(HDRequestFailureBlock)failure {
    BOOL shouldMock = false;
    // 查找该 requestURI 存不存在 mock 配置
    SAAppEnvMockDataModel *mockDataModel;
    for (SAAppEnvMockDataModel *model in self.mockDataMapList) {
        if ([model.requestURI isEqualToString:self.requestURI]) {
            mockDataModel = model;
            break;
        }
    }
    shouldMock = !HDIsObjectNil(mockDataModel) && mockDataModel.enabled;
    if (shouldMock) {
        NSDictionary *json = [self mockDataWithJsonPath:mockDataModel.jsonPath];
        if (HDIsObjectNil(json)) {
            NSErrorDomain errorDomain = [NSString stringWithFormat:@"当前为 MOCK 环境 %@ 接口已配置映射但未找到 %@.json 文件", self.requestURI, mockDataModel.jsonPath];
            [self logMessageString:[NSString stringWithFormat:@"%@", errorDomain]];
            return false;
        } else {
            HDNetworkResponse *response = [HDNetworkResponse responseWithSessionTask:nil responseObject:json error:nil];
            response.extraData = [SARspModel yy_modelWithJSON:response.responseObject];
            !success ?: success(response);
            [self logMessageString:[NSString stringWithFormat:@"⚠️⚠️⚠️：接口 %@ 返回的为 MOCK 数据", self.requestURI]];
            return true;
        }
    } else {
        return false;
    }
}

- (NSDictionary *)mockDataWithJsonPath:(NSString *)jsonPath {
    if (HDIsStringEmpty(jsonPath))
        return nil;
    NSString *path = [NSString stringWithFormat:@"%@.json", jsonPath];
    //    NSString *pathInBundle = [NSBundle.mainBundle pathForResource:path ofType:nil inDirectory:@"MockJson"];
    //    if (HDIsStringEmpty(pathInBundle)) return nil;

    NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
    NSString *pathStr = [mainBundleDirectory stringByAppendingPathComponent:path];
    NSURL *url = [NSURL fileURLWithPath:pathStr];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];

    // 将文件数据化
    //    NSData *data = [[NSData alloc] initWithContentsOfFile:pathInBundle];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *mockData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return mockData;
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
        @"projectName": @"SuperApp"
    }];

    NSString *flag = [SACacheManager.shared objectForKey:KBlueAndGreenFlag type:SACacheTypeCachePublic];
    if (HDIsStringNotEmpty(flag)) {
        [header addEntriesFromDictionary:@{@"flag": flag}];
    }

    if (self.isNeedLogin && [SAUser hasSignedIn]) {
        [header addEntriesFromDictionary:@{@"accessToken": SAUser.shared.accessToken}];
    }

    return header;
}

- (NSDictionary *)sa_customSignatureEncryptFactors {
    if (self.cipherMode == SANetworkRequestCipherModeMD5V2) {
        NSMutableDictionary<NSString *, NSString *> *finalParams = [[NSMutableDictionary alloc] initWithCapacity:3];
        [finalParams addEntriesFromDictionary:@{@"appNo": @"11", @"appVersion": HDDeviceInfo.appVersion, @"channel": @"AppStore"}];

        if (self.isNeedLogin && [SAUser hasSignedIn]) {
            [finalParams addEntriesFromDictionary:@{@"accessToken": SAUser.shared.accessToken}];
        }

        return finalParams;
    } else {
        return @{};
    }
}

#pragma mark - getter
- (NSArray<SAAppEnvMockDataModel *> *)mockDataMapList {
    if (!_mockDataMapList) {
        NSString *path = [NSBundle.mainBundle pathForResource:@"MockMap.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        _mockDataMapList = [NSArray yy_modelArrayWithClass:SAAppEnvMockDataModel.class json:array];
    }
    return _mockDataMapList;
}

@end
