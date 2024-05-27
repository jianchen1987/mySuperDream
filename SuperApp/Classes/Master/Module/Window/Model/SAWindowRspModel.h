//
//  SAWindowRepModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

@class SAWindowModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAWindowRspModel : SARspModel

/// 数据源
@property (nonatomic, strong) NSArray<SAWindowModel *> *list;

@end

NS_ASSUME_NONNULL_END
