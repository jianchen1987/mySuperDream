//
//  SAGoogleGeocodeModel.m
//  SuperApp
//
//  Created by Chaos on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAGoogleGeocodeModel.h"


@implementation SAGoogleGeocodeComponentsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"shortName": @"short_name",
        @"longName": @"long_name",
    };
}

@end


@implementation SAGoogleGeocodeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"formattedAddress": @"formatted_address",
        @"addressComponents": @"address_components",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"addressComponents": SAGoogleGeocodeComponentsModel.class,
    };
}

@end
