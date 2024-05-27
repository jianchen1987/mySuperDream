//
//  GNAlertUntils.m
//  SuperApp
//
//  Created by wmz on 2021/6/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNAlertUntils.h"
#import "HDActionSheetView.h"
#import "HDLocationManager.h"
#import "HDSystemCapabilityUtil.h"
#import "HDTips.h"
#import "KSTools.h"
#import "WMCustomViewActionView.h"
#import "WMOrderDetailRiderModel.h"
#import <MapKit/MapKit.h>


@implementation GNAlertUntils

///导航弹窗
+ (void)navigation:(NSString *)name lat:(double)lat lon:(double)lon {
    HDActionSheetViewConfig *config = HDActionSheetViewConfig.new;
    config.containerCorner = 0;
    HDActionSheetView *alert = [HDActionSheetView alertViewWithCancelButtonTitle:[KSTools localizedStringForKey:@"button_cancel" value:@"Cancel"] config:config];
    NSMutableArray<HDActionSheetViewButton *> *buttons = [[NSMutableArray alloc] initWithCapacity:5];

    [buttons addObject:[HDActionSheetViewButton
                           buttonWithTitle:[KSTools localizedStringForKey:@"AppleMap" value:@"Apple Map"]
                                      type:HDActionSheetViewButtonTypeCustom
                                   handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                       [alertView dismiss];
                                       CLLocationCoordinate2D station = CLLocationCoordinate2DMake(lat, lon);
                                       MKMapItem *toStation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:station addressDictionary:nil]];
                                       MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                                       currentLocation.name = GNLocalizedString(@"gn_myLocation_map", @"我的位置");
                                       toStation.name = name;
                                       [MKMapItem
                                           openMapsWithItems:@[currentLocation, toStation]
                                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
                                   }]];

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", @"SuperApp", @"superApp", lat, lon];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [buttons addObject:[HDActionSheetViewButton buttonWithTitle:[KSTools localizedStringForKey:@"GoogleMap" value:@"Google Map"] type:HDActionSheetViewButtonTypeCustom
                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                [alertView dismiss];
                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success){
                                                                }];
                                                            }]];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        CLLocationCoordinate2D xcoordinate = [self getBaiDuCoordinateByGaoDeCoordinate:CLLocationCoordinate2DMake(lat, lon)];

        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:%@&mode=transit&coord_type= bd09ll",
                                                         HDLocationManager.shared.coordinate2D.latitude,
                                                         HDLocationManager.shared.coordinate2D.longitude,
                                                         GNLocalizedString(@"gn_myLocation_map", @"我的位置")];
        if (lat != 0 && lon != 0) {
            urlString = [NSString stringWithFormat:@"%@&destination=latlng:%f,%f|name:%@", urlString, xcoordinate.latitude, xcoordinate.longitude, name ?: @""];
        } else {
            urlString = [NSString stringWithFormat:@"%@&destination=%@|name:%@", urlString, name ?: @"", name ?: @""];
        }
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [buttons addObject:[HDActionSheetViewButton buttonWithTitle:GNLocalizedString(@"gn_baidu_map", @"百度地图") type:HDActionSheetViewButtonTypeCustom
                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                [alertView dismiss];
                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success){
                                                                }];
                                                            }]];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=SuperApp&backScheme=superApp&slat=%f&slon=%f&sname=%@&dev=1&t=1",
                                                         HDLocationManager.shared.coordinate2D.latitude,
                                                         HDLocationManager.shared.coordinate2D.longitude,
                                                         GNLocalizedString(@"gn_myLocation_map", @"我的位置")];
        if (lat != 0 && lon != 0) {
            urlString = [NSString stringWithFormat:@"%@&dlat=%f&dlon=%f&dname=%@", urlString, lat, lon, name ?: @""];
        } else {
            urlString = [NSString stringWithFormat:@"%@&dname=%@", urlString, name];
        }
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [buttons addObject:[HDActionSheetViewButton buttonWithTitle:GNLocalizedString(@"gn_gaode_map", @"高德地图") type:HDActionSheetViewButtonTypeCustom
                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                [alertView dismiss];
                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success){
                                                                }];
                                                            }]];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=bus&fromcoord=%f,%f&from=%@&referer=superApp",
                                                         HDLocationManager.shared.coordinate2D.latitude,
                                                         HDLocationManager.shared.coordinate2D.longitude,
                                                         GNLocalizedString(@"gn_myLocation_map", @"我的位置")];
        if (lat != 0 && lon != 0) {
            urlString = [NSString stringWithFormat:@"%@&tocoord=%f,%f&to=%@", urlString, lat, lon, name ?: @""];
        } else {
            urlString = [NSString stringWithFormat:@"%@&to=%@", urlString, name ?: @""];
        }
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [buttons addObject:[HDActionSheetViewButton buttonWithTitle:GNLocalizedString(@"gn_tencen_map", @"腾讯地图") type:HDActionSheetViewButtonTypeCustom
                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                [alertView dismiss];
                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success){
                                                                }];
                                                            }]];
    }

    if (buttons.count == 0) {
        [HDTips showWithText:[KSTools localizedStringForKey:@"no_navigave_tips" value:@"找不到可用的导航工具"] hideAfterDelay:3];
        return;
        ;
    }
    [alert addButtons:buttons];
    [alert show];
}

