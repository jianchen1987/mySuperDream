//
//  PNTransPhoneViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransPhoneViewModel.h"
#import "PNTransListDTO.h"
#import "PNWalletAcountModel.h"
#import "PNWalletDTO.h"


@interface PNTransPhoneViewModel ()
@property (nonatomic, strong) PNWalletDTO *walletDTO;
@property (nonatomic, strong) PNTransListDTO *transDTO;

@end


@implementation PNTransPhoneViewModel

/// 获取账户余额
- (void)getMyWalletBalance {
    [self.view showloading];
    @HDWeakify(self);
    [self.walletDTO getMyWalletInfoSuccess:^(PNWalletAcountModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.walletAccountModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

/// 确认转账
- (void)confirmTransferToPhone:(NSDictionary *)dict success:(void (^_Nullable)(HDTransferOrderBuildRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    HDLog(@"confirm");
    [self.transDTO outConfirmOrderWithParams:dict shouldAlertErrorMsgExceptSpecCode:YES success:^(HDTransferOrderBuildRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

#pragma mark
- (PNWalletDTO *)walletDTO {
    return _walletDTO ?: ({ _walletDTO = PNWalletDTO.new; });
}

- (PNTransListDTO *)transDTO {
    return _transDTO ?: ({ _transDTO = PNTransListDTO.new; });
}
@end
