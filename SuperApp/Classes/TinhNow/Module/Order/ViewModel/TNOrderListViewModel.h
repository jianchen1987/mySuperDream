//
//  TNOrderListViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAQueryPaymentStateRspModel.h"
#import "TNEnum.h"
#import "TNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderListViewModel : TNViewModel
/// 订单状态
@property (nonatomic, copy) TNOrderState state;
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
/// 是否有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
/// 页码  用于静默刷新数据  拉取同样的数据
@property (nonatomic, assign) NSInteger pageSize;
/// 加载数据失败
@property (nonatomic, copy) void (^failedGetDataBlock)(void);
/// 获取最新的列表数据
- (void)getNewData;
/// 获取下一页列表数据
- (void)loadMoreData;

/// 确认订单
- (void)confirmOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(void))completion;
/// 查询订单支付状态
- (void)queryOrderPaymentStateWithOrderNo:(NSString *)orderNo completion:(void (^)(SAQueryPaymentStateRspModel *_Nullable rspModel))completion;
/// 再次购买
- (void)rebuymOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(NSArray *skuIds))completion;
/// 取消订单
- (void)cancelOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(void))completion;
/// 附近购买
- (void)nearBuyOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(NSString *route))completion;
/// 创建支付订单号
- (void)createOutPayOrderNoWithOrderNo:(NSString *)orderNo completion:(void (^)(NSString *outPayOrderNo))completion;
/// 查询商户信息
- (void)queryStoreDetailWithStoreNo:(NSString *)storeNo completion:(void (^)(NSString *merchantNo))completion;
@end

NS_ASSUME_NONNULL_END