/// 转为百度坐标
+ (CLLocationCoordinate2D)getBaiDuCoordinateByGaoDeCoordinate:(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065);
}

///拨打电话
+ (void)callString:(NSString *)phone {
    [GNAlertUntils callWithModelArray:@[[WMAlertCallPopModel initName:GNLocalizedString(@"gn_contact_merchant", @"联系商家") image:@"yn_order_callStore" data:phone type:WMCallPhoneTypeServerStore]]
                                 info:@{}];
}

+ (void)callAndServerString:(NSString *)phone {
    [GNAlertUntils commonCallWithArray:@[
        [WMAlertCallPopModel hotServerModel],
        [WMAlertCallPopModel initName:GNLocalizedString(@"gn_contact_merchant", @"联系商家") image:@"yn_order_callStore" data:phone type:WMCallPhoneTypeServerStore]
    ]
                                  info:@{}];
}

+ (void)callWithModelArray:(nullable NSArray<WMAlertCallPopModel *> *)dataSource info:(nullable NSDictionary *)info {
    /// orderNo
    NSString *orderNo = info[@"orderNo"];
    WMAlertCallPopView *view = [[WMAlertCallPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.datasource = dataSource;
    [view layoutyImmediately];
    WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.needTopSepLine = true;
        config.title = WMLocalizedString(@"you_can_contact", @"你可以联系");
    }];
    [actionView show];
    view.clickedEventBlock = ^(WMAlertCallPopModel *_Nonnull model) {
        [actionView dismiss];
        ///客服热线
        if ([model.dataSource isKindOfClass:NSArray.class] && [model.type isEqualToString:WMCallPhoneTypeServer]) {
            if ([model.dataSource isKindOfClass:NSArray.class]) {
                [GNAlertUntils callWithModelArray:model.dataSource info:info];
            }
        }
        /// telegram
        else if ([model.type isEqualToString:WMCallPhoneTypeTelegram]) {
            if ([model.dataSource isKindOfClass:NSString.class] && [SAWindowManager canOpenURL:model.dataSource]) {
                [SAWindowManager openUrl:model.dataSource withParameters:nil];
            }
        }
        ///商家电话
        else if ([model.type isEqualToString:WMCallPhoneTypeServerStore]) {
            if ([model.dataSource isKindOfClass:NSString.class]) {
                [HDSystemCapabilityUtil makePhoneCall:model.dataSource];
            }
        }
        ///骑手
        else if ([model.type isEqualToString:WMCallPhoneTypeServerRider]) {
            if ([model.dataSource isKindOfClass:WMOrderDetailRiderModel.class]) {
                WMOrderDetailRiderModel *rider = (WMOrderDetailRiderModel *)model.dataSource;
                NSDictionary *dict = @{
                    @"operatorType": @(9),
                    @"operatorNo": rider.riderNo ?: @"",
                    @"prepareSendTxt": [NSString stringWithFormat:WMLocalizedString(@"NyF6Fg39", @"我想咨询订单号：%@"), orderNo],
                    @"phoneNo": rider.riderPhone ?: @"",
                    @"scene": SAChatSceneTypeYumNowDelivery
                };
                [[HDMediator sharedInstance] navigaveToIMViewController:dict];
            }
        }
        ///拨打电话
        else if ([model.type isEqualToString:WMCallPhoneTypeCall]) {
            if ([model.dataSource isKindOfClass:NSString.class]) {
                [HDSystemCapabilityUtil makePhoneCall:model.dataSource];
            }
        }
        ///在线联系
        else if ([model.type isEqualToString:WMCallPhoneTypeOnline]) {
            if ([model.dataSource isKindOfClass:NSDictionary.class]) {
                HDLog(@"%@", model.dataSource);
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:model.dataSource];
                [dic addEntriesFromDictionary:@{@"scene": SAChatSceneTypeYumNowArbitral}];
                [HDMediator.sharedInstance navigaveToGroupChat:dic];
            }
        }
    };
}

