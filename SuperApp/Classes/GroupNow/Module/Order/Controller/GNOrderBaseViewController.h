//
//  GNOrderBaseViewController.h
//  SuperApp
//
//  Created by wmz on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNEnum.h"
#import "GNViewController.h"
#import "SAPaymentDTO.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderBaseViewController : GNViewController
/// 聚合单号
@property (nonatomic, strong) NSString *aggregateOrderNo;
/// 定时器
@property (nonatomic, strong, nullable) NSTimer *timer;
/// 收银台定时器
@property (nonatomic, strong, nullable) NSTimer *bankStartTimer;
/// 来源
@property (nonatomic, assign) GNOrderFromType type;
/// 移除需要消失的控制器
- (void)removeViewController:(BOOL)removeSelf;
- (void)removeViewController:(BOOL)removeSelf withoutVCNameArr:(nullable NSArray<NSString *> *)limitArr;
/// 开启定时器
- (void)startTimer;
/// 关闭定时器
- (void)cancelTimer;
/// 定时器方法
- (void)refreshAction;
/// 刷新
- (void)updateUI;
///刷新支付状态
- (void)getPaymentStateSuccess:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
