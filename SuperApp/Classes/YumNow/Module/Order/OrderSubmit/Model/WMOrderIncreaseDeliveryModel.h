//
//  WMOrderIncreaseDeliveryModel.h
//  SuperApp
//
//  Created by wmz on 2022/4/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderIncreaseDeliveryModel : WMRspModel

@property (nonatomic, strong) SAInternationalizationModel *timeRemark;
///增加配送费备注
@property (nonatomic, strong) SAInternationalizationModel *feeRemark;
///增加的配送时间
@property (nonatomic, assign) NSTimeInterval increaseDeliveryTime;
///是否增加配送时间
@property (nonatomic, assign) BOOL increaseTimeFlag;
///是否增加配送费
@property (nonatomic, assign) BOOL increaseFeeFlag;
///暂停配送
@property (nonatomic, assign) BOOL stopFlag;
///时间段
@property (nonatomic, copy) NSString *effectTime;

@end

NS_ASSUME_NONNULL_END
