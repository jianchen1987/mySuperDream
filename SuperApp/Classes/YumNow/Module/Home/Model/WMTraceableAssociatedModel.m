//
//  WMTraceableAssociatedModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMTraceableAssociatedModel.h"


@implementation WMTraceableAssociatedModel

+ (instancetype)traceableAssociatedModel:(id)associatedObject trackName:(NSString *)trackName {
    return [[self alloc] initModel:associatedObject trackName:trackName];
}

- (instancetype)initModel:(id)associatedObject trackName:(NSString *)trackName {
    if (self = [super init]) {
        self.associatedObject = associatedObject;
        self.trackName = trackName;
    }
    return self;
}
@end
