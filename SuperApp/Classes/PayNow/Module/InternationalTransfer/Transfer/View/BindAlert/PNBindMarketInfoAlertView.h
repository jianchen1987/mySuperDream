//
//  PNBindMarketInfoAlertView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
#import "PNBindMarketingInfoAlertConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBindMarketInfoAlertView : HDActionAlertView
/// 初始化
- (instancetype)initAlertWithConfig:(PNBindMarketingInfoAlertConfig *)config;

/// 清除文本
- (void)clearText;
@end

NS_ASSUME_NONNULL_END
