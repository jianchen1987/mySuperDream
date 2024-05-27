//
//  PNMarketingListItemModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMarketingListItemModel : PNModel
/// 推广专员手机号
@property (nonatomic, copy) NSString *promoterLoginName;
/// 好友手机号
@property (nonatomic, copy) NSString *friendLoginName;
/// 好友姓名
@property (nonatomic, copy) NSString *friendName;
/// 是否满足发放条件
@property (nonatomic, assign) BOOL satisfied;
/// 推广专员发放奖励订单号
@property (nonatomic, copy) NSString *promoterOrderNo;
/// 推广专员奖励金额(USD)
@property (nonatomic, strong) NSString *promoterReward;
/// 推广专员奖励是否已发放
@property (nonatomic, assign) BOOL promoterRewardIssue;
/// 好友发放奖励订单号
@property (nonatomic, copy) NSString *friendOrderNo;
/// 好友奖励金额(USD)
@property (nonatomic, copy) NSString *friendReward;
/// 好友奖励是否已发放
@property (nonatomic, assign) BOOL friendRewardIssue;
/// 【10 是】   【11 否】
@property (nonatomic, assign) NSInteger friendSatisfied;


/// title 的key
@property (nonatomic, copy) NSString *tradeStr;
@end

NS_ASSUME_NONNULL_END
