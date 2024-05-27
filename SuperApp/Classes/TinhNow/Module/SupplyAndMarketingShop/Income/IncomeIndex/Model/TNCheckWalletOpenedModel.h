//
//  TNCheckWalletOpenedModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCheckWalletOpenedModel : TNModel
///账户等级 accountLevel 返回 null 或者 PRIMARY 时，就是未实名。
@property (nonatomic, copy) NSString *accountLevel;
///是否开通钱包
@property (nonatomic, assign) BOOL walletCreated;
/// 是否实名认证了  accountLevel = 2 || 3 为ture
@property (nonatomic, assign) BOOL isVerifiedRealName;
@end

NS_ASSUME_NONNULL_END
