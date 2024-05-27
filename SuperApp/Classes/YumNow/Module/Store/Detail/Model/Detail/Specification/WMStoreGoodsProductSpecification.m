//
//  WMStoreGoodsProductSpecification.m
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreGoodsProductSpecification.h"
#import "WMStoreGoodsPromotionModel.h"


@implementation WMStoreGoodsProductSpecification
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"descriptionEn": @"description",
             @"specificationId": @"id",
             @"nameEn": @"name",
             @"status": @"shelfStatus",
             @"salePriceCent" : @"salePrice.cent",
    };
}

#pragma mark - setter

- (void)setDescriptionEn:(NSString *)descriptionEn {
    _descriptionEn = descriptionEn;
    self.desc.en_US = descriptionEn;
}

- (void)setDescriptionKm:(NSString *)descriptionKm {
    _descriptionKm = descriptionKm;
    self.desc.km_KH = descriptionKm;
}

- (void)setDescriptionZh:(NSString *)descriptionZh {
    _descriptionZh = descriptionZh;
    self.desc.zh_CN = descriptionZh;
}

#pragma mark - lazy load
- (SAInternationalizationModel *)desc {
    if (!_desc) {
        _desc = SAInternationalizationModel.new;
    }
    return _desc;
}

- (NSString *)salePrice {
    if(!_salePrice && _salePriceCent >= 0) {
        return [NSString stringWithFormat:@"%.2f", _salePriceCent / 100.0];
    }
    return _salePrice;
}

@end
