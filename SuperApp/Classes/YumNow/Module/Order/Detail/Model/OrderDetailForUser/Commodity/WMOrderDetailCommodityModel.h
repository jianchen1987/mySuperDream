//
//  WMOrderDetailCommodityModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMOrderDetailProductModel.h"
#import "WMStoreFillGiftRuleModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailCommodityModel : WMModel
/// 增值税税率
@property (nonatomic, copy) NSString *vatRate;
/// 增值税
@property (nonatomic, strong) SAMoneyModel *vat;
/// 总价
@property (nonatomic, strong) SAMoneyModel *totalPrice;
/// 优惠金额总计
@property (nonatomic, strong) SAMoneyModel *discountTotalPrice;
/// 运费券金额
@property (nonatomic, strong) SAMoneyModel *freightCouponAmount;
/// 总打包费
@property (nonatomic, strong) SAMoneyModel *totalPackageFee;
/// 门店打包费
@property (nonatomic, strong) SAMoneyModel *packingFee;
/// 餐盒费
@property (nonatomic, strong) SAMoneyModel *boxFee;
/// 配送费
@property (nonatomic, strong) SAMoneyModel *deliverFee;
/// 商品总数
@property (nonatomic, assign) NSUInteger commodityTotalQuantity;
/// 商品
@property (nonatomic, copy) NSArray<WMOrderDetailProductModel *> *commodityList;
/// 商品项数量(不是所有商品累加的总数量)
@property (nonatomic, assign) NSUInteger commodityCategoryQuantity;
/// 满赠列表
@property (nonatomic, copy) NSArray<WMStoreFillGiftRuleModel *> *giftList;
@end

NS_ASSUME_NONNULL_END
