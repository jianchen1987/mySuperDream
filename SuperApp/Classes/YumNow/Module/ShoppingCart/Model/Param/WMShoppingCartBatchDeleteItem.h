//
//  WMShoppingCartBatchDeleteItem.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/26.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartBatchDeleteItem : WMModel
/// 购物车数量减少值 删除固定是0
@property (assign, nonatomic) NSInteger deleteDelta;
/// 业务类型：10-外卖业务，11-电商业务  DELEVERY :10-外卖业务 ECOMMERCE :11-电商业务
@property (nonatomic, copy) NSString *businessType;
/// appv2.3使用的  固定传1  是否自动删除
@property (nonatomic, assign) NSInteger autoDetele;
/// 购物项展示号
@property (nonatomic, copy) NSString *itemDisplayNo;
/// 快照 id
@property (nonatomic, copy) NSString *inEffectVersionId;
@end

NS_ASSUME_NONNULL_END
