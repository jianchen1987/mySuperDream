//
//  TNQueryGoodsCategoryRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNCategoryModel;


@interface TNQueryGoodsCategoryRspModel : TNRspModel
/// list
@property (nonatomic, strong) NSArray<TNCategoryModel *> *list;
@end

NS_ASSUME_NONNULL_END
