//
//  PNMSHomeManager.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSHomeManager.h"
#import "HDMediator+PayNow.h"
#import "PNMSHomeDTO.h"
#import "PNMSInfoModel.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import "ViPayUser.h"
#import <HDUIKit/NAT.h>


@implementation PNMSHomeManager
static PNMSHomeDTO *_msHomeDTO = nil;

+ (void)adjustCheckMerchantServicesCompletion:(void (^)(BOOL isSuccess, NSString *merchantNo, NSString *merchantName, NSString *operatorNo, PNMSRoleType role, NSArray *merchantMenus,
                                                        NSArray *permission, NSString *storeNo, NSString *storeName))completion {
    if (!_msHomeDTO) {
        _msHomeDTO = PNMSHomeDTO.new;
    }

    UIViewController *visableVc = SAWindowManager.visibleViewController;
    [visableVc.view showloading];

    ///查询绑定的商户信息
    [_msHomeDTO getMerchantServicesInfo:^(PNMSInfoModel *_Nonnull rspModel) {
        [visableVc.view dismissLoading];
        PNMerchantStatus status = rspModel.status;
        //        status = PNMerchantStatusEnable;
        if (status == PNMerchantStatusUnBind) { /// 没有绑定商户
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesIntroductionVC:@{}];
        } else if (status == PNMerchantStatusUnderKYCLevel) { /// KYC 等级不够
            /// PNLocalizedString(@"pre_upgrade_KYC_tips", @"您的账户还完成KYC认证，请先升级您的账户。")
            [NAT showAlertWithMessage:rspModel.desc confirmButtonTitle:PNLocalizedString(@"Go_to_upgrade", @"去升级")
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
        } else if (status == PNMerchantStatusDisenable) { /// 停用
            [NAT showAlertWithMessage:rspModel.desc buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismiss];
                              }];
        } else if (status == PNMerchantStatusReviewing || status == PNMerchantStatusFailed) { ///审核中,审核失败
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesOpenResultVC:@{}];
        } else if (status == PNMerchantStatusEnable) {
            if (rspModel.merchantList.count > 0) {
                // 目前固定取第一个
                PNMSMerchantListModel *merchantListItemModel = [rspModel.merchantList firstObject];
                if (merchantListItemModel.hasTradePwd) { ///  没有设置密码得先设置 商户交易密码
                    !completion ?:
                                  completion(YES,
                                   merchantListItemModel.merchantNo,
                                   merchantListItemModel.merchantName,
                                   merchantListItemModel.operatorNo,
                                   rspModel.role,
                                   rspModel.merchantMenus,
                                   rspModel.permission,
                                   rspModel.storeNo,
                                   rspModel.storeName);
                } else {
                    void (^successHandler)(BOOL) = ^(BOOL success) {
                        if (success) {
                            NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:visableVc.navigationController.viewControllers];
                            [marr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([obj isMemberOfClass:NSClassFromString(@"PNMSTradePwdController")]) {
                                    [marr removeObject:obj];
                                }
                            }];
                            visableVc.navigationController.viewControllers = marr;

                            !completion ?:
                                          completion(YES,
                                           merchantListItemModel.merchantNo,
                                           merchantListItemModel.merchantName,
                                           merchantListItemModel.operatorNo,
                                           rspModel.role,
                                           rspModel.merchantMenus,
                                           rspModel.permission,
                                           rspModel.storeNo,
                                           rspModel.storeName);
                        }
                    };

                    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:@{
                        @"actionType": @(1),
                        @"completion": successHandler,
                        @"operatorNo": merchantListItemModel.operatorNo,
                    }];
                }
            } else {
                !completion ?: completion(NO, @"", @"", @"", 0, @[], @[], @"", @"");
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [visableVc.view dismissLoading];
    }];
}

@end
