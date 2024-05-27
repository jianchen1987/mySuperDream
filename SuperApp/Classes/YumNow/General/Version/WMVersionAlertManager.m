//
//  WMVersionAlertManager.m
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMVersionAlertManager.h"
#import "SACacheManager.h"


@implementation WMVersionAlertManager
+ (BOOL)versionShouldAlert:(SAVersionAlertViewConfig *)config {
    if (config.ignoreCache) {
        return YES;
    }
    NSArray<NSString *> *showHistory = [SACacheManager.shared objectForKey:kCacheKeyYumUserIgnoredAppVersion type:SACacheTypeDocumentPublic relyLanguage:NO];
    if (showHistory && [showHistory isKindOfClass:NSArray.class]) {
        NSString *total = [showHistory componentsJoinedByString:@"|"];
        NSString *key = [NSString stringWithFormat:@"%@_%@_%@_%@_%@", config.versionId, config.updateVersion, config.updateInfo, config.updateModel, config.packageLink];
        if ([total rangeOfString:key].location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}
@end
