//
//  HDCouponTicketStoreModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 优惠券门店 */
@interface HDCouponTicketStoreModel : SAModel
@property (nonatomic, copy) NSString *businessHoursStart;     ///< 营业开始时间 为空时表示24小时营业
@property (nonatomic, copy) NSString *businessHoursEnd;       ///< 营业结束时间 为空时表示24小时营业
@property (nonatomic, copy) NSString *province;               ///< 省
@property (nonatomic, copy) NSString *city;                   ///< 市
@property (nonatomic, copy) NSString *area;                   ///< 区
@property (nonatomic, copy) NSString *storeAddress;           ///< 门店地址
@property (nonatomic, copy) NSString *storeFullAddress;       ///< 门店全地址
@property (nonatomic, copy) NSString *storeLat;               ///< 门店纬度
@property (nonatomic, copy) NSString *storeLot;               ///< 门店经度
@property (nonatomic, copy) NSString *storeName;              ///< 门店名称
@property (nonatomic, copy) NSString *storeNo;                ///< 门店编号
@property (nonatomic, copy) NSString *storeTel;               ///< 门店电话
@property (nonatomic, assign) BOOL shouldShowPhoneInfo;       ///< 是否显示号码信息
@property (nonatomic, assign) BOOL shouldShowAddressInfo;     ///< 是否显示位置信息
@property (nonatomic, assign) BOOL shouldShowOpenTimeInfo;    ///< 是否显示营业时间信息
@property (nonatomic, assign) BOOL isLast;                    ///< 是不是最后一个
@property (nonatomic, assign) BOOL isFirst;                   ///< 是不是第一个
@property (nonatomic, assign) double userLocationLatitude;    ///< 用户位置纬度
@property (nonatomic, assign) double userLocationLongitude;   ///< 用户位置经度
@property (nonatomic, assign) BOOL isGetUserLocationSuccess;  ///< 获取JS位置是否成功
@property (nonatomic, assign) double distanceFromUserToStore; ///< 用户到门店的距离，单位：米
@end

NS_ASSUME_NONNULL_END
