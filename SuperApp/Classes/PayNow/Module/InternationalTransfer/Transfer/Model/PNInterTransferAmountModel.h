//
//  PNInterTransferAmountModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferAmountModel : PNModel
/// 金额
@property (nonatomic, copy) NSString *amount;
/// 币种
@property (nonatomic, copy) NSString *currency;
@end

NS_ASSUME_NONNULL_END
