//
//  TNOrderDetailsViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import "TNViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNQueryOrderDetailsRspModel;
@class TNQueryExchangeOrderExplainRspModel;


@interface TNOrderDetailsViewModel : TNViewModel

/// 刷新标识
@property (nonatomic, assign) BOOL refreshFlag;
/// 订单详情模型
@property (nonatomic, strong) TNQueryOrderDetailsRspModel *orderDetails;
/// 数据
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 状态 在哪个section
@property (nonatomic, strong) NSIndexPath *statusIndexPath;
/// 网络加载失败
@property (nonatomic, copy) void (^networkFailBlock)(void);
/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;

/// 获取订单详情
/// @param orderNo 中台订单号
- (void)getNewDataWithOrderNo:(NSString *)orderNo;

- (void)cancalOrderWithOrderNo:(NSString *)orderNo completed:(void (^)(void))completed;
- (void)confirmOrderWithOrderNo:(NSString *)orderNo completed:(void (^)(void))completed;
- (void)queryExchangeOrderExplainSuccess:(void (^_Nullable)(TNQueryExchangeOrderExplainRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
- (void)rebuyOrderWithOrderNo:(NSString *)orderNo completed:(void (^)(NSArray *skuIds))completed;

- (void)changeOrderAddressWithOrderNo:(NSString *)orderNo addressNo:(NSString *)addressNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

// 判断是否可以修改地址
- (BOOL)canEdit:(TNOrderState)orderStatus;

- (void)cancelApplyRefundWithOrderNo:(NSString *)orderNo completed:(void (^)(void))completed;

/// 检查所选地址是否在目标区域内
/// @param latitude 纬度
/// @param longitude 经度
- (void)checkAdressIsOnTargetAreaWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude completed:(void (^)(void))completed;
@end

NS_ASSUME_NONNULL_END
