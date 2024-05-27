//
//  GNRefundViewModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNViewModel.h"
#import "GNOrderDTO.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNRefundViewModel : GNViewModel
///聚合订单编号
@property (nonatomic, copy, nonnull) NSString *orderNo;
///订单编号
@property (nonatomic, copy, nonnull) NSString *buinessNo;
///请求接口状态
@property (nonatomic, assign) GNRequestType refreshType;
/// rspModel
@property (nonatomic, strong, nullable) GNRefundModel *rspModel;
///数据源
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *dataSource;
///取消原因
@property (nonatomic, strong, nullable) NSString *cancelState;
///取消时间
@property (nonatomic, assign) NSTimeInterval cancelTime;
///电话
@property (nonatomic, strong, nonnull) NSString *businessPhone;
/// DTO
@property (nonatomic, strong) GNOrderDTO *refundDetailDTO;

///聚合退款详情
- (void)queryOrderDetailInfo;
///团购订单详情
- (void)getOrderDetailCompletion:(void (^)(BOOL error))completion;
@end

NS_ASSUME_NONNULL_END
