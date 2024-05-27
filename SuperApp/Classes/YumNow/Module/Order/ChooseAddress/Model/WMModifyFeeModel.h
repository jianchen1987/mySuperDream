//
//  WMModifyFeeModel.h
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMModifyFeeModel : WMRspModel
///增加配送时长
@property (nonatomic, assign) NSInteger inTime;
///距离
@property (nonatomic, assign) NSInteger distance;
/// deliveryFee
@property (nonatomic, strong) SAMoneyModel *deliveryFee;

@end

NS_ASSUME_NONNULL_END
