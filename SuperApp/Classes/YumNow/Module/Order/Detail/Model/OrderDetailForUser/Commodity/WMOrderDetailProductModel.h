//
//  WMOrderDetailProductModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMModel.h"
#import "WMOrderDetailProductPropertyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailProductModel : WMModel
/// 商品id
@property (nonatomic, copy) NSString *commodityId;
/// 商品名称
@property (nonatomic, copy) NSString *commodityName;
/// 快照id
@property (nonatomic, copy) NSString *commoditySnapshootId;
/// 商品图片列表
@property (nonatomic, copy) NSArray<NSString *> *commodityPictureIds;
/// 售价
@property (nonatomic, strong) SAMoneyModel *originalPrice;
/// 优惠后单价
@property (nonatomic, strong) SAMoneyModel *afterDiscountUnitPrice;
/// 优惠后总价
@property (nonatomic, strong) SAMoneyModel *afterDiscountTotalPrice;
/// 打包费
@property (nonatomic, strong) SAMoneyModel *packageFee;
/// 规格id
@property (nonatomic, copy) NSString *commoditySpecificationId;
/// 属性 id
@property (nonatomic, copy) NSArray<WMOrderDetailProductPropertyModel *> *propertyList;
/// 数量
@property (nonatomic, assign) NSUInteger quantity;
/// 规格名称
@property (nonatomic, copy) NSString *specificationName;
/// 门店状态，用于设置数量变化控件状态
@property (nonatomic, copy) WMShopppingCartStoreStatus storeStatus;
/// 商品类型
@property (nonatomic, assign) WMGoodsCommodityType commodityType;
/// 最大数量
@property (nonatomic, assign) NSUInteger maxQuantity;
/// 商品类型
@property (nonatomic, copy) NSString *orderCommodityId;

@end

NS_ASSUME_NONNULL_END
