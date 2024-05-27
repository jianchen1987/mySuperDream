//
//  WMStoreDetailRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMNextServiceTimeModel.h"
#import "WMRspModel.h"
#import "WMStoreStatusModel.h"

@class WMStoreDetailPromotionModel, IficationModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreDetailRspModel : WMRspModel
/// 地址
@property (nonatomic, copy) NSString *address;
/// 公告
@property (nonatomic, strong) SAInternationalizationModel *announcement;
/// 营业时间
@property (nonatomic, copy) NSArray<NSArray<NSString *> *> *businessHours;
/// 营业天
@property (nonatomic, copy) NSArray<NSString *> *businessDays;
/// 经营范围
//@property (nonatomic, copy) NSArray<SAInternationalizationModel *> *businessScopes;
/// 经营范围 2.8.3增加
@property (nonatomic, copy) NSArray<IficationModel *> *businessScopesV2;
/// 优惠活动
@property (nonatomic, copy) NSArray<WMStoreDetailPromotionModel *> *promotions;
/// 号码
@property (nonatomic, copy) NSString *contactNumber;
/// 配送费
@property (nonatomic, strong) SAMoneyModel *deliveryFee;
/// 配送时间
@property (nonatomic, assign) NSUInteger deliveryTime;

@property (nonatomic, assign) NSUInteger estimatedDeliveryTime;
/// 距离
@property (nonatomic, assign) double distance;
/// 是否在范围内
@property (nonatomic, assign) BOOL inRange;
/// 纬度
@property (nonatomic, strong) NSNumber *latitude;
/// logo
@property (nonatomic, copy) NSString *logo;
/// 精度
@property (nonatomic, strong) NSNumber *longitude;
/// 商户号
@property (nonatomic, copy) NSString *merchantNo;
/// 图片
@property (nonatomic, copy) NSString *photo;
/// 图片数组=
@property (nonatomic, copy) NSArray<NSString *> *photos;
/// 资质图片数组
@property (nonatomic, copy) NSArray<NSString *> *businessLicenseImages;
/// 起送价
@property (nonatomic, strong) SAMoneyModel *minOrderAmount;
/// 原起送价
@property (nonatomic, strong) SAMoneyModel *oldMinOrderAmount;
/// 评论数
@property (nonatomic, assign) NSUInteger reviewCount;
/// 评分
@property (nonatomic, assign) float reviewScore;
/// 门店 id
@property (nonatomic, copy) NSString *storeId;
/// 门店名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 门店状态
@property (nonatomic, strong) WMStoreStatusModel *storeStatus;
/// 支付方式
@property (nonatomic, copy) NSArray<WMOrderAvailablePaymentType> *supportedPayments;
/// 商品优惠活动
@property (nonatomic, copy) NSArray<NSString *> *productPromotions;
/// 是否支持极速达配送服务
@property (nonatomic, copy) SABoolValue speedDelivery;
/// 慢必赔
@property (nonatomic, copy) SABoolValue slowPayMark;
/// 是否收藏
@property (nonatomic, assign) BOOL favourite;
/// 已售商品数
@property (nonatomic, assign) NSUInteger ordered;
/// 分享链接
@property (nonatomic, copy) NSString *shareLink;
/// 下次服务时间
@property (nonatomic, strong) WMNextServiceTimeModel *nextServiceTime;
/// 下次营业时间
@property (nonatomic, copy) NSString *nextBusinessTime;
/// 暂停配送时间
@property (nonatomic, copy) NSString *effectTime;
/// 特殊区域提示
@property (nonatomic, strong) SAInternationalizationModel *priceRemark;
/// 爆单状态 10正常 20爆单 30爆单停止接单
@property (nonatomic, assign) WMStoreFullOrderState fullOrderState;
/// 出餐慢状态 10正常 20出餐慢
@property (nonatomic, assign) WMStoreSlowMealState slowMealState;
/// 是否有领取的活动
@property (nonatomic, assign) NSInteger shouGiveCouponActivity;
/// 优惠行数
@property (nonatomic, assign) NSInteger numberOfLinesOfPromotion;
/// 优惠更多
@property (nonatomic, assign) BOOL moreHidden;
/// 关联的团购门店id
@property (nonatomic, copy) NSString *grouponStoreNo;
/// 展示券包按钮
@property (nonatomic, copy) NSArray *couponPackageCodes;
/// 展示配送费金额
@property (nonatomic, copy) NSString *showDeliveryStr;
/// 分享图
@property (nonatomic, copy) NSString *shareBgImage;
/// 门店服务标签
@property (nonatomic, copy) NSArray<NSString *> *serviceLabel;
/// 是否支持到店自取
@property (nonatomic, assign) BOOL pickUpStatus;
/// 店铺视频数组
@property (nonatomic, strong) NSArray<NSString *>*videoUrls;

@end


@interface IficationModel : WMRspModel
/// name
@property (nonatomic, copy) NSString *classificationName;
/// code
@property (nonatomic, copy) NSString *scopeCode;
/// 分享链接
@property (nonatomic, copy) NSArray<IficationModel *> *subClassifications;

@end
NS_ASSUME_NONNULL_END
