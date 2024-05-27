//
//  VipayUser.h
//  customer
//
//  Created by 陈剑 on 2018/7/27.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDUserInfoRspModel.h"
#import "HDUserRegisterRspModel.h"
#import "PNEnum.h"
#import "PNWalletFunctionModel.h"
#import "SACodingModel.h"
#import "YYModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface VipayUser : SACodingModel
@property (nonatomic, strong) PNWalletFunctionModel *functionModel;
@property (nonatomic, copy) NSString *customerNo;
/// 是否设置了支付密码
@property (nonatomic, assign) BOOL tradePwdExist;
/// 用户名
@property (nonatomic, copy) NSString *loginName;
/// 昵称
@property (nonatomic, copy) NSString *nickName;

@property (atomic, copy, nullable) NSString *sessionKey;
@property (nonatomic, copy, nullable) NSString *mobileToken;
//@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy, nullable) NSString *userNo;
@property (nonatomic, copy, nullable) NSString *headUrl;
@property (nonatomic, copy, nullable) NSString *status;
@property (nonatomic, assign) PNSexType sex;
@property (nonatomic, copy, nullable) NSString *accountNo;
//@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, strong, nullable) NSNumber *userInfoVersion;
@property (atomic, strong, nullable) NSDate *sessionUpdateTime;
@property (atomic, strong, nullable) NSDate *mobileUpdateTime;
/// 用户等级：100/初级;200/中级;300高级
@property (nonatomic, assign) PNUserLevel accountLevel;
////// 设备token
@property (nonatomic, copy, nullable) NSString *userDeviceToken;
///< 三方渠道UserID
@property (nonatomic, copy, nullable) NSString *thirdPartUserId;
//////< 三方登录token
@property (nonatomic, copy, nullable) NSString *thirdPartAccessToken;
//////< 三方渠道
@property (nonatomic, copy, nullable) NSString *thirdPartChannel;
//////< 邀请码
@property (nonatomic, copy, nullable) NSString *invitationCode;
/** 是否设置了支付密码 */
//@property (nonatomic, assign) BOOL tradePwdExist;
///< 登录密码是否设置
@property (nonatomic, assign) BOOL loginPwdExist;
///< 账单邮箱
@property (nonatomic, copy, nullable) NSString *billEmail;
/// 是否实名认证 12未实名 13已实名
@property (nonatomic, assign) PNAuthenStatus authStatus;
/// 账号状态升级
@property (nonatomic, assign) PNAccountLevelUpgradeStatus upgradeStatus;
@property (nonatomic, copy) NSString *upgradeMessage;
/// 用户升级失败原因
@property (nonatomic, copy, nullable) NSString *upgradeDesc;

/// 证件类型：12身份证；13护照；22驾照；23警察证/公务员证
@property (nonatomic, assign) PNPapersType cardType;
/// 证件号码
@property (nonatomic, copy) NSString *cardNum;
/// 证件有效期
@property (nonatomic, assign) NSInteger expirationTime;
/// 证件到期日
@property (nonatomic, assign) NSInteger visaExpirationTime;
/// 证明照
@property (nonatomic, copy) NSString *idCardBackUrl;
/// 反面照
@property (nonatomic, copy) NSString *idCardFrontUrl;

/// 名
@property (nonatomic, copy) NSString *firstName;
/// 姓
@property (nonatomic, copy) NSString *lastName;
/// 出生日期
@property (nonatomic, assign) NSInteger birthday;
/// 国籍区域
@property (nonatomic, copy) NSString *country;
/// 手持证件照
@property (nonatomic, copy) NSString *cardHandUrl;

/// 商户号 【取第一个】
@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, copy) NSString *merchantName;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;

/// 角色
@property (nonatomic, assign) PNMSRoleType role;
/// 菜单权限
@property (nonatomic, strong) NSArray *merchantMenus;
@property (nonatomic, assign) BOOL walletPrower;
@property (nonatomic, assign) BOOL withdraowPower;
@property (nonatomic, assign) BOOL collectionPower;
@property (nonatomic, assign) BOOL storePower;
@property (nonatomic, assign) BOOL receiverCodePower;
@property (nonatomic, assign) BOOL storeDataQueryPower;
/// 权限
@property (nonatomic, strong) NSMutableArray *permission;

/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 店铺编号
@property (nonatomic, copy) NSString *storeNo;

+ (instancetype _Nullable)shareInstance;
+ (void)loginWithModel:(HDUserRegisterRspModel *_Nullable)model;
- (void)logout;
- (void)save;
+ (BOOL)isLogin;
- (void)updateByModel:(HDUserInfoRspModel *_Nullable)model;
- (void)pn_lockSessionCompletion:(void (^)(void))completion;
- (void)pn_unlockSession;
- (BOOL)pn_needUpdateMobileToken;

/// 钱包余额 菜单显示
+ (BOOL)hasWalletBalanceMenu;

/// 今日收款 菜单显示
+ (BOOL)hasCollectionTodayMenu;

/// 提现 菜单显示
+ (BOOL)hasWalletWithdrawMenu;

/// 交易记录 菜单显示
+ (BOOL)hasCollectionDataQueryMenu;

/// 门店管理 菜单显示
+ (BOOL)hasStoreManagerMenu;

/// 收款码 菜单显示
+ (BOOL)hasMerchantCodeQueryMenu;

/// 操作员管理 菜单显示
+ (BOOL)hasOperatorManagerMenu;

/// 上传凭证 菜单显示
+ (BOOL)hasUploadVoucherMenu;

/// 右上角 设置入口
+ (BOOL)hasSettingMenu;

/// 钱包明细列表 入口
+ (BOOL)hasWalletOrder;

/// 交易记录 入口
+ (BOOL)hasWalletTransferList;
@end

NS_ASSUME_NONNULL_END
