//
//  SAShoppingAddressModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
@class SAAddressModel;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAShoppingAddressCellType) {
    SAShoppingAddressCellTypeDefault = 1, ///< 展示
    SAShoppingAddressCellTypeEdit = 2,    ///< 编辑
    SAShoppingAddressCellTypeChoose = 3   ///< 选择地址
};


@interface SAShoppingAddressModel : SACodingModel
/// 地址
@property (nonatomic, copy) NSString *address;
/// 是否默认地址
@property (nonatomic, copy) SABoolValue isDefault;
/// 是否在配送范围内
@property (nonatomic, copy) SABoolValue inRange;
/// 性别
@property (nonatomic, assign) SAGender gender;
/// 用户编号
@property (nonatomic, copy) NSString *operatorNo;
/// 纬度
@property (nonatomic, strong) NSNumber *latitude;
/// 经度
@property (nonatomic, strong) NSNumber *longitude;
/// 手机号
@property (nonatomic, copy) NSString *mobile;
/// 收货人姓名
@property (nonatomic, copy) NSString *consigneeName;
/// 手机区号
@property (nonatomic, copy) NSString *areaCode;
/// 地址编号
@property (nonatomic, copy) NSString *addressNo;
/// 图片文件
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;
/// 标签
@property (nonatomic, copy) NSArray<NSString *> *tags;
/// 收货人详细地址
@property (nonatomic, copy) NSString *consigneeAddress;
/// cell 样式
@property (nonatomic, assign) SAShoppingAddressCellType cellType;
/// 是否选中
@property (nonatomic, copy) SABoolValue isSelected;
/// 完整地址
@property (nonatomic, copy, readonly) NSString *fullAddress;
/// 是否支持极速达配送服务
@property (nonatomic, copy) SABoolValue speedDelivery;
/// 是否支持慢必赔
@property (nonatomic, copy) SABoolValue slowPayMark;
/// 国家
@property (nonatomic, copy) NSString *country;
/// 省
@property (nonatomic, copy) NSString *state;
/// 市
@property (nonatomic, copy) NSString *city;
/// 区
@property (nonatomic, copy) NSString *subLocality;
/// 街道
@property (nonatomic, copy) NSString *street;
/// 缩略名称
@property (nonatomic, copy) NSString *shortName;
/// 省/市编码
@property (nonatomic, copy) NSString *provinceCode;
/// 区编码
@property (nonatomic, copy) NSString *districtCode;
/// 公社编码
@property (nonatomic, copy) NSString *communeCode;
/// 与当前定位的距离
@property (nonatomic, assign) CLLocationDistance distance;

// AddressModel转为SAShoppingAddressModel
+ (instancetype)shoppingAddressModelWithAddressModel:(SAAddressModel *)model;

/// 是否需要完善地址信息
/// @param clientType 业务线传空时，直接校验地址是否需要完善
- (BOOL)isNeedCompleteAddressInClientType:(SAClientType _Nullable)clientType;

@end

NS_ASSUME_NONNULL_END
