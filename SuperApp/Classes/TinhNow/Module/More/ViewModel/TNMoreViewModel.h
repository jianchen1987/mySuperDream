//
//  TNMoreViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMoreViewModel : TNViewModel

/// 头像地址
@property (nonatomic, copy) NSString *headUrlStr;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 分销客
//@property (nonatomic, assign) BOOL isDistributor;
/// 是否是卖家
@property (nonatomic, assign) BOOL isSeller;
/// 刷新电商用户信息
- (void)getTinhNowUserInfo;
//- (void)getUser
@end

NS_ASSUME_NONNULL_END
