//
//  PNGamePaymentViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameRspModel.h"
#import "PNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNGameListViewModel : PNViewModel
/// 数据
@property (strong, nonatomic) PNGameRspModel *rspModel;
/// 账单类型
@property (nonatomic, assign) PNPaymentCategory paymentCategoryCode;
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
//请求数据
- (void)getNewData;
@end

NS_ASSUME_NONNULL_END
