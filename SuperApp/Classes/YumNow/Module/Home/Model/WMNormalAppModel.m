//
//  WMNormalAppModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMNormalAppModel.h"


@implementation WMNormalAppModel
+ (instancetype)normalAppModelWithTitle:(NSString *)title imageName:(NSString *)imageName {
    return [[self alloc] initWithTitle:title imageName:imageName];
}

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    if (self = [super init]) {
        self.appName = title;
        self.appImageName = imageName;
    }
    return self;
}
@end
