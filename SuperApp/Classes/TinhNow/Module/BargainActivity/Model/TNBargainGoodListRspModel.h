//
//  TNBargainGoodListRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNPagingRspModel.h"
@class TNBargainGoodModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainGoodListRspModel : TNPagingRspModel
/// 商品数据源
@property (strong, nonatomic) NSArray<TNBargainGoodModel *> *records;
@end

NS_ASSUME_NONNULL_END
