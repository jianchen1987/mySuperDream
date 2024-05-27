//
//  TNAdressChangeTipsAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNAdressChangeTipsAlertConfig.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNAdressChangeTipsAlertView : HDActionAlertView

/// 初始化
/// @param config 配置模型
+ (instancetype)alertViewWithConfig:(TNAdressChangeTipsAlertConfig *)config;

/// 点击选择地址回调
@property (nonatomic, copy) void (^chooseAdressClickCallBack)(void);

/// 点击专题回调
@property (nonatomic, copy) void (^activityClickCallBack)(NSString *activityId);
@end

NS_ASSUME_NONNULL_END
