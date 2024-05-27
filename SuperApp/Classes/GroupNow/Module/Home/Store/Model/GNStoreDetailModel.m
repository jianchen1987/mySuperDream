//
//  GNStoreDetailModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreDetailModel.h"
#import "GNMultiLanguageManager.h"


@implementation GNStoreDetailModel

- (NSString *)businessStr {
    if (!_businessStr) {
        NSMutableString *mstr = [[NSMutableString alloc] initWithString:@""];
        NSDictionary *info = @{
            @"MONDAY": WMLocalizedString(@"monday", @"MONDAY"),
            @"TUESDAY": WMLocalizedString(@"tuesday", @"TUESDAY"),
            @"WEDNESDAY": WMLocalizedString(@"wednesday", @"WEDNESDAY"),
            @"THURSDAY": WMLocalizedString(@"thursday", @"THURSDAY"),
            @"FRIDAY": WMLocalizedString(@"friday", @"FRIDAY"),
            @"SATURDAY": WMLocalizedString(@"saturday", @"SATURDAY"),
            @"SUNDAY": WMLocalizedString(@"sunday", @"SUNDAY"),
        };
        for (int i = 0; i < self.businessDays.count; i++) {
            GNMessageCode *code = self.businessDays[i];
            if ([code isKindOfClass:GNMessageCode.class]) {
                [mstr appendString:info[code.codeId] ?: @""];
                if (i != self.businessDays.count - 1) {
                    if (SAMultiLanguageManager.currentLanguage != SALanguageTypeEN) {
                        [mstr appendString:@"、"];
                    }
                }
            }
        }

        if (mstr.length)
            [mstr appendString:@"\n\n"];

        for (int i = 0; i < self.businessHours.count; i++) {
            NSArray *hours = self.businessHours[i];
            if ([hours isKindOfClass:NSArray.class]) {
                [mstr appendString:@" "];
                for (int j = 0; j < hours.count; j++) {
                    NSString *str = hours[j];
                    if ([str isKindOfClass:NSString.class]) {
                        [mstr appendString:str];
                        if (j == 0) {
                            [mstr appendString:@"~"];
                        }
                    }
                }
            }
        }
        _businessStr = mstr;
    }
    return _businessStr;
}

- (NSString *)shortBusinessStr {
    if (!_shortBusinessStr) {
        NSMutableString *mstr = [[NSMutableString alloc] initWithString:@""];
        for (int i = 0; i < self.businessHours.count; i++) {
            NSArray *hours = self.businessHours[i];
            if ([hours isKindOfClass:NSArray.class]) {
                for (int j = 0; j < hours.count; j++) {
                    NSString *str = hours[j];
                    if ([str isKindOfClass:NSString.class]) {
                        [mstr appendString:str];
                        if (j == 0) {
                            [mstr appendString:@"-"];
                        }
                    }
                }
            }
            if (i != self.businessHours.count - 1) {
                [mstr appendString:@","];
            }
        }
        _shortBusinessStr = mstr;
    }
    return _shortBusinessStr;
}

- (NSArray<NSString *> *)storeQualificationPhotoArr {
    if (!_storeQualificationPhotoArr) {
        if (self.storeQualificationPhoto && [self.storeQualificationPhoto isKindOfClass:NSString.class] && self.storeQualificationPhoto.length) {
            if ([self.storeQualificationPhoto containsString:@","]) {
                _storeQualificationPhotoArr = [self.storeQualificationPhoto componentsSeparatedByString:@","];
            } else {
                _storeQualificationPhotoArr = @[self.storeQualificationPhoto];
            }
        }
        if (!_storeQualificationPhotoArr) {
            _storeQualificationPhotoArr = @[];
        }
    }
    return _storeQualificationPhotoArr;
}

- (NSArray<NSString *> *)storeIntroducePhotoArr {
    if (!_storeIntroducePhotoArr) {
        if (self.storeIntroducePhoto && [self.storeIntroducePhoto isKindOfClass:NSString.class] && self.storeIntroducePhoto.length) {
            if ([self.storeIntroducePhoto containsString:@","]) {
                _storeIntroducePhotoArr = [self.storeIntroducePhoto componentsSeparatedByString:@","];
            } else {
                _storeIntroducePhotoArr = @[self.storeIntroducePhoto];
            }
        }
        if (!_storeIntroducePhotoArr) {
            _storeIntroducePhotoArr = @[];
        }
    }
    return _storeIntroducePhotoArr;
}

- (NSArray<NSString *> *)storeEnvironmentPhotoArr {
    if (!_storeEnvironmentPhotoArr) {
        if (self.storeEnvironmentPhoto && [self.storeEnvironmentPhoto isKindOfClass:NSString.class] && self.storeEnvironmentPhoto.length) {
            if ([self.storeEnvironmentPhoto containsString:@","]) {
                _storeEnvironmentPhotoArr = [self.storeEnvironmentPhoto componentsSeparatedByString:@","];
            } else {
                _storeEnvironmentPhotoArr = @[self.storeEnvironmentPhoto];
            }
        }
        if (!_storeEnvironmentPhotoArr) {
            _storeEnvironmentPhotoArr = @[];
        }
    }
    return _storeEnvironmentPhotoArr;
}

- (NSArray<NSString *> *)storeAllPhotoArr {
    if (!_storeAllPhotoArr) {
        NSMutableArray *allPhotoArr = NSMutableArray.new;
        [allPhotoArr addObjectsFromArray:self.storeEnvironmentPhotoArr];
        [allPhotoArr addObjectsFromArray:self.storeIntroducePhotoArr];
        [allPhotoArr addObjectsFromArray:self.storeQualificationPhotoArr];
        _storeAllPhotoArr = allPhotoArr;
    }
    return _storeAllPhotoArr;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"productList": GNProductModel.class,
        @"businessDays": GNMessageCode.class,
        @"inServiceName": GNInternationalizationModel.class,
    };
}

@end
