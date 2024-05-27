//
//  WMTimeBucketsRecommandRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMTimeBucketsAreaModel;


@interface WMTimeBucketsRecommandRspModel : WMRspModel
/// list
@property (nonatomic, strong) NSArray<WMTimeBucketsAreaModel *> *list;
@end

NS_ASSUME_NONNULL_END
