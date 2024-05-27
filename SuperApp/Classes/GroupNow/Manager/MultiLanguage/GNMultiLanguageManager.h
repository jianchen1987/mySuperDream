//
//  GNMultiLanguageManager.h
//  SuperApp
//
//  Created by wmz on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMultiLanguageManager.h"

NS_ASSUME_NONNULL_BEGIN

#define GNLocalizedString(key, _value) [SAMultiLanguageManager localizedStringForKey:key value:_value table:@"Localizable" bundleName:@"GMLocalizedResource"]
#define GNLocalizedStringFromTable(key, _value, _table) [SAMultiLanguageManager localizedStringForKey:key value:_value table:_table bundleName:@"GNLocalizedResource"]
#define GNLocalizedStringForLanguageFromTable(language, _key, _value, _table) \
    [SAMultiLanguageManager localizedStringForLanguage:language key:_key value:_value table:_table bundleName:@"GNLocalizedResource"]


@interface GNMultiLanguageManager : SAMultiLanguageManager

@end

NS_ASSUME_NONNULL_END
