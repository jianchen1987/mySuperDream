//
//  GNStoreCellModel.h
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNProductModel.h"
#import "GNStringUntils.h"
#import "SACaculateNumberTool.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreCellModel : GNCellModel
/// 商家地址
@property (nonatomic, copy) NSString *address;
/// 入场时间
@property (nonatomic, copy) NSString *starTime;
/// 距离
@property (nonatomic, assign) double distance;
/// 商户No，用于跳转商户详情
@property (nonatomic, copy) NSString *storeNo;
/// 商家名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 商家名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 商家环境图/产品图（后台上传的app广告图）
@property (nonatomic, copy) NSString *storeEnvironmentPhoto;
/// 商圈
@property (nonatomic, strong) SAInternationalizationModel *commercialDistrictName;
/// 下单数
@property (nonatomic, copy) NSString *ordered;
/// 分类名称
@property (nonatomic, strong) SAInternationalizationModel *classificationName;
/// 推荐券
@property (nonatomic, strong) GNProductModel *couponsProduct;
/// 推荐产品
@property (nonatomic, strong) GNProductModel *product;
/// 产品列表
@property (nonatomic, strong) NSArray<GNProductModel *> *productList;
/// 搜索关键词
@property (nonatomic, copy) NSString *keyWord;
/// 经纬度
@property (nonatomic, strong) GeoPointDTO *geoPointDTO;
/// 商家电话
@property (nonatomic, copy) NSString *businessPhone;
/// logo
@property (nonatomic, copy) NSString *logo;
/// 分数
@property (nonatomic, copy) NSString *score;
/// 人均消费
@property (nonatomic, strong) NSDecimalNumber *perCapita;
/// 压缩图
//@property (nonatomic, strong) UIImage *scaleImage;

//@property (nonatomic, assign) CGFloat iconHeight;

/// 展示预约
@property (nonatomic, assign) BOOL showReserve;

///< 埋点来源
@property (nonatomic, copy) NSString *source;

@end
NS_ASSUME_NONNULL_END
