//
//  PNCheckMarketingRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCheckMarketingRspModel : PNModel
/// 是否已绑定推广专员
@property (nonatomic, assign) BOOL isBinded;
/// 首单国际转账的资格(为true代表还没进行过国际转账 需要强制弹窗绑定推广专员)
@property (nonatomic, assign) BOOL isFirstFxtTrade;
/// 是否已绑定推广专员
@property (nonatomic, assign) BOOL isPromoter;
/// 推广专员手机号
@property (nonatomic, copy) NSString *promoterLoginName;
/// 推广专员--姓
@property (nonatomic, copy) NSString *promoterSurName;
/// 推广专员--名
@property (nonatomic, copy) NSString *promoterName;
/// 是否需要弹窗
@property (nonatomic, assign) BOOL needPop;
@end

NS_ASSUME_NONNULL_END
