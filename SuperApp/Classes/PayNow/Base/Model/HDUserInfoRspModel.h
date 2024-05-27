//
//  HDUserInfoRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/6.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDBaseCodingObject.h"
#import "HDJsonRspModel.h"
#import "PNEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDThirdPartAuthLoginInfoModel : HDBaseCodingObject

@property (nonatomic, copy) NSString *headUrl;      ///< 头像
@property (nonatomic, copy) NSString *authNickName; ///< 昵称
@property (nonatomic, copy) NSString *channel;      ///< 渠道

@end


@interface HDUserInfoRspModel : HDJsonRspModel
@property (nonatomic, copy) NSString *customerNo;
@property (nonatomic, copy) NSString *accountNo;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSNumber *version;
@property (nonatomic, assign) BOOL tradePwdExist;
@property (nonatomic, assign) BOOL loginPwdExist;
@property (nonatomic, copy) NSString *invitationCode; ///< 邀请码
@property (nonatomic, copy) NSArray<HDThirdPartAuthLoginInfoModel *> *authInfoList;
@property (nonatomic, copy) NSString *billEmail; ///< 账单邮箱

/**
 账号等级
 */
@property (nonatomic, assign) PNUserLevel accountLevel; ///用户等级：10/初级;11/中级;12高级 ,

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
/// 签证到期日
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

@property (nonatomic, assign) PNSexType sex;

@end

NS_ASSUME_NONNULL_END
