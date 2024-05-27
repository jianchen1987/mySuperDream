//
//  WMShoppingCartStoreProductProperty.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartStoreProductProperty.h"


@implementation WMShoppingCartStoreProductProperty
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"propertyId": @"id",
        @"nameEn": @"name",
    };
}

#pragma mark - setter
- (void)setNameEn:(NSString *)nameEn {
    _nameEn = nameEn;
    self.name.en_US = nameEn;
}

- (void)setNameKm:(NSString *)nameKm {
    _nameKm = nameKm;
    self.name.km_KH = nameKm;
}

- (void)setNameZh:(NSString *)nameZh {
    _nameZh = nameZh;
    self.name.zh_CN = nameZh;
}

#pragma mark - lazy load
- (SAInternationalizationModel *)name {
    if (!_name) {
        _name = SAInternationalizationModel.new;
    }
    return _name;
}
@end
