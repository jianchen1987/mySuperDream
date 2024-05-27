//
//  PNGuarateenBuildOrderPaymentRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/11.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenBuildOrderPaymentRspModel.h"


@implementation PNGuarateenBuildOrderPaymentRspModel
- (NSString *)guarateenTipsStr {
    return [NSString
        stringWithFormat:PNLocalizedString(@"ytEuVxQM", @"说明：买方付款成功后资金会暂存平台，%zd天后买方若没有确认完成交易，系统会自动完成交易把资金结算给卖方，并且无法再申请退款！"), self.day];
}

- (SAMoneyModel *)tradeAmtMoneyModel {
    SAMoneyModel *moneyModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%f", self.tradeAmt.doubleValue * 100] currency:self.tradeCy];

    return moneyModel;
}

- (SAMoneyModel *)payAmtMoneyModel {
    SAMoneyModel *moneyModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%f", self.payAmt.doubleValue * 100] currency:self.payAmtCy];

    return moneyModel;
}

- (SAMoneyModel *)freeAmtMoneyModel {
    SAMoneyModel *moneyModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%f", self.freeAmt.doubleValue * 100] currency:self.tradeCy];

    return moneyModel;
}

@end
