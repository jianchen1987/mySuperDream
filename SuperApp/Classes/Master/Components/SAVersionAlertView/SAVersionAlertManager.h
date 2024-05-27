//
//  SAVersionAlertManager.h
//  SuperApp
//
//  Created by Chaos on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAVersionBaseAlertView.h"
#import "SAVersionAlertViewConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAVersionAlertManager : NSObject

+ (SAVersionBaseAlertView *)alertViewWithConfig:(SAVersionAlertViewConfig *__nullable)config;

+ (BOOL)versionShouldAlert:(SAVersionAlertViewConfig *)config;

@end

NS_ASSUME_NONNULL_END
