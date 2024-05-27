//
//  TNWithDrawAuditAmountCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNWithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWithDrawAuditAmountCellModel : NSObject
///状态
@property (nonatomic, copy) TNWithDrawApplyStatus status;
@property (strong, nonatomic) SAMoneyModel *amountMoney;
/// 收益类型（0：未知、1：普通收益、2：兼职收益）
@property (nonatomic, assign) TNSellerIdentityType commissionType;
///
@property (nonatomic, copy) NSString *remark;
@end


@interface TNWithDrawAuditAmountCell : SATableViewCell
///
@property (strong, nonatomic) TNWithDrawAuditAmountCellModel *model;
@end

NS_ASSUME_NONNULL_END
