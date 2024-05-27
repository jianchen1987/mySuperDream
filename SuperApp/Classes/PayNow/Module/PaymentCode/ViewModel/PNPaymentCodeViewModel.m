//
//  PNPaymentCodeViewModel.m
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNPaymentCodeViewModel.h"
#import "HDGenQRCodeRspModel.h"
#import "HDGetPaymentCodeRsp.h"
#import "HDQrCodePaymentResultQueryRsp.h"
#import "HDUserBussinessCreateRsp.h"
#import "HDUserBussinessQueryRsp.h"
#import "PNPaymentCodeDTO.h"
#import "PNRspModel.h"
#import "PNUserDTO.h"


@interface PNPaymentCodeViewModel ()
@property (nonatomic, strong) PNPaymentCodeDTO *paymentCodeDTO;

@property (nonatomic, strong) PNUserDTO *userDTO;
@end


@implementation PNPaymentCodeViewModel

/// 查询业务
- (void)queryUserBussinessStatusWithType:(PNUserBussinessType)bussinessType success:(void (^)(HDUserBussinessQueryRsp *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.paymentCodeDTO queryUserBussinessStatusWithType:bussinessType success:^(PNRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock([HDUserBussinessQueryRsp yy_modelWithJSON:rspModel.data]);
    } failure:failureBlock];
}

/// 开通业务
- (void)openBussinessWithType:(PNUserBussinessType)bussinessType
                        index:(NSString *)index
                     password:(NSString *)password
                      success:(void (^)(HDUserBussinessCreateRsp *rspModel))successBlock
                      failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.paymentCodeDTO openBussinessWithType:bussinessType index:index password:password success:^(PNRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock([HDUserBussinessCreateRsp yy_modelWithJSON:rspModel.data]);
    } failure:failureBlock];
}

/// 关闭业务
- (void)closeBussinessWithType:(PNUserBussinessType)bussinessType success:(void (^)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.paymentCodeDTO closeBussinessWithType:bussinessType success:^(PNRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock();
    } failure:failureBlock];
}

/// 获取付款结果
- (void)queryPaymentCodeResultWithContentQrCode:(NSString *)contentQrCode
                                        success:(void (^)(HDQrCodePaymentResultQueryRsp *rspModel))successBlock
                                        failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.paymentCodeDTO queryPaymentCodeResultWithContentQrCode:contentQrCode success:^(PNRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock([HDQrCodePaymentResultQueryRsp yy_modelWithJSON:rspModel.data]);
    } failure:failureBlock];
}

/// 免密支付 更新
- (void)updateCertifiledWithType:(PNUserBussinessType)bussinessType
                   operationType:(PNUserCertifiedTypes)operationType
                         success:(void (^)(void))successBlock
                         failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.paymentCodeDTO updateCertifiledWithType:bussinessType operationType:operationType success:^(PNRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock();
    } failure:failureBlock];
}

/// 获取收款码
- (void)genQRCodeByLoginName:(NSString *)loginName Amount:(NSString *)amount Currency:(NSString *)currency success:(void (^)(HDGenQRCodeRspModel *rspModel))successBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.paymentCodeDTO genQRCodeByLoginName:loginName Amount:amount Currency:currency success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock([HDGenQRCodeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)getLimitList:(void (^_Nullable)(NSArray<PNWalletLimitModel *> *list))successBlock {
    //    @HDWeakify(self);
    [self.userDTO getWalletLimit:^(NSArray<PNWalletLimitModel *> *_Nonnull list) {
        !successBlock ?: successBlock(list);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){
        //        @HDStrongify(self);
    }];
}

#pragma mark
- (PNPaymentCodeDTO *)paymentCodeDTO {
    if (!_paymentCodeDTO) {
        _paymentCodeDTO = [[PNPaymentCodeDTO alloc] init];
    }
    return _paymentCodeDTO;
}

- (PNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[PNUserDTO alloc] init];
    }
    return _userDTO;
}
@end
