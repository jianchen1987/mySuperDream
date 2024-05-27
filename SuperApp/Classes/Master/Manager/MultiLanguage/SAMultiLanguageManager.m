//
//  SAMultiLanguageManager.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDCommonDefines.h>

SALanguageType const SALanguageTypeCN = @"zh-CN";
SALanguageType const SALanguageTypeEN = @"en-US";
SALanguageType const SALanguageTypeKH = @"km-KH";

NSString *kNotificationNameLanguageChanged = @"app.notificationName.languageChange";

static NSString *const kCurrentLanguageCacheKey = @"kCurrentLanguageCache";


@implementation SAMultiLanguageManager
+ (SALanguageType)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentLanguage = [defaults valueForKey:kCurrentLanguageCacheKey];
    if (HDIsStringEmpty(currentLanguage)) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *systemLanguage = [languages objectAtIndex:0];
        if ([systemLanguage hasPrefix:@"zh"]) {
            currentLanguage = SALanguageTypeCN;
        } else if ([systemLanguage hasPrefix:@"km"]) {
            currentLanguage = SALanguageTypeKH;
        } else {
            // 默认英文
            currentLanguage = SALanguageTypeEN;
        }
        [defaults setValue:currentLanguage forKey:kCurrentLanguageCacheKey];
        [defaults synchronize];
    }
    return currentLanguage;
}

+ (NSString *)currentLanguageDisplayName {
    return [@{SALanguageTypeEN: @"English", SALanguageTypeKH: @"ភាសាខ្មែរ", SALanguageTypeCN: @"中文"} objectForKey:self.currentLanguage];
}

+ (NSString *)imageNameForLanguageType:(SALanguageType)type {
    if ([type isEqualToString:SALanguageTypeCN]) {
        return @"ic_chinese_cycle";
    } else if ([type isEqualToString:SALanguageTypeKH]) {
        return @"ic_khmer_cycle";
    } else {
        return @"ic_english_cycle";
    }
    return nil;
}

+ (SALanguageType)languageTypeForDisplayName:(NSString *)displayName {
    if ([self.supportLanguageDisplayNames containsObject:displayName]) {
        return [@{@"English": SALanguageTypeEN, @"ភាសាខ្មែរ": SALanguageTypeKH, @"中文": SALanguageTypeCN} objectForKey:displayName];
    }
    return self.currentLanguage;
}

+ (NSArray<NSString *> *)supportLanguageDisplayNames {
    return @[@"English", @"ភាសាខ្មែរ", @"中文"];
}

+ (BOOL)setLanguage:(SALanguageType)type {
    if (HDIsStringEmpty(type))
        return false;
    if ([type isEqualToString:self.currentLanguageDisplayName])
        return false;
    if ([@[SALanguageTypeCN, SALanguageTypeEN, SALanguageTypeKH] containsObject:type]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:type forKey:kCurrentLanguageCacheKey];
        [defaults synchronize];

        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameLanguageChanged object:nil];
        return true;
    }
    return false;
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *_Nullable)table bundleName:(NSString *)bundleName {
    return [self localizedStringForLanguage:nil key:key value:value table:table bundleName:bundleName];
}

+ (NSString *)localizedStringForLanguage:(SALanguageType)language key:(NSString *)key value:(NSString *)value table:(NSString *)table {
    return [self localizedStringForLanguage:language key:key value:value table:table bundleName:@"LocalizedResource"];
}

+ (NSString *)localizedStringForLanguage:(SALanguageType _Nullable)language key:(NSString *)key value:(NSString *_Nullable)value table:(NSString *)table bundleName:(NSString *)bundleName {
    if (HDIsStringEmpty(language)) {
        language = self.currentLanguage;
    }
    NSBundle *localizedFile = [self bundleForBundleName:bundleName language:language];
    NSString *tmp = [localizedFile localizedStringForKey:key value:value table:table];
    return tmp;
}

//+ (UIImage *)localizedImageForName:(NSString *)imageName bundleName:(NSString *)bundleName {
//    return [UIImage imageWithContentsOfFile:[[self bundleForBundleName:bundleName] pathForResource:imageName ofType:@"png"]];
//}

+ (BOOL)isCurrentLanguageCN {
    return [self.currentLanguage isEqualToString:SALanguageTypeCN];
}

+ (BOOL)isCurrentLanguageKH {
    return [self.currentLanguage isEqualToString:SALanguageTypeKH];
}

+ (BOOL)isCurrentLanguageEN {
    return [self.currentLanguage isEqualToString:SALanguageTypeEN];
}

#pragma mark - private methods
static NSCache *_bundleCache = nil;
+ (NSBundle *)bundleForBundleName:(NSString *)bundleName language:(NSString *)language {
    if (!_bundleCache) {
        _bundleCache = [NSCache new];
    }

    NSString *key = [NSString stringWithFormat:@"%@.%@", bundleName, language];
    NSBundle *localizedFile = [_bundleCache objectForKey:key];
    if (!localizedFile) {
        NSBundle *bundle = [NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:bundleName ofType:@"bundle"]];
        localizedFile = [NSBundle bundleWithPath:[bundle pathForResource:language ofType:@"lproj"]];
        [_bundleCache setObject:localizedFile forKey:key];
    }
    return localizedFile;
}
@end
