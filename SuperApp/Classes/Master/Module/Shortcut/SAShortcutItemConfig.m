//
//  SAShortcutItemConfig.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShortcutItemConfig.h"

SAShortcutItemConfigType SAShortcutItemConfigTypeScan = @"shortcutItemID.SuperApp.scan";
SAShortcutItemConfigType SAShortcutItemConfigTypeCollection = @"shortcutItemID.SuperApp.collection";
SAShortcutItemConfigType SAShortcutItemConfigTypeTransfer = @"shortcutItemID.SuperApp.transfer";
SAShortcutItemConfigType SAShortcutItemConfigTypeMap = @"shortcutItemID.SuperApp.map";


@implementation SAShortcutItemConfig
+ (instancetype)configWithType:(SAShortcutItemConfigType)type icon:(NSString *)icon internationalizationModel:(SAInternationalizationModel *)internationalizationModel routePath:(NSString *)routePath {
    SAShortcutItemConfig *item = SAShortcutItemConfig.new;
    item.type = type;
    item.icon = icon;
    item.internationalizationModel = internationalizationModel;
    item.routePath = routePath;
    return item;
}
@end
