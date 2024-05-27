//
//  GNOrderViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCouponDetailModel.h"
#import "GNOrderPagingRspModel.h"
#import "GNOrderTableViewCell.h"
#import "GNRefundModel.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderViewModel : GNViewModel
///订单列表
@property (nonatomic, strong) NSMutableArray<GNOrderCellModel *> *dataSource;
///需要倒计时的订单
@property (nonatomic, strong) NSMutableArray<GNOrderCellModel *> *countDownList;
///详情detail模型
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *detailSource;
///退款cell模型
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *refundSource;
///订单详情model
@property (nonatomic, strong, nullable) GNOrderCellModel *detailModel;
///是否还有下一页
@property (nonatomic, assign) BOOL hasNextPage;
///倒计时数组
@property (nonatomic, strong) NSMutableArray *totalLastTime;
///优惠券信息
@property (nonatomic, copy, nullable) NSArray<GNCouponDetailModel *> *couponDataSource;

/// 订单列表
/// @param pageNum 页码
/// @param bizState 订单状态
- (void)getOrderListMore:(NSInteger)pageNum bizState:(nullable NSString *)bizState completion:(nullable void (^)(GNOrderPagingRspModel *rspModel))completion;

/// 订单详情
/// @param orderNo 订单号
- (void)getOrderDetailOrderNo:(nonnull NSString *)orderNo completion:(void (^)(BOOL error))completion;

/// 获取订单核销信息
/// @param orderNo 订单号
- (void)orderVerificationStateOrderNo:(nonnull NSString *)orderNo completion:(void (^)(GNMessageCode *rspModel))completion;

/// 获取订单优惠券信息
/// @param orderNo 订单号
- (void)orderCouponWithOrderNo:(nonnull NSString *)orderNo;

@end

NS_ASSUME_NONNULL_END
