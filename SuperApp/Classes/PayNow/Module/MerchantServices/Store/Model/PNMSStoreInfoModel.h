//
//  PNMSStoreInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPermissionModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreInfoModel : PNMSPermissionModel

/// 该门店有多少个操作员
@property (nonatomic, assign) NSInteger operatorCount;
/// 门店ID
@property (nonatomic, copy) NSString *storeId;
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 商户名称
@property (nonatomic, copy) NSString *merchantName;
/// 商户logo
@property (nonatomic, copy) NSString *merchantLogo;

@property (nonatomic, copy) NSString *storeNum;

// 门店状态(ENABLE:启用,CLOSE:停用)
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSString *statusStr;
/// 省
@property (nonatomic, copy) NSString *province;
/// 市
@property (nonatomic, copy) NSString *city;
/// 区
@property (nonatomic, copy) NSString *area;
/// 具体地址
@property (nonatomic, copy) NSString *address;
/// 纬度
@property (nonatomic, copy) NSString *latitude;
/// 经度
@property (nonatomic, copy) NSString *longitude;
/// 门店电话号码
@property (nonatomic, copy) NSString *storePhone;
/// 门店电话号码
@property (nonatomic, strong) NSArray *storePhoneList;
/// 门店照片
@property (nonatomic, strong) NSArray *storeImages;
/// 开始营业时间(时分秒)
@property (nonatomic, copy) NSString *businessHoursStart;
/// 结束营业时间(时分秒)
@property (nonatomic, copy) NSString *businessHoursEnd;
/// 国家
@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *applySource;
@end

NS_ASSUME_NONNULL_END
