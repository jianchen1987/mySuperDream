//
//  SAAppPayResultViewController.h
//  SuperApp
//
//  Created by seeu on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAQueryPaymentStateRspModel.h"
#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppPayResultViewController : SAViewController

@property (nonatomic, copy) NSString *payOrderNo; ///< 支付订单号

/// 点击完成按钮
@property (nonatomic, copy) void (^clickedCompleteHandler)(SAQueryPaymentStateRspModel *_Nullable);

/// 点击完成按钮
@property (nonatomic, copy) void (^clickedBackToMerchantHandler)(SAQueryPaymentStateRspModel *_Nullable);

@end

NS_ASSUME_NONNULL_END
