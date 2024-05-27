//
//  WMStoreGoodsProductSpecification.h
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMModel.h"
#import "WMStoreGoodsPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 商品规格
@interface WMStoreGoodsProductSpecification : WMModel
/// 商品编号
@property (nonatomic, copy) NSString *code;
/// 日销量
@property (nonatomic, assign) NSUInteger dailySales;
/// 商品描述
@property (nonatomic, strong) SAInternationalizationModel *desc;
/// 商品描述-英文
@property (nonatomic, copy) NSString *descriptionEn;
/// 商品描述-柬文
@property (nonatomic, copy) NSString *descriptionKm;
/// 商品描述-中文
@property (nonatomic, copy) NSString *descriptionZh;
/// 商品名称
@property (nonatomic, copy) NSString *name;
/// 折扣价
//@property (nonatomic, strong) SAMoneyModel *discountPrice;
///// 售价
//@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 售价
@property (nonatomic, strong) NSString *salePrice;
/// 原价
@property (nonatomic, assign) NSInteger salePriceCent;

/// 商品规格 id
@property (nonatomic, copy) NSString *specificationId;
/// 商品 id
@property (nonatomic, copy) NSString *productId;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 商品图片路径集合
@property (nonatomic, copy) NSArray<NSString *> *imagePaths;
/// 商品菜单 id
@property (nonatomic, copy) NSString *menuId;
/// 上架状态
@property (nonatomic, assign) WMGoodsStatus status;
/// 排序
@property (nonatomic, assign) NSInteger sort;
/// 商品优惠
@property (nonatomic, strong) WMStoreGoodsPromotionModel *productPromotion;

#pragma mark - 绑定属性
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 是否最后一项
@property (nonatomic, assign) BOOL isLast;


@end

NS_ASSUME_NONNULL_END
