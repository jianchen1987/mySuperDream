//
//  WMMultiLanguageManager.h
//  SuperApp
//
//  Created by VanJay on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMultiLanguageManager.h"

NS_ASSUME_NONNULL_BEGIN

#define WMLocalizedString(key, _value) [SAMultiLanguageManager localizedStringForKey:key value:_value table:@"Localizable" bundleName:@"WMLocalizedResource"]
#define WMLocalizedStringFromTable(key, _value, _table) [SAMultiLanguageManager localizedStringForKey:key value:_value table:_table bundleName:@"WMLocalizedResource"]
#define WMLocalizedStringForLanguageFromTable(language, _key, _value, _table) \
    [SAMultiLanguageManager localizedStringForLanguage:language key:_key value:_value table:_table bundleName:@"WMLocalizedResource"]


@interface WMMultiLanguageManager : SAMultiLanguageManager

@end

NS_ASSUME_NONNULL_END
