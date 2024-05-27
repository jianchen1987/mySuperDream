//
//  SACMSPageViewConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSPageViewConfig.h"
#import "SACMSCardViewConfig.h"
#import "SACMSPluginViewConfig.h"
#import <HDKitCore/HDKitCore.h>


@interface SACMSPageViewConfig ()

@property (nonatomic, copy) NSString *pageNo;                 ///< 页面编号
@property (nonatomic, copy) NSString *contentPageNo;                 ///< 内容页面编号
@property (nonatomic, copy) NSString *pageName;               ///< 页面名称
@property (nonatomic, copy) NSString *businessLine;           ///< 业务线
@property (nonatomic, copy) NSString *backgroundColor;        ///<
@property (nonatomic, copy) NSString *backgroundImage;        ///<
@property (nonatomic, strong) NSDictionary *theme;            ///< 主题
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; ///< 内边距

@end


@implementation SACMSPageViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //        self.backgroundColor = @"#FFFFFF";
        self.backgroundImage = nil;
    }

    return self;
}

#pragma mark - YYModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"backgroundColor": @"pageColor",
        @"backgroundImage": @"pageBackgroundPic",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cards": SACMSCardViewConfig.class, @"plugins": SACMSPluginViewConfig.class};
}

#pragma mark - getter
- (UIColor *)getBackgroundColor {
    NSString *hex = [self.theme objectForKey:@"backgroundColor"];
    if (HDIsStringEmpty(hex)) {
        return [UIColor hd_colorWithHexString:HDIsStringNotEmpty(self.backgroundColor) ? self.backgroundColor : @"#FFFFFF"];
    } else {
        return [UIColor hd_colorWithHexString:hex];
    }
}

- (NSString *)getBackgroundImage {
    NSString *imageUrl = [self.theme objectForKey:@"backgroundImage"];
    if (HDIsStringEmpty(imageUrl)) {
        return self.backgroundImage;
    } else {
        return imageUrl;
    }
}

- (UIEdgeInsets)getContentEdgeInsets {
    NSDictionary *edgeInsets = [self.theme objectForKey:@"contentEdgeInsets"];
    if (edgeInsets && edgeInsets.count) {
        return UIEdgeInsetsMake([edgeInsets[@"top"] doubleValue], [edgeInsets[@"left"] doubleValue], [edgeInsets[@"bottom"] doubleValue], [edgeInsets[@"right"] doubleValue]);
    } else {
        return self.contentEdgeInsets;
    }
}

- (NSDictionary *)getPageTemplateContent {
    if (HDIsStringEmpty(_pageTemplate)) {
        return [NSDictionary dictionary];
    }
    return [NSJSONSerialization JSONObjectWithData:[_pageTemplate dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:SACMSPageViewConfig.class]) {
        return NO;
    }

    SACMSPageViewConfig *obj = (SACMSPageViewConfig *)object;

    if (![self.contentPageNo isEqualToString:obj.contentPageNo]) {
        HDLog(@"内容页编号改变啦");
        return NO;
    }

    if (![self.pageName isEqualToString:obj.pageName]) {
        HDLog(@"页面名称改变啦");
        return NO;
    }

    if (HDIsStringNotEmpty(self.backgroundColor) && HDIsStringEmpty(obj.backgroundColor)) {
        HDLog(@"背景颜色改变啦");
        return NO;
    }

    if (HDIsStringEmpty(self.backgroundColor) && HDIsStringNotEmpty(obj.backgroundColor)) {
        HDLog(@"背景颜色改变啦");
        return NO;
    }

    if (HDIsStringNotEmpty(self.backgroundColor) && HDIsStringNotEmpty(obj.backgroundColor) && ![self.backgroundColor isEqualToString:obj.backgroundColor]) {
        HDLog(@"背景颜色改变啦");
        return NO;
    }

    if (HDIsStringNotEmpty(self.backgroundImage) && HDIsStringEmpty(obj.backgroundImage)) {
        HDLog(@"背景图片改变啦");
        return NO;
    }

    if (HDIsStringEmpty(self.backgroundImage) && HDIsStringNotEmpty(obj.backgroundImage)) {
        HDLog(@"背景图片改变啦");
        return NO;
    }

    if (HDIsStringNotEmpty(self.backgroundImage) && HDIsStringNotEmpty(obj.backgroundImage) && ![self.backgroundImage isEqualToString:obj.backgroundImage]) {
        HDLog(@"背景图片改变啦");
        return NO;
    }

    if (self.pageTemplateType != obj.pageTemplateType) {
        HDLog(@"模板类型改变啦");
        return NO;
    }

    if (![self.pageTemplate isEqualToString:obj.pageTemplate]) {
        HDLog(@"模板内容改变啦");
        return NO;
    }

    if (self.cards.count != obj.cards.count) {
        return NO;
    }
    __block BOOL isEqual = YES;
    // 遍历两个对象的卡片数组是否一致
    [self.cards enumerateObjectsUsingBlock:^(SACMSCardViewConfig *_Nonnull config, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray<SACMSCardViewConfig *> *bingo = [obj.cards hd_filterWithBlock:^BOOL(SACMSCardViewConfig *_Nonnull item) {
            return [item isEqual:config];
        }];
        // 有不同项，停止
        if (!bingo.count) {
            *stop = YES;
            isEqual = NO;
        }
    }];

    if (!isEqual) {
        HDLog(@"卡片改变啦");
        return NO;
    }

    if (self.plugins.count != obj.plugins.count) {
        return NO;
    }

    isEqual = YES;
    [self.plugins enumerateObjectsUsingBlock:^(SACMSPluginViewConfig *_Nonnull config, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray<SACMSPluginViewConfig *> *bingo = [obj.plugins hd_filterWithBlock:^BOOL(SACMSPluginViewConfig *_Nonnull item) {
            return [item isEqual:config];
        }];
        if (!bingo.count) {
            *stop = YES;
            isEqual = NO;
        }
    }];

    if (!isEqual) {
        HDLog(@"插件改变啦");
        return NO;
    }

    return YES;
}

@end
