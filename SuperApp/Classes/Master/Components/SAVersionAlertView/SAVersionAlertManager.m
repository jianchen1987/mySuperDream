//
//  SAVersionAlertManager.m
//  SuperApp
//
//  Created by Chaos on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAVersionAlertManager.h"
#import "SABetaVersionAlertView.h"
#import "SACacheManager.h"
#import "SANewVersionAlertView.h"


@implementation SAVersionAlertManager

+ (SAVersionBaseAlertView *)alertViewWithConfig:(SAVersionAlertViewConfig *)config {
    if ([config.updateModel isEqualToString:SAVersionUpdateModelBeta]) {
        return [SABetaVersionAlertView alertViewWithConfig:config];
    } else {
        return [SANewVersionAlertView alertViewWithConfig:config];
    }
}

+ (BOOL)versionShouldAlert:(SAVersionAlertViewConfig *)config {
    if (config.ignoreCache) {
        return YES;
    }

    NSArray<NSString *> *showHistory = [SACacheManager.shared objectForKey:kCacheKeyUserIgnoredAppVersion type:SACacheTypeDocumentPublic relyLanguage:NO];

    if (showHistory && [showHistory isKindOfClass:NSArray.class]) {
        NSString *total = [showHistory componentsJoinedByString:@"|"];
        if ([total rangeOfString:config.versionId].location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}

@end
