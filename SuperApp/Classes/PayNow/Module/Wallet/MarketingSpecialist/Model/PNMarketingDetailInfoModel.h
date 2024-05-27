//
//  PNMarketingDetailInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMarketingDetailInfoModel : PNModel
/// 推广专员手机号
@property (nonatomic, copy) NSString *promoterLoginName;
/// 推广专员姓名
@property (nonatomic, copy) NSString *promoterName;
/// 推广专员状态 10生效 11失效
@property (nonatomic, assign) NSInteger promoterStatus;
/// 绑定好友数（个）
@property (nonatomic, assign) NSInteger bindNum;
/// 应发放奖励金额（$）
@property (nonatomic, strong) SAMoneyModel *totalReward;
@end

NS_ASSUME_NONNULL_END
