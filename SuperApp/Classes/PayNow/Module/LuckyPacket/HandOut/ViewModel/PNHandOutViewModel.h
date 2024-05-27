//
//  PNHandOutViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCashToolsRspModel.h"
#import "PNExchangeRateModel.h"
#import "PNHandOutModel.h"
#import "PNPacketBuildRspModel.h"
#import "PNViewModel.h"
#import "PNWalletAcountModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNHandOutViewModel : PNViewModel
/// 切换 红包类型
@property (nonatomic, assign) PNPacketType currentPacketType;

@property (nonatomic, assign) BOOL clearFlag;
///
@property (nonatomic, assign) BOOL calculationRateFlag;

/// 金额 刷新
@property (nonatomic, assign) BOOL amountFlag;

/// 控制按钮显示
@property (nonatomic, assign) BOOL ruleLimitFlag;

/// 界面刷新
@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, assign) BOOL hideKeyBoardFlag;

/// 红包ID [暂存一下]
@property (nonatomic, copy) NSString *packetId;

///
@property (nonatomic, strong) PNHandOutModel *model;

/// 兑换model
@property (nonatomic, strong) PNExchangeRateModel *exchangeRateModel;

@property (nonatomic, strong) PNWalletAcountModel *walletAccountModel;

@property (nonatomic, strong) PNPacketBuildRspModel *buildModel;

@property (nonatomic, strong) PNCashToolsRspModel *cashToolsModel;

/// 获取数据
- (void)getData;

/// 红包下单
- (void)orderBuildLuckyPacket:(void (^_Nullable)(PNPacketBuildRspModel *rspModel, PNCashToolsRspModel *cashToolsModel))completion;

/// 受理出金
- (void)cashAccept:(NSString *)tradeNo
               pwd:(NSString *)password
     methodPayment:(PNCashToolsMethodPaymentItemModel *)methodPayment
              view:(UIView *)showView
        completion:(void (^_Nullable)(NSString *tradeNo, PNTransType tradeType))completion
           failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
