//
//  SACancellationApplicationView.h
//  SuperApp
//
//  Created by Tia on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationReasonModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationApplicationView : SAView
/// 下一步回调
@property (nonatomic, copy) void (^nextBlock)(SACancellationReasonModel *model);

@end

NS_ASSUME_NONNULL_END
