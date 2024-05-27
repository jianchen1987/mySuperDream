

//
//  SAAppDelegate+PushService.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+YumNow.h"
#import "SAAppDelegate+PushService.h"
#import "SAAppSwitchManager.h"
#import "SALotteryAlertViewPresenter.h"
#import "SAMarketingAlertView.h"
#import "SAMessageManager.h"
#import "SANotificationConst.h"
#import "SARemoteNotificationModel.h"
#import "SARemoteNotifyViewModel.h"
#import "SATalkingData.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "WMFeedBackHistoryViewController.h"
#import "WMOrderDetailViewController.h"
#import "WMOrderModifyAddressHistoryViewController.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDTips.h>
#import <KSInstantMessagingKit/KSInstantMessagingKit.h>
#import <PushKit/PushKit.h>
#import <UserNotifications/UNUserNotificationCenter.h>

static char kAssociatedObjectKey_RemoteNotifyDTO;


@interface SAAppDelegate () <UNUserNotificationCenterDelegate, PKPushRegistryDelegate>

@property (nonatomic, strong) SARemoteNotifyViewModel *remoteNotifyDTO;

@end


@implementation SAAppDelegate (PushService)

- (void)initRemotePush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册apns
    [self registerAPNS:application];
    // 注册voip
    [self registerVoipPush];
}

- (void)registerVoipPush {
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];

    // 根据voip推送还是普通推荐来决定CallKit的开启与否
    //是否根据定位判断callkit开启，默认不需要判断定位,直接开启
//    NSString *callKitLocation = [SAAppSwitchManager.shared switchForKey:SAAppSwitchAppCallKitLocation];
//    BOOL needCallKitLocation = (callKitLocation && [callKitLocation isEqualToString:@"on"]);
//    if (needCallKitLocation) {
//        BOOL result = [NSUserDefaults.standardUserDefaults boolForKey:@"appCallKitSwitch"];
//        [KSCallKitCenter.sharedInstance enableCallKit:result];
//    }

    //    [NSUserDefaults.standardUserDefaults synchronize];
    //    [KSCallKitCenter.sharedInstance enableCallKit:NO];
}

/**
 * 注册苹果推送，获取deviceToken用于推送
 */
- (void)registerAPNS:(UIApplication *)application {
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge
                                                                      completionHandler:^(BOOL granted, NSError *_Nullable error){
                                                                      }];
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *DT = nil;
    if (@available(iOS 13.0, *)) {
        NSUInteger length = [deviceToken length];
        char *chars = (char *)[deviceToken bytes];
        NSMutableString *hexString = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < length; i++) {
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
        }
        DT = hexString;
    } else {
        DT = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        DT = [DT stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    //    HDLog(@"⚠️⚠️⚠️：注册DT成功:%@", DT);
    //    // 存储 token 至本地
    [SACacheManager.shared setObject:DT forKey:kCacheKeyFCMRemoteNotifitionToken type:SACacheTypeCachePublic];

    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameReceiveRegistrationToken object:nil userInfo:@{@"fcmToken": DT}];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [TalkingData trackEvent:@"⚠️⚠️⚠️：注册DeviceToken失败" label:error.localizedDescription];
    
}

/// 在后台收到推送，点击消息通知不会触发, 静默消息只会走后台回调，不会走前台回调，即没有alert内容的消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    HDLog(@"在后台收到推送:%@", userInfo);
    SARemoteNotificationModel *model = [SARemoteNotificationModel yy_modelWithJSON:userInfo];
    
    // 送达回调
    if (HDIsStringNotEmpty(model.pushChannel)) {
        [self.remoteNotifyDTO notificationCallbackInChannel:SAPushChannelHello bizId:model.bizId templateNo:model.templateNo isClick:NO newStrategy:model.newStrategy success:nil failure:nil];
    } else {
        [self.remoteNotifyDTO notificationCallbackInChannel:SAPushChannelAPNS bizId:model.bizId templateNo:model.templateNo isClick:NO newStrategy:model.newStrategy success:nil failure:nil];
    }
    
    
    //处理语音通话的静默推送
    if ([model.voipType isEqualToString:@"voice"] && [model.templateNo isEqualToString:@"VOIP01"] && model.isRejected) {
       // 挂断电话的状态通知
       NSMutableDictionary *dic = NSMutableDictionary.new;
       dic[@"rejectorOperatorNo"] = model.rejectorOperatorNo;
       dic[@"isRejected"] = @(model.isRejected);
       dic[@"voipType"] = model.voipType;
       dic[@"channel"] = model.channel;
        [KSCallManager handleRejectCallingWithDic:dic forType:@"" operatorNo:SAUser.shared.operatorNo withCompletionHandler:^{
            // 处理完后告诉系统，后台任务已经处理完，可以杀掉app了
            completionHandler(UIBackgroundFetchResultNewData);
        }];
        
   } else if ([model.templateNo isEqualToString:@"VOIP02"]) {
     // 普通推送，来电提醒
       [KSCallManager receiveIncomingPushWithType:@"voice"
                                   retemoteUserOp:model.rejectorOperatorNo
                                   remoteNickName:model.nickname
                                    remoteHeadUrl:model.avatarUrl
                                          channel:model.channel
                                            token:model.token
                                    currentUserOp:SAUser.shared.operatorNo completion:^{
           // 处理完后告诉系统，后台任务已经处理完，可以杀掉app了
           completionHandler(UIBackgroundFetchResultNewData);
       }];
       
       
       
   } else if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [self proccessNotification:userInfo];
       // 处理完后告诉系统，后台任务已经处理完，可以杀掉app了
       completionHandler(UIBackgroundFetchResultNewData);
    }
}

