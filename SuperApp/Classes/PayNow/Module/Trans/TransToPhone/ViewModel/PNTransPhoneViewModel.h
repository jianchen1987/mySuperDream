//
//  PNTransPhoneViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

@class PNWalletAcountModel;
@class HDTransferOrderBuildRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNTransPhoneViewModel : PNViewModel

/// 手机号 - 【 只用来填充数据 】
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, assign) PNTransferType bizType;

/// 当前选择的币种 账户
@property (nonatomic, strong) PNCurrencyType selectCurrency;

@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, strong) PNWalletAcountModel *walletAccountModel;
/// 获取账户余额
- (void)getMyWalletBalance;

/// 确认转账
- (void)confirmTransferToPhone:(NSDictionary *)dict success:(void (^_Nullable)(HDTransferOrderBuildRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
