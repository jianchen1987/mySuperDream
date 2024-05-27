//
//  PNQueryWithdrawCodeModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNQueryWithdrawCodeModel : PNModel
/// 汇款单号
@property (nonatomic, strong) NSString *orderNo;
/// 提现码
@property (nonatomic, strong) NSString *code;
/// 汇款金额
@property (nonatomic, strong) SAMoneyModel *amount;
/// 提现码状态：
@property (nonatomic, assign) PNWithdrawCodeStatus status;
/// 创建时间
@property (nonatomic, strong) NSString *createTime;
/// 提现时间
@property (nonatomic, strong) NSString *finishedTime;
/// 过期（失效）时间
@property (nonatomic, strong) NSString *expiredTime;

@end

NS_ASSUME_NONNULL_END
