//
//  TNGoodSpecsAndSkusModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNProductSkuModel;
@class TNProductSpecificationModel;
@class TNProductBatchPriceInfoModel;


@interface TNGoodInfoModel : TNModel
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 购买提示 规格弹窗上提示
@property (nonatomic, copy) NSString *purchaseTips;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 店铺id
@property (nonatomic, copy) NSString *storePhone;
/// 是否弹窗店铺提示
@property (nonatomic, assign) BOOL showPurchaseTipsStore;
/// 弹窗店铺提示文案
@property (nonatomic, copy) NSString *purchaseTipsStore;
/// 商品是否限购
@property (nonatomic, assign) BOOL goodsLimitBuy;
/// 限购数量
@property (nonatomic, assign) NSInteger maxLimit;
/// skus
@property (nonatomic, strong) NSArray<TNProductSkuModel *> *skus;
/// specs
@property (nonatomic, strong) NSArray<TNProductSpecificationModel *> *specs;
/// 是否可以购买
@property (nonatomic, assign) BOOL canBuy;
///阶梯价信息
@property (strong, nonatomic) TNProductBatchPriceInfoModel *batchPriceInfo;
/// 获取价格区间
- (NSString *)getPriceRange;
/// 获取最大库存
- (NSNumber *)getMaxStock;
@end

NS_ASSUME_NONNULL_END
