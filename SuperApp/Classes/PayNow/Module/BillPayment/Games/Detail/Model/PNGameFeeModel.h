//
//  PNGameFeeModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNGameFeeModel : PNModel
/// 手续费
@property (strong, nonatomic) SAMoneyModel *fee;
/// 营销优惠
@property (strong, nonatomic) SAMoneyModel *promotion;
/// 费用承担方
@property (nonatomic, copy) NSString *chargeType;
///  手续费
@property (strong, nonatomic) SAMoneyModel *totalAmount;
@end

NS_ASSUME_NONNULL_END
