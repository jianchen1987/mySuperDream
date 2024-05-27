//
//  PayOrderTableHeaderViewModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNOrderTableHeaderViewModel : PNModel
@property (nonatomic, copy) NSString *iconImgName;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, copy) NSString *amountStr;
@property (nonatomic, copy) NSString *incomeFlag;

/// 交易类型
@property (nonatomic, assign) PNTransType transType;
/// 提现码
@property (nonatomic, copy) NSString *withdrawCode;
/// 提现码状态
@property (nonatomic, assign) PNWithdrawCodeStatus withdrawStatus;
/// 提现码过期时间
@property (nonatomic, copy) NSString *withdrawOverdueTime;
@end

NS_ASSUME_NONNULL_END
