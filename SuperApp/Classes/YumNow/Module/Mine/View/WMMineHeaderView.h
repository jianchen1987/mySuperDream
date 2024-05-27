//
//  WMMineHeaderView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMMineHeaderView : SAView

@property (nonatomic, copy) void (^tapEventHandler)(void);
/// 更新头像
- (void)setHeadImageWithUrl:(NSString *_Nullable)url;

/// 更新昵称
- (void)setNickName:(NSString *)nickName;
@end

NS_ASSUME_NONNULL_END
