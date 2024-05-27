//
//  PNCAMNetworRequest.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCAMNetworRequest.h"
#import "SAAppEnvManager.h"
#import "SAUser.h"


@implementation PNCAMNetworRequest

- (instancetype)init {
    if (self = [super init]) {
        self.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.coolcashcam;
        self.requestTimeoutInterval = 60;
#ifdef DEBUG
//        self.shouldPrintRspJsonString = NO;
//        self.shouldPrintParamJsonString = YES;
#endif
    }
    return self;
}

- (NSDictionary *)hd_preprocessParameter:(NSDictionary *)parameter {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[super hd_preprocessParameter:parameter]];
    if (self.isNeedLogin && [SAUser hasSignedIn]) {
        [params addEntriesFromDictionary:@{@"loginName": SAUser.shared.loginName}];
    }
    return params;
}
@end
