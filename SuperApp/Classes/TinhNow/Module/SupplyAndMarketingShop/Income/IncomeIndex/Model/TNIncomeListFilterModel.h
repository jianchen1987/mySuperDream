//
//  TNIncomeListFilterModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeListFilterModel : TNModel
/// 1：普通收益、2：兼职收益
@property (nonatomic, assign) TNSellerIdentityType supplierType;
/// 搜索全部收益记录
@property (nonatomic, assign) BOOL showAll;
/// 查询最近 x 天的数据，可选值 7/ 30
@property (nonatomic, strong) NSNumber *_Nullable dailyInterval;
/// 开始时间
@property (nonatomic, copy) NSString *_Nullable dateRangeStart;
/// 结束时间
@property (nonatomic, copy) NSString *_Nullable dateRangeEnd;
/// 1: 已结算 2: 预估收入
@property (nonatomic, assign) NSInteger queryMode;
//自定义属性  筛选条件除开supplierType  全部为空
@property (nonatomic, assign) BOOL isCleanFilter;
@end

///  收益统计
@interface TNIncomeCommissionSumModel : TNModel
///
@property (nonatomic, assign) NSInteger total;          ///总条数
@property (strong, nonatomic) SAMoneyModel *totalMoney; ///< 总收益
@end

NS_ASSUME_NONNULL_END
