//
//  SAAppEnvConfig.m
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppEnvConfig.h"

SAAppEnvType const SAAppEnvTypeProduct = @"product";
SAAppEnvType const SAAppEnvTypeBakcup = @"backups";
SAAppEnvType const SAAppEnvTypeUAT = @"uat";
SAAppEnvType const SAAppEnvTypeSIT = @"sit";
SAAppEnvType const SAAppEnvTypeMOCK = @"mock";
SAAppEnvType const SAAppEnvTypePreRelease = @"pre_release";
SAAppEnvType const SAAppEnvTypeFAT = @"fat";


@implementation SAAppEnvConfig
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"serviceURL": @[@"serviceURL", @"ServiceURL"],
        @"fileServer": @[@"fileServer", @"FileServer"],
        @"h5Url": @[@"h5URL", @"h5Url", @"H5Url"],
        @"payServiceURL": @[@"payServiceURL", @"payServiceURL"],
        @"payH5Url": @[@"payH5Url", @"payH5Url"],
        @"payFileServer": @[@"payFileServer", @"payFileServer"],
        @"coolcashcam": @[@"coolcashcam", @"CoolcashCam"],
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"当前环境配置：\nname：%@\ntype：%@\nserviceURL：%@\nfileServer：%@\nh5URL：%@\n TinhNow:%@\n PayNow:%@\n coolcashcam:%@",
                                      self.name,
                                      self.type,
                                      self.serviceURL,
                                      self.fileServer,
                                      self.h5URL,
                                      self.tinhNowHost,
                                      self.payServiceURL,
                                      self.coolcashcam];
}

@end
