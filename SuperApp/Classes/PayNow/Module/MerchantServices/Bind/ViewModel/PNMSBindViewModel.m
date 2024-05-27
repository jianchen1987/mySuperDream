//
//  PNMSBindViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBindViewModel.h"
#import "HDMediator+PayNow.h"
#import "PNMSBindDTO.h"
#import "PNMSBindModel.h"
#import "PNRspModel.h"


@interface PNMSBindViewModel ()
@property (nonatomic, strong) PNMSBindDTO *homeDTO;
@end


@implementation PNMSBindViewModel
/// 查询商户信息
- (void)getMerchantInfoWithMerchantNo:(NSString *)merchantNo {
    [self.view showloading];
    @HDWeakify(self);
    [self.homeDTO queryMerchantServicesInfoWithMerchantNo:merchantNo success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        PNMSBindModel *model = [PNMSBindModel yy_modelWithJSON:rspModel.data];
        if (WJIsStringNotEmpty(model.merchantName) && WJIsStringNotEmpty(model.merchantNo)) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesBindVC:@{@"data": model.yy_modelToJSONObject}];
        } else {
            NSLog(@"数据有问题");
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 获取验证码
- (void)sendSMSCodeWithMerchantNo:(NSString *)merchantNo success:(void (^)(void))successBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.homeDTO sendSMSCodeWithMerchantNo:merchantNo success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

///
- (void)verifyAndBindWithMerchantNo:(NSString *)merchantNo smsCode:(NSString *)smsCode {
    [self.view showloading];
    @HDWeakify(self);
    [self.homeDTO verifyAndBindWithMerchantNo:merchantNo smsCode:smsCode success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [HDMediator.sharedInstance navigaveToPayNowMerchantServicesBindResultVC:@{}];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNMSBindDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = [[PNMSBindDTO alloc] init];
    }
    return _homeDTO;
}
@end
