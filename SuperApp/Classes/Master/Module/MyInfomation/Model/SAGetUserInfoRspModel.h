//
//  SAGetUserInfoRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"
#import "SAUserThirdBindModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAInternationalizationModel;


@interface SAGetUserInfoRspModel : SARspModel
/// 性别
@property (nonatomic, copy) SAGender gender;
/// 头像
@property (nonatomic, copy) NSString *headURL;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 生日
@property (nonatomic, copy) NSString *birthday;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
/// 手机号
@property (nonatomic, copy) NSString *mobile;
/// 邮箱
@property (nonatomic, copy) NSString *email;
/// 邮箱验证状态 10：未验证 11：已验证
@property (nonatomic, assign) NSInteger emailStatus;
/// 头像 Id
@property (nonatomic, copy) NSString *headFileId;
/// 头像分组
@property (nonatomic, copy) NSString *headGroup;
/// 职业
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *education;      ///< 学历
@property (nonatomic, copy) NSString *invitationCode; ///< 邀请码

/// 联系电话
@property (nonatomic, copy) NSString *contactNumber;

#pragma mark - 会员相关
///< 积分余额
@property (nonatomic, strong) NSNumber *pointBalance;
///< 会员等级
@property (nonatomic, assign) NSUInteger opLevel;
///< 会员名称
@property (nonatomic, copy) NSString *opLevelName;
///< 会员logo
@property (nonatomic, copy) NSString *memberLogo;
#pragma mark - 第三方渠道
/// 第三方绑定
@property (nonatomic, copy) NSArray<SAUserThirdBindModel *> *thirdBindsList;

/// custom
@property (nonatomic, assign) NSInteger WMAge;
@end

NS_ASSUME_NONNULL_END
