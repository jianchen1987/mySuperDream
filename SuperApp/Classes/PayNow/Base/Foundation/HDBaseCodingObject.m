//
//  HDBaseCodingObject.m
//  customer
//
//  Created by VanJay on 2019/3/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDBaseCodingObject.h"
#import "YYModel.h"


@implementation HDBaseCodingObject

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
