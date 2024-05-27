//
//  SASetPhoneBindViewController.h
//  SuperApp
//
//  Created by Tia on 2023/6/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASetPhoneBindViewController : SAViewController
/// 绑定手机成功后的回调
@property (nonatomic, copy) dispatch_block_t bindSuccessBlock;

@end

NS_ASSUME_NONNULL_END
