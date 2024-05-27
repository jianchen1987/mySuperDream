//
//  SALotteryAlertView.h
//  SuperApp
//
//  Created by seeu on 2021/8/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SALotteryAlertViewConfig : NSObject
@property (nonatomic, assign) NSUInteger count;        ///< 次数
@property (nonatomic, copy) NSString *lotteryThemeUrl; ///< 弹窗图片
@property (nonatomic, copy) NSString *url;             ///< 跳转地址
@end


@interface SALotteryAlertView : HDActionAlertView

+ (instancetype)alertViewWithConfig:(SALotteryAlertViewConfig *__nullable)config;

@property (nonatomic, strong) SALotteryAlertViewConfig *config; ///< 配置

@end

NS_ASSUME_NONNULL_END
