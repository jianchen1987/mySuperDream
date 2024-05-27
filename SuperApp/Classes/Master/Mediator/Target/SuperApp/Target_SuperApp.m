
//
//  Target_SuperApp.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "Target_SuperApp.h"
#import "CMSTestViewController.h"
#import "GNTabBarController.h"
#import "HDCheckstandWebViewController.h"
#import "SAAddressListViewController.h"
#import "SAAddressModel.h"
#import "SAAppSwitchManager.h"
#import "SAAppVersionInfoRspModel.h"
#import "SAAppVersionViewController.h"
#import "SABusinessBaseCouponListViewController.h"
#import "SACMSCacheKeyConst.h"
#import "SACallAccountController.h"
#import "SAChangeLanguageViewPresenter.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAChangePayPwdInputSMSViewController.h"
#import "SAChooseAddressMapViewController.h"
#import "SAChooseMyAddressViewController.h"
#import "SAChooseZoneViewController.h"
#import "SACouponRedemptionController.h"
#import "SAImDelegateManager.h"
#import "SAMessageCenterViewController.h"
#import "SAMyCouponsViewController.h"
#import "SAMyInfomationViewController.h"
#import "SANavigationController.h"
#import "SAPasswordSettingOptionViewController.h"
#import "SAPayResultViewController.h"
#import "SARefundDetailViewController.h"
#import "SASetEmailViewController.h"
#import "SASetNickNameViewController.h"
#import "SASettingPayPwdViewController.h"
#import "SASettingsViewController.h"
#import "SASuggestionViewController.h"
#import "SASystemMessageViewController.h"
#import "SATabBarController.h"
#import "SATopUpOrderDetailViewController.h"
#import "SAVersionAlertManager.h"
#import "SAWalletBillDetailViewController.h"
#import "SAWalletBillListViewController.h"
#import "SAWalletChargeResultViewController.h"
#import "SAWalletChargeViewController.h"
#import "SAWalletViewController.h"
#import "SAWindowManager.h"
#import "TNTabBarViewController.h"
#import "UIView+NAT.h"
#import "WMStoreFavoutiteListController.h"
#import "WMTabBarController.h"
#import <HDServiceKit/HDScanCodeViewController.h>
#import <KSInstantMessagingKit/KSAudioCall.h>
#import <KSInstantMessagingKit/KSChatUI.h>
#import <KSInstantMessagingKit/KSCore.h>
#import <KSInstantMessagingKit/KSVideoCall.h>
#import "PNOpenWalletVC.h"
#import "SABusinessCouponListViewController.h"
#import "SACMSWaterfallViewController.h"
#import "SACancellationApplicationViewController.h"
#import "SAChangeLoginPasswordViewController.h"
#import "SACommonOrderDetailsViewController.h"
#import "SACommonRefundDetailViewController.h"
#import "SAForgotPasswordViewController.h"
#import "SALoginBySMSViewController.h"
#import "SALoginByVerificationCodeViewController.h"
#import "SAOrderViewController.h"
#import "SARefundDestinationViewController.h"
#import "SASetPasswordViewController.h"
#import "SASuggestionDetailViewController.h"
#import "SAUserBillListViewController.h"
#import "SAUserBillPaymentDetailsViewController.h"
#import "SAUserBillRefundDetailsViewController.h"
#import "SAWaitPayResultViewController.h"
#import "WNHomeViewController.h"
#import "WNQRDecoder+PayNow.h"
#import "WNQRDecoder.h"
#import "SAOrderSearchViewController.h"
#import "SAImFeedbackViewController.h"
#import "SAScanViewController.h"
#import "SALoginWithSMSViewController.h"
#import "SAVerificationCodeViewController.h"
#import "SAForgetPasswordOrBindPhoneViewController.h"
#import "SASetPhoneViewController.h"
#import "SABindEmailViewController.h"
#import "SAAddressCacheAdaptor.h"
#import "SAMCChatListViewController.h"

@implementation _Target (SuperApp)

