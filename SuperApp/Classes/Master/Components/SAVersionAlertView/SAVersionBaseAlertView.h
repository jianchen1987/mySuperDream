//
//  SAVersionBaseAlertView.h
//  SuperApp
//
//  Created by Chaos on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SAVersionAlertViewConfig;


@interface SAVersionBaseAlertView : HDActionAlertView

+ (instancetype)alertViewWithConfig:(SAVersionAlertViewConfig *__nullable)config;

@property (nonatomic, strong) SAVersionAlertViewConfig *config; ///< 配置

@end

NS_ASSUME_NONNULL_END
