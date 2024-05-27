//
//  PNCreditRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/28.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCreditRspModel : PNModel
/// 是否开通钱包 true -开通钱包 FALSE - 未开通钱包
@property (nonatomic, assign) BOOL walletCreated;
/// 钱包账户状态
@property (nonatomic, assign) PNWAlletAccountStatus accountStatus;
/// 账号状态升级
@property (nonatomic, assign) PNAccountLevelUpgradeStatus upgradeStatus;
/// 钱包账户等级
@property (nonatomic, assign) PNUserLevel accountLevel;
/// 协议h5
@property (nonatomic, copy) NSString *agreementH5;
/// 贷款入口h5
@property (nonatomic, copy) NSString *entranceH5;
/// 是否授信  true - 是  FALSE - 否
@property (nonatomic, assign) BOOL authorization;
/// 公司名称
@property (nonatomic, copy) NSString *corporateName;
@end

NS_ASSUME_NONNULL_END
