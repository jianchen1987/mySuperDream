//
//  SACommonRefundDetailViewModel.h
//  SuperApp
//
//  Created by Tia on 2022/5/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

@class SACommonRefundInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface SACommonRefundDetailViewModel : SAViewModel
/// 聚合订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
/// 数据源
@property (nonatomic, strong, readonly) NSArray<SACommonRefundInfoModel *> *dataSource;
/// 刷新标志
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;

- (void)queryOrdeDetailInfo;

@end

NS_ASSUME_NONNULL_END
