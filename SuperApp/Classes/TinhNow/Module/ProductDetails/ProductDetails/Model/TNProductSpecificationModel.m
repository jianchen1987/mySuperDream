//
//  TNProductSepcificationModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductSpecificationModel.h"


@implementation TNProductSpecificationModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"specId": @"id",
        @"specName": @"name"

    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"specValues": [TNProductSpecPropertieModel class]};
}

- (TNProductSpecPropertieModel *)getPropertiesModelWithId:(NSString *)propertiesId {
    TNProductSpecPropertieModel *model = nil;
    for (TNProductSpecPropertieModel *m in self.specValues) {
        if ([m.propId isEqualToString:propertiesId]) {
            model = m;
            break;
        }
    }
    return model;
}

@end
