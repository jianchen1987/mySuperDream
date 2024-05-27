//
//  SASetPhoneByVerificationCodeViewController.h
//  SuperApp
//
//  Created by Tia on 2023/6/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASetPhoneByVerificationCodeViewController : SAViewController
/// 国家代码（855、86）
@property (nonatomic, copy) NSString *countryCode;
/// 账号（手机号）
@property (nonatomic, copy) NSString *accountNo;
/// 绑定手机成功后的回调
@property (nonatomic, copy) dispatch_block_t bindSuccessBlock;

@end

NS_ASSUME_NONNULL_END
