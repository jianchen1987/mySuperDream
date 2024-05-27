//
//  WMShoppingCartRemoveGoodsRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartRemoveGoodsRspModel : WMRspModel
/// 用户账号id
@property (nonatomic, copy) NSString *userAccountId;
/// 商品sku id
@property (nonatomic, copy) NSString *goodsSkuId;
@end

NS_ASSUME_NONNULL_END
