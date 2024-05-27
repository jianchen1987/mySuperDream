//
//  SACMSTItleViewConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSTitleViewConfig.h"
#import <HDKitCore/HDKitCore.h>


@interface SACMSTitleViewConfig ()

@property (nonatomic, copy) NSString *icon;                   ///< 图标
@property (nonatomic, copy) NSString *titleColor;             ///< 标题颜色
@property (nonatomic, assign) NSUInteger titleFont;           ///< 标题字号
@property (nonatomic, copy) NSString *titleLink;              ///< 标题跳转链接
@property (nonatomic, copy) NSString *subTitleColor;          ///< 副标题颜色
@property (nonatomic, assign) NSUInteger subTitleFont;        ///< 副标题字号
@property (nonatomic, copy) CMSTitleViewStyle style;          ///< 样式
@property (nonatomic, strong) NSDictionary *theme;            ///< 主题
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; ///< 内边距

@end


@implementation SACMSTitleViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#343b4d";
        self.titleFont = 17;
        self.subTitleColor = @"#5d667f";
        self.subTitleFont = 15;
        self.style = CMSTitleViewStyleValue1;
    }
    return self;
}

- (NSString *)getIcon {
    NSString *icon = [self.theme objectForKey:@"icon"];
    if (HDIsStringEmpty(icon)) {
        return self.icon;
    } else {
        return icon;
    }
}

- (CMSTitleViewStyle)getStyle {
    CMSTitleViewStyle style = [self.theme objectForKey:@"style"];
    if (HDIsStringEmpty(style)) {
        return self.style;
    } else {
        return style;
    }
}

- (NSString *)getTitle {
    NSString *title = [self.theme objectForKey:@"title"];
    if (HDIsStringEmpty(title)) {
        return self.title;
    } else {
        return title;
    }
}

- (UIColor *)getTitleColor {
    NSString *hex = [self.theme objectForKey:@"titleColor"];
    if (HDIsStringEmpty(hex)) {
        return [UIColor hd_colorWithHexString:self.titleColor];
    } else {
        return [UIColor hd_colorWithHexString:hex];
    }
}

- (UIFont *)getTitleFont {
    NSNumber *font = [self.theme objectForKey:@"titleFont"];
    if (HDIsObjectNil(font)) {
        return [UIFont systemFontOfSize:self.titleFont weight:UIFontWeightBold];
    } else {
        return [UIFont systemFontOfSize:font.integerValue weight:UIFontWeightBold];
    }
}

- (NSString *)getTitleLink {
    NSString *titleLink = [self.theme objectForKey:@"titleLink"];
    if (HDIsStringEmpty(titleLink)) {
        return self.titleLink;
    } else {
        return titleLink;
    }
}

- (NSString *)getSubTitle {
    NSString *subTitle = [self.theme objectForKey:@"subTitle"];
    if (HDIsStringEmpty(subTitle)) {
        return self.subTitle;
    } else {
        return subTitle;
    }
}

- (UIColor *)getSubTitleColor {
    NSString *hex = [self.theme objectForKey:@"subTitleColor"];
    if (HDIsStringEmpty(hex)) {
        return [UIColor hd_colorWithHexString:self.subTitleColor];
    } else {
        return [UIColor hd_colorWithHexString:hex];
    }
}

- (UIFont *)getSubTitleFont {
    NSNumber *font = [self.theme objectForKey:@"subTitleFont"];
    if (HDIsObjectNil(font)) {
        return [UIFont systemFontOfSize:self.subTitleFont];
    } else {
        return [UIFont systemFontOfSize:font.integerValue];
    }
}

- (NSString *)getSubTitleLink {
    NSString *subTitleLink = [self.theme objectForKey:@"subTitleLink"];
    if (HDIsStringEmpty(subTitleLink)) {
        return self.subTitleLink;
    } else {
        return subTitleLink;
    }
}

- (UIEdgeInsets)getContentEdgeInsets {
    NSDictionary *edgeInsets = [self.theme objectForKey:@"contentEdgeInsets"];
    if (edgeInsets && edgeInsets.count) {
        return UIEdgeInsetsMake([edgeInsets[@"top"] doubleValue], [edgeInsets[@"left"] doubleValue], [edgeInsets[@"bottom"] doubleValue], [edgeInsets[@"right"] doubleValue]);
    } else {
        if (HDIsStringEmpty(self.getIcon)) {
            return UIEdgeInsetsMake(8, 15, 8, 15);
        } else {
            return UIEdgeInsetsMake(8, 0, 8, 0);
        }
    }
}

- (void)setTitleColor:(NSString *)titleColor {
    if (HDIsStringEmpty(titleColor)) {
        _titleColor = @"#343b4d";
    } else {
        _titleColor = titleColor;
    }
}

- (void)setTitleFont:(NSUInteger)titleFont {
    if (titleFont <= 0) {
        _titleFont = 17;
    } else {
        _titleFont = titleFont;
    }
}

- (void)setSubTitleColor:(NSString *)subTitleColor {
    if (HDIsStringEmpty(subTitleColor)) {
        _subTitleColor = @"5d667f";
    } else {
        _subTitleColor = subTitleColor;
    }
}

- (void)setSubTitleFont:(NSUInteger)subTitleFont {
    if (subTitleFont <= 0) {
        _subTitleFont = 15;
    } else {
        _subTitleFont = subTitleFont;
    }
}

@end
