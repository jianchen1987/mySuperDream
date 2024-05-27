//
//  PNMSStoreOperatorInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPermissionModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreOperatorInfoModel : PNMSPermissionModel

@property (nonatomic, assign) BOOL voiceSwitch;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *storeOperatorId;

/// 商户编号
@property (nonatomic, copy) NSString *merchantNo;
/// 商户名称
@property (nonatomic, copy) NSString *merchantName;
/// 登录的账号
@property (nonatomic, copy) NSString *operatorMobile;
/// 姓名
@property (nonatomic, copy) NSString *name;
/// 账户编号
@property (nonatomic, copy) NSString *accountNo;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
/// 操作员名称
@property (nonatomic, copy) NSString *operatorName;
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 角色
@property (nonatomic, assign) PNMSRoleType role;
@property (nonatomic, copy) NSString *roleStr;

@end

NS_ASSUME_NONNULL_END
