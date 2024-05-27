//
//  SAAddressSearchItem.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddressSearchItemComponent : NSObject
/// 长名
@property (nonatomic, copy) NSString *long_name;
/// 短名
@property (nonatomic, copy) NSString *short_name;
/// 类型
@property (nonatomic, copy) NSArray<NSString *> *types;
@end


@interface SAAddressSearchItemGeometryLocation : NSObject
/// 经度
@property (nonatomic, strong) NSNumber *lng;
/// 纬度
@property (nonatomic, strong) NSNumber *lat;
@end


@interface SAAddressSearchItemGeometryViewport : NSObject
/// 北
@property (nonatomic, strong) SAAddressSearchItemGeometryLocation *northeast;
/// 南
@property (nonatomic, strong) SAAddressSearchItemGeometryLocation *southwest;
@end


@interface SAAddressSearchItemGeometry : NSObject
/// 类型
@property (nonatomic, copy) NSString *location_type;
/// 位置
@property (nonatomic, strong) SAAddressSearchItemGeometryLocation *location;
/// viewport
@property (nonatomic, strong) SAAddressSearchItemGeometryViewport *viewport;
@end


@interface SAAddressSearchItemPlusCode : NSObject
/// compound_code
@property (nonatomic, copy) NSString *compound_code;
/// global_code
@property (nonatomic, copy) NSString *global_code;
@end


@interface SAAddressSearchItem : SAModel
@property (nonatomic, copy) NSArray<NSString *> *access_points;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 附近
@property (nonatomic, copy) NSString *vicinity;
/// 地址
@property (nonatomic, copy) NSString *formatted_address;
/// id
@property (nonatomic, copy) NSString *place_id;
/// 地址列表
@property (nonatomic, copy) NSArray<SAAddressSearchItemComponent *> *address_components;
/// 几何结构
@property (nonatomic, strong) SAAddressSearchItemGeometry *geometry;
/// plus_code
@property (nonatomic, strong) SAAddressSearchItemPlusCode *plus_code;
/// 类型
@property (nonatomic, copy) NSArray<NSString *> *types;
@end

NS_ASSUME_NONNULL_END
