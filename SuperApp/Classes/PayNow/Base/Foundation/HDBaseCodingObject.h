//
//  HDBaseCodingObject.h
//  customer
//
//  Created by VanJay on 2019/3/27.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>


@interface HDBaseCodingObject : SAModel <NSCoding, NSCopying>

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (id)copyWithZone:(NSZone *)zone;

- (NSUInteger)hash;

- (BOOL)isEqual:(id)object;

@end
