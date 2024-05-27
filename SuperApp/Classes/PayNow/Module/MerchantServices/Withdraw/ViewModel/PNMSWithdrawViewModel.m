//
//  PNMSCaseInViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdrawViewModel.h"
#import "HDPayeeInfoModel.h"
#import "PNMSHomeDTO.h"
#import "PNMSTransferCreateOrderRspModel.h"
#import "PNMSWitdrawDTO.h"
#import "PNMSWithdranBankInfoModel.h"
#import "PNRspModel.h"
#import "PNTransListDTO.h"
#import "ViPayUser.h"


@interface PNMSWithdrawViewModel ()
@property (nonatomic, strong) PNTransListDTO *transferDTO;
@property (nonatomic, strong) PNMSHomeDTO *homeDTO;
@property (nonatomic, strong) PNMSWitdrawDTO *withdrawDTO;
@property (nonatomic, assign) NSInteger tagF;
@end


@implementation PNMSWithdrawViewModel

- (void)getMSBalance {
    [self.view showloading];
    @HDWeakify(self);
    [self.homeDTO getMSHomeBalance:^(NSArray<PNMSBalanceInfoModel *> *_Nonnull rspList) {
        @HDStrongify(self);
        [self.view dismissLoading];
        for (PNMSBalanceInfoModel *itemModel in rspList) {
            if ([itemModel.currency isEqualToString:self.selectCurrency]) {
                self.balanceInfoModel = itemModel;
                break;
            }
        }
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

///  下单
- (void)createOrderWithAmount:(NSString *)amount success:(void (^_Nullable)(PNMSTransferCreateOrderRspModel *rspModel))successBlock {
    [self.view showloading];
    @HDWeakify(self);

    NSDictionary *dict = @{
        @"amt": amount,
        @"userFeeAmt": @(0),
        @"realAmt": amount,
        @"currency": self.selectCurrency,
        @"userMp": VipayUser.shareInstance.loginName,
        @"merchantNo": self.merchantNo,
        @"operatorNo": self.operatorNo,
        @"operatorType": @(10),
    };

    [self.withdrawDTO transferMSCreateOrderWithParam:dict success:^(PNMSTransferCreateOrderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)getWitdrawBankList:(BOOL)isShowLoading {
    if (isShowLoading) {
        [self.view showloading];
    }

    @HDWeakify(self);
    [self.withdrawDTO getBankCradListWithCurrency:self.selectCurrency success:^(NSArray<PNMSWithdranBankInfoModel *> *_Nonnull rspArray) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.dataSource = [NSMutableArray arrayWithArray:rspArray];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 商户服务提现 交易前检查
- (void)preCheck:(void (^_Nullable)(void))successBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@((NSInteger)(self.amount.doubleValue * 100)) forKey:@"orderAmt"];
    [dict setValue:self.selectCurrency forKey:@"currency"];

    [self.view showloading];
    @HDWeakify(self);
    [self.withdrawDTO withdrawPreCheck:dict success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)bankCardCreateOrder:(PNMSWithdranBankInfoModel *)model success:(void (^_Nullable)(PNMSTransferCreateOrderRspModel *rspModel))successBlock {
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:self.amount forKey:@"orderAmt"];
    //    [dict setValue:self.selectCurrency forKey:@"currency"];
    //
    //
    //    [self.view showloading];
    //
    //    @HDWeakify(self);
    //    [self preCheck:dict success:^{
    //        [dict setValue:model.accountNumber forKey:@"accountNumber"];
    //        [dict setValue:model.participantCode forKey:@"participantCode"];
    //
    //        @HDStrongify(self);
    //        @HDWeakify(self);
    //        [self.withdrawDTO bankCardWithdrawMSCreateOrderWithParam:dict success:^(PNMSTransferCreateOrderRspModel * _Nonnull rspModel) {
    //            @HDStrongify(self);
    //            [self.view dismissLoading];
    //            !successBlock ?: successBlock(rspModel);
    //        } failure:^(PNRspModel * _Nullable rspModel, NSInteger errorType, NSError * _Nullable error) {
    //            @HDStrongify(self);
    //            [self.view dismissLoading];
    //        }];
    //    }];
}

/// 通过银行账号 + 银行反查 账户名称
- (void)getAccountName {
    if (WJIsStringNotEmpty(self.withdranBankInfoModel.participantCode) && WJIsStringNotEmpty(self.withdranBankInfoModel.accountNumber)) {
        NSDictionary *dict = @{
            @"accountNumber": self.withdranBankInfoModel.accountNumber,
            @"participantCode": self.withdranBankInfoModel.participantCode,
            @"currency": self.withdranBankInfoModel.currency,
        };

        [self.view showloading];
        @HDWeakify(self);
        self.rule = NO;
        [self.withdrawDTO queryBankCardInfo:dict success:^(PNRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.withdranBankInfoModel.accountName = [rspModel.data objectForKey:@"accountName"] ?: @"";
            self.rule = YES;
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.rule = NO;
        }];
    }
}

/// 删除 银行卡
- (void)deleteBankCard:(PNMSWithdranBankInfoModel *)model {
    [self.view showloading];
    @HDWeakify(self);

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.accountNumber forKey:@"accountNumber"];
    [dict setValue:model.participantCode forKey:@"participantCode"];
    [dict setValue:model.currency forKey:@"currency"];

    [self.withdrawDTO deleteBankCard:dict success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self.dataSource removeObject:model];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNMSHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = [[PNMSHomeDTO alloc] init];
    }
    return _homeDTO;
}

- (PNMSWitdrawDTO *)withdrawDTO {
    if (!_withdrawDTO) {
        _withdrawDTO = [[PNMSWitdrawDTO alloc] init];
    }
    return _withdrawDTO;
}

- (NSMutableArray<PNMSWithdranBankInfoModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNTransListDTO *)transferDTO {
    if (!_transferDTO) {
        _transferDTO = [[PNTransListDTO alloc] init];
    }
    return _transferDTO;
}
@end
