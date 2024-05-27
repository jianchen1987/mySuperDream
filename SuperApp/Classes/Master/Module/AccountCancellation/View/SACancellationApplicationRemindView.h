//
//  SACancellationApplicationRemindView.h
//  SuperApp
//
//  Created by Tia on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationApplicationRemindView : SAView
/// 下一步回调
@property (nonatomic, copy) dispatch_block_t nextBlock;

@end

NS_ASSUME_NONNULL_END
