//
//  WMProductSearchRspModel.h
//  SuperApp
//
//  Created by Chaos on 2020/11/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "WMStoreGoodsItem.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMProductSearchRspModel : SACommonPagingRspModel
/// 所有商品
@property (nonatomic, strong) NSArray<WMStoreGoodsItem *> *list;
@end

NS_ASSUME_NONNULL_END
