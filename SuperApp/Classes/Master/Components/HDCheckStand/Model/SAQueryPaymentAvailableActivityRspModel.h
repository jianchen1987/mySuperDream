//
//  SAQueryPaymentAvailableActivityRspMode.h
//  SuperApp
//
//  Created by seeu on 2022/5/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPaymentToolsActivityModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAQueryPaymentAvailableActivityRspModel : SARspInfoModel
///< 支付工具活动列表
@property (nonatomic, strong) NSArray<SAPaymentToolsActivityModel *> *list;
@end

NS_ASSUME_NONNULL_END
