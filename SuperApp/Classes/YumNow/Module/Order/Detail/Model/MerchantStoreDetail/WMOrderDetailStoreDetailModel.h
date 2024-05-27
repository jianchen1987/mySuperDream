//
//  WMOrderDetailStoreDetailModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 订单详情页门店详情
@interface WMOrderDetailStoreDetailModel : WMModel
/// 联系电话
@property (nonatomic, copy) NSString *contactNumber;
/// 商户名
@property (nonatomic, strong) SAInternationalizationModel *merchantName;
/// 商户名-英文
@property (nonatomic, copy) NSString *merchantNameEn;
/// 商户名-柬文
@property (nonatomic, copy) NSString *merchantNameKm;
/// 商户名-中文
@property (nonatomic, copy) NSString *merchantNameZh;
/// 公告
@property (nonatomic, strong) SAInternationalizationModel *announcement;
/// 公告-英文
@property (nonatomic, copy) NSString *announcementEn;
/// 公告-柬文
@property (nonatomic, copy) NSString *announcementKm;
/// 公告-中文
@property (nonatomic, copy) NSString *announcementZh;
/// 门店名
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 门店名-英文
@property (nonatomic, copy) NSString *storeNameEn;
/// 门店名-柬文
@property (nonatomic, copy) NSString *storeNameKm;
/// 门店名-中文
@property (nonatomic, copy) NSString *storeNameZh;
/// 门店地址
@property (nonatomic, copy) NSString *address;
/// 自动接单配置
@property (nonatomic, copy) WMOrderAutoAcceptConfigType autoConfirm;
/// 营业时间
@property (nonatomic, copy) NSArray<NSArray<NSString *> *> *businessHours;
/// 资质图片
@property (nonatomic, copy) NSArray<NSString *> *businessLicenseImage;
/// 配送模式
@property (nonatomic, copy) WMOrderDeliveryMode deliveryMode;
/// 配送范围, 单位: km
@property (nonatomic, strong) NSNumber *deliveryRange;
/// 纬度
@property (nonatomic, strong) NSNumber *latitude;
/// 门店logo
@property (nonatomic, copy) NSString *logo;
/// 经度
@property (nonatomic, copy) NSString *longitude;
/// 管理账号
@property (nonatomic, copy) NSString *managerAccount;
/// 门店联系人
@property (nonatomic, copy) NSString *managerName;
/// 商户编号
@property (nonatomic, copy) NSString *merchantNo;
/// 门店登录账号UID
@property (nonatomic, copy) NSString *operatorNo;
/// 门店背景图
@property (nonatomic, copy) NSString *photo;
/// 门店图片
@property (nonatomic, copy) NSArray<NSString *> *photos;
/// 产品数
@property (nonatomic, assign) NSUInteger productCount;
/// 起送价格
@property (nonatomic, strong) SAMoneyModel *requiredPrice;
/// 起送价格
@property (nonatomic, copy) NSString *requiredPriceCent;
/// 备餐时间
@property (nonatomic, assign) NSUInteger requiredTime;
/// 评价数
@property (nonatomic, assign) NSUInteger reviewCount;
/// 评分
@property (nonatomic, assign) double reviewScore;
/// 门店 id
@property (nonatomic, copy) NSString *storeId;
/// 门店NO
@property (nonatomic, copy) NSString *storeNo;
/// 门店状态
@property (nonatomic, copy) WMShopppingCartStoreStatus storeStatus;
/// 增值税率
@property (nonatomic, strong) NSNumber *taxRate;
/// 数据版本
@property (nonatomic, copy) NSString *version;
@end

NS_ASSUME_NONNULL_END
