//
//  SAMineHeaderView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAGetUserInfoRspModel;


@interface SAMineHeaderView : SAView

@property (nonatomic, copy) void (^tapEventHandler)(void);

/// 网络异常or数据没返回时，用缓存刷新页面
/// @param nickName 昵称
/// @param url 头像
/// @param balance 积分余额
- (void)updateInfoWithNickName:(NSString *)nickName headUrl:(NSString *_Nullable)url pointBalance:(NSNumber *)balance;

/// 更新信息
/// @param model 用户信息模型
- (void)updateInfoWithModel:(SAGetUserInfoRspModel *_Nullable)model;

- (void)updateSigninEntrance:(NSString *_Nullable)url;

@end

NS_ASSUME_NONNULL_END
