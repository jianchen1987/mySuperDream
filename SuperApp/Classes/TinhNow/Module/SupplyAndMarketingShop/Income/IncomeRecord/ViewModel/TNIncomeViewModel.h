//
//  TNIncomeViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeListFilterModel.h"
#import "TNIncomeModel.h"
#import "TNIncomeRspModel.h"
#import "TNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeViewModel : TNViewModel
@property (strong, nonatomic) TNIncomeModel *incomeModel; ///< 收益模型
/// 筛选模型
@property (strong, nonatomic) TNIncomeListFilterModel *filterModel;
///收益统计数据
@property (strong, nonatomic) TNIncomeCommissionSumModel *_Nullable commissionSumModel;
@property (nonatomic, strong) NSMutableArray<TNIncomeRecordItemModel *> *recordList;    ///< 收益列表
@property (nonatomic, strong) NSMutableArray<TNIncomeRecordItemModel *> *preRecordList; ///< 预估收益列表

@property (nonatomic, assign) BOOL incomeRefreshFlag;       ///< 收益刷新标记
@property (nonatomic, assign) BOOL commitionSumRefreshFlag; ///< 收益统计刷新标记
@property (nonatomic, assign) BOOL recordRefreshFlag;       ///< 收益列表刷新标记
@property (nonatomic, assign) BOOL preRecordRefreshFlag;    ///<  预估收益刷新标记
///
@property (nonatomic, assign) NSInteger recordCurrentPage;    ///< 收益列表当前页码
@property (nonatomic, assign) NSInteger preRecordCurrentPage; ///<预估列表当前页码
@property (nonatomic, assign) BOOL recordHasNextPage;         ///< 收益列表是否有下一页
@property (nonatomic, assign) BOOL preRecordHasNextPage;      ///<预估收益列表是否有下一页
///
@property (nonatomic, copy) void (^incomeGetDataFaild)(void);             ///<  收益详情获取数据失败回调
@property (nonatomic, copy) void (^recordListGetNewDataFaild)(void);      ///<  收益列表获取数据失败回调
@property (nonatomic, copy) void (^recordListLoadMoreDataFaild)(void);    ///<  收益列表获取数据失败回调
@property (nonatomic, copy) void (^preRecordListGetNewDataFaild)(void);   ///<  预估收益列表获取数据失败回调
@property (nonatomic, copy) void (^preRecordListLoadMoreDataFaild)(void); ///<  预估收益列表获取数据失败回调

//获取收益数据
- (void)getIncomeData;
//获取收益统计数据
- (void)getCommissionSum;

- (void)recordGetNewData;
- (void)recordGetNewDataWithLoading:(BOOL)isNeedLoading;
- (void)recordLoadMoreData;

- (void)preRecordGetNewData;
- (void)preRecordLoadMoreData;

@end

NS_ASSUME_NONNULL_END