/// 在前台收到消息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary *userInfo = notification.request.content.userInfo;
    SARemoteNotificationModel *model = [SARemoteNotificationModel yy_modelWithJSON:userInfo];
    HDLog(@"在前台收到推送:%@", userInfo);
    [self proccessNotification:userInfo];
    // 刷新未读数
    [SAMessageManager.share getUnreadMessageCount:nil];

    if (HDIsObjectNil(model.pushAction)) {
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    } else {
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }

    if (HDIsStringNotEmpty(model.pushChannel)) {
        [self.remoteNotifyDTO notificationCallbackInChannel:SAPushChannelHello bizId:model.bizId templateNo:model.templateNo isClick:NO newStrategy:model.newStrategy success:nil failure:nil];
    } else {
        [self.remoteNotifyDTO notificationCallbackInChannel:SAPushChannelAPNS bizId:model.bizId templateNo:model.templateNo isClick:NO newStrategy:model.newStrategy success:nil failure:nil];
    }
}

/// 点击屏幕进来
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    SARemoteNotificationModel *model = [SARemoteNotificationModel yy_modelWithJSON:userInfo];

    [self clickOnNotification:userInfo];
    HDLog(@"点击推送进 APP：%@", userInfo);
    completionHandler();

    if (HDIsStringNotEmpty(model.pushChannel)) {
        [self.remoteNotifyDTO notificationCallbackInChannel:SAPushChannelHello bizId:model.bizId templateNo:model.templateNo isClick:YES newStrategy:model.newStrategy success:nil failure:nil];
    } else {
        [self.remoteNotifyDTO notificationCallbackInChannel:SAPushChannelAPNS bizId:model.bizId templateNo:model.templateNo isClick:YES newStrategy:model.newStrategy success:nil failure:nil];
    }
}

#pragma mark - 处理消息推送
// 处理业务推送
- (void)proccessNotification:(NSDictionary *)userInfo {
    SARemoteNotificationModel *model = [SARemoteNotificationModel yy_modelWithJSON:userInfo];
    // 判断模板类型（即业务类型）
    if ([model.templateNo isEqualToString:@"PCC001"]) { // 用户收到新的优惠券

    } else if ([model.templateNo isEqualToString:@"PCO001"]) { // 门店接单
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO002"]) { // 骑手已取餐，配送中
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO003"]) { // 已送达
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO004"]) { // 商家同意取消申请 后台操作取消
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO005"]) { // 商家同意退款申请
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO006"]) { // 商家拒绝取消申请
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO007"]) { // 商家拒绝退款申请
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO008"]) { // 预计5分钟送达
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO010"]) { // 订单已取消（商家取消）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO011"]) { // 订单已取消（商家超时未接单）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO012"]) { // 订单已取消（系统取消）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO013"]) { // 订单已取消（超时自动取消）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PMO042"] || [model.templateNo isEqualToString:@"PMO043"]) { // 抽奖消息
        if (HDIsStringNotEmpty(model.aggregateOrderNo)) {
            [SALotteryAlertViewPresenter showLotteryAlertViewWithOrderNo:model.aggregateOrderNo completion:nil];
        }
        
    } else if ([model.templateNo isEqualToString:@"PMO070"] || [model.templateNo isEqualToString:@"PMO068"] || [model.templateNo isEqualToString:@"PMO072"]) { //扫码点餐
        [self dealingWithScanOrderDetailActionWithOrderNo:model.orderId templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO014"] || [model.templateNo isEqualToString:@"PCO015"]) { //修改地址
        [self dealingWithModifyAddressOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO017"] || [model.templateNo isEqualToString:@"PCO018"] || [model.templateNo isEqualToString:@"PCO019"]) { //售后反馈
        [self dealingWithOrderFeedBackDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:false];
        
    } else if ([model.templateNo isEqualToString:@"PCO020"]) { // 意见详情
        [self dealingWithSuggestDetialWithSuggestionInfoId:model.suggestionInfoId shouldJump:false];
        
    } else if (!HDIsObjectNil(model.pushAction)) {
        [self _showPushAction:model];
        
    }
    // 发送通知，有需要的自己订阅
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameNewMessages object:nil userInfo:userInfo];
}

