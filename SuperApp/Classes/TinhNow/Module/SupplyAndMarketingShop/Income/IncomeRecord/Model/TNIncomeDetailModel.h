//
//  TNIncomeDetailModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNIncomeOrderShopsModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeDetailModel : TNModel
@property (strong, nonatomic) SAMoneyModel *totalAmountMoney;                 ///< 商品金额总计
@property (strong, nonatomic) SAMoneyModel *platformServiceFeeMoney;          ///< 平台服务费
@property (strong, nonatomic) SAMoneyModel *commissionAmountMoney;            ///< 卖家收益费用
@property (strong, nonatomic) SAMoneyModel *actualIncomeMoney;                ///< 实际收益费用
@property (nonatomic, copy) NSString *completeTime;                           ///<完成时间
@property (nonatomic, copy) NSString *nickname;                               ///<用户昵称
@property (nonatomic, copy) NSString *shopName;                               ///<店铺名称
@property (nonatomic, assign) NSInteger status;                               ///<提现状态    0:可不提现    1：可提现
@property (strong, nonatomic) NSArray<TNIncomeOrderShopsModel *> *orderShops; ///<商品信息
@property (nonatomic, copy) NSString *remark;                                 ///<收益提示文案
@end

NS_ASSUME_NONNULL_END
