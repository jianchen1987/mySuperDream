//
//  TNIncomeRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
#import "TNPagingRspModel.h"
typedef NS_ENUM(NSInteger, TNIncomeRecordItemType) {
    TNIncomeRecordItemTypeIncome = 0,         //卖家收益
    TNIncomeRecordItemTypeWithDraw = 1,       //提现结算
    TNIncomeRecordItemTypeWithDrawReject = 2, //提现驳回
    TNIncomeRecordItemTypePartTimeDeduct = 3  //收益扣回
};

typedef NS_ENUM(NSInteger, TNPreIncomeRecordStatus) {
    TNPreIncomeRecordStatusGoing = 1, //订单进行中
    TNPreIncomeRecordStatusCancel = 2 //订单取消
};
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeRecordItemModel : TNModel
@property (nonatomic, copy) NSString *objId;               ///< 业务员id
@property (nonatomic, assign) TNIncomeRecordItemType type; ///类型    0：商品卖家收益 1：:提现结算
@property (nonatomic, copy) NSString *memberId;            ///<用户ID
@property (nonatomic, copy) NSString *date;                ///<日期
@property (nonatomic, copy) NSString *time;                ///<时间
@property (nonatomic, copy) NSString *remark;              ///<说明
@property (nonatomic, copy) NSString *amount;              ///<金额
///
@property (strong, nonatomic) SAMoneyModel *amountMoney;      ///金额对象
@property (nonatomic, assign) TNPreIncomeRecordStatus status; ///< 预估收益列表 才有  订单状态
@end


@interface TNIncomeRspModel : TNPagingRspModel
@property (strong, nonatomic) NSArray<TNIncomeRecordItemModel *> *list;
@end

NS_ASSUME_NONNULL_END
