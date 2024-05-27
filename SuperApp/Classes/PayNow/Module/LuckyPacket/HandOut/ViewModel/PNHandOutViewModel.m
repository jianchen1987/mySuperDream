//
//  PNHandOutViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNHandOutViewModel.h"
#import "HDGetEncryptFactorRspModel.h"
#import "PNCheckstandDTO.h"
#import "PNCommonUtils.h"
#import "PNExchangeRateModel.h"
#import "PNFactorRspModel.h"
#import "PNHandOutDTO.h"
#import "PNPasswordManagerDTO.h"
#import "PNTransListDTO.h"
#import "PNWalletDTO.h"
#import "PayHDPaymentProcessingHUD.h"
#import "PayHDTradeConfirmPaymentRspModel.h"
#import "PayHDTradeSubmitPaymentRspModel.h"
#import "RSACipher.h"


@interface PNHandOutViewModel ()
@property (nonatomic, strong) PNHandOutDTO *handOutDTO;
@property (nonatomic, strong) PNWalletDTO *walletDTO;
@property (nonatomic, strong) PNCheckstandDTO *standDTO;
@property (nonatomic, strong) PNPasswordManagerDTO *pwdDTO;
@property (nonatomic, strong) PayHDPaymentProcessingHUD *payHud;
@end


@implementation PNHandOutViewModel

- (void)getData {
    [self.view showloading];

    dispatch_group_t taskGroup = dispatch_group_create();

    dispatch_group_enter(taskGroup);
    [self getExchangeRate:^(PNExchangeRateModel *_Nullable rspModel) {
        self.exchangeRateModel = rspModel;
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_enter(taskGroup);
    [self getWalletInfo:^(PNWalletAcountModel *_Nullable rspModel) {
        self.walletAccountModel = rspModel;
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_enter(taskGroup);
    [self getCoverImageList:^(NSArray<NSString *> *rspArray) {
        if (rspArray.count > 0) {
            self.model.imageUrl = [rspArray objectAtIndex:0];
        }
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^{
        self.refreshFlag = !self.refreshFlag;
        [self.view dismissLoading];
    });
}

/// 查询汇率
- (void)getExchangeRate:(void (^_Nullable)(PNExchangeRateModel *_Nullable rspModel))completion {
    [self.handOutDTO getExchangeRate:^(PNExchangeRateModel *_Nonnull rspModel) {
        !completion ?: completion(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

/// 查询账号余额
- (void)getWalletInfo:(void (^_Nullable)(PNWalletAcountModel *_Nullable rspModel))completion {
    [self.walletDTO getMyWalletInfoSuccess:^(PNWalletAcountModel *_Nonnull rspModel) {
        !completion ?: completion(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

/// 获取图片地址
- (void)getCoverImageList:(void (^_Nullable)(NSArray<NSString *> *rspArray))completion {
    [self.handOutDTO getCoverImageList:^(NSArray<NSString *> *_Nonnull rspArray) {
        !completion ?: completion(rspArray);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

/// 下单
- (void)orderBuildLuckyPacket:(void (^_Nullable)(PNPacketBuildRspModel *rspModel, PNCashToolsRspModel *cashToolsModel))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setValue:@(self.model.splitType) forKey:@"splitType"];
    [dict setValue:@(self.model.packetType) forKey:@"packetType"];
    [dict setValue:@(self.model.grantObject) forKey:@"grantObject"];
    NSString *amtStr = [PNCommonUtils yuanTofen:self.model.amt];
    [dict setValue:amtStr forKey:@"amt"];
    [dict setValue:@(self.model.qty) forKey:@"qty"];
    [dict setValue:self.model.cy forKey:@"cy"];
    [dict setValue:self.model.imageUrl forKey:@"imageUrl"];
    [dict setValue:self.model.remarks forKey:@"remarks"];

    if (self.model.packetType == PNPacketType_Password) {
        [dict setValue:self.model.password forKey:@"password"];
        [dict setValue:@(PNPacketKeyType_Custom) forKey:@"keyType"];
    }

    if (self.model.grantObject == PNPacketGrantObject_In) {
        //        NSString *loginNames = [self.model.receivers componentsJoinedByString:@","];
        [dict setValue:self.model.receivers forKey:@"receivers"];
    }

    [self.view showloading];
    @HDWeakify(self);

    [self.handOutDTO packetBuild:dict success:^(PNPacketBuildRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.buildModel = rspModel;

        [self.handOutDTO cashTool:rspModel.tradeNo success:^(PNCashToolsRspModel *_Nonnull cashToolRspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.cashToolsModel = cashToolRspModel;
            !completion ?: completion(rspModel, cashToolRspModel);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)cashAccept:(NSString *)tradeNo
               pwd:(NSString *)password
     methodPayment:(PNCashToolsMethodPaymentItemModel *)methodPayment
              view:(UIView *)showView
        completion:(void (^_Nullable)(NSString *tradeNo, PNTransType tradeType))completion
           failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    self.payHud = [PayHDPaymentProcessingHUD showLoadingIn:showView offset:0];
    @HDWeakify(self);
    [self.standDTO coolCashOutCashAcceptWithTradeNo:tradeNo paymentCurrency:0 methodPayment:methodPayment success:^(PayHDTradeConfirmPaymentRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        NSString *random = [PNCommonUtils getRandomKey];
        [self.pwdDTO getEncryptFactorWithRandom:random success:^(HDGetEncryptFactorRspModel *_Nonnull factorRspModel) {
            NSString *securityTxt = [RSACipher encrypt:password publicKey:factorRspModel.publicKey];
            [self.pwdDTO coolCashOutPaymentSubmitWithVoucherNo:rspModel.voucherNo index:factorRspModel.index payPwd:securityTxt success:^(PayHDTradeSubmitPaymentRspModel *_Nonnull submitRspModel) {
                [self.payHud showSuccessCompletion:^{
                    !completion ?: completion(submitRspModel.tradeNo, submitRspModel.tradeType);
                }];
            } failure:failureBlock];
        } failure:failureBlock];
    } failure:failureBlock];
}

#pragma mark
- (PNHandOutDTO *)handOutDTO {
    if (!_handOutDTO) {
        _handOutDTO = [[PNHandOutDTO alloc] init];
    }
    return _handOutDTO;
}

- (PNWalletDTO *)walletDTO {
    if (!_walletDTO) {
        _walletDTO = [[PNWalletDTO alloc] init];
    }
    return _walletDTO;
}

- (PNCheckstandDTO *)standDTO {
    if (!_standDTO) {
        _standDTO = [[PNCheckstandDTO alloc] init];
    }
    return _standDTO;
}

- (PNPasswordManagerDTO *)pwdDTO {
    if (!_pwdDTO) {
        _pwdDTO = [[PNPasswordManagerDTO alloc] init];
    }
    return _pwdDTO;
}
@end
