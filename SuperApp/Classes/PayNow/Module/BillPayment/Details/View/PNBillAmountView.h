//
//  PNBillAmountView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"
#import "PNWaterBillModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBillAmountView : PNView

/// 是否可以编辑输入金额
@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, strong) PNBalancesInfoModel *balancesInfoModel;

@end

NS_ASSUME_NONNULL_END
