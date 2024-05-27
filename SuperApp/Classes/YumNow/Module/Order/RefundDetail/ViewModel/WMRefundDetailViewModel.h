//
//  WMRefundDetailViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailModel.h"
#import "WMViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMRefundDetailViewModel : WMViewModel
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 详情模型
@property (nonatomic, strong, readonly) WMOrderDetailModel *detailModel;
/// 数据源
@property (nonatomic, copy, readonly) NSArray<HDTableViewSectionModel *> *dataSource;
/// 刷新标志
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;

- (void)queryOrdeDetailInfo;
@end

NS_ASSUME_NONNULL_END
