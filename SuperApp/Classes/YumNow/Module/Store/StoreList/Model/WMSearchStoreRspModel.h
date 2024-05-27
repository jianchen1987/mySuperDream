//
//  WMSearchStoreRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "WMStoreListItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSearchStoreRspModel : SACommonPagingRspModel
/// 所有门店
@property (nonatomic, copy) NSArray<WMStoreListItemModel *> *list;
@end

@interface WMSearchStoreNewRspModel : SACommonPagingRspModel
/// 所有门店
@property (nonatomic, copy) NSArray<WMStoreListNewItemModel *> *list;

@end

NS_ASSUME_NONNULL_END
