//
//  WMGoodsStockModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMEnumModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMGoodsStockModel : WMEnumModel
/// 状态
@property (nonatomic, assign) WMShoppingCartGoodInventoryStatus status;
@end

NS_ASSUME_NONNULL_END
