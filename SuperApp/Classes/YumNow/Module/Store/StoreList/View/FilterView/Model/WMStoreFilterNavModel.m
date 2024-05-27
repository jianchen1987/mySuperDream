//
//  WMStoreFilterNavModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterNavModel.h"

WMStoreFilterNavType const WMStoreFilterNavTypeSortType = @"sortType";
WMStoreFilterNavType const WMStoreFilterNavTypeCategory = @"category";


@implementation WMStoreFilterNavModel
+ (instancetype)merchantFilterNavModelWithType:(WMStoreFilterNavType)type title:(NSString *__nullable)title image:(UIImage *)image {
    return [[self alloc] initWithType:type title:title image:image];
}

- (instancetype)initWithType:(WMStoreFilterNavType)type title:(NSString *)title image:(UIImage *)image {
    if (self = [super init]) {
        self.type = type;
        self.title = title;
        self.image = image;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n 名称：%@\n 类型：%@ \n", self.title, self.type];
}
@end
