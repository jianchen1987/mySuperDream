//
//  PNMSOperatorViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOperatorViewModel.h"
#import "PNMSOperatorDTO.h"
#import "PNRspModel.h"


@interface PNMSOperatorViewModel ()
@property (nonatomic, strong) PNMSOperatorDTO *operatorDTO;
@end


@implementation PNMSOperatorViewModel

- (void)getNewData:(BOOL)isNeedShowLoading {
    if (isNeedShowLoading) {
        [self.view showloading];
    }

    @HDWeakify(self);
    [self.operatorDTO getOperatorListData:^(NSArray<PNMSOperatorInfoModel *> *_Nonnull rspArray) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.dataSource = [NSMutableArray arrayWithArray:rspArray];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

- (void)getOperatorDetail {
    [self.view showloading];
    @HDWeakify(self);
    [self.operatorDTO getOperatorDetail:self.operatorMobile success:^(PNMSOperatorInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.operatorInfoModel = rspModel;
        self.operatorInfoModel.operatorMobile = [self.operatorInfoModel.operatorMobile stringByReplacingOccurrencesOfString:@"8550" withString:@""];
        self.isSuccess = YES;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 重置交易密码
- (void)resetPwdWithOperatorMobile:(NSString *)operatorMobile {
    [self.view showloading];
    @HDWeakify(self);
    [self.operatorDTO reSetOperatorPwdSendSMS:operatorMobile success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_sms_send", @"短信发送成功") type:HDTopToastTypeSuccess];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 解除绑定
- (void)unBindWithOperatorMobile:(NSString *)operatorMobile {
    [self.view showloading];
    @HDWeakify(self);
    [self.operatorDTO unBindOperator:operatorMobile success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self getNewData:NO];
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_unbind_succeeds", @"解绑成功") type:HDTopToastTypeSuccess];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 保持或者编辑 操作员信息
- (void)saveOrUpdateOperatorInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.operatorInfoModel.operatorUserId forKey:@"id"];
    [dict setValue:[NSString stringWithFormat:@"8550%@", self.operatorInfoModel.operatorMobile] forKey:@"operatorMobile"];
    NSString *permissionListStr = [self.operatorInfoModel.permissionList componentsJoinedByString:@","];
    [dict setValue:permissionListStr forKey:@"permissionList"];
    [dict setValue:self.operatorInfoModel.accountNo forKey:@"accountNo"];

    [self.view showloading];
    @HDWeakify(self);
    [self.operatorDTO saveOrUpdateOperator:dict success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self.view.viewController.navigationController popViewControllerAnimated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 反查信息
- (void)getCoolCashAccountName {
    [self.view showloading];

    @HDWeakify(self);
    [self.operatorDTO getCCAmountWithMobile:self.operatorInfoModel.operatorMobile success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        HDLog(@"%@", rspModel.data);
        if ([rspModel.data isKindOfClass:NSDictionary.class]) {
            NSString *firstName = [rspModel.data objectForKey:@"firstName"] ?: @"";
            NSString *lastName = [rspModel.data objectForKey:@"lastName"] ?: @"";
            self.operatorInfoModel.name = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
            self.operatorInfoModel.accountNo = [rspModel.data objectForKey:@"accountNo"];
            self.isSuccess = YES;
        }
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.operatorInfoModel.name = @"";
        self.operatorInfoModel.accountNo = @"";
    }];
}

#pragma mark
- (NSMutableArray<PNMSOperatorInfoModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNMSOperatorDTO *)operatorDTO {
    if (!_operatorDTO) {
        _operatorDTO = [[PNMSOperatorDTO alloc] init];
    }
    return _operatorDTO;
}
@end
