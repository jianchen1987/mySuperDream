//
//  AcountCellModel.m
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNAcountCellModel.h"


@implementation PNAcountCellModel

+ (PNAcountCellModel *)getModel:(NSString *)shadowImageName
                        bgImage:(NSString *)bgImageName
                   CSymbolImage:(NSString *)CSymbolImageNmae
                        Balance:(NSString *)balance
                       Currency:(NSString *)currency
                  currencyImage:(NSString *)currencyImageName
                 NonCashBalance:(NSString *)nonCashBalance {
    PNAcountCellModel *model = PNAcountCellModel.new;
    model.shadowImageName = shadowImageName;
    model.bgImageName = bgImageName;
    model.CSymbolImageNmae = CSymbolImageNmae;
    model.balance = balance;
    model.currency = currency;
    model.currencyImageName = currencyImageName;
    model.nonCashBalance = nonCashBalance;
    return model;
}

@end
