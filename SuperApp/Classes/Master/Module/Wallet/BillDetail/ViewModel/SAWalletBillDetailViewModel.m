//
//  SAWalletBillDetailViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillDetailViewModel.h"
#import "SAWalletDTO.h"


@interface SAWalletBillDetailViewModel ()
/// DTO
@property (nonatomic, strong) SAWalletDTO *walletDTO;
/// 详情
@property (nonatomic, strong) SAWalletBillDetailRspModel *detailRspModel;
/// 是否正在加载
@property (nonatomic, assign) BOOL isLoading;
@end


@implementation SAWalletBillDetailViewModel
#pragma mark - public methods
- (void)getNewData {
    self.isLoading = true;
    @HDWeakify(self);
    [self.walletDTO queryWalletBillDetailWithTradeNo:self.tradeNo success:^(SAWalletBillDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.isLoading = false;
        self.detailRspModel = rspModel;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.isLoading = false;
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
