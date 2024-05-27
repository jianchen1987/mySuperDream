#import "SAMultiLanguageManager.h"

NS_ASSUME_NONNULL_BEGIN

#define PNLocalizedString(key, _value) [PNMultiLanguageManager localizedStringForKey:key value:_value table:@"Localizable" bundleName:@"PayLocalizedResource"]
#define PNLocalizedStringFromTable(key, _value, _table) [PNMultiLanguageManager localizedStringForKey:key value:_value table:_table bundleName:@"PayLocalizedResource"]
#define PNLocalizedStringForLanguageFromTable(language, _key, _value, _table) \
    [PNMultiLanguageManager localizedStringForLanguage:language key:_key value:_value table:_table bundleName:@"PayLocalizedResource"]


@interface PNMultiLanguageManager : SAMultiLanguageManager

@end

NS_ASSUME_NONNULL_END
