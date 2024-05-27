//
//  WMStoreMenuItem.m
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreMenuItem.h"


@implementation WMStoreMenuItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"menuId": @"id",
        //        @"nameEn": @"name"
    };
}
//
//- (void)setNameEn:(NSString *)nameEn {
//    _nameEn = nameEn;
//    self.name.en_US = nameEn;
//}
//
//- (void)setNameKm:(NSString *)nameKm {
//    _nameKm = nameKm;
//    self.name.km_KH = nameKm;
//}
//
//- (void)setNameZh:(NSString *)nameZh {
//    _nameZh = nameZh;
//    self.name.zh_CN = nameZh;
//}
//
//#pragma mark - lazy load
//- (SAInternationalizationModel *)name {
//    if (!_name) {
//        _name = SAInternationalizationModel.new;
//    }
//    return _name;
//}
@end
