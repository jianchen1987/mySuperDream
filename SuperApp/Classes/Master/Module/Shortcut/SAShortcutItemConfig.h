//
//  SAShortcutItemConfig.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAModel.h"

typedef NSString *SAShortcutItemConfigType NS_STRING_ENUM;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT SAShortcutItemConfigType SAShortcutItemConfigTypeScan;
FOUNDATION_EXPORT SAShortcutItemConfigType SAShortcutItemConfigTypeCollection;
FOUNDATION_EXPORT SAShortcutItemConfigType SAShortcutItemConfigTypeTransfer;
FOUNDATION_EXPORT SAShortcutItemConfigType SAShortcutItemConfigTypeMap;


@interface SAShortcutItemConfig : SAModel
/// 类型
@property (nonatomic, copy) SAShortcutItemConfigType type;
/// 图标名
@property (nonatomic, copy) NSString *icon;
/// 国际化名称
@property (nonatomic, strong) SAInternationalizationModel *internationalizationModel;
/// 路由
@property (nonatomic, copy) NSString *routePath;

+ (instancetype)configWithType:(SAShortcutItemConfigType)type icon:(NSString *)icon internationalizationModel:(SAInternationalizationModel *)internationalizationModel routePath:(NSString *)routePath;
@end

NS_ASSUME_NONNULL_END
