//
//  WMMoreEatOnTimeRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMEatOnTimePagingRspModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMMoreEatOnTimeRspModel : WMRspModel
/// id
@property (nonatomic, assign) NSInteger id;
/// name
@property (nonatomic, copy) NSString *title;
/// name
@property (nonatomic, strong) WMEatOnTimePagingRspModel *rel;
/// images
@property (nonatomic, copy) NSString *images;
///时间
@property (nonatomic, copy) NSString *businessTime;

@end

NS_ASSUME_NONNULL_END
