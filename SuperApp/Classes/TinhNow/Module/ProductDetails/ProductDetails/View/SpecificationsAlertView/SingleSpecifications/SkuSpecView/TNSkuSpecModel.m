//
//  TNSkuSpecModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSkuSpecModel.h"
#import "TNGoodInfoModel.h"
#import "TNProductDetailsRspModel.h"


@implementation TNSkuSpecModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"skus": [TNProductSkuModel class], @"specs": [TNProductSpecificationModel class]};
}
+ (instancetype)modelWithGoodModel:(TNGoodInfoModel *)model {
    TNSkuSpecModel *skuModel = [[TNSkuSpecModel alloc] init];
    skuModel.skus = model.skus;
    skuModel.specs = model.specs;
    skuModel.productId = model.productId;
    skuModel.priceRange = [model getPriceRange];
    skuModel.maxStock = [model getMaxStock];
    skuModel.storeNo = model.storeNo;
    skuModel.purchaseTips = model.purchaseTips;
    skuModel.goodsLimitBuy = model.goodsLimitBuy;
    skuModel.maxLimit = model.maxLimit;
    skuModel.minLimit = 1;
    skuModel.batchPriceInfo = model.batchPriceInfo;
    if (model.skus.count > 0) {
        TNProductSkuModel *first = model.skus.firstObject;
        if (HDIsStringNotEmpty(first.showWight)) {
            skuModel.showWight = first.showWight;
        }
        skuModel.thumbnail = first.thumbnail;
        skuModel.skuLargeImg = first.thumbnail;
    }
    return skuModel;
}
+ (instancetype)modelWithGoodDetailModel:(TNProductDetailsRspModel *)model {
    TNSkuSpecModel *skuModel = [[TNSkuSpecModel alloc] init];
    skuModel.skus = model.skus;
    skuModel.specs = model.specs;
    skuModel.productId = model.productId;
    skuModel.priceRange = [model getPriceRange];
    skuModel.maxStock = [model getMaxStock];
    skuModel.storeNo = model.storeNo;
    skuModel.purchaseTips = model.purchaseTips;
    skuModel.goodsLimitBuy = model.goodsLimitBuy;
    skuModel.isBuyLimitGood = model.isBuyLimitGood;
    skuModel.maxLimit = model.maxLimit;
    skuModel.minLimit = model.minLimit;
    skuModel.shareCode = model.shareCode;
    skuModel.isSupplier = model.isSupplier;
    skuModel.sp = model.sp;
    skuModel.batchPriceInfo = model.batchPriceInfo;
    skuModel.productName = model.name;
    if (model.productImages.count > 0) {
        skuModel.thumbnail = model.productImages.firstObject.thumbnail;
        skuModel.skuLargeImg = model.productImages.firstObject.source;
    }
    if (model.skus.count == 1) {
        TNProductSkuModel *first = model.skus.firstObject;
        if (HDIsStringNotEmpty(first.showWight)) {
            skuModel.showWight = first.showWight;
        }
    }
    return skuModel;
}
@end
