//
//  WMStoreGoodsRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/12/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMStoreGoodsItem.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMStoreGoodsRspModel : WMModel
/// 商品列表
@property (nonatomic, copy) NSArray<WMStoreGoodsItem *> *products;
@end

NS_ASSUME_NONNULL_END
