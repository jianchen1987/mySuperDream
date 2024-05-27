//
//  TNMultiLanguageManager.h
//  SuperApp
//
//  Created by VanJay on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMultiLanguageManager.h"

NS_ASSUME_NONNULL_BEGIN

#define TNLocalizedString(key, _value) [SAMultiLanguageManager localizedStringForKey:key value:_value table:@"Localizable" bundleName:@"TNLocalizedResource"]
#define TNLocalizedStringFromTable(key, _value, _table) [SAMultiLanguageManager localizedStringForKey:key value:_value table:_table bundleName:@"TNLocalizedResource"]
#define TNLocalizedStringForLanguageFromTable(language, _key, _value, _table) \
    [SAMultiLanguageManager localizedStringForLanguage:language key:_key value:_value table:_table bundleName:@"TNLocalizedResource"]


@interface TNMultiLanguageManager : SAMultiLanguageManager

@end

NS_ASSUME_NONNULL_END
