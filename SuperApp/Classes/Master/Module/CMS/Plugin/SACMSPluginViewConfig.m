//
//  SACMSPluginViewConfig.m
//  SuperApp
//
//  Created by seeu on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSPluginViewConfig.h"


@interface SACMSPluginViewConfig ()

///< 插件编号
@property (nonatomic, copy) NSString *pluginNo;
///< 插件类型
@property (nonatomic, copy) CMSPluginIdentify modleLable;
///< 插件名称
@property (nonatomic, copy) NSString *pluginName;
///< 插件内容
@property (nonatomic, copy) NSString *pluginContent;

@end


@implementation SACMSPluginViewConfig

- (NSDictionary *)getPluginContent {
    if (HDIsStringEmpty(self.pluginContent)) {
        return [NSDictionary dictionary];
    }
    NSData *data = [self.pluginContent dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:SACMSPluginViewConfig.class]) {
        HDLog(@"插件类型不一致");
        return NO;
    }

    SACMSPluginViewConfig *config = (SACMSPluginViewConfig *)object;

    if (![self.modleLable isEqualToString:config.modleLable]) {
        //        HDLog(@"插件类型不一致");
        return NO;
    }

    if (![self.pluginNo isEqualToString:config.pluginNo]) {
        //        HDLog(@"插件编号不一致");
        return NO;
    }

    if (![self.pluginName isEqualToString:config.pluginName]) {
        HDLog(@"插件名称不一致");
        return NO;
    }

    if (![self.pluginContent isEqualToString:config.pluginContent]) {
        HDLog(@"插件内容不一致");
        return NO;
    }

    return YES;
}

@end
