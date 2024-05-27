//
//  PNMSOpenModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOpenModel : PNModel

@property (nonatomic, copy) NSString *merchantNo;

/// 商户类型，10：个人商户，12：企业商户
@property (nonatomic, assign) PNMerchantType merchantType;
/// 证件类型，10：身份证，11：护照
@property (nonatomic, assign) PNPapersType identificationType;
/// 证件号
@property (nonatomic, copy) NSString *identificationNumber;
/// 商家负责人姓
@property (nonatomic, copy) NSString *personLastName;
/// 商家负责人名
@property (nonatomic, copy) NSString *personFirstName;
/// 证件照 正面
@property (nonatomic, copy) NSString *identificationFrontImg;
/// 证件照 反面
@property (nonatomic, copy) NSString *identificationBackImg;
/// 店铺名称
@property (nonatomic, copy) NSString *merchantName;
/// 经营品类 大类
@property (nonatomic, copy) NSString *merchantCategory;
/// 经营品类 小类
@property (nonatomic, copy) NSString *categoryItem;
/// 营业执照号码(max:30)
@property (nonatomic, copy) NSString *businessLicenseNumber;
/// 营业执照注册号图片 :
@property (nonatomic, strong) NSArray *businessLicenseImages;
/// 店铺门头照
@property (nonatomic, copy) NSString *storeFrontImg;
/// 省
@property (nonatomic, copy) NSString *province;
/// 市
@property (nonatomic, copy) NSString *city;
/// 区
@property (nonatomic, copy) NSString *area;
/// 具体地址(max:500)
@property (nonatomic, copy) NSString *address;
/// 经度
@property (nonatomic, copy) NSString *longitude;
/// 纬度
@property (nonatomic, copy) NSString *latitude;
/// 签约人姓
@property (nonatomic, copy) NSString *recruitedFirstName;
/// 签约人名
@property (nonatomic, copy) NSString *recruitedLastName;

@end

NS_ASSUME_NONNULL_END
