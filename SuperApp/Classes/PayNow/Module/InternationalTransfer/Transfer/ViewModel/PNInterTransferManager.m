//
//  PNInterTransferManager.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferManager.h"
#import "HDMediator+PayNow.h"
#import "PNInterTransferDTO.h"
#import "PNRspModel.h"
#import "PNUtilMacro.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import "ViPayUser.h"
#import <HDUIKit/NAT.h>


@implementation PNInterTransferManager
static PNInterTransferDTO *_transferDTO = nil;

+ (void)adjustChecKInterTransferCompletion:(void (^)(BOOL isSuccess))completion {
    if (!_transferDTO) {
        _transferDTO = PNInterTransferDTO.new;
    }

    UIViewController *visableVc = SAWindowManager.visibleViewController;
    [visableVc.view showloading];

    /// 状态
    [_transferDTO checkInterTransfer:^(PNRspModel *_Nonnull rspModel) {
        [visableVc.view dismissLoading];
        !completion ?: completion(YES);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [visableVc.view dismissLoading];

        /// 额外处理特殊的code
        if (WJIsObjectNil(rspModel)) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"network_no_network", @"网络开小差啦") type:HDTopToastTypeError];
        } else {
            if ([rspModel.code isEqualToString:@"FX7001"]) {
                // 需要完善kyc用户信息
                [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                      [HDMediator.sharedInstance navigaveToPayNowAccountInfoVC:@{}];
                                  }];
            } else if ([rspModel.code isEqualToString:@"FX7002"]) {
                /// 需要升级为尊享用户
                [NAT showAlertWithMessage:rspModel.msg confirmButtonTitle:PNLocalizedString(@"Go_to_upgrade", @"去升级")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                        if (VipayUser.shareInstance.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALING || VipayUser.shareInstance.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_UPGRADING
                            || VipayUser.shareInstance.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING) {
                            [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountResultVC:@{}];
                        } else {
                            [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{}];
                        }
                    }
                    cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];
            } else {
                [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
            }
        }

        !completion ?: completion(NO);
    }];
}

@end