+ (void)commonCallWithArray:(nullable NSArray<WMAlertCallPopModel *> *)dataSource info:(nullable NSDictionary *)info {
    /// telegramLink
    NSString *telegramLink = info[@"telegramLink"];
    /// teleModel
    NSString *teleFirst = WMLocalizedString(@"wm_telegram_online", @"Telegram在线客服");
    NSString *teleLast = WMLocalizedString(@"wm_quick_response", @"秒速响应");
    NSMutableAttributedString *teleSte = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", teleFirst, teleLast]];
    [teleSte addAttributes:@{
        NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:13],
        NSForegroundColorAttributeName: HDAppTheme.WMColor.B3,
    }
                     range:[teleSte.string rangeOfString:teleFirst]];
    [teleSte addAttributes:@{
        NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11],
        NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
    }
                     range:[teleSte.string rangeOfString:teleLast]];
    /// telegramModel
    WMAlertCallPopModel *telegramModel = [WMAlertCallPopModel initName:teleSte image:@"yn_order_telegram" data:telegramLink ?: @"https://t.me/wownow_cs_bot" type:WMCallPhoneTypeTelegram];

    teleFirst = WMLocalizedString(@"wm_service_hotline", @"服务热线");
    teleLast = WMLocalizedString(@"wm_wait_minutes", @"等待2-5分钟");
    teleSte = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", teleFirst, teleLast]];
    [teleSte addAttributes:@{
        NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:13],
        NSForegroundColorAttributeName: HDAppTheme.WMColor.B3,
    }
                     range:[teleSte.string rangeOfString:teleFirst]];
    [teleSte addAttributes:@{
        NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11],
        NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
    }
                     range:[teleSte.string rangeOfString:teleLast]];
    /// serverModel
    WMAlertCallPopModel *serverModel = [WMAlertCallPopModel initName:teleSte image:@"yn_order_hotServer" data:dataSource type:WMCallPhoneTypeServer];
    if (info[@"groupID"]) {
        WMAlertCallPopModel *onlineModel = [WMAlertCallPopModel initName:WMLocalizedString(@"wm_order_online_contact", @"在线联系") image:@"yn_order_online_contact"
                                                                    data:@{@"groupID": info[@"groupID"]}
                                                                    type:WMCallPhoneTypeOnline];
        [GNAlertUntils callWithModelArray:@[onlineModel, serverModel] info:info];
    } else {
        [GNAlertUntils callWithModelArray:@[telegramModel, serverModel] info:info];
    }
}

@end
