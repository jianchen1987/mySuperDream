//
//  GNStoreDetailModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNInternationalizationModel.h"
#import "GNMessageCode.h"
#import "GNProductModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GeoPointDTO, MessageCode;


@interface GNStoreDetailModel : GNCellModel
/// 商家名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 商家介绍
@property (nonatomic, strong) SAInternationalizationModel *storeIntroduce;
/// logo
@property (nonatomic, copy) NSString *logo;
/// 商圈
@property (nonatomic, strong) SAInternationalizationModel *commercialDistrictName;
/// 分类名称
@property (nonatomic, strong) SAInternationalizationModel *classificationName;
/// 其他服务
@property (nonatomic, strong) NSArray<GNInternationalizationModel *> *inServiceName;
/// 经纬度
@property (nonatomic, strong) GeoPointDTO *geoPointDTO;
/// 门店状态 GS001：已入场 、GS002：已离场 、 GS003：准备中
@property (nonatomic, strong) GNMessageCode *storeStatus;
/// 门店营业状态  GB001营业中 GB002停业中
@property (nonatomic, strong) GNMessageCode *businessStatus;
/// 商家地址
@property (nonatomic, copy) NSString *address;
/// 营业电话
@property (nonatomic, copy) NSString *businessPhone;
/// 店内环境
@property (nonatomic, copy) NSString *storeEnvironmentPhoto;
/// 店内资质
@property (nonatomic, copy) NSString *storeQualificationPhoto;
/// 营业时间（小时）
@property (nonatomic, copy) NSArray<NSArray<NSString *> *> *businessHours;
/// 营业时间（天）
@property (nonatomic, copy) NSArray<GNMessageCode *> *businessDays;
/// 产品列表
@property (nonatomic, copy) NSArray<GNProductModel *> *productList;
/// 商户No，用于跳转商户详情
@property (nonatomic, copy) NSString *storeNo;
/// 商家介绍图片
@property (nonatomic, copy) NSString *storeIntroducePhoto;
/// 分数
@property (nonatomic, copy) NSString *score;
/// 人均消费
@property (nonatomic, strong) NSDecimalNumber *perCapita;
/// 分享链接
@property (nonatomic, copy) NSString *shareUrl;
/// custom
/// 拼接的营业时间
@property (nonatomic, copy) NSString *businessStr;
/// 拼接的营业时间 短
@property (nonatomic, copy) NSString *shortBusinessStr;
/// 解析的图片数组
@property (nonatomic, copy) NSArray<NSString *> *storeEnvironmentPhotoArr;
/// 解析的图片数组
@property (nonatomic, copy) NSArray<NSString *> *storeQualificationPhotoArr;
/// 解析的商家图片
@property (nonatomic, copy) NSArray<NSString *> *storeIntroducePhotoArr;
/// 所有图片
@property (nonatomic, copy) NSArray<NSString *> *storeAllPhotoArr;
/// 商家广告图
@property (nonatomic, copy) NSString *signboardPhoto;

@end

NS_ASSUME_NONNULL_END
