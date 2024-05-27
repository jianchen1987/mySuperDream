//
//  SAAddressModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressSearchRspModel.h"
#import "SACacheManager.h"
#import "SACodingModel.h"
#import "SALocationUtil.h"
#import "SAShoppingAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAAddressModelFromType) {
    SAAddressModelFromTypeUnknown = 0,     ///< 未知
    SAAddressModelFromTypeLocate = 1,      ///< 定位
    SAAddressModelFromTypeAddressList = 2, ///< 收货地址列表
    SAAddressModelFromTypeMap = 3,         ///< 地图
    SAAddressModelFromTypeAdd = 4,         ///< 添加地址
    SAAddressModelFromTypeSearch = 5,      ///< 搜索地址
    SAAddressModelFromTypeOrderSubmit = 6, ///< 订单提交
    SAAddressModelFromTypeOnceTime = 7,    ///< 一次性使用地址（外卖首页通过tipview手动选择的地址）
    SAAddressModelFromTypeUserChoosed = 8  ///< 用户选择
};


@interface SAAddressModel : SACodingModel
/// 经度
@property (nonatomic, strong) NSNumber *lon;
/// 纬度
@property (nonatomic, strong) NSNumber *lat;
/// 省市区地址
@property (nonatomic, copy) NSString *address;
/// 门牌号
@property (nonatomic, copy) NSString *consigneeAddress;
/// 地址编号
@property (nonatomic, copy) NSString *addressNo;
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
/// 完整地址
@property (nonatomic, copy, readonly) NSString *fullAddress;
/// 来源
@property (nonatomic, assign) SAAddressModelFromType fromType;
/// 标签
@property (nonatomic, copy) NSArray<NSString *> *tags;
/// 是否默认地址
@property (nonatomic, copy) NSString *temp;
/// 性别
@property (nonatomic, copy) NSString *gender;
/// 联系人姓名
@property (nonatomic, copy) NSString *consigneeName;
/// 手机号
@property (nonatomic, copy) NSString *mobile;

// 经纬度是否可用
- (BOOL)isValid;
// 是否需要完善地址信息
- (BOOL)isNeedCompleteAddress;

+ (instancetype)addressModelWithAddressDictionary:(NSDictionary<SAAddressKey, id> *)addressDictionary;
+ (instancetype)addressModelWithAddressSearchItem:(SAAddressSearchRspModel *)searchItem;
+ (instancetype)addressModelWithShoppingAddressModel:(SAShoppingAddressModel *)shoppingAddressModel;

@end

NS_ASSUME_NONNULL_END
