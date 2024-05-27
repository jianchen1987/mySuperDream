//
//  SAInternationalizationModel.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMultiLanguageManager.h"


@implementation SAInternationalizationModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"en_US": @[@"en-US", @"en_US", @"en", @"en-us", @"nameEn", @"value"],
        @"zh_CN": @[@"zh-CN", @"zh_CN", @"zh", @"zh-cn", @"nameZh", @"valueZh"],
        @"km_KH": @[@"cb", @"km_KH", @"kh", @"km-KH", @"km-kh", @"nameKm", @"valueKm"],
    };
}

+ (instancetype)modelWithCN:(NSString *)zh en:(NSString *)en kh:(NSString *)kh {
    return [[self alloc] initWithCN:zh en:en kh:kh];
}

- (instancetype)initWithCN:(NSString *)zh en:(NSString *)en kh:(NSString *)kh {
    if (self = [super init]) {
        self.zh_CN = zh;
        self.en_US = en;
        self.km_KH = kh;
    }
    return self;
}

+ (instancetype)modelWithInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table {
    return [[self alloc] initWithInternationalKey:key value:value table:table];
}

- (instancetype)initWithInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table {
    if (self = [super init]) {
        self.zh_CN = SALocalizedStringForLanguageFromTable(SALanguageTypeCN, key, value, table);
        self.en_US = SALocalizedStringForLanguageFromTable(SALanguageTypeEN, key, value, table);
        self.km_KH = SALocalizedStringForLanguageFromTable(SALanguageTypeKH, key, value, table);
    }
    return self;
}

- (NSString *)desc {
    NSString *title = self.en_US;
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        title = self.zh_CN;
    } else if (SAMultiLanguageManager.isCurrentLanguageKH) {
        title = self.km_KH;
    }
    return title;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:SAInternationalizationModel.class]) {
        return NO;
    }
    SAInternationalizationModel *that = object;

    if ([self.zh_CN isEqualToString:that.zh_CN] && [self.en_US isEqualToString:that.en_US] && [self.km_KH isEqualToString:that.km_KH]) {
        return YES;
    }

    return NO;
}

@end


@implementation SAInternationalizationModel (YumNow)

+ (instancetype)modelWithWMInternationalKey:(NSString *)key value:(NSString *)value table:(NSString *)table {
    return [[self alloc] initWithWMInternationalKey:key value:value table:table];
}

- (instancetype)initWithWMInternationalKey:(NSString *)key value:(NSString *)value table:(NSString *)table {
    if (self = [super init]) {
        self.zh_CN = [SAMultiLanguageManager localizedStringForLanguage:SALanguageTypeCN key:key value:value table:table bundleName:@"WMLocalizedResource"];
        self.en_US = [SAMultiLanguageManager localizedStringForLanguage:SALanguageTypeEN key:key value:value table:table bundleName:@"WMLocalizedResource"];
        self.km_KH = [SAMultiLanguageManager localizedStringForLanguage:SALanguageTypeKH key:key value:value table:table bundleName:@"WMLocalizedResource"];
    }
    return self;
}

@end


@implementation SAInternationalizationModel (GroupBuy)

+ (instancetype)modelWithGNInternationalKey:(NSString *)key value:(NSString *)value table:(NSString *)table {
    return [[self alloc] initWithGNInternationalKey:key value:value table:table];
}

- (instancetype)initWithGNInternationalKey:(NSString *)key value:(NSString *)value table:(NSString *)table {
    if (self = [super init]) {
        self.zh_CN = [SAMultiLanguageManager localizedStringForLanguage:SALanguageTypeCN key:key value:value table:table bundleName:@"GMLocalizedResource"];
        self.en_US = [SAMultiLanguageManager localizedStringForLanguage:SALanguageTypeEN key:key value:value table:table bundleName:@"GMLocalizedResource"];
        self.km_KH = [SAMultiLanguageManager localizedStringForLanguage:SALanguageTypeKH key:key value:value table:table bundleName:@"GMLocalizedResource"];
    }
    return self;
}

@end
