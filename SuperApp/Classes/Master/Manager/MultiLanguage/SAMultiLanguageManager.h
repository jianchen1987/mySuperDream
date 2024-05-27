//
//  SAMultiLanguageManager.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

@import Foundation;
@import UIKit;

#define SALocalizedString(key, _value) [SAMultiLanguageManager localizedStringForKey:key value:_value table:@"Localizable" bundleName:@"SALocalizedResource"]
#define SALocalizedStringFromTable(key, _value, _table) [SAMultiLanguageManager localizedStringForKey:key value:_value table:_table bundleName:@"SALocalizedResource"]
#define SALocalizedStringForLanguageFromTable(language, _key, _value, _table) \
    [SAMultiLanguageManager localizedStringForLanguage:language key:_key value:_value table:_table bundleName:@"SALocalizedResource"]

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SALanguageType NS_STRING_ENUM;
/// 简体中文
FOUNDATION_EXPORT SALanguageType const SALanguageTypeCN;
/// 英语
FOUNDATION_EXPORT SALanguageType const SALanguageTypeEN;
/// 高棉语
FOUNDATION_EXPORT SALanguageType const SALanguageTypeKH;

FOUNDATION_EXPORT NSString *kNotificationNameLanguageChanged;


@interface SAMultiLanguageManager : NSObject

/** 当前语言 */
+ (SALanguageType)currentLanguage;

/** 当前语言描述 */
+ (NSString *)currentLanguageDisplayName;

/** 根据语言返回对应国家图片名 */
+ (NSString *)imageNameForLanguageType:(SALanguageType)type;

/// 所有支持的语言
+ (NSArray<NSString *> *)supportLanguageDisplayNames;

/// 根据语言显示返回语种
+ (SALanguageType)languageTypeForDisplayName:(NSString *)displayName;

/// 设置语言，成功返回 YES，否则 NO
/// @param type 语言类型
+ (BOOL)setLanguage:(SALanguageType)type;

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *_Nullable)table bundleName:(NSString *)bundleName;
+ (NSString *)localizedStringForLanguage:(SALanguageType _Nullable)language key:(NSString *)key value:(NSString *_Nullable)value table:(NSString *)table;
+ (NSString *)localizedStringForLanguage:(SALanguageType _Nullable)language key:(NSString *)key value:(NSString *_Nullable)value table:(NSString *)table bundleName:(NSString *)bundleName;
//+ (UIImage *)localizedImageForName:(NSString *)imageName bundleName:(NSString *)bundleName;

/** 当前语言是否是中文 */
+ (BOOL)isCurrentLanguageCN;

/** 当前语言是否是高棉语 */
+ (BOOL)isCurrentLanguageKH;

/** 当前语言是否是英语 */
+ (BOOL)isCurrentLanguageEN;
@end

NS_ASSUME_NONNULL_END
