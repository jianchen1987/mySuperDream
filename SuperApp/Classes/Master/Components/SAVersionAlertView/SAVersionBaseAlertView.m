//
//  SAVersionBaseAlertView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAVersionBaseAlertView.h"
#import "SAVersionAlertViewConfig.h"
#import "SACacheManager.h"


@implementation SAVersionBaseAlertView

+ (instancetype)alertViewWithConfig:(SAVersionAlertViewConfig *__nullable)config {
    return [[self alloc] initWithConfig:config];
}

- (instancetype)initWithConfig:(SAVersionAlertViewConfig *__nullable)config {
    if (self = [super init]) {
        self.config = config ? config : [[SAVersionAlertViewConfig alloc] init];
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = false;
    }
    return self;
}

#pragma mark - Action
- (void)dismiss {
    // 关闭弹窗
    // 记录本次弹窗
    [self save];
    [super dismiss];
}

- (BOOL)save {
    if (HDIsStringEmpty(self.config.versionId)) {
        return NO;
    }

    NSMutableArray<NSString *> *tmp = NSMutableArray.new;
    NSArray<NSString *> *showHistory = [SACacheManager.shared objectForKey:kCacheKeyUserIgnoredAppVersion type:SACacheTypeDocumentPublic relyLanguage:NO];
    if (showHistory && [showHistory isKindOfClass:NSArray.class]) {
        [tmp addObjectsFromArray:showHistory];
    }
    [tmp addObject:self.config.versionId];
    [SACacheManager.shared setObject:tmp forKey:kCacheKeyUserIgnoredAppVersion type:SACacheTypeDocumentPublic relyLanguage:NO];

    return YES;
}
@end
