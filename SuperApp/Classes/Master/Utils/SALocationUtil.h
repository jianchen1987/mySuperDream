//
//  SALocationUtil.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HDUIKit/HDAlertView.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SAAddressKey NS_STRING_ENUM;
FOUNDATION_EXPORT SAAddressKey const SAAddressKeyStreet;          // 街道
FOUNDATION_EXPORT SAAddressKey const SAAddressKeySubLocality;     // 区
FOUNDATION_EXPORT SAAddressKey const SAAddressKeyState;           // 省
FOUNDATION_EXPORT SAAddressKey const SAAddressKeySubThoroughfare; // 例：19号
FOUNDATION_EXPORT SAAddressKey const SAAddressKeyThoroughfare;    // 例：东圃大马路
FOUNDATION_EXPORT SAAddressKey const SAAddressKeyCountry;         // 国家
FOUNDATION_EXPORT SAAddressKey const SAAddressKeyName;            // 缩略名称
FOUNDATION_EXPORT SAAddressKey const SAAddressKeyCity;            // 市


@interface SALocationUtil : NSObject

/// 经纬度转地址
/// @param coordinate 经纬度
/// @param completion 完成
+ (void)transferCoordinateToAddress:(CLLocationCoordinate2D)coordinate
                         completion:(void (^)(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary))completion;

/// 弹出需要授权提示
/// @param confirmButtonHandler 确认回调
/// @param cancelButtonHandler 取消回调，可不设置
+ (HDAlertView *)showNeedAuthedTipConfirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonHandler:(HDAlertViewButtonHandler __nullable)cancelButtonHandler;

/// 弹出未授权提示
/// @param confirmButtonHandler 确认回调，可不设置，默认去APP系统设置
/// @param cancelButtonHandler 取消回调，可不设置
+ (HDAlertView *)showUnAuthedTipConfirmButtonHandler:(HDAlertViewButtonHandler __nullable)confirmButtonHandler cancelButtonHandler:(HDAlertViewButtonHandler __nullable)cancelButtonHandler;
@end

NS_ASSUME_NONNULL_END
