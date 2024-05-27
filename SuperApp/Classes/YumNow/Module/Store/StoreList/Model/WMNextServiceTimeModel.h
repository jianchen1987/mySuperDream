//
//  WMNextServiceTimeModel.h
//  SuperApp
//
//  Created by wmz on 2021/8/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMNextWeekModel;


@interface WMNextServiceTimeModel : WMModel
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) WMNextWeekModel *weekday;
@end


@interface WMNextWeekModel : WMModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *code;
@end
NS_ASSUME_NONNULL_END
