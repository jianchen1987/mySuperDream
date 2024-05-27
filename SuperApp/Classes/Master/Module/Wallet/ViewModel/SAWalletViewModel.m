//
//  SAWalletViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletViewModel.h"
#import "SAQueryAvaliableChannelRspModel.h"
#import "SAWalletBalanceModel.h"
#import "SAWalletDTO.h"


@interface SAWalletViewModel ()
/// 数据源
@property (nonatomic, copy) NSArray<SAWalletItemModel *> *dataSource;
/// DTO
@property (nonatomic, strong) SAWalletDTO *walletDTO;
@end


@implementation SAWalletViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        SAWalletItemModel *model = SAWalletItemModel.new;
        model.logoImageName = @"wallet_logo";
        model.bgImageName = @"wallet_bg";
        model.title = SALocalizedString(@"balance", @"Balance");
        model.content = @"$ -.--";
        model.nonCashBalanceStr = @"0.00";
        model.nonCashBalance = @"0";
        self.dataSource = @[model];
    }
    return self;
}

#pragma mark - public methods
- (void)getNewData {
    @HDWeakify(self);
    [self.walletDTO queryBalanceSuccess:^(SAWalletBalanceModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (!HDIsObjectNil(rspModel) && rspModel.walletCreated) {
            SAWalletItemModel *itemModel = self.dataSource.firstObject;
            itemModel.content = rspModel.balance.thousandSeparatorAmount;
            itemModel.nonCashBalanceStr = rspModel.nonCashBalance.thousandSeparatorAmount;
            itemModel.nonCashBalance = rspModel.nonCashBalance.cent;
        }
        !self.successGetNewDataBlock ?: self.successGetNewDataBlock(self.dataSource);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.failedGetNewDataBlock ?: self.failedGetNewDataBlock(self.dataSource);
    }];
}

- (void)queryAvaliableChannelFinish:(void (^)(NSUInteger count))finish {
    [self.view showloading];
    @HDWeakify(self);
    [self.walletDTO queryAvaliableChannelWithTransType:HDWalletTransTypeRecharge clientType:SAClientTypeViPay success:^(NSArray<NSString *> *channels) {
        @HDStrongify(self);
        [self.view dismissLoading];
        finish(channels.count);
        //        finish(0);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        finish(0);
    }];
}

#pragma mark - lazy load
- (SAWalletDTO *)walletDTO {
    if (!_walletDTO) {
        _walletDTO = SAWalletDTO.new;
    }
    return _walletDTO;
}
@end
