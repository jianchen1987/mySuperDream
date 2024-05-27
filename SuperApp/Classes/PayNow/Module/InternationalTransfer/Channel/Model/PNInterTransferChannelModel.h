//
//  PNInterTransferChannelModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRateModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferChannelModel : PNModel
/// log路径
@property (nonatomic, copy) NSString *logoPath;

/// 渠道
@property (nonatomic, assign) PNInterTransferThunesChannel channel;

/* 1000 入金
2000 转账
3000 国际转账
4000 账单缴费
5000 CoolCash网点
6000 商户服务
 */
@property (nonatomic, assign) NSInteger bizType;

/// 10-开启 11-关闭 ,12 -试运行
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) PNInterTransferRateModel *rateModel;
@end

NS_ASSUME_NONNULL_END
