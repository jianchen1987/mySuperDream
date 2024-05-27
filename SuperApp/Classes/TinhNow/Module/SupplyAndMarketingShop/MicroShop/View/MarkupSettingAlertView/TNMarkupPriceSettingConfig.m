//
//  TNMarkupPriceSettingConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMarkupPriceSettingConfig.h"
#import "TNMultiLanguageManager.h"


@implementation TNMarkupPriceSettingConfig
+ (instancetype)defaultConfig {
    TNMarkupPriceSettingConfig *config = [[TNMarkupPriceSettingConfig alloc] init];
    config.type = TNMarkupPriceSettingTypeGlobal;
    return config;
}
- (void)setType:(TNMarkupPriceSettingType)type {
    _type = type;
    if (type == TNMarkupPriceSettingTypeGlobal) {
        self.title = TNLocalizedString(@"uIoUicAT", @"店铺加价设置");
        self.tips = TNLocalizedString(@"lh2qHdTn", @"在批发价基础上增加，选购分销商品销售价会自动加价，也可以在我的店铺修改商品销售价");
    } else if (type == TNMarkupPriceSettingTypeSingleProduct) {
        self.title = TNLocalizedString(@"TTujoFCX", @"修改价格");
        self.tips = TNLocalizedString(@"fSI31JlG", @"在批发价的基础上增加， 商品销售价会自动加价");
    } else if (type == TNMarkupPriceSettingTypeBatchProduct) {
        self.title = TNLocalizedString(@"EAcRaWe9", @"批量修改价格");
        self.tips = TNLocalizedString(@"fSI31JlG", @"在批发价的基础上增加， 商品销售价会自动加价");
    }
}
@end
