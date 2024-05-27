//
//  PNIDVerifyViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNIDVerifyViewModel.h"
#import "PNIDVerifyDTO.h"
#import "PNNotificationMacro.h"
#import "SASettingPayPwdViewController.h"


@interface PNIDVerifyViewModel ()
@property (nonatomic, strong) PNIDVerifyDTO *idVerifyDTO;
@end


@implementation PNIDVerifyViewModel

// 获取 注册的证件类型
- (void)getCardType {
    [self.view showloading];
    @HDWeakify(self);
    [self.idVerifyDTO getCardType:^(PNGetCardTypeRspModel *_Nonnull model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.cardTypeRspModel = model;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 校验信息
- (void)verifyCustomerInfo:(NSString *)lastName firstName:(NSString *)firstName cardNum:(NSString *)cardNum {
    [self.view showloading];
    @HDWeakify(self);

    /*
     surname 姓  => lastName
     name 名称 => firstName
     */
    NSDictionary *verifyParamDict = @{
        @"loginName": SAUser.shared.loginName,
        @"userNo": SAUser.shared.operatorNo,
        @"accountLevel": @(self.userLevel),
        @"surname": lastName,
        @"name": firstName,
        @"cardType": self.cardTypeRspModel.code,
        @"cardNum": cardNum,
    };

    [self.idVerifyDTO verifyCustomerInfo:verifyParamDict success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{
            @"completion": self.successHandler,
            @"actionType": @(7),
            @"verifyParam": verifyParamDict,
        }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNIDVerifyDTO *)idVerifyDTO {
    if (!_idVerifyDTO) {
        _idVerifyDTO = [[PNIDVerifyDTO alloc] init];
    }
    return _idVerifyDTO;
}

@end
