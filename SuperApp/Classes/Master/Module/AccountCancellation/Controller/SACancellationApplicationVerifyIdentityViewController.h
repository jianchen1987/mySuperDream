//
//  SACancellationApplicationVerifyIdentityViewController.h
//  SuperApp
//
//  Created by Tia on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationReasonModel.h"
#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationApplicationVerifyIdentityViewController : SAViewController
/// 注销原因模型数据
@property (nonatomic, strong) SACancellationReasonModel *reasonModel;

@end

NS_ASSUME_NONNULL_END
