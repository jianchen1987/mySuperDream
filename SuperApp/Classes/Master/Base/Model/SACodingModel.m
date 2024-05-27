//
//  SACodingModel.m
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"


@implementation SACodingModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}
@end
