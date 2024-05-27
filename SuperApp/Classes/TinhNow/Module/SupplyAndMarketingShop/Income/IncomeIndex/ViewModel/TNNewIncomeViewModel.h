//
//  TNNewIncomeViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNIncomeListFilterModel.h"
#import "TNNewIncomeRspModel.h"
#import "TNNewProfitIncomeModel.h"
#import "TNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNNewIncomeViewModel : TNViewModel
/// 收益账户模型
@property (strong, nonatomic) TNNewProfitIncomeModel *profitModel;
/// 筛选模型
@property (strong, nonatomic) TNIncomeListFilterModel *filterModel;
///收益统计数据
@property (strong, nonatomic) TNIncomeCommissionSumModel *_Nullable commissionSumModel;
/// 列表刷新标记
@property (nonatomic, assign) BOOL incomeRefreshFlag;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
/// 列表是否有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 列表数据
@property (nonatomic, strong) NSMutableArray<TNNewIncomeItemModel *> *list;
@property (nonatomic, copy) void (^getNewDataFaild)(void);   ///<  收益列表获取数据失败回调
@property (nonatomic, copy) void (^loadMoreDataFaild)(void); ///<  收益列表获取数据失败回调
///拉取账户数据
- (void)getProfitIncomeDataCompletion:(void (^)(BOOL isSucess))completion;
/// 获取列表收益统计
- (void)getIncomeSettlementSumCompletion:(void (^)(void))completion;
/// 检验用户是否开通了钱包
- (void)checkUserOpenedWallet;
/// 请求列表数据
- (void)getNewListDataWithLoading:(BOOL)loading;
/// 请求更多列表数据
- (void)loadMoreListData;
@end

NS_ASSUME_NONNULL_END