#pragma mark - 处理点击消息事件
// 处理点击消息事件
- (void)clickOnNotification:(NSDictionary *)userInfo {
    SARemoteNotificationModel *model = [SARemoteNotificationModel yy_modelWithJSON:userInfo];
    // 判断模板类型（即业务类型）
    if ([model.templateNo isEqualToString:@"PCC001"]) { // 用户收到新的优惠券
        [HDMediator.sharedInstance navigaveToMyCouponsViewController:@{
            @"source" : @"推送点击",
            @"associatedId" : model.sendSerialNumber
        }];
        
    } else if ([model.templateNo isEqualToString:@"PCO001"]) { // 门店接单
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO002"]) { // 骑手已取餐，配送中
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO003"]) { // 已送达
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO004"]) { // 商家同意取消申请 后台操作取消
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO005"]) { // 商家同意退款申请
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO006"]) { // 商家拒绝取消申请
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO007"]) { // 商家拒绝退款申请
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO008"]) { // 预计5分钟送达
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO010"]) { // 订单已取消（商家取消）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO011"]) { // 订单已取消（商家超时未接单）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO012"]) { // 订单已取消（系统取消）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO013"]) { // 订单已取消（超时自动取消）
        [self dealingWithOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PMO042"] || [model.templateNo isEqualToString:@"PMO043"]) { // 抽奖消息
        if (HDIsStringNotEmpty(model.linkAddress)) {
            [SAWindowManager openUrl:model.linkAddress withParameters:@{
                @"source" : @"推送点击",
                @"associatedId" : model.sendSerialNumber
            }];
            
        } else if (HDIsStringNotEmpty(model.aggregateOrderNo)) {
            [SALotteryAlertViewPresenter showLotteryAlertViewWithOrderNo:model.aggregateOrderNo completion:nil];
            
        }
        
    } else if ([model.templateNo isEqualToString:@"PMO070"] || [model.templateNo isEqualToString:@"PMO068"] || [model.templateNo isEqualToString:@"PMO072"]) { //扫码点餐
        [self dealingWithScanOrderDetailActionWithOrderNo:model.orderId templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO014"] || [model.templateNo isEqualToString:@"PCO015"]) { //修改地址
        [self dealingWithModifyAddressOrderDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO017"] || [model.templateNo isEqualToString:@"PCO018"] || [model.templateNo isEqualToString:@"PCO019"]) { //售后反馈
        [self dealingWithOrderFeedBackDetailActionWithOrderNo:model.orderNo templateNo:model.templateNo shouldJump:true];
        
    } else if ([model.templateNo isEqualToString:@"PCO027"]) { // 慢必赔
        [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/slow-pay"}];
        
    } else if ([model.templateNo isEqualToString:@"VOIP02"] || [model.templateNo isEqualToString:@"VOIP01"]) {
        // VOIP 通知
        [HDMediator.sharedInstance navigaveToChatListViewController:nil];
        
    } else if (!HDIsObjectNil(model.pushAction)) {
        [self _showPushAction:model];
        
    } else if (!HDIsStringEmpty(model.linkAddress)) { // 其他判定为系统消息
        
        [SAWindowManager openUrl:model.linkAddress withParameters:@{
            @"source" : @"推送点击",
            @"associatedId" : model.sendSerialNumber
        }];
    }

    [SATalkingData trackEvent:@"推送通知_点击" label:@"" parameters:@{@"messageNo": model.sendSerialNumber, @"link": HDIsStringNotEmpty(model.linkAddress) ? model.linkAddress : @""}];
}

#pragma mark - private methods
/// 展示推送提示
/// @param model 推送数据
- (void)_showPushAction:(SARemoteNotificationModel *)model {
    if (model.pushAction.type == SARemoteNotificationActionTypeToast) {
        [HDTips showWithText:model.pushAction.content.desc hideAfterDelay:3];
    } else if (model.pushAction.type == SARemoteNotificationActionTypeAlert) {
        SAMarketingAlertViewConfig *config = [[SAMarketingAlertViewConfig alloc] init];
        config.type = @"11";
        config.activityId = model.bizId;
        SAMarketingAlertItem *item = [[SAMarketingAlertItem alloc] init];
        item.popImage = model.pushAction.image.zh_CN;
        item.jumpLink = model.pushAction.link.zh_CN;
        config.zhImageAndLinkInfos = @[item];

        item = [[SAMarketingAlertItem alloc] init];
        item.popImage = model.pushAction.image.en_US;
        item.jumpLink = model.pushAction.link.en_US;
        config.enImageAndLinkInfos = @[item];

        item = [[SAMarketingAlertItem alloc] init];
        item.popImage = model.pushAction.image.km_KH;
        item.jumpLink = model.pushAction.link.km_KH;
        config.kmImageAndLinkInfos = @[item];
        SAMarketingAlertView *alertView = [SAMarketingAlertView alertViewWithConfigs:@[config]];
        alertView.identitableString = model.pushAction.link.desc;
        [alertView show];
    }
}

/// 处理订单详情的推送
/// @param orderNo 订单号
/// @param templateNo 模板号
/// @param shouldJump 是否需要跳转订单详情页逻辑
- (void)dealingWithOrderDetailActionWithOrderNo:(NSString *)orderNo templateNo:(NSString *)templateNo shouldJump:(BOOL)shouldJump {
    // 判断当前页面是不是当前订单详情页
    UIViewController *topViewController = SAWindowManager.visibleViewController;
    if ([topViewController isKindOfClass:WMOrderDetailViewController.class]) {
        WMOrderDetailViewController *orderDetailVC = (WMOrderDetailViewController *)topViewController;
        // 判断是不是当前订单
        if ([orderDetailVC.orderNo isEqualToString:orderNo]) {
            // 刷新
            [orderDetailVC hd_getNewData];
        } else {
            if (shouldJump) {
                [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": orderNo}];
            }
        }
    } else {
        if (shouldJump) {
            [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": orderNo}];
        }
    }
}

/// 处理修改地址的推送
/// @param orderNo 订单号
/// @param templateNo 模板号
/// @param shouldJump 是否需要跳转修改地址逻辑
- (void)dealingWithModifyAddressOrderDetailActionWithOrderNo:(NSString *)orderNo templateNo:(NSString *)templateNo shouldJump:(BOOL)shouldJump {
    /// 判断当前页面是不是当前订单详情页
    UIViewController *topViewController = SAWindowManager.visibleViewController;
    if ([topViewController isKindOfClass:WMOrderDetailViewController.class]) {
        WMOrderDetailViewController *orderDetailVC = (WMOrderDetailViewController *)topViewController;
        // 判断是不是当前订单
        if ([orderDetailVC.orderNo isEqualToString:orderNo]) {
            // 刷新
            [orderDetailVC hd_getNewData];
        } else {
            if (shouldJump) {
                [HDMediator.sharedInstance navigaveToModifyOrderAddressHistoryViewController:@{@"orderNo": orderNo}];
            }
        }
    }
    /// 判断当前页面是不是当前修改地址记录页
    else if ([topViewController isKindOfClass:WMOrderModifyAddressHistoryViewController.class]) {
        WMOrderModifyAddressHistoryViewController *orderDetailVC = (WMOrderModifyAddressHistoryViewController *)topViewController;
        // 判断是不是当前订单
        if ([orderDetailVC.parentOrderNo isEqualToString:orderNo]) {
            // 刷新
            [orderDetailVC hd_getNewData];
        } else {
            if (shouldJump) {
                [HDMediator.sharedInstance navigaveToModifyOrderAddressHistoryViewController:@{@"orderNo": orderNo}];
            }
        }
    } else {
        if (shouldJump) {
            [HDMediator.sharedInstance navigaveToModifyOrderAddressHistoryViewController:@{@"orderNo": orderNo}];
        }
    }
}

/// 处理反馈售后的推送
/// @param orderNo 订单号
/// @param templateNo 模板号
/// @param shouldJump 是否需要跳转反馈历史记录
- (void)dealingWithOrderFeedBackDetailActionWithOrderNo:(NSString *)orderNo templateNo:(NSString *)templateNo shouldJump:(BOOL)shouldJump {
    UIViewController *topViewController = SAWindowManager.visibleViewController;
    if ([topViewController isKindOfClass:WMOrderDetailViewController.class]) {
        WMOrderDetailViewController *orderDetailVC = (WMOrderDetailViewController *)topViewController;
        if ([orderDetailVC.orderNo isEqualToString:orderNo]) {
            [orderDetailVC hd_getNewData];
        } else {
            if (shouldJump) {
                [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{@"orderNo": orderNo}];
            }
        }
    } else if ([topViewController isKindOfClass:WMFeedBackHistoryViewController.class]) {
        WMFeedBackHistoryViewController *orderDetailVC = (WMFeedBackHistoryViewController *)topViewController;
        if ([orderDetailVC.orderNo isEqualToString:orderNo]) {
            [orderDetailVC hd_getNewData];
        } else {
            if (shouldJump) {
                [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{@"orderNo": orderNo}];
            }
        }
    } else {
        if (shouldJump) {
            [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{@"orderNo": orderNo}];
        }
    }
}

/// 处理扫码订单详情的推送
/// @param orderNo 订单号
/// @param templateNo 模板号
/// @param shouldJump 是否需要跳转订单详情页逻辑
- (void)dealingWithScanOrderDetailActionWithOrderNo:(NSString *)orderNo templateNo:(NSString *)templateNo shouldJump:(BOOL)shouldJump {
    // 判断当前页面是不是当前订单详情页
    UIViewController *topViewController = SAWindowManager.visibleViewController;
    if ([topViewController isKindOfClass:HDWebViewHostViewController.class]) {
        HDWebViewHostViewController *orderDetailVC = (HDWebViewHostViewController *)topViewController;
        // 判断是不是当前订单
        if ([orderDetailVC.url containsString:orderNo]) {
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameNewMessages object:nil userInfo:nil];
        } else {
            if (shouldJump) {
                [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": [NSString stringWithFormat:@"/mobile-h5/marketing/order-food/order-detail?id=%@", orderNo]}];
            }
        }
    } else {
        if (shouldJump) {
            [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": [NSString stringWithFormat:@"/mobile-h5/marketing/order-food/order-detail?id=%@", orderNo]}];
        }
    }
}

- (void)dealingWithSuggestDetialWithSuggestionInfoId:(NSString *)suggestionInfoId shouldJump:(BOOL)shouldJump {
    if (HDIsStringNotEmpty(suggestionInfoId) && shouldJump)
        [HDMediator.sharedInstance navigaveToSuggestionDetailViewController:@{@"suggestionInfoId": suggestionInfoId}];
}

#pragma mark - pushKitDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type {
    if (!pushCredentials.token.length) {
        HDLog(@"voip token is null");
        return;
    }
    NSUInteger length = [pushCredentials.token length];
    char *chars = (char *)[pushCredentials.token bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < length; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    NSString *token = hexString;

    token = [[[token stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    HDLog(@"⚠️⚠️⚠️：注册Voip DT成功:%@", token);
    //    // 存储 token 至本地
    [SACacheManager.shared setObject:token forKey:kCacheKeyAppleVoipToken type:SACacheTypeCachePublic];

    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameVoipTokenChanged object:nil userInfo:@{@"voipToken": token}];
}

- (void)pushRegistry:(PKPushRegistry *)registry
    didReceiveIncomingPushWithPayload:(nonnull PKPushPayload *)payload
                              forType:(nonnull PKPushType)type
                withCompletionHandler:(nonnull void (^)(void))completion {
    HDLog(@"%s", __func__);
    if (type == PKPushTypeVoIP) {
        HDLog(@"%@", payload.dictionaryPayload);
        [self.remoteNotifyDTO notificationCallbackInChannel:SAPushChannelVOIP bizId:payload.dictionaryPayload[@"bizId"] templateNo:nil isClick:NO newStrategy:NO success:nil failure:nil];
        
        [KSCallManager pushRegistry:registry didReceiveIncomingPushWithPayload:payload forType:type operatorNo:SAUser.shared.operatorNo withCompletionHandler:completion];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type {
    HDLog(@"%s", __func__);
}

- (SARemoteNotifyViewModel *)remoteNotifyDTO {
    SARemoteNotifyViewModel *remoteNotifyDTO = objc_getAssociatedObject(self, &kAssociatedObjectKey_RemoteNotifyDTO);

    if (nil == remoteNotifyDTO) {
        remoteNotifyDTO = [SARemoteNotifyViewModel new];
        self.remoteNotifyDTO = remoteNotifyDTO;
    }

    return remoteNotifyDTO;
}

- (void)setRemoteNotifyDTO:(SARemoteNotifyViewModel *)remoteNotifyDTO {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_RemoteNotifyDTO, remoteNotifyDTO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
