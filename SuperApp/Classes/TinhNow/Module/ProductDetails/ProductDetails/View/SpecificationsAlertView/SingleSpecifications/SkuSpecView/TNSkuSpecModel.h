//
//  TNSkuSpecModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNProductSkuModel.h"
#import "TNProductSpecificationModel.h"
@class TNGoodInfoModel;
@class TNProductDetailsRspModel;
@class TNProductBatchPriceInfoModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSkuSpecModel : TNModel
/// 默认图片
@property (nonatomic, copy) NSString *thumbnail;
/// sku大图  用于预览大图
@property (nonatomic, copy) NSString *skuLargeImg;
/// 价格区间
@property (nonatomic, copy) NSString *priceRange;
/// 最大库存数
@property (nonatomic, copy) NSNumber *maxStock;
/// 购物提示
@property (nonatomic, copy) NSString *purchaseTips;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 商品名称
@property (nonatomic, copy) NSString *productName;
/// 分销客分享code 用于统计佣金   未有单独的字段返回   需在分享链接里面截取
@property (nonatomic, copy) NSString *shareCode;
/// 是否是限购商品
@property (nonatomic, assign) BOOL goodsLimitBuy;
/// 是否可以购买限购商品
@property (nonatomic, assign) BOOL isBuyLimitGood;
/// 最小限购数量
@property (nonatomic, assign) NSInteger minLimit;
/// 最大限购数量
@property (nonatomic, assign) NSInteger maxLimit;
/// skus
@property (nonatomic, strong) NSArray<TNProductSkuModel *> *skus;
/// specs
@property (nonatomic, strong) NSArray<TNProductSpecificationModel *> *specs;
/// 重量显示带单位
@property (nonatomic, copy) NSString *showWight;
///是否是卖家
@property (nonatomic, assign) BOOL isSupplier;
/// 供销码
@property (nonatomic, copy) NSString *sp;
///阶梯价信息
@property (strong, nonatomic) TNProductBatchPriceInfoModel *batchPriceInfo;

///// 初始化一个 规格模型
///// @param model 加购列表模型
+ (instancetype)modelWithGoodModel:(TNGoodInfoModel *)model;

/// 初始化一个 规格模型
/// @param model 商品详情模型
+ (instancetype)modelWithGoodDetailModel:(TNProductDetailsRspModel *)model;
@end

NS_ASSUME_NONNULL_END
