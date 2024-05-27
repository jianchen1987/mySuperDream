//
//  WMStoreModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMNextServiceTimeModel.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreStatusModel.h"
#import "SAYumNowLandingPageCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMBaseStoreModel : WMModel
///< 累计销量
@property (nonatomic, assign) NSUInteger saleCount;
///< 配送费
@property (nonatomic, strong) NSNumber *deliveryFee;
///< 商户名称
@property (nonatomic, strong) SAInternationalizationModel *merchantName;
///< 商户编号
@property (nonatomic, copy) NSString *merchantNo;
///< 备餐时间
@property (nonatomic, assign) NSTimeInterval requiredTime;
///< 商户 logo
@property (nonatomic, copy) NSString *logo;
///< 门店 id
@property (nonatomic, copy) NSString *storeId;
///< 门店编号
@property (nonatomic, copy) NSString *storeNo;
///< 门店名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
///预计送达时间
@property (nonatomic, strong) NSString *deliveryTime;
///< 配送时间
@property (nonatomic, strong) NSString *estimatedDeliveryTime;
///< 已售
@property (nonatomic, strong) NSString *sale;
///< 状态
@property (nonatomic, strong) WMStoreStatusModel *storeStatus;
///经营分类 2.8.3增加
@property (nonatomic, copy) NSArray<NSString *> *businessScopesV2;
///< 门店经度
@property (nonatomic, assign) double longitude;
///< 门店纬度
@property (nonatomic, assign) double latitude;
///< 是否为新店
@property (nonatomic, assign) BOOL isNewStore;
///< 距离
@property (nonatomic, assign) double distance;
///< 门店和用户距离描述
@property (nonatomic, copy, readonly) NSString *distanceStr;
///< 名称行数，默认 0
@property (nonatomic, assign) NSUInteger numberOfLinesOfNameLabel;
///< 描述行数，默认 0
@property (nonatomic, assign) NSUInteger numberOfLinesOfDescLabel;
///< 图片
@property (nonatomic, copy) NSString *photo;
///< 评论数量
@property (nonatomic, assign) NSInteger commentsCount;
///< 评分
@property (nonatomic, assign) float ratingScore;

@property (nonatomic, assign) NSInteger ordered;
/// 自定义标签
@property (nonatomic, copy) NSString *tags;
/// 商品优惠活动
@property (nonatomic, copy) NSArray<NSString *> *productPromotions;
/// 门店服务标签
@property (nonatomic, copy) NSArray<NSString *> *serviceLabel;
/// 是否支持极速达配送服务
@property (nonatomic, copy) SABoolValue speedDelivery;
/// 慢必赔
@property (nonatomic, copy) SABoolValue slowPayMark;
/// 爆单状态 10正常 20爆单 30爆单停止接单
@property (nonatomic, assign) WMStoreFullOrderState fullOrderState;
/// 出餐慢状态 10正常 20出餐慢
@property (nonatomic, assign) WMStoreSlowMealState slowMealState;
/// 优惠行数，默认 1
@property (nonatomic, assign) NSInteger numberOfLinesOfPromotion;
/// 休息中
@property (nonatomic, strong) WMNextServiceTimeModel *nextServiceTime;
#pragma mark - 绑定属性
///< 当前关键词，用于高亮显示处理
@property (nonatomic, copy) NSString *keyWord;
/// 是否为第一个
@property (nonatomic, assign) BOOL isFirst;
///
@property (nonatomic, strong) NSMutableAttributedString *attribStr;
///优化标签卡顿
@property (nonatomic, strong) NSMutableAttributedString *tagString;
@property (nonatomic, strong) NSArray *tagArr;
///比率
@property (nonatomic, assign) CGFloat rate;
///付费标志
@property (nonatomic, assign) BOOL payFlag;
///优化标签卡顿
@property (nonatomic, assign) NSInteger lines;
/// hadShowNext
@property (nonatomic, assign) BOOL hadShowNext;
/// 编辑选择
@property (nonatomic, assign) BOOL isEditSelected;
/// 是否展示已售字段
@property (nonatomic, assign) BOOL isShowSaleCount;

@property (nonatomic, copy) NSString *uuid;
///在配送范围
@property (nonatomic, assign) BOOL inRange;
/// 店铺类型 ST0001普通门店、ST0002品牌门店、ST0003中国门店、ST0004CKA门店
@property (nonatomic, copy) NSString *storeType;
///< 出现时间
@property (nonatomic, assign) NSTimeInterval willDisplayTime;

@end

@interface WMStoreModel : WMBaseStoreModel
/// 优惠活动
@property (nonatomic, copy) NSArray<WMStoreDetailPromotionModel *> *promotions;

@end

@interface WMNewStoreModel : WMBaseStoreModel
/// 优惠活动
@property (nonatomic, copy) NSArray<NSString *>*promotions;

@property (nonatomic, copy) YumNowLandingPageStoreCardStyle storeLogoShowType;

- (CGFloat)storeCardHeightWith:(YumNowLandingPageStoreCardStyle)storeLogoShowType;


@end

NS_ASSUME_NONNULL_END