- (void)_Action(scanQRCode):(NSDictionary *)params {
    HDScanCodeViewController *vc = [HDScanCodeViewController new];
    vc.resultBlock = ^(NSString *_Nullable scanString) {
        HDLog(@"扫码结果:%@", scanString);
        NSString *trimStr = [scanString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // wownow先识别内部路由
        if ([WNQRDecoder.sharedInstance canDecodeQRCode:trimStr]) {
            [WNQRDecoder.sharedInstance decodeQRCode:trimStr];
            return;
        } else if ([WNQRDecoder.sharedInstance canDecodePayNowQRCode:trimStr]) {
            // coolcash 处理内部二维码
            [WNQRDecoder.sharedInstance decodePayNowQRCode:trimStr];
            return;
        } else {
            // 业务方处理不了再转给wownow兜底
            [WNQRDecoder.sharedInstance decodeQRCode:trimStr];
        }
    };
    vc.customerTitle = SALocalizedString(@"scan_title", @"扫一扫");
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToSettingsViewController):(NSDictionary *)params {
    SASettingsViewController *vc = [[SASettingsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(appSuggestion):(NSDictionary *)params {
    SASuggestionViewController *vc = [[SASuggestionViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(myInformation):(NSDictionary *)params {
    SAMyInfomationViewController *vc = [[SAMyInfomationViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToEmailController):(NSDictionary *)params {
    SASetEmailViewController *vc = [[SASetEmailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(setPhone):(NSDictionary *)params {
    SASetPhoneViewController *vc = [[SASetPhoneViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToSetNickNameController):(NSDictionary *)params {
    SASetNickNameViewController *vc = [[SASetNickNameViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToSetNicknameController):(NSDictionary *)params {
    SASetNickNameViewController *vc = [[SASetNickNameViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToAppVersionViewController):(NSDictionary *)params {
    SAAppVersionViewController *vc = [[SAAppVersionViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(YumNow):(NSDictionary *)params {
    WMTabBarController *vc = [[WMTabBarController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(TinhNow):(NSDictionary *)params {
    //进入tinhNow 如果已经在tinhNow 已经存在  直接pop回去首页
    id rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:SATabBarController.class]) {
        SATabBarController *trueRootVC = (SATabBarController *)rootVC;
        SANavigationController *selectedVC = [trueRootVC selectedViewController];
        if ([selectedVC.topViewController isKindOfClass:[TNTabBarViewController class]]) { //在tinhNow里面
            TNTabBarViewController *tabBarVC = (TNTabBarViewController *)selectedVC.topViewController;
            SANavigationController *subNav = [tabBarVC selectedViewController];
            if (tabBarVC.selectedIndex != 0) {
                [tabBarVC setSelectedIndex:0];
            }
            [subNav popToRootViewControllerAnimated:YES];
            return;
        } else {
            for (UIViewController *subVC in selectedVC.childViewControllers) {
                if ([subVC isKindOfClass:[TNTabBarViewController class]]) {
                    TNTabBarViewController *tabBarVC = (TNTabBarViewController *)subVC;
                    if (tabBarVC.selectedIndex != 0) {
                        [tabBarVC setSelectedIndex:0];
                    }
                    [selectedVC popToViewController:tabBarVC animated:YES];
                    return;
                }
            }
        }
    }
    TNTabBarViewController *vc = [[TNTabBarViewController alloc] init];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(GroupOn):(NSDictionary *)params {
    GNTabBarController *vc = [[GNTabBarController alloc] init];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToTopUpDetailViewController):(NSDictionary *)params {
    SATopUpOrderDetailViewController *vc = [[SATopUpOrderDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(revceivingAddressList):(NSDictionary *)params {
    SAAddressListViewController *vc = [[SAAddressListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(login):(NSDictionary *)params {
    [SAWindowManager switchWindowToLoginViewController];
}

- (void)_Action(navigaveToTopUpRefundDetailViewController):(NSDictionary *)params {
    SARefundDetailViewController *vc = [[SARefundDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(commonRefundDetail):(NSDictionary *)params {
    SACommonRefundDetailViewController *vc = [[SACommonRefundDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToRefundDestinationViewController):(NSDictionary *)params {
    SARefundDestinationViewController *vc = [[SARefundDestinationViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(myCouponList):(NSDictionary *)params {
    SAMyCouponsViewController *vc = [[SAMyCouponsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(businessCouponList):(NSDictionary *)params {
    if ([params[@"businessLine"] isEqualToString:@"YumNow"]) {
        SABusinessCouponListViewController *vc = [[SABusinessCouponListViewController alloc] initWithRouteParameters:params];
        [SAWindowManager navigateToViewController:vc parameters:params];
    } else {
        SABusinessBaseCouponListViewController *vc = [[SABusinessBaseCouponListViewController alloc] initWithRouteParameters:params];
        [SAWindowManager navigateToViewController:vc parameters:params];
    }
}

- (void)_Action(wallet):(NSDictionary *)params {
    [SAWindowManager navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                           @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                         SALocalizedString(@"login_new2_Wallet", @"钱包")] bindSuccessBlock:^{
        [HDMediator.sharedInstance navigaveToPayNowWalletVC:@{}];
    }
                                              cancelBindBlock:nil];
}

- (void)_Action(navigaveToSettingPayPwdViewController):(NSDictionary *)params {
    SASettingPayPwdViewController *vc = [[SASettingPayPwdViewController alloc] initWithRouteParameters:params];
    BOOL isPresent = [params objectForKey:@"isPresent"];
    if (isPresent) {
        [SAWindowManager presentViewController:vc parameters:nil];
    } else {
        [SAWindowManager navigateToViewController:vc parameters:params];
    }
}

- (void)_Action(navigaveToWalletChargeViewController):(NSDictionary *)params {
    SAWalletChargeViewController *vc = [[SAWalletChargeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToWalletBillListViewController):(NSDictionary *)params {
    SAWalletBillListViewController *vc = [[SAWalletBillListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToWalletBillDetailViewController):(NSDictionary *)params {
    SAWalletBillDetailViewController *vc = [[SAWalletBillDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToChooseMyAddressViewController):(NSDictionary *)params {
    SAChooseMyAddressViewController *vc = [[SAChooseMyAddressViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToSettingPwdOptionViewController):(NSDictionary *)params {
    SAPasswordSettingOptionViewController *vc = [[SAPasswordSettingOptionViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToWalletChargeResultViewController):(NSDictionary *)params {
    SAWalletChargeResultViewController *vc = [[SAWalletChargeResultViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToWalletChangePayPwdAskingViewController):(NSDictionary *)params {
    SAChangePayPwdAskingViewController *vc = [[SAChangePayPwdAskingViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToWalletChangePayPwdInputSMSCodeViewController):(NSDictionary *)params {
    SAChangePayPwdInputSMSViewController *vc = [[SAChangePayPwdInputSMSViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToCheckstandWebViewController):(NSDictionary *)params {
    NSString *url = [params valueForKey:@"url"];
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    HDLog(@"打开地址：%@", url);
    HDCheckstandWebViewController *vc = [[HDCheckstandWebViewController alloc] init];
    vc.url = url;
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(CashierResult):(NSDictionary *)params {
    //    @{@"pageLabel":@"WOWNOW_HOME"}
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:params];
    [tmp setObject:@"online_payment_result" forKey:@"pageLabel"];
    SAPayResultViewController *vc = [[SAPayResultViewController alloc] initWithRouteParameters:tmp];
    [SAWindowManager navigateToViewController:vc parameters:tmp];
}

- (void)_Action(phoneTouUpOrderDetails):(NSDictionary *)params {
    SATopUpOrderDetailViewController *topup = [[SATopUpOrderDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:topup parameters:params];
}

- (void)_Action(storeFavorite):(NSDictionary *)params {
    WMStoreFavoutiteListController *vc = [[WMStoreFavoutiteListController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(systemMessageList):(NSDictionary *)params {
    SASystemMessageViewController *vc = [[SASystemMessageViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(im):(NSDictionary *)params {
    HDLog(@"!!IM params: %@", params);

    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    if ([KSInstMsgManager.share hasSign]) {
        [HDMediator.sharedInstance navigaveToChatViewController:params];
    } else {
        [KSInstMsgManager.share registerImUserAndLoginWithOperatorNo:SAUser.shared.operatorNo storeNo:nil role:KSInstMsgRoleUser completion:^(NSError *_Nonnull error) {
            [HDMediator.sharedInstance navigaveToChatViewController:params];
        }];
    }
}

- (void)_Action(openChatViewController):(NSDictionary *)params {
    NSString *operatorNo = [params objectForKey:@"operatorNo"];
    NSString *storeNo = [params objectForKey:@"storeNo"];
    NSString *card = [params objectForKey:@"card"];
    NSString *cardStr = [[card hd_URLDecodedString] hd_URLDecodedString];
    NSString *prepareSendTxt = [[params objectForKey:@"prepareSendTxt"] hd_URLDecodedString];
    NSString *roleStr = [params objectForKey:@"operatorType"];
    KSInstMsgRole role = [roleStr integerValue];
    NSString *phoneNo = [params objectForKey:@"phoneNo"];
    id<KSChatViewControllerDelegate> delegate = [params objectForKey:@"delegate"];
    NSString *orderCardJson = [params objectForKey:@"orderCard"];
    NSNumber *shouldShowFeedbackService = [params objectForKey:@"shouldShowFeedbackService"];
    NSString *scene = [params objectForKey:@"scene"];

    HDLog(@"!!IM开始发起聊天");
    UIView *keyWindow = UIApplication.sharedApplication.keyWindow;
    [keyWindow showloading];
    @HDWeakify(keyWindow);

    [KSInstMsgManager.share queryRosterWithOperatorNo:operatorNo storeNo:storeNo role:role completion:^(KSRoster *_Nonnull roster, NSError *_Nonnull error) {
        HDLog(@"!!IM聊天对象：%@ -- error: %@", roster, error);
        @HDStrongify(keyWindow);
        [keyWindow dismissLoading];
        if (!error) {
            KSChatConfig *config = KSChatConfig.new;
            if (HDIsStringNotEmpty(prepareSendTxt)) {
                config.textWillSendOnStartup = prepareSendTxt;
            }
            if (HDIsStringNotEmpty(phoneNo)) {
                config.phoneNo = phoneNo;
            }

            // 商品卡片
            if (HDIsStringNotEmpty(cardStr)) {
                NSDictionary *cardDict = [cardStr hd_dictionary];

                NSString *title = [cardDict objectForKey:@"title"];
                NSString *content = [cardDict objectForKey:@"content"];
                NSString *image = [cardDict objectForKey:@"imageUrl"];
                NSString *link = [cardDict objectForKey:@"link"];
                NSString *extensionJson = [cardDict objectForKey:@"extensionJson"];
                KSChatGoodsFloatCardViewModel *floatCardViewModel = [[KSChatGoodsFloatCardViewModel alloc] initWithImageUrl:image title:title content:content link:link];
                floatCardViewModel.extensionJson = extensionJson;
                config.floatCardViewModel = floatCardViewModel;
            }

            // 订单卡片
            if (HDIsStringNotEmpty(orderCardJson)) {
                NSDictionary *orderDic = [orderCardJson hd_dictionary];

                KSChatOrderFloatCardViewModel *floatOrderCard = [[KSChatOrderFloatCardViewModel alloc] initWithStoreLogo:orderDic[@"storeLogo"] storeName:orderDic[@"storeName"]
                                                                                                         orderStatusDesc:orderDic[@"orderStatusDesc"]
                                                                                                               goodsIcon:orderDic[@"goodsIcon"]
                                                                                                               goodsDesc:orderDic[@"goodsDesc"]
                                                                                                               orderTime:orderDic[@"orderTime"]
                                                                                                                   total:orderDic[@"total"]
                                                                                                            businessLine:orderDic[@"bizLine"]
                                                                                                                 orderNo:orderDic[@"orderNo"]
                                                                                                              bizOrderNo:orderDic[@"bizOrderNo"]];
                NSString *extensionJson = orderDic[@"extensionJson"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:floatOrderCard.extensionJson.hd_dictionary];
                [dic addEntriesFromDictionary:extensionJson.hd_dictionary];
                floatOrderCard.extensionJson = [dic yy_modelToJSONString];
                config.floatCardViewModel = floatOrderCard;
            }

            config.supportTools = config.supportTools | KSChatSupportToolsOrder;
            config.shouldShowFeedbackService = shouldShowFeedbackService.boolValue;
            config.scene = scene;

            KSChatVC *chat = [[KSChatVC alloc] initWithRoster:roster conversation:nil config:config];
            chat.delegate = delegate ? delegate : [SAImDelegateManager shared];
            chat.orderListDelegate = [SAImDelegateManager shared];


            [SAWindowManager navigateToViewController:chat];
        } else {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"not_online", @"客服不在线") type:HDTopToastTypeError];
        }
    }];
}

- (void)_Action(openGroupChatViewController):(NSDictionary *)params {
    NSString *groupId = [params valueForKey:@"groupID"];
    NSString *card = [params objectForKey:@"card"];
    NSString *cardStr = [[card hd_URLDecodedString] hd_URLDecodedString];
    NSString *prepareSendTxt = [[params objectForKey:@"prepareSendTxt"] hd_URLDecodedString];

    NSString *phoneNo = [params objectForKey:@"phoneNo"];
    id<KSChatViewControllerDelegate> delegate = [params objectForKey:@"delegate"];
    NSString *orderCardJson = [params objectForKey:@"orderCard"];
    NSString *scene = [params objectForKey:@"scene"];

    HDLog(@"!!IM开始登陆");

    void (^openGroupChatVC)(void) = ^void(void) {
        KSChatConfig *config = KSChatConfig.new;
        if (HDIsStringNotEmpty(prepareSendTxt)) {
            config.textWillSendOnStartup = prepareSendTxt;
        }
        if (HDIsStringNotEmpty(phoneNo)) {
            config.phoneNo = phoneNo;
        }

        if (HDIsStringNotEmpty(cardStr)) {
            NSDictionary *cardDict = [cardStr hd_dictionary];

            NSString *title = [cardDict objectForKey:@"title"];
            NSString *content = [cardDict objectForKey:@"content"];
            NSString *image = [cardDict objectForKey:@"imageUrl"];
            NSString *link = [cardDict objectForKey:@"link"];
            NSString *extensionJson = [cardDict objectForKey:@"extensionJson"];
            KSChatGoodsFloatCardViewModel *floatCardViewModel = [[KSChatGoodsFloatCardViewModel alloc] initWithImageUrl:image title:title content:content link:link];
            floatCardViewModel.extensionJson = extensionJson;
            config.floatCardViewModel = floatCardViewModel;
        }

        if (HDIsStringNotEmpty(orderCardJson)) {
            NSDictionary *orderDic = [orderCardJson hd_dictionary];

            KSChatOrderFloatCardViewModel *floatOrderCard = [[KSChatOrderFloatCardViewModel alloc] initWithStoreLogo:orderDic[@"storeLogo"] storeName:orderDic[@"storeName"]
                                                                                                     orderStatusDesc:orderDic[@"orderStatusDesc"]
                                                                                                           goodsIcon:orderDic[@"goodsIcon"]
                                                                                                           goodsDesc:orderDic[@"goodsDesc"]
                                                                                                           orderTime:orderDic[@"orderTime"]
                                                                                                               total:orderDic[@"total"]
                                                                                                        businessLine:orderDic[@"bizLine"]
                                                                                                             orderNo:orderDic[@"orderNo"]
                                                                                                          bizOrderNo:orderDic[@"bizOrderNo"]];
            NSString *extensionJson = orderDic[@"extensionJson"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:floatOrderCard.extensionJson.hd_dictionary];
            [dic addEntriesFromDictionary:extensionJson.hd_dictionary];
            floatOrderCard.extensionJson = [dic yy_modelToJSONString];
            config.floatCardViewModel = floatOrderCard;
        }

        NSString *voiceCallSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchIMVoiceCall];
        if (HDIsStringNotEmpty(voiceCallSwitch) && [voiceCallSwitch.lowercaseString isEqualToString:@"on"]) {
            config.supportTools = config.supportTools | KSChatSupportToolsOrder | KSChatSupportToolsVoiceCall;
        } else {
            config.supportTools = config.supportTools | KSChatSupportToolsOrder;
        }

        config.scene = scene;

        KSGroupChatVC *chat = [[KSGroupChatVC alloc] initWithGroupID:groupId conversation:nil config:config];
        chat.delegate = delegate ? delegate : [SAImDelegateManager shared];
        chat.orderListDelegate = [SAImDelegateManager shared];
        [SAWindowManager navigateToViewController:chat];
    };


    if (![KSInstMsgManager.share hasSign]) {
        [KSInstMsgManager.share signinWithOperatorNo:SAUser.shared.operatorNo storeNo:nil role:KSInstMsgRoleUser completion:^(NSError *_Nonnull error) {
            if (!error) {
                openGroupChatVC();
            }
        }];
    } else {
        openGroupChatVC();
    }
}

- (void)_Action(couponRedemptionList):(NSDictionary *)params {
    SACouponRedemptionController *vc = [[SACouponRedemptionController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToChooseZoneViewController):(NSDictionary *)params {
    SAChooseZoneViewController *vc = [[SAChooseZoneViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(chooseAddressInMap):(NSDictionary *)params {
    SAChooseAddressMapViewController *vc = [[SAChooseAddressMapViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(callTest):(NSDictionary *)params {
    SACallAccountController *vc = [[SACallAccountController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

//- (void)_Action(audioCall):(NSDictionary *)params {
//    if (![SAUser hasSignedIn]) {
//        [SAWindowManager switchWindowToLoginViewController];
//        return;
//    }
//
//    NSString *remotePhone = params[@"phone"];
//
//    NSString *remoteOperatorNo = params[@"operatorNo"];
//    NSString *remoteNickname = params[@"nickname"];
//    NSString *remoteHeadImage = params[@"headImage"];
//
//    [KSAudioCallManager showAudioGroupCallWithPhone:SAUser.shared.loginName
//                                         operatorNo:SAUser.shared.operatorNo
//                                      remoteUserOps:@[@"1280423934434238464",@"1282953142081392640"]];
//

//    if (HDIsStringNotEmpty(remoteOperatorNo) && HDIsStringNotEmpty(remoteNickname)) {
//        // 被叫方信息不为空，头像可能为空，所以不判断
//        [KSAudioCallManager showAudioCallWithPhone:SAUser.shared.loginName
//                                        operatorNo:SAUser.shared.operatorNo
//                                  remoteOperatorNo:remoteOperatorNo
//                                    remoteNickName:remoteNickname
//                                     remoteHeadURL:remoteHeadImage];
//    } else if (HDIsStringNotEmpty(remotePhone)) {
//        // 被叫方信息不完整，需要去请求
//        [KSAudioCallManager showAudioCallWithPhone:SAUser.shared.loginName operatorNo:SAUser.shared.operatorNo remotePhone:remotePhone];
//    } else {
//        // 被叫方信息不完整，并且被叫方手机号也没有，无法发起通话
//        HDLog(@"调起语音通话失败：调用参数错误");
//    }
//}

//- (void)_Action(videoCall):(NSDictionary *)params {
//    if (![SAUser hasSignedIn]) {
//        [SAWindowManager switchWindowToLoginViewController];
//        return;
//    }
//
//    NSString *remotePhone = params[@"phone"];
//
//    NSString *remoteOperatorNo = params[@"operatorNo"];
//    NSString *remoteNickname = params[@"nickname"];
//    NSString *remoteHeadImage = params[@"headImage"];
//
//    if (HDIsStringNotEmpty(remoteOperatorNo) && HDIsStringNotEmpty(remoteNickname)) {
//        // 被叫方信息不为空，头像可能为空，所以不判断
//
//        [KSVideoCallManager showVideoCallWithPhone:SAUser.shared.loginName
//                                        operatorNo:SAUser.shared.operatorNo
//                                  remoteOperatorNo:remoteOperatorNo
//                                    remoteNickName:remoteNickname
//                                     remoteHeadURL:remoteHeadImage];
//    } else if (HDIsStringNotEmpty(remotePhone)) {
//        // 被叫方信息不完整，需要去请求
//        [KSVideoCallManager showVideoCallWithPhone:SAUser.shared.loginName operatorNo:SAUser.shared.operatorNo remotePhone:remotePhone];
//    } else {
//        // 被叫方信息不完整，并且被叫方手机号也没有，无法发起通话
//        HDLog(@"调起视频通话失败：调用参数错误");
//    }
//}

- (void)_Action(CMSTest):(NSDictionary *)params {
    BOOL needChooseCity = [params[@"needChooseCity"] boolValue];
    if (needChooseCity) {
        void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
            [SACacheManager.shared setObject:addressModel forKey:kCMSCacheKeyChooseAddress type:SACacheTypeDocumentPublic];
            CMSTestViewController *vc = [[CMSTestViewController alloc] initWithRouteParameters:params];
            [SAWindowManager navigateToViewController:vc parameters:params];
        };
        /// 当前选择的地址模型
        [HDMediator.sharedInstance navigaveToChooseAddressInMapViewController:@{@"callback": callback, @"notNeedPop": @true}];
    } else {
        SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeMaster];
        [SACacheManager.shared setObject:addressModel forKey:kCMSCacheKeyChooseAddress type:SACacheTypeDocumentPublic];
        CMSTestViewController *vc = [[CMSTestViewController alloc] initWithRouteParameters:params];
        [SAWindowManager navigateToViewController:vc parameters:params];
    }
}

- (void)_Action(address):(NSDictionary *)params {
    SAAddressListViewController *vc = [[SAAddressListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

#pragma mark -
- (void)_Action(changeLanguage):(NSDictionary *)params {
    [SAChangeLanguageViewPresenter showChangeLanguageView];
}

- (void)_Action(checkAppVersion):(NSDictionary *)params {
    UIView *keyWindow = UIApplication.sharedApplication.keyWindow;
    [keyWindow showloading];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/config/get.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        SAAppVersionInfoRspModel *infoRspModel = [SAAppVersionInfoRspModel yy_modelWithJSON:rspModel.data];
        [keyWindow dismissLoading];
        if (HDIsStringEmpty(infoRspModel.publicVersion)) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"app_version_latest", @"当前版本已是最新") type:HDTopToastTypeSuccess];
        } else {
            SAVersionAlertViewConfig *config = SAVersionAlertViewConfig.new;
            config.versionId = infoRspModel.versionId;
            config.updateInfo = infoRspModel.versionInfo;
            config.updateVersion = infoRspModel.publicVersion;
            config.updateModel = infoRspModel.updateModel;
            config.packageLink = infoRspModel.packageLink;
            config.ignoreCache = YES;
            if ([SAVersionAlertManager versionShouldAlert:config]) {
                SAVersionBaseAlertView *alertView = [SAVersionAlertManager alertViewWithConfig:config];
                alertView.didDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {

                };
                [alertView show];
            }
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        [keyWindow dismissLoading];
    }];
}

- (void)_Action(navigaveToMessagesViewController):(NSDictionary *)params {
    SAMessageCenterViewController *vc = [[SAMessageCenterViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(cmsContentPage):(NSDictionary *)params {
    SACMSWaterfallViewController *vc = [[SACMSWaterfallViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(cmsWaterfallContentPage:)(NSDictionary *)params {
    SACMSWaterfallViewController *vc = [[SACMSWaterfallViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(wownowHomePage:)(NSDictionary *)params {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [dic setObject:@"WOWNOW_HOME3.0_O2O" forKey:@"pageLabel"];
    WNHomeViewController *vc = [[WNHomeViewController alloc] initWithRouteParameters:dic];
    [SAWindowManager navigateToViewController:vc parameters:dic];
}

- (void)_Action(commonOrderDetails:)(NSDictionary *)params {
    SACommonOrderDetailsViewController *vc = [[SACommonOrderDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(userBillList:)(NSDictionary *)params {
    SAUserBillListViewController *vc = [[SAUserBillListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(userBillPaymentDetails:)(NSDictionary *)params {
    SAUserBillPaymentDetailsViewController *vc = [[SAUserBillPaymentDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(userBillRefundDetails:)(NSDictionary *)params {
    SAUserBillRefundDetailsViewController *vc = [[SAUserBillRefundDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(waitPayResult:)(NSDictionary *)params {
    SAWaitPayResultViewController *vc = [[SAWaitPayResultViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(cancellationApplication:)(NSDictionary *)params {
    SACancellationApplicationViewController *vc = [[SACancellationApplicationViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(orderList:)(NSDictionary *)params {
    SAOrderViewController *vc = [[SAOrderViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(loginBySMS:)(NSDictionary *)params {
    SALoginBySMSViewController *vc = [[SALoginBySMSViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(loginWithSMS:)(NSDictionary *)params {
    SALoginWithSMSViewController *vc = [[SALoginWithSMSViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(loginByVerificationCode:)(NSDictionary *)params {
    SALoginByVerificationCodeViewController *vc = [[SALoginByVerificationCodeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(VerificationCode:)(NSDictionary *)params {
    SAVerificationCodeViewController *vc = [[SAVerificationCodeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(forgotPassword:)(NSDictionary *)params {
    SAForgotPasswordViewController *vc = [[SAForgotPasswordViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(forgetPasswordOrBindPhone:)(NSDictionary *)params {
    SAForgetPasswordOrBindPhoneViewController *vc = [[SAForgetPasswordOrBindPhoneViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(setPassword:)(NSDictionary *)params {
    SASetPasswordViewController *vc = [[SASetPasswordViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToChangeLoginPasswordViewController):(NSDictionary *)params {
    SAChangeLoginPasswordViewController *vc = [[SAChangeLoginPasswordViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(suggestionDetail:)(NSDictionary *)params {
    SASuggestionDetailViewController *vc = [[SASuggestionDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}


- (void)_Action(imFeedBack:)(NSDictionary *)params {
    SAImFeedbackViewController *vc = [[SAImFeedbackViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}


- (void)_Action(orderSearch:)(NSDictionary *)params {
    SAOrderSearchViewController *vc = [[SAOrderSearchViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}
//绑定tg机器人
- (void)_Action(bindTg:)(NSDictionary *)params {
    void (^tgBind)(void) = ^void(void) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/operator/telegram/bindBot.do";

        NSMutableDictionary *p = NSMutableDictionary.new;
        p[@"telegramId"] = params[@"tgid"];
        p[@"botUsername"] = params[@"username"];
        request.requestParameter = p;
        request.isNeedLogin = YES;

        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"tg_bind_tip", @"恭喜您成功绑定大象APP账号") type:HDTopToastTypeSuccess];
        } failure:^(HDNetworkResponse *_Nonnull response) {
            HDLog(@"绑定失败");
        }];
    };
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewControllerWithLoginToDoEvent:tgBind];
        return;
    }
    tgBind();
}


- (void)_Action(ocrScan:)(NSDictionary *)params {
    SAScanViewController *VC = [[SAScanViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:VC parameters:params];
}

- (void)_Action(bindEmail):(NSDictionary *)params {
    SABindEmailViewController *vc = [[SABindEmailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(chatList):(NSDictionary *)params {
    SAMCChatListViewController *vc = [[SAMCChatListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

@end
