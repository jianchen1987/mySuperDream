//
//  SAWalletManager.m
//  SuperApp
//
//  Created by VanJay on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletManager.h"
#import "HDMediator+PayNow.h"
#import "HDMediator+SuperApp.h"
#import "SARspModel.h"
#import "SAUser.h"
#import "SAWalletBalanceModel.h"
#import "SAWalletDTO.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"


@implementation SAWalletManager
static SAWalletDTO *_walletDTO = nil;

+ (void)adjustShouldSettingPayPwdCompletion:(void (^)(BOOL needSetting, BOOL isSuccess))completion {
    [self adjustShouldSettingPayPwdCompletion:completion shouldSet:true];
}

+ (void)adjustShouldSettingPayPwdCompletion:(void (^)(BOOL needSetting, BOOL isSuccess))completion shouldSet:(BOOL)shouldSet {
    // 先判断用户是否已缓存是否开通钱包（开通了就不会关闭）
    if (SAUser.shared.tradePwdExist) {
        // 已经设置支付密码
        !completion ?: completion(false, true);
        return;
    }
    // 未设置，再次查询
    if (!_walletDTO) {
        _walletDTO = SAWalletDTO.new;
    }

    UIViewController *visableVc = SAWindowManager.visibleViewController;
    [visableVc.view showloading];

    [_walletDTO queryBalanceSuccess:^(SAWalletBalanceModel *_Nonnull rspModel) {
        [visableVc.view dismissLoading];

        if (!rspModel.walletCreated && shouldSet) {
            [HDMediator.sharedInstance navigaveToPayNowOpenWalletVC:@{
                @"viewType": @(0),
                @"completion": completion,
            }];
        } else {
            // 走未激活流程 进行验证
            if ([rspModel.accountStatus isEqualToString:PNWAlletAccountStatusNotActive]) {
                [HDMediator.sharedInstance navigaveToPayNowOpenWalletVC:@{
                    @"viewType": @(1),
                    @"accountLevel": @(rspModel.accountLevel),
                    @"completion": completion,
                }];
            } else {
                // 成功查询余额代表已设置支付密码
                SAUser.shared.tradePwdExist = true;
                [SAUser.shared save];
                // 回调
                !completion ?: completion(false, true);
            }
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [visableVc.view dismissLoading];
        ///更改接口之后理论上应该不会出现这个错误
        if ([rspModel.code isEqualToString:@"U1022"]) {
            if (shouldSet) {
                // 未设置支付密码
                //                    [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{@"actionType": @(2),
                //                                                                                       @"completion": completion,
                //                                                                                       @"isPresent": @(1)
                //                    }];
                [HDMediator.sharedInstance navigaveToPayNowOpenWalletVC:@{
                    @"viewType": @(0),
                    @"completion": completion,
                }];
            } else {
                !completion ?: completion(true, false);
            }

        } else {
            // 其它异常，不处理
            !completion ?: completion(false, false);
        }
    }];
}
@end
