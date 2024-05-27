//
//  WMCalculateProductPriceRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMCalculateProductPriceGoodsItem.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 商品规格信息检查或核算返回
@interface WMCalculateProductPriceRspModel : WMRspModel
/// 计算的商品集合
@property (nonatomic, copy) NSArray<WMCalculateProductPriceGoodsItem *> *productAndSpecCheckDetailsReqDTOS;
/// 总打包费
@property (nonatomic, strong) SAMoneyModel *packingChargesTotalPrice;
/// 商品总价
@property (nonatomic, strong) SAMoneyModel *productTotalPrice;
@end

NS_ASSUME_NONNULL_END
