//
//  WMOrderSubmitQueryGoodsItem.h
//  SuperApp
//
//  Created by Chaos on 2021/5/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitQueryGoodsItem : WMModel

/// 商品id
@property (nonatomic, assign) long goodsId;
/// 规格id
@property (nonatomic, assign) long goodsSkuId;
/// 快照id
@property (nonatomic, assign) long inEffectVersionId;
/// 属性 id
@property (nonatomic, strong) NSArray<NSNumber *> *properties;

@end

NS_ASSUME_NONNULL_END
