//
//  NTESRiskUniPerception.h
//  RiskPerception
//
//  Created by Netease on 2022/4/27.
//  Copyright © 2022 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AntiCheatResult.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NTESRiskUniReportPlug = 0, // 外挂
    NTESRiskUniReportStudio = 1 // 工作室

} NTESRiskUniReportType;


typedef enum {
    // 签名信息
    Cmd_GetSignInfo = 0,
    // 越狱状态
    Cmd_IsRootDevice = 2,
    // SDK版本
    Cmd_GetHTPVersion = 7,
    // 获取超时数据
    Cmd_GetCollectData = 8,
    // 初始化配置内容，防止初始化失败情况下，客户可以通过服务端请求初始化配置并传递给SDK
    Cmd_SetConfigData = 16,
    // 客户服务端将check结果传递给SDK，便于执行后续动作
    Cmd_SetResponseData = 17,
    // 32位deviceID
    Cmd_GetYiDunCode = 99,
    // 64位deviceID
    Cmd_GetYiDunID = 100,
} RequestCmdID;


typedef enum {
    // 心跳数据，可直接在客户端解析
    INFO_TYPE_HEARTBEAT = 1,
    // 加密后的心跳数据，必须发往客户服务端进行解密
    INFO_TYPE_ENC_HEARTBEAT = 2,
    // 检测信息，包括 APP 基本信息及风控检测到的异常信息，信息详情请联系易盾获取
//    INFO_TYPE_CHEATINFO = 3,
} NTESHeartBeat;

typedef void (^HeartBeatBlock)(NSString *result);
typedef void (^InfoReceiver)(int type, NSString *info);
typedef void (^TokenBlock)(NSString *token, NSInteger code, NSString *message);
typedef void (^GetTokenCallback)(AntiCheatResult *result);
typedef void (^ActualRiskBlock)(NSInteger code, NSString *token);
typedef void (^HTPCallback)(int code, NSString *msg, NSString *content);

@interface NTESRiskUniPerception : NSObject

/**
 *  单例
 *
 *  @return               返回NTESRiskUniPerception对象
 */
+ (NTESRiskUniPerception *)fomentBevelDeadengo;

/**
 * 初始化接口，客户启动app时调用，只需调用一次
 *
 * @param productId        易盾官网注册的AppId
 * @param callback        回调信息
 *
 */
- (void)init:(NSString *)productId callback:(HTPCallback __nullable)callback;

- (void)initWithProductId:(NSString *)productId callback:(HTPCallback __nullable)callback DEPRECATED_MSG_ATTRIBUTE("Please use [NTESRiskUniPerception init:callback:].");

/**
 * 获取Token，默认超时3s
 *
 * @param businessId               场景id
 * @param timeout                  超时时间（范围：10000ms以内  单位:ms）
 *
 * @return                  获取到的token，用于校验是否有作弊行为
 */
- (AntiCheatResult *)getToken:(NSString *)businessId
                  withTimeout:(int)timeout;

- (NSString *)getTokenWithBussinessId:(NSString *)businessId
                          withTimeout:(int)timeout
                                error:(NSError **)error DEPRECATED_MSG_ATTRIBUTE("Please use [NTESRiskUniPerception getToken:withTimeout:].");

/**
 * 获取Token，默认超时3s
 *
 * @param businessId               场景id
 * @param timeout                        超时时间（范围：10000ms以内  单位:ms）
 * @param callback                      获取Token完成后回调
 */
- (void)getTokenAsync:(NSString *)businessId
          withTimeout:(int)timeout
      completeHandler:(GetTokenCallback)callback;

- (void)getTokenWithBussinessId:(NSString *)businessId
                    withTimeout:(int)timeout
                completeHandler:(TokenBlock)callback DEPRECATED_MSG_ATTRIBUTE("Please use [NTESRiskUniPerception getTokenAsync:withTimeout:completeHandler:].");

/**
 *  设置用户角色信息,用户登录或者切换账号后请调用这个接口,在此之前确保已调用initWithAppId.(调用这个接口后，才会启动外挂保护功能)
 *
 *  @param businessId                业务id
 *  @param roleId                    用户id
 *  @param roleName                  用户名字
 *  @param roleAccount               用户账号名
 *  @param roleServer                用户服务器
 *  @param serverId                  用户服务器id
 *  @param gameJson                  客户端自定义json
 *
 *  @注意事项                          上述参数除businessId必填外，可根据实际情况进行传入，所填信息需要能够定位到当前登陆玩家
 */
- (void)setRoleInfo:(NSString *)businessId
             roleId:(NSString *)roleId
           roleName:(NSString *)roleName
        roleAccount:(NSString *)roleAccount
         roleServer:(NSString *)roleServer
           serverId:(int)serverId
           gameJson:(NSString *)gameJson;

- (void)setRoleInfoWithBusinessId:(NSString *)businessId
                           roleId:(NSString *)roleId
                         roleName:(NSString *)roleName
                      roleAccount:(NSString *)roleAccount
                       roleServer:(NSString *)roleServer
                         serverId:(int)serverId
                         gameJson:(NSString *)gameJson DEPRECATED_MSG_ATTRIBUTE("Please use [NTESRiskUniPerception setRoleInfo:roleId:roleName:roleAccount:roleServer:serverId:gameJson:].");

/**
 *  退出登陆
 *
 *  @注意事项 调用setRoleInfoWithRoleId接口后再调用该接口,不能放在setRoleInfoWithRoleId的前面调用
 */
- (void)logOut;

/**
 *  数据查询
 *
 *  @param request            RequestCmdID:查询类型
 *  @param data                           配合查询需要的数据，不需要时传空，详见接入文档。
 */
- (NSString *)ioctl:(int)request withData:(NSString *)data;

/**
 *  心跳系统结果
 *
 *  @param block                        返回的心跳数据为默认为加密数据。
 */
- (void)heartbeatCheckResult:(HeartBeatBlock)block DEPRECATED_MSG_ATTRIBUTE("Please use [NTESRiskUniPerception heartbeatCheckResult:].");

/**
 *  心跳系统结果
 *
 *  @param type                           type=1 为未加密数据，type=2为加密数据。
 */
- (void)heartbeatCheckResult:(NSInteger)type callBack:(HeartBeatBlock)block DEPRECATED_MSG_ATTRIBUTE("Please use [NTESRiskUniPerception heartbeatCheckResult:callBack:].");

/**
 *  心跳系统结果
 *
 *  @param receiver                        返回的心跳数据为默认为加密数据。
 */
- (void)registInfoReceiver:(InfoReceiver)receiver;

/**
 *  模拟点击AI识别-开启数据采集
 *
 *  @param gameplayId                        玩法id
 *  @param sceneId                           场景id
 */
- (void)registerTouchEvent:(NSUInteger)gameplayId andSceneId:(NSUInteger)sceneId;

/**
 *  模拟点击AI识别-关闭数据采集
 *
 */
- (void)unregisterTouchEvent;
@end

NS_ASSUME_NONNULL_END
