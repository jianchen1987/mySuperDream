//
//  SAAppAuthorizeDTO.h
//  SuperApp
//
//  Created by Tia on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppAuthorizeDTO : SAView

/// 提交app权限
/// - Parameters:
///   - authorize: 类型，值暂时只有推送， 1
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)submitWithAuthorize:(NSInteger)authorize success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
