//
//  TNMarkupPriceSettingAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMarkupPriceSettingConfig.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNMarkupPriceSettingAlertView : HDActionAlertView
- (instancetype)initAlertViewWithConfig:(TNMarkupPriceSettingConfig *)config;
/// 设置价格策略后 回调
@property (nonatomic, copy) void (^setPricePolicyCompleteCallBack)(void);
@end

NS_ASSUME_NONNULL_END
