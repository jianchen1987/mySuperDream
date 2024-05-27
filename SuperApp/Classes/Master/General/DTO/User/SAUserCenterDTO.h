//
//  SAUserCenterDTO.h
//  SuperApp
//
//  Created by seeu on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SALoginRspModel.h"
#import "SAModel.h"
#import "SAWechatGetAccessTokenRspModel.h"
#import "SAThirdPartyAccountBindStatusRspModel.h"
NS_ASSUME_NONNULL_BEGIN

@class SACheckUserStatusRspModel;
@class SAUserSilentPermissionRspModel;
@class SAContactModel;
@class SAMoneyModel;
@class SAWPontWillGetRspModel;
@class SAEarnPointBannerRspModel;


@interface SAUserCenterDTO : SAModel
/// 短信登陆，注册并登陆使用同一个接口
/// @param phoneNo 手机号
/// @param code 验证码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)loginWithPhoneNo:(NSString *)phoneNo
                 SmsCode:(NSString *)code
                 bizType:(NSString *)bizType
             agreementNo:(NSString *)agreementNo
               riskToken:(NSString *)riskToken
                 success:(void (^_Nullable)(SALoginRspModel *rspModel))successBlock
                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 设置登陆密码
/// @param password 登陆密码密文
/// @param index 加密因子索引
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)setLoginPasswordWithEncryptPwd:(NSString *)password index:(NSString *)index success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 检查手机号注册状态
/// @param countryCode 国家
/// @param accountNo 手机号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)checkUserStatusWithCountryCode:(NSString *)countryCode
                             accountNo:(NSString *)accountNo
                               success:(void (^)(SACheckUserStatusRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock;

/// 查询用户第三方绑定状态
/// @param channel 渠道
/// @param userId 用户 ID
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)checkThirdPartyAccountBindStatusChannel:(SAThirdPartyBindChannel)channel
                                         userId:(NSString *)userId
                                        success:(void (^)(SAThirdPartyAccountBindStatusRspModel *rspModel))successBlock
                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 授权登录
/// @param channel 渠道
/// @param thirdToken token
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)authLoginWithChannel:(SAThirdPartyBindChannel)channel
                      userId:(NSString *)userId
                  thirdToken:(NSString *)thirdToken
                   riskToken:(NSString *)riskToken
                     success:(void (^)(SALoginRspModel *rspModel))successBlock
                     failure:(CMNetworkFailureBlock)failureBlock;

/// 密码登陆
/// @param accountNo 账号
/// @param pwd 密码密文
/// @param index 加密索引
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)loginWithAccountNo:(NSString *)accountNo
                encryptPwd:(NSString *)pwd
                     index:(NSString *)index
                 riskToken:(NSString *)riskToken
                   success:(void (^)(SALoginRspModel *rspModel))successBlock
                   failure:(CMNetworkFailureBlock)failureBlock;

/// 激活操作员
/// @param account 账号
/// @param thirdToken 三方token
/// @param thirdUserName 三方用户名
/// @param channel 渠道
/// @param apiTicket 凭证
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)activeOperatorWithAccount:(NSString *)account
                       thirdToken:(NSString *)thirdToken
                    thirdUserName:(NSString *)thirdUserName
                          channel:(NSString *)channel
                        apiTicket:(NSString *)apiTicket
                        riskToken:(NSString *)riskToken
                          success:(void (^)(SALoginRspModel *rspModel))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock;

/// 绑定三方登陆账号并注册新账号
/// @param account 账号
/// @param thirdToken 三方token
/// @param thirdUserName 三方用户名
/// @param channel 渠道
/// @param apiTicket 凭证
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)bindLoginThirdPartyWithAccount:(NSString *)account
                        pwdSecurityStr:(NSString *_Nullable)pwdSecurityStr
                                 index:(NSString *_Nullable)index
                            thirdToken:(NSString *)thirdToken
                         thirdUserName:(NSString *)thirdUserName
                               channel:(NSString *)channel
                             apiTicket:(NSString *)apiTicket
                               success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock;

/// 用授权码换取AccessToken 和 UserID
/// @param authCode 授权码
/// @param channel 渠道
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getWechatAccessTokenWithAuthCode:(NSString *)authCode
                                 channel:(SAThirdPartyBindChannel)channel
                                 success:(void (^_Nullable)(SAWechatGetAccessTokenRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)userPermissionSilentlyWithParams:(NSDictionary *)params success:(void (^_Nullable)(SAUserSilentPermissionRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 绑定邀请码
/// @param invitationCode 邀请码
/// @param channel 渠道
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)bindInvitationCodeWithCode:(NSString *)invitationCode invitationChannel:(NSString *)channel success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 绑定注册
/// @param account 账号
/// @param thirdToken token
/// @param thirdUserName 用户名
/// @param channel 渠道
/// @param apiTicket ticket
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)thirtPartyBindRegisterWithAccountNo:(NSString *)account
                                 thirdToken:(NSString *)thirdToken
                              thirdUserName:(NSString *)thirdUserName
                                    channel:(NSString *)channel
                                  apiTicket:(NSString *)apiTicket
                                  riskToken:(NSString *)riskToken
                                    success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock;

/// 上传用户通讯录（悄咪咪）
/// @param datas 用户通讯录数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)uploadUserContactsWithDataArray:(NSArray<SAContactModel *> *)datas
                             operatorNo:(NSString *)operatorNo
                                success:(void (^_Nullable)(NSArray<SAContactModel *> *uploadedData))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询交易获得的积分数
/// @param orderNo 交易聚合单号
/// @param businessLine 业务线
/// @param actuallyPaidAmount 实付金额
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryHowManyWPointWillGetWithOrderNo:(NSString *)orderNo
                                businessLine:(SAClientType)businessLine
                          actuallyPaidAmount:(SAMoneyModel *)actuallyPaidAmount
                                  merchantNo:(NSString *_Nullable)merchantNo
                                     success:(void (^_Nullable)(SAWPontWillGetRspModel *_Nullable rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)thirdPartyRegisterWithChannel:(SAThirdPartyBindChannel)channel
                               userId:(NSString *)userId
                             authCode:(NSString *)authCode
                          accessToken:(NSString *)accessToken
                            riskToken:(NSString *)riskToken
                              success:(void (^)(SALoginRspModel *rspModel))successBlock
                              failure:(CMNetworkFailureBlock)failureBlock;

/// 查询Banner类型为未达门槛和已达门槛的启用中banner
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryEarnPointBannerSuccess:(void (^)(SAEarnPointBannerRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 第三方（APPLEID  FACEBOOK）登录接口
/// @param channel 频道
/// @param userId userId
/// @param thirdToken 第三方Token
/// @param riskToken 易盾Token
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)thirdPartLoginWithChannel:(SAThirdPartyBindChannel)channel
                           userId:(NSString *)userId
                       thirdToken:(NSString *)thirdToken
                        riskToken:(NSString *)riskToken
                          success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock;

/// 检查第三方绑定状态
/// @param channel 频道
/// @param userId userId
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)checkThirdPartyAccountBindStatusV2WithChannel:(SAThirdPartyBindChannel)channel
                                               userId:(NSString *)userId
                                              success:(void (^)(SAThirdPartyAccountBindStatusRspModel *_Nonnull))successBlock
                                              failure:(CMNetworkFailureBlock)failureBlock;

- (void)authLoginV2WithChannel:(SAThirdPartyBindChannel)channel
                        userId:(NSString *)userId
                    thirdToken:(NSString *)thirdToken
                     riskToken:(NSString *)riskToken
                       success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                       failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
