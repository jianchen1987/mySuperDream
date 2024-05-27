//
//  AcountCellModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNAcountCellModel : PNModel
@property (nonatomic, copy) NSString *shadowImageName;
@property (nonatomic, copy) NSString *bgImageName;
//币种符号
@property (nonatomic, copy) NSString *CSymbolImageNmae;
@property (nonatomic, copy) NSString *balance;
//币种
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *currencyImageName;
@property (nonatomic, copy) NSString *nonCashBalance;

@property (nonatomic, copy) NSString *freezeBalance;


/// 商户的可用余额
@property (nonatomic, copy) NSString *usableBalance;

+ (PNAcountCellModel *)getModel:(NSString *)shadowImageName
                        bgImage:(NSString *)bgImageName
                   CSymbolImage:(NSString *)CSymbolImageNmae
                        Balance:(NSString *)balance
                       Currency:(NSString *)currency
                  currencyImage:(NSString *)currencyImageName
                 NonCashBalance:(NSString *)nonCashBalance;

@end

NS_ASSUME_NONNULL_END
