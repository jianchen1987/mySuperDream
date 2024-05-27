//
//  WMShoppingCartAddGoodsRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartAddGoodsRspModel : WMRspModel
/// 用户账号id
@property (nonatomic, copy) NSString *userAccountId;
/// 当前商品sku的购买数量
@property (nonatomic, assign) NSUInteger purchaseQuantity;
/// 商品sku id
@property (nonatomic, copy) NSString *goodsSkuId;
/// 商品购物项展示号
@property (nonatomic, copy) NSString *itemDisplayNo;
/// 用户购物项展示号
@property (nonatomic, copy) NSString *userDisplayNo;
/// 门店购物项展示号
@property (nonatomic, copy) NSString *merchantDisplayNo;
/// 商品优惠总价
@property (nonatomic, strong) SAMoneyModel *totalDiscountAmount;
@end

NS_ASSUME_NONNULL_END
