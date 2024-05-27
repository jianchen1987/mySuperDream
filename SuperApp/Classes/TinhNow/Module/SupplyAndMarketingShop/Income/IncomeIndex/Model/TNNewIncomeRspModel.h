//
//  TNNewIncomeRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
#import "TNPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TNIncomeSettleStatus) {
    TNIncomeSettleStatusPending = 0, //待结算
    TNIncomeSettleStatusSettled = 1, //已结算
    TNIncomeSettleStatusInvalid = 2, //无效订单
};


@interface TNNewIncomeItemModel : TNModel
@property (nonatomic, copy) NSString *objId;                     ///< id
@property (nonatomic, copy) NSString *memberId;                  ///<用户ID
@property (nonatomic, copy) NSString *date;                      ///<日期
@property (nonatomic, copy) NSString *time;                      ///<时间
@property (nonatomic, assign) TNIncomeSettleStatus settleStatus; ///<结算状态
/// 订单状态
@property (nonatomic, copy) TNOrderState orderStatus;
@property (nonatomic, copy) SAMoneyModel *amount;      ///< 金额
@property (nonatomic, copy) NSString *settleStatusStr; ///<结算状态显示文案
@property (nonatomic, copy) NSString *orderStatusStr;  ///<订单状态显示文案
@end


@interface TNNewIncomeRspModel : TNPagingRspModel
/// 列表
@property (strong, nonatomic) NSArray<TNNewIncomeItemModel *> *list;
@end

NS_ASSUME_NONNULL_END
