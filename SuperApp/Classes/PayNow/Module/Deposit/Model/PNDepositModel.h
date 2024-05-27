//
//  DepositModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

typedef NS_ENUM(NSInteger, PNDepositAppType) {
    BakongApp,
    BankApp,
    CoolCash_outlet,
};

NS_ASSUME_NONNULL_BEGIN


@interface PNDepositModel : PNModel
@property (nonatomic, copy) NSString *iconImgName;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, assign) PNDepositAppType apptype;
@end

NS_ASSUME_NONNULL_END
