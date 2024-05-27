//
//  PNBillSupplierListViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

@class PNBillSupplierInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNBillSupplierListViewModel : PNViewModel
@property (nonatomic, assign) BOOL refreshFlag;
/// 账单类型
@property (nonatomic, assign) PNPaymentCategory paymentCategory;
/// 原始数据源
@property (nonatomic, strong) NSMutableArray<PNBillSupplierInfoModel *> *dataSourceArray;

/// 展示的数据源
@property (nonatomic, strong) NSMutableArray<PNBillSupplierInfoModel *> *showDataSourceArray;

/// 查询供应商列表
- (void)getBillerSupplierList;

@end

NS_ASSUME_NONNULL_END
