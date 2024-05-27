//
//  GNProductModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNEnum.h"
#import "GNMessageCode.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GeoPointDTO;


@interface GNProductModel : GNCellModel
/// 产品名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 内容
@property (nonatomic, strong) SAInternationalizationModel *content;
/// 内容
@property (nonatomic, strong) SAInternationalizationModel *productContent;
/// 使用时间
@property (nonatomic, strong) SAInternationalizationModel *useTime;
/// 使用规则
@property (nonatomic, strong) SAInternationalizationModel *useRules;
/// 适用范围
@property (nonatomic, strong) SAInternationalizationModel *applyRange;
/// 有效期
@property (nonatomic, assign) NSInteger termOfValidity;
/// 距离
@property (nonatomic, assign) double distance;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 营业电话
@property (nonatomic, copy) NSString *businessPhone;
/// 产品状态 GS001：上架  GS002：下架
@property (nonatomic, strong) GNMessageCode *productStatus;
/// 产品code
@property (nonatomic, copy) NSString *codeId;
/// 产品code（订单列表用到）
@property (nonatomic, copy) NSString *productCode;
/// 商品类型：常规：GP001，代金券：GP002
@property (nonatomic, strong) GNMessageCode *type;
/// 商品类型：常规：GP001，代金券：GP002
@property (nonatomic, strong) GNMessageCode *productType;
/// 原价
@property (nonatomic, strong) NSDecimalNumber *originalPrice;
/// 售价
@property (nonatomic, strong) NSDecimalNumber *price;
/// 已售
@property (nonatomic, assign) NSInteger ordered;
/// 已售
@property (nonatomic, assign) NSInteger consumptionOrderCodeNum;
/// 产品图片
@property (nonatomic, copy) NSString *imagePath;
/// 多个图片
@property (nonatomic, copy) NSString *newsImagePath;
/// 限购数量
@property (nonatomic, assign) NSInteger homePurchaseRestrictions;
/// 是否限购 1限购 2不限购
@property (nonatomic, assign) GNHomePurchaseRestrictionsType whetherHomePurchaseRestrictions;
/// 经纬度
@property (nonatomic, strong) GeoPointDTO *geoPointDTO;
/// 商家名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 商家no
@property (nonatomic, copy) NSString *storeNo;
/// 商家no
@property (nonatomic, copy) NSString *storeLogo;
/// 是否有效
@property (nonatomic, assign) BOOL isTermOfValidity;
/// true为范围 false为天数
@property (nonatomic, assign) BOOL termOfValidityType;
/// 有效期范围开始时间
@property (nonatomic, assign) long termOfValidityFrom;
/// 有效期范围结束时间
@property (nonatomic, assign) long termOfValidityTo;
/// 是否售罄
@property (nonatomic, assign) BOOL isSoldOut;
/// 分数
@property (nonatomic, copy) NSString *storeScore;
/// 解析的图片数组
@property (nonatomic, copy) NSArray<NSString *> *imagePathArr;
/// 分享地址
@property (nonatomic, copy) NSString *shareUrl;
/// 是否过期自动退 1是 2否
@property (nonatomic, assign) NSInteger whetherRefund;

/// 文章商品
/// 产品名称
@property (nonatomic, strong) SAInternationalizationModel *productName;

- (CGFloat)itemHeight;

@end

NS_ASSUME_NONNULL_END
