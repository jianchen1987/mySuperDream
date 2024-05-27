//
//  PNAlertInputView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAlertInputViewConfig.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNAlertInputView : HDActionAlertView
/// 初始化
- (instancetype)initAlertWithConfig:(PNAlertInputViewConfig *)config;

/// 清除文本
- (void)clearText;
@end

NS_ASSUME_NONNULL_END
