//
//  PNGuarateenDetailModel.m
//  SuperApp
//
//  Created by xixi on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenDetailModel.h"


@implementation PNGuarateenDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"flow": PNGuarateenFlowModel.class,
        @"nextActions": PNGuarateenNextActionModel.class,
    };
}

- (NSString *)amtStr {
    SAMoneyModel *moneyModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%f", self.amt.doubleValue * 100] currency:self.cy];

    return moneyModel.thousandSeparatorAmount;
}

- (NSString *)feeAmtStr {
    SAMoneyModel *moneyModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%f", self.feeAmt.doubleValue * 100] currency:self.cy];

    return moneyModel.thousandSeparatorAmount;
}

@end


@implementation PNGuarateenFlowModel

@end


@implementation PNGuarateenNextActionModel

@end
