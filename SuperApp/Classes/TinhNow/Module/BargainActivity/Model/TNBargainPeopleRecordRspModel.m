//
//  TNBargainPeopleRecordRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainPeopleRecordRspModel.h"


@implementation TNBargainPeopleRecordRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pages": @"totalPage"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items": [TNHelpPeolpleRecordeModel class]};
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageNum = 1; //默认页码为1
    }
    return self;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.pageNum >= self.pages) {
        self.hasNextPage = NO;
    } else {
        self.hasNextPage = YES;
    }

    return YES;
}
@end
