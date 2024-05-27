//
//  SACMSPluginViewConfig.h
//  SuperApp
//
//  Created by seeu on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSDefine.h"
#import "SACMSPageViewConfig.h"
#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSPluginViewConfig : SACodingModel
///< 页面配置，透传, 不要修改
@property (nonatomic, strong) SACMSPageViewConfig *pageConfig;
///< 插件编号
@property (nonatomic, copy, readonly) NSString *pluginNo;
///< 插件类型
@property (nonatomic, copy, readonly) CMSPluginIdentify modleLable;
///< 插件名称
@property (nonatomic, copy, readonly) NSString *pluginName;
///< 插件内容
@property (nonatomic, copy, readonly) NSString *pluginContent;

- (NSDictionary *)getPluginContent;

@end

NS_ASSUME_NONNULL_END
