//
//  TNWithdrawModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NSString *TNWithDrawApplyStatus NS_STRING_ENUM;
FOUNDATION_EXPORT TNWithDrawApplyStatus const TNWithDrawApplyStatusPending;  ///<审核中
FOUNDATION_EXPORT TNWithDrawApplyStatus const TNWithDrawApplyStatusApproved; ///< 审核通过
FOUNDATION_EXPORT TNWithDrawApplyStatus const TNWithDrawApplyStatusFailed;   ///<审核失败


@interface TNWithdrawModel : TNModel
@property (strong, nonatomic) SAMoneyModel *amountMoney;       ///< 提现金额
@property (nonatomic, copy) NSString *voucher;                 ///< 凭证
@property (nonatomic, assign) TNPaymentWayCode settlementType; ///< 提现方式
///状态
@property (nonatomic, copy) TNWithDrawApplyStatus status;
/// 银行账号
@property (nonatomic, strong) NSString *account;
/// 开户名
@property (nonatomic, strong) NSString *accountHolder;
///银行名称
@property (nonatomic, strong) NSString *bank;
///备注
@property (nonatomic, strong) NSString *memo;
/// 收益类型（0：未知、1：普通收益、2：兼职收益）
@property (nonatomic, assign) TNSellerIdentityType commissionType;
///
@property (nonatomic, copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
