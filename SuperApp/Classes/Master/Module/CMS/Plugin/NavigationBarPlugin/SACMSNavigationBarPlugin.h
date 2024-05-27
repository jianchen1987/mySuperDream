//
//  SACMSNavigationBarPlugin.h
//  SuperApp
//
//  Created by seeu on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSNavigationBarPluginConfig.h"
#import "SACMSPluginView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressModel;


@interface SACMSNavigationBarPlugin : SACMSPluginView
///< 配置
@property (nonatomic, strong, readonly, nullable) SACMSNavigationBarPluginConfig *navConfig;
///< 当前展示的地址
@property (nonatomic, strong, readonly, nullable) SAAddressModel *currentlyAddress;
/// 位置变化回调
@property (nonatomic, copy) void (^locationChangedHandler)(SAAddressModel *_Nullable address);

///< 绑定控制器名称
@property (nonatomic, copy, nullable) NSString *bindVCName;

@end

NS_ASSUME_NONNULL_END
