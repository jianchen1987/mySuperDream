//
//  TNNewIncomeDetailModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNIncomeOrderShopsModel.h"
#import "TNModel.h"
#import "TNNewIncomeRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNNewIncomeDetailModel : TNModel
@property (strong, nonatomic) SAMoneyModel *totalAmount;                      ///< 商品金额总计
@property (strong, nonatomic) SAMoneyModel *platformServiceFee;               ///< 平台服务费
@property (strong, nonatomic) SAMoneyModel *commissionAmount;                 ///< 卖家收益费用
@property (strong, nonatomic) SAMoneyModel *actualIncome;                     ///< 实际收益费用
@property (nonatomic, copy) NSString *completeTime;                           ///<完成时间
@property (nonatomic, copy) NSString *nickname;                               ///<用户昵称
@property (nonatomic, copy) NSString *shopName;                               ///<店铺名称
@property (strong, nonatomic) NSArray<TNIncomeOrderShopsModel *> *orderShops; ///<商品信息
@property (nonatomic, copy) NSString *cashInTime;                             ///<结算时间
@property (nonatomic, copy) NSString *orderCreateTime;                        ///<下单时间
@property (nonatomic, copy) NSString *settleStatusStr;                        ///<结算状态显示文案
@property (nonatomic, copy) NSString *orderStatusStr;                         ///<订单状态显示文案
/// 1：普通收益、2：兼职收益
@property (nonatomic, assign) TNSellerIdentityType type;
@property (nonatomic, assign) TNIncomeSettleStatus settleStatus; ///<结算状态
@end

NS_ASSUME_NONNULL_END
