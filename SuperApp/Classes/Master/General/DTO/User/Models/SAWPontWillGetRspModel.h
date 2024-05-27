//
//  SAWPontWillGetRspModel.h
//  SuperApp
//
//  Created by seeu on 2022/5/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

@class SAMoneyModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAWPontWillGetRspModel : SARspInfoModel
///< 业务线
@property (nonatomic, copy) NSString *businessLine;
///< 是否可获得积分
@property (nonatomic, assign) BOOL bePermitted;
///< 获得的积分数
@property (nonatomic, strong) NSNumber *point;
///< 获得积分的门槛
@property (nonatomic, strong) SAMoneyModel *thresholdAmount;

@end

NS_ASSUME_NONNULL_END
