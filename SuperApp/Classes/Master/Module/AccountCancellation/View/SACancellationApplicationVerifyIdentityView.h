//
//  SACancellationApplicationVerifyIdentityView.h
//  SuperApp
//
//  Created by Tia on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationApplicationVerifyIdentityView : SAView
/// 下一步回调
@property (nonatomic, copy) dispatch_block_t nextBlock;
/// 取消回调
@property (nonatomic, copy) dispatch_block_t cancelBlock;

@end

NS_ASSUME_NONNULL_END
