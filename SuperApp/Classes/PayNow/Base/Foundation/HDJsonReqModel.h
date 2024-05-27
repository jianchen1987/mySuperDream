//
//  HDJsonReqModel.h
//  National Wallet
//
//  Created by 陈剑 on 2018/4/25.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HDJsonReqModel : NSObject
/** 请求时间，格式 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, copy) NSString *requestTm;
/** 平台名称 */
@property (nonatomic, copy) NSString *platformName;
/** 设备 ID，只有在恢复出厂才会变化 */
@property (nonatomic, copy) NSString *deviceId;
/** 会话 ID */
@property (nonatomic, copy) NSString *tokenId;
@property (nonatomic, copy) NSString *md5;
/** 语言 */
@property (nonatomic, copy) NSString *acceptLanguage;
/** APP 版本 */
@property (nonatomic, copy) NSString *appVersion;
/** 会话 session */
@property (nonatomic, copy) NSString *sessionKey;
/** 请求重试次数，默认 0，即不重试，交由业务控制 */
@property (nonatomic, assign) NSInteger retryCount;
/** 重试间隔，即过多久重试，默认 0，即失败了就重试 */
@property (nonatomic, assign) NSTimeInterval retryInterval;
/** 重试间隔是否步进，随着失败次数增加，重试间隔加长，如 1 -> 3 -> 9 */
@property (nonatomic, assign, getter=isRetryProgressive) BOOL retryProgressive;
/** 是否需要登录，默认开启，如果需要，会自动添加用户名参数 */
@property (nonatomic, assign) BOOL isNeedLogin;
/** 是否需要sessionKey，默认关闭，某些接口需要传 session 至 headerField 中 */
@property (nonatomic, assign) BOOL needSessionKey;
/** 打印 response json string，用于快速建模 */
@property (nonatomic, assign) BOOL shouldPrintRspString;
/** 参数对应的字符串，解决 BaseViewModel 在一个页面调同一接口回调被覆盖情况 */
@property (nonatomic, copy) NSString *paramsStr;
/** 关联对象，附带信息，用于做一些匹配 */
@property (nonatomic, strong) id associatedObject;

- (NSDictionary *)getRequestJsonDictionary;

- (NSString *)getTraceNo;

- (void)setReqParams:(NSDictionary *)params;

/// 获取设备相关信息
+ (NSString *)getDeviceInfo;

@end
