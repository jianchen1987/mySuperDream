//
//  TNNewIncomeDetailViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeDetailModel.h"
#import "TNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNNewIncomeDetailViewModel : TNViewModel
@property (nonatomic, copy) NSString *objId;                        ///< 查询id
@property (strong, nonatomic) NSMutableArray *dataArr;              ///< 收益数据源
@property (strong, nonatomic) TNNewIncomeDetailModel *detailModel;  ///< 模型
@property (nonatomic, assign) BOOL refreshFlag;                     ///< 刷新标记
@property (nonatomic, copy) void (^incomeDetailGetDataFaild)(void); ///<  收益详情获取数据失败回调
//获取详情数据
- (void)getDatailData;
@end

NS_ASSUME_NONNULL_END
