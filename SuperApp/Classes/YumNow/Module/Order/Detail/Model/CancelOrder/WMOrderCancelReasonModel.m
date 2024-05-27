//
//  WMOrderCancelReasonModel.m
//  SuperApp
//
//  Created by wmz on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderCancelReasonModel.h"


@implementation WMOrderCancelReasonModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ids": @"id", @"operatorStr": @"operator"};
}

- (NSString *)name {
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        _name = self.nameZh ?: _name;
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeEN]) {
        _name = self.nameEn ?: _name;
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        _name = self.nameKm ?: _name;
    }
    return _name ?: @"";
}

@end
