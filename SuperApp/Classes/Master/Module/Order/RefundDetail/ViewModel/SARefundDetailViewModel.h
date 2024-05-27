//
//  SARefundDetailViewModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderRefundInfoModel.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SARefundDetailViewModel : SAViewModel

/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 退款信息模型
@property (nonatomic, strong, readonly) SAOrderRefundInfoModel *orderRefundInfoModel;
/// 数据源
@property (nonatomic, copy, readonly) NSArray<HDTableViewSectionModel *> *dataSource;
/// 刷新标志
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;

- (void)queryOrdeDetailInfo;

@end

NS_ASSUME_NONNULL_END
