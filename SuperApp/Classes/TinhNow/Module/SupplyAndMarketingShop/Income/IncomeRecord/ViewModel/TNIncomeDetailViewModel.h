//
//  TNIncomeDetailViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeDetailModel.h"
#import "TNViewModel.h"
#import "TNIncomeRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeDetailViewModel : TNViewModel
@property (nonatomic, copy) NSString *objId; ///< 查询id
///收益详情类型0：商品分销佣金1：提现结算2：提现驳回3：订单取消负数扣回
@property (nonatomic, assign) TNIncomeRecordItemType type;
@property (strong, nonatomic) NSMutableArray *dataArr;              ///< 收益数据源
@property (strong, nonatomic) TNIncomeDetailModel *detailModel;     ///< 模型
@property (nonatomic, assign) BOOL refreshFlag;                     ///< 刷新标记
@property (nonatomic, copy) void (^incomeDetailGetDataFaild)(void); ///<  收益详情获取数据失败回调
//获取详情数据
- (void)getDatailData;
@end

NS_ASSUME_NONNULL_END
