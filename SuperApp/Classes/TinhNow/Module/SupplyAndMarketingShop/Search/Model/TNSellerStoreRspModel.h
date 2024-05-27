//
//  TNSellerStoreRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"
@class TNSellerStoreModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerStoreRspModel : TNPagingRspModel
/// 店铺列表
@property (nonatomic, strong) NSArray<TNSellerStoreModel *> *list;
@end

NS_ASSUME_NONNULL_END
