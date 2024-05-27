//
//  TNNetworkRequest.m
//  SuperApp
//
//  Created by 张杰 on 2021/11/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNetworkRequest.h"
#import "SAMultiLanguageManager.h"
#import "SAUser.h"


@implementation TNNetworkRequest

#pragma mark - overwrite
- (NSDictionary<NSString *, NSString *> *)sa_preprocessHeaderFields:(NSDictionary<NSString *, NSString *> *)headerFields {
    NSMutableDictionary<NSString *, NSString *> *header = [[NSMutableDictionary alloc] initWithDictionary:headerFields];
    [header addEntriesFromDictionary:@{
        @"appNo": @"11",
        @"termTyp": @"IOS",
        @"Accept-Language": SAMultiLanguageManager.currentLanguage,
        @"appVersion": HDDeviceInfo.appVersion,
        @"channel": @"AppStore",
        @"appId": @"SuperApp",
        @"projectName": @"SuperApp"
    }];

    if (self.isNeedLogin && [SAUser hasSignedIn]) {
        [header addEntriesFromDictionary:@{@"accessToken": SAUser.shared.accessToken}];
        [header addEntriesFromDictionary:@{@"loginName": SAUser.shared.loginName}];
    }

    return header;
}
@end
