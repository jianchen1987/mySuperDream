//
//  PNMSCaseInViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSInfoModel.h"
#import "PNViewModel.h"

@class PNMSTransferCreateOrderRspModel;
@class PNMSWithdranBankInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSWithdrawViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, copy) NSString *operatorNo;

@property (nonatomic, strong) PNCurrencyType selectCurrency;
@property (nonatomic, strong) PNMSBalanceInfoModel *balanceInfoModel;
@property (nonatomic, copy) NSString *amount; //提现金额

@property (nonatomic, strong) NSMutableArray<PNMSWithdranBankInfoModel *> *dataSource;

/// 当前的model [新增]
@property (nonatomic, strong) PNMSWithdranBankInfoModel *withdranBankInfoModel;

@property (nonatomic, assign) BOOL rule;

/// 获取账号余额
- (void)getMSBalance;

///  下单
- (void)createOrderWithAmount:(NSString *)amount success:(void (^_Nullable)(PNMSTransferCreateOrderRspModel *rspModel))successBlock;

/// 获取已经绑定的银行卡列表
- (void)getWitdrawBankList:(BOOL)isShowLoading;

/// 通过银行账号 + 银行反查 账户名称
- (void)getAccountName;

/// 删除 银行卡
- (void)deleteBankCard:(PNMSWithdranBankInfoModel *)model;

- (void)preCheck:(void (^_Nullable)(void))successBlock;

/// 提现下单
- (void)bankCardCreateOrder:(PNMSWithdranBankInfoModel *)model success:(void (^_Nullable)(PNMSTransferCreateOrderRspModel *rspModel))successBlock;

@end

NS_ASSUME_NONNULL_END
