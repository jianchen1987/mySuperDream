//
//  WMAppFunctionModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMAppFunctionModel.h"


@implementation WMAppFunctionModel

+ (instancetype)appFunctionModelWithRouteScheme:(NSString *)routeScheme routePath:(NSString *)routePath routeParams:(NSDictionary *)routeParams trackName:(NSString *)trackName {
    return [[self alloc] initWithRouteScheme:routeScheme routePath:routePath routeParams:routeParams trackName:trackName];
}

- (instancetype)initWithRouteScheme:(NSString *)routeScheme routePath:(NSString *)routePath routeParams:(NSDictionary *)routeParams trackName:(NSString *)trackName {
    if (self = [super init]) {
        self.routeScheme = routeScheme;
        self.routePath = routePath;
        self.routeParams = routeParams;
        self.trackName = trackName;
    }
    return self;
}
@end
