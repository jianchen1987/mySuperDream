//
//  PNBillModifyAccountViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"
#import "PNWaterBillModel.h"

@class PNBillModifyAmountModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HandleModifyAmountBlock)(PNBalancesInfoModel *model);


@interface PNBillModifyAmountViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) NSString *billNo;

@property (nonatomic, strong) PNBalancesInfoModel *balancesInfoModel;

@property (nonatomic, copy) HandleModifyAmountBlock handleModifyAmountBlock;

@property (nonatomic, strong) PNBillModifyAmountModel *modifyAmountModel;

- (void)billModifyAmount:(NSString *)amount;

@end

NS_ASSUME_NONNULL_END
