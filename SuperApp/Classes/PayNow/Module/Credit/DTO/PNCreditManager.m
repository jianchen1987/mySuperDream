//
//  PNCreditManager.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/28.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNCreditManager.h"
#import "PNCreditDTO.h"
#import "UIView+NAT.h"
#import "PNCreditRspModel.h"
#import "SAWindowManager.h"
#import "HDMediator+PayNow.h"
#import <HDUIKit/NAT.h>


@interface PNCreditManager ()
@property (nonatomic, strong) PNCreditDTO *creditDTO;
@end


@implementation PNCreditManager

+ (instancetype)sharedInstance {
    static PNCreditManager *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[super allocWithZone:nil] init];
    });
    return ins;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

#pragma mark
- (void)checkCreditAuthorizationCompletion:(void (^)(BOOL needAuth, NSDictionary *rpsData))completion {
    UIViewController *visableVc = SAWindowManager.visibleViewController;
    [visableVc.view showloading];


    @HDWeakify(visableVc);
    [self.creditDTO checkCreditAuthorization:^(PNCreditRspModel *_Nonnull rspModel) {
        @HDStrongify(visableVc);
        [visableVc.view dismissLoading];

        if (!rspModel.authorization) {
            !completion ?: completion(true, [rspModel yy_modelToJSONObject]);
        } else {
            /// 未开通钱包
            if (!rspModel.walletCreated) {
                [HDMediator.sharedInstance navigaveToPayNowOpenWalletVC:@{
                    @"viewType": @(0),
                }];
                !completion ?: completion(false, nil);
                return;
            }
            /// 走未激活流程 进行验证
            if ([rspModel.accountStatus isEqualToString:PNWAlletAccountStatusNotActive]) {
                [HDMediator.sharedInstance navigaveToPayNowOpenWalletVC:@{
                    @"viewType": @(1),
                    @"accountLevel": @(rspModel.accountLevel),
                }];
                !completion ?: completion(false, nil);
                return;
            }

            /// 非尊享
            if (rspModel.accountLevel != PNUserLevelHonour) {
                [NAT showAlertWithMessage:PNLocalizedString(@"VUL8JNLi", @"账户等级非尊享，请升级") confirmButtonTitle:PNLocalizedString(@"Go_to_upgrade", @"去升级")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                        if (rspModel.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALING || rspModel.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_UPGRADING
                            || rspModel.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING) {
                            [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountResultVC:@{}];
                        } else {
                            [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{}];
                        }
                    }
                    cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];

                !completion ?: completion(false, nil);
                return;
            }

            if (rspModel.authorization) {
                [SAWindowManager openUrl:rspModel.entranceH5 withParameters:nil];
                !completion ?: completion(false, nil);
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(visableVc);
        [visableVc.view dismissLoading];
    }];
}

#pragma mark
- (PNCreditDTO *)creditDTO {
    if (!_creditDTO) {
        _creditDTO = [[PNCreditDTO alloc] init];
    }
    return _creditDTO;
}
@end
