//
//  SASetPhoneViewController.h
//  SuperApp
//
//  Created by Tia on 2023/6/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASetPhoneViewController : SAViewController
/// 绑定手机成功后的回调
@property (nonatomic, copy) dispatch_block_t bindSuccessBlock;
/// 取消绑定
@property (nonatomic, copy) dispatch_block_t cancelBindBlock;
/// 需要展示的文言
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
