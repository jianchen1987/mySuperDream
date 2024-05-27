//
//  SAGoodsModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;
@class SAInternationalizationModel;

/// 商品模型
@interface SAGoodsModel : SACodingModel

@property (nonatomic, copy) NSString *imageUrl;                       ///< 商品图片
@property (nonatomic, strong) SAInternationalizationModel *goodsName; ///< 商品名
@property (nonatomic, strong) SAMoneyModel *goodsOriPrice;            ///< 商品原单价
@property (nonatomic, strong) SAMoneyModel *goodsSellPrice;           ///< 商品销售单价
@property (nonatomic, assign) NSUInteger quantity;                    ///< 商品数量
@property (nonatomic, copy) NSString *skuId;                          ///< 商品规格Id
///< 商品规格名称
@property (nonatomic, copy) NSString *skuName;
@property (nonatomic, assign) NSUInteger stocks;            ///< 商品库存
@property (nonatomic, copy) NSArray<NSString *> *propertys; ///< 商品属性列表
///< id
@property (nonatomic, copy) NSString *goodsId;
///< 快照id
@property (nonatomic, copy) NSString *snapshotId;

@end

NS_ASSUME_NONNULL_END
