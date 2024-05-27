//
//  PNAccountViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAccountViewModel.h"
#import "PNAccountUpgradeDTO.h"
#import "PNUserDTO.h"


@interface PNAccountViewModel ()
@property (nonatomic, strong) PNUserDTO *userDTO;
@property (nonatomic, strong) PNAccountUpgradeDTO *upgradeDTO;

@end


@implementation PNAccountViewModel

/// 获取用户信息
- (void)getUserInfo {
    [self.view showloading];

    @HDWeakify(self);
    [self.userDTO getPayNowUserInfoV2Success:^(HDUserInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.userInfoModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 实名提交
- (void)submitRealNameWithParams:(NSMutableDictionary *)params successBlock:(void (^)(void))successBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.upgradeDTO submitRealNameWithParams:params successBlock:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 实名提交V2
- (void)submitRealNameV2WithParams:(NSMutableDictionary *)params successBlock:(void (^)(void))successBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.upgradeDTO submitRealNameV2WithParams:params successBlock:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 获取限额
- (void)getWalletLimit:(void (^_Nullable)(NSArray<PNWalletLimitModel *> *list))successBlock {
    [self.view showloading];

    @HDWeakify(self);
    [self.userDTO getWalletLimit:^(NSArray<PNWalletLimitModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock(list);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 查询最新提交的KYC信息
- (void)getUserInfoFromKYC {
    [self.view showloading];

    @HDWeakify(self);
    [self.userDTO queryUserInfoFromKYC:^(HDUserInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.userInfoModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 获取服务器当前时间
- (void)getCurrentDate {
    [self.userDTO getCurrentDay:^(NSString *_Nonnull rspDate) {
        self.currentDateStr = rspDate;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

#pragma mark
- (PNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[PNUserDTO alloc] init];
    }
    return _userDTO;
}

- (PNAccountUpgradeDTO *)upgradeDTO {
    if (!_upgradeDTO) {
        _upgradeDTO = [[PNAccountUpgradeDTO alloc] init];
    }
    return _upgradeDTO;
}
@end
