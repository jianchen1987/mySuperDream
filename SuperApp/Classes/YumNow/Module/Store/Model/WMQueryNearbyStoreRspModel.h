//
//  WMQueryNearbyStoreRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "WMStoreModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMQueryNearbyStoreRspModel : SACommonPagingRspModel
/// 列表
@property (nonatomic, copy) NSArray<WMStoreModel *> *list;
@end

@interface WMQueryNearbyStoreNewRspModel : SACommonPagingRspModel
/// 列表
@property (nonatomic, copy) NSArray<WMNewStoreModel *> *list;
@end


NS_ASSUME_NONNULL_END
