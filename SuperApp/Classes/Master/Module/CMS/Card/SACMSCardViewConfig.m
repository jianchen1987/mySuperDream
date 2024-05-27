//
//  SACMSCardViewConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSCardViewConfig.h"
#import "SACMSTitleViewConfig.h"
#import <HDKitCore/HDKitCore.h>


@interface SACMSCardViewConfig ()

@property (nonatomic, copy) CMSCardIdentify identify;  ///< 卡片标识
@property (nonatomic, copy) NSString *cardNo;          ///< 编号
@property (nonatomic, copy) NSString *cardName;        ///< 名称
@property (nonatomic, copy) NSString *backgroundImage; ///< 背景图
@property (nonatomic, copy) NSString *backgroundColor; ///< 背景色
@property (nonatomic, strong) NSDictionary *theme;     ///< 主题
@property (nonatomic, assign) NSInteger location;      ///< 位置
@property (nonatomic, copy) NSString *cardContent;

@end


@implementation SACMSCardViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        self.backgroundColor = @"#00FFFFFF";
        self.backgroundImage = nil;
    }
    return self;
}

#pragma mark - YYModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"identify": @"cardModelLabel",
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"nodes": SACMSNode.class,
    };
}

#pragma mark - getter
- (NSArray<NSDictionary *> *)getAllNodeContents {
    NSArray *nodesContent = [self.nodes mapObjectsUsingBlock:^id _Nonnull(SACMSNode *_Nonnull obj, NSUInteger idx) {
        return [obj getNodeContent];
    }];
    return nodesContent;
}

- (NSDictionary *)getCardContent {
    if (HDIsStringEmpty(_cardContent)) {
        return [NSDictionary dictionary];
    }
    NSData *data = [_cardContent dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (UIColor *)getBackgroundColor {
    NSString *hex = [self.theme objectForKey:@"backgroundColor"];
    if (HDIsStringEmpty(hex)) {
        return [UIColor hd_colorWithHexString:self.backgroundColor];
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

- (void)setCardContent:(NSString *)cardContent {
    _cardContent = cardContent;

    NSDictionary *edgeInsets = [[self getCardContent] objectForKey:@"edgeInesets"];
    if (edgeInsets && edgeInsets.count) {
        self.contentEdgeInsets = UIEdgeInsetsMake([edgeInsets[@"top"] doubleValue], [edgeInsets[@"left"] doubleValue], [edgeInsets[@"bottom"] doubleValue], [edgeInsets[@"right"] doubleValue]);
    }

    SACMSTitleViewConfig *titleConfig = [SACMSTitleViewConfig yy_modelWithJSON:[self getCardContent]];
    if (HDIsStringNotEmpty(titleConfig.getTitle) || HDIsStringNotEmpty(titleConfig.getSubTitle) || HDIsStringNotEmpty(titleConfig.getIcon)) {
        self.titleConfig = titleConfig;
    }

    NSString *backgroundColor = [[self getCardContent] objectForKey:@"backgroundColor"];
    if (HDIsStringNotEmpty(backgroundColor)) {
        self.backgroundColor = backgroundColor;
    }

    NSString *backgroundImage = [[self getCardContent] objectForKey:@"backgroundImage"];
    if (HDIsStringNotEmpty(backgroundImage)) {
        self.backgroundImage = backgroundImage;
    }
}

#pragma mark - OverWrite
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:SACMSCardViewConfig.class]) {
        return NO;
    }

    SACMSCardViewConfig *config = (SACMSCardViewConfig *)object;
    if (![self.identify isEqualToString:config.identify]) {
        //        HDLog(@"卡片模板不同");
        return NO;
    }

    if (![self.cardNo isEqualToString:config.cardNo]) {
        //        HDLog(@"卡片编号不同");
        return NO;
    }

    if (![self.cardName isEqualToString:config.cardName]) {
        HDLog(@"卡片名称不同");
        return NO;
    }

    if (self.location != config.location) {
        HDLog(@"卡片位置不同");
        return NO;
    }

    if (![self.cardContent isEqualToString:config.cardContent]) {
        HDLog(@"卡片内容不一样");
        return NO;
    }

    if (![self.backgroundColor isEqualToString:config.backgroundColor]) {
        HDLog(@"卡片背景颜色不一样");
        return NO;
    }

    if (HDIsStringNotEmpty(self.backgroundImage) && HDIsStringEmpty(config.backgroundImage)) {
        HDLog(@"卡片背景图片不一样");
        return NO;
    }

    if (HDIsStringEmpty(self.backgroundImage) && HDIsStringNotEmpty(config.backgroundImage)) {
        HDLog(@"卡片背景图片不一样");
        return NO;
    }

    if (HDIsStringNotEmpty(self.backgroundImage) && HDIsStringNotEmpty(config.backgroundImage) && ![self.backgroundImage isEqualToString:config.backgroundImage]) {
        HDLog(@"卡片背景图片不一样");
        return NO;
    }

    if (self.nodes.count != config.nodes.count) {
        HDLog(@"卡片节点数不一致");
        return NO;
    }

    __block BOOL isEqual = YES;
    [self.nodes enumerateObjectsUsingBlock:^(SACMSNode *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray<SACMSNode *> *bingo = [config.nodes hd_filterWithBlock:^BOOL(SACMSNode *_Nonnull item) {
            return [item isEqual:obj];
        }];

        if (!bingo.count) {
            *stop = YES;
            isEqual = NO;
        }
    }];
    if (!isEqual) {
        HDLog(@"节点不一致");
        return NO;
    }

    return YES;
}

#pragma mark - setter
- (void)setBackgroundColor:(NSString *)backgroundColor {
    if (HDIsStringEmpty(backgroundColor)) {
        _backgroundColor = @"#00FFFFFF";
    } else {
        _backgroundColor = backgroundColor;
    }
}

#pragma mark - lazy load
- (SACMSTitleViewConfig *)titleConfig {
    if (!_titleConfig) {
        _titleConfig = SACMSTitleViewConfig.new;
    }
    return _titleConfig;
}

- (NSArray<SACMSNode *> *)nodes {
    if (!_nodes) {
        _nodes = [NSArray array];
    }
    return _nodes;
}

@end
