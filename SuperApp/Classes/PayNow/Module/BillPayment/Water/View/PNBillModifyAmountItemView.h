//
//  PNBillModifyAmountItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"
#import "PNWaterBillModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ModifyAccountBlock)(void);


@interface PNBillModifyAmountItemView : PNView
@property (nonatomic, strong) PNBalancesInfoModel *balancesInfoModel;
@property (nonatomic, assign) BOOL isShowModifyButton;

@property (nonatomic, copy) ModifyAccountBlock modifyAccountBlock;
@end

NS_ASSUME_NONNULL_END
