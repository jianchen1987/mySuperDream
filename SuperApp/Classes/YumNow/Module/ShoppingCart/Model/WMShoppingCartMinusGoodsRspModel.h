//
//  WMShoppingCartMinusGoodsRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartMinusGoodsRspModel : WMRspModel
/// 用户账号id
@property (nonatomic, copy) NSString *userAccountId;
/// 商品sku id
@property (nonatomic, copy) NSString *goodsSkuId;
/// 商品优惠后总价
@property (nonatomic, strong) SAMoneyModel *totalDiscountAmount;
@end

NS_ASSUME_NONNULL_END
