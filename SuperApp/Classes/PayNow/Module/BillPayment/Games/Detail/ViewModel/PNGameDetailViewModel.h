//
//  PNGameDetailViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBalanceAndExchangeModel.h"
#import "PNGameRspModel.h"
#import "PNGameSubmitOrderResponseModel.h"
#import "PNViewModel.h"
#import "SAQueryOrderInfoRspModel.h"
NS_ASSUME_NONNULL_BEGIN
@class PNGameItemModel;


@interface PNGameDetailViewModel : PNViewModel
/// 娱乐分类id
@property (nonatomic, copy) NSString *categoryId;
/// 数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataArr;
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 按钮是否可点击
@property (nonatomic, assign) BOOL btnEnable;
/// 钱包余额模型
@property (strong, nonatomic) PNBalanceAndExchangeModel *balanceModel;
///获取最新数据
- (void)getNewData;
///更新选中的item
- (void)updateSelectedItem:(PNGameItemModel *)item;
///查询用户钱包余额
- (void)queryBalanceAndExchangeCompletion:(void (^)(PNBalanceAndExchangeModel *_Nullable balanceModel))completion;
///下订单 isWalletType是否是钱包下单
- (void)createGameOrderByType:(BOOL)isWalletType completion:(void (^)(PNGameSubmitOrderResponseModel *_Nullable responseModel))completion;
///查询中台订单信息
- (void)queryOrderInfoWithAggregationOrderNo:(NSString *_Nonnull)aggregationOrderNo completion:(void (^)(SAQueryOrderInfoRspModel *_Nullable rspModel))completion;
@end

NS_ASSUME_NONNULL_END
