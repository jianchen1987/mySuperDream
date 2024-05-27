//
//  GNCancelViewModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderCancelRspModel.h"
#import "GNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNCancelViewModel : GNViewModel
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 数据源
@property (nonatomic, strong, nullable) NSMutableArray *dataSource;
/// 取消数据源
@property (nonatomic, strong) NSArray<GNOrderCancelRspModel *> *cancelDataSource;
/// 取消原因
@property (nonatomic, strong) GNCellModel *reasonModel;
/// 请求接口状态
@property (nonatomic, assign) GNRequestType refreshType;
/// 刷新按钮状态
@property (nonatomic, assign) BOOL changeBTNState;
///请求取消原因列表
- (void)getCancelList;
///取消请求
- (void)orderCanceledWithState:(nonnull NSString *)cancelState remark:(nullable NSString *)remark completion:(void (^)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
