//
//  PNMSInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 商户钱包余额信息
@interface PNMSBalanceInfoModel : PNModel
/// 账户余额
@property (nonatomic, copy) NSString *balance;
/// 可用余额
@property (nonatomic, copy) NSString *usableBalance;
/// 可交易余额
@property (nonatomic, copy) NSString *tradableBalance;
/// 币种
@property (nonatomic, copy) NSString *currency;
@end


@interface PNMSMerchantListModel : PNModel
/// 登录名
@property (nonatomic, copy) NSString *loginAccount;
/// 主操作员
@property (nonatomic, copy) NSString *operatorNo;
/// 商户号
@property (nonatomic, copy) NSString *merchantNo;
/// 商户名
@property (nonatomic, copy) NSString *merchantName;
/// 商户状态 10：启用，11：停用，12：待激活，13：退网
@property (nonatomic, assign) NSInteger merStatus;
/// 是否设置了交易密码
@property (nonatomic, assign) BOOL hasTradePwd;
/// 商户钱包余额信息
@property (nonatomic, strong) NSArray<PNMSBalanceInfoModel *> *balanceInfos;
@end


@interface PNMSInfoModel : PNModel
/// 用户手机号
@property (nonatomic, copy) NSString *loginName;
/// 用户号
@property (nonatomic, copy) NSString *userNo;
/// 主商户号
@property (nonatomic, copy) NSString *mainMerchantNo;
/// 状态, 10：启用，11：禁用，12：待激活，13：退网，20：kyc等级不够，21：审核中，22：审核失败，23：未绑定商户
@property (nonatomic, assign) PNMerchantStatus status;
/// 描述信息
@property (nonatomic, copy) NSString *desc;
/// 商户列表
@property (nonatomic, strong) NSArray<PNMSMerchantListModel *> *merchantList;

/// 角色
@property (nonatomic, assign) PNMSRoleType role;
/// 菜单列表
@property (nonatomic, strong) NSMutableArray *merchantMenus;
/// 权限
@property (nonatomic, strong) NSMutableArray *permission;
/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 店铺编号
@property (nonatomic, copy) NSString *storeNo;

@end

NS_ASSUME_NONNULL_END
