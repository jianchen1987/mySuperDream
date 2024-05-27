//
//  SAChangeCountryViewProvider.m
//  SuperApp
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeCountryViewProvider.h"
#import <HDKitCore/NSString+HD_Validator.h>

NSString *const kCacheKeyUserLastChoosedCountry = @"kCacheKeyUserLastChoosedCountry";
NSString *const kCacheKeyUserLastChoosedAreaCode = @"kCacheKeyUserLastChoosedAreaCode";


@implementation SAChangeCountryViewProvider
static NSMutableArray<SACountryModel *> *_dataSource = nil;

+ (NSArray<SACountryModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:2];

        SACountryModel *model = [SACountryModel modelWithDisplayText:[NSString stringWithFormat:@"%@ +855", SALocalizedString(@"cambodia", @"柬埔寨")] countryCode:@"855"];
        [model updatePhoneNumberFormat:@"xx-xxx-xxxx" minimumDigits:8 maximumDigits:10];
        model.zeroPrefixPhoneNumberFormat = @"xxx-xxx-xxxx";
        @HDWeakify(model);
        model.isPhoneNumberValidBlock = ^BOOL(NSString *_Nonnull phoneNumber) {
            @HDStrongify(model);
            NSString *phoneTmp = phoneNumber;
            while ([phoneTmp hasPrefix:@"0"]) {
                phoneTmp = [phoneTmp substringFromIndex:1];
            }
            return phoneTmp.length >= model.minimumDigits && phoneTmp.length <= model.maximumDigits;
        };
        [_dataSource addObject:model];

        SACountryModel *cnModel = [SACountryModel modelWithDisplayText:[NSString stringWithFormat:@"%@ +86", SALocalizedString(@"china", @"中国")] countryCode:@"86"];
        [cnModel updatePhoneNumberFormat:@"xxx-xxxx-xxxx" minimumDigits:11 maximumDigits:11];

        @HDWeakify(cnModel);
        cnModel.isPhoneNumberValidBlock = ^BOOL(NSString *_Nonnull phoneNumber) {
            @HDStrongify(cnModel);
            return phoneNumber.length >= cnModel.minimumDigits && phoneNumber.length <= cnModel.maximumDigits;
        };
        [_dataSource addObject:cnModel];
    }
    return _dataSource;
}

+ (NSArray<SACountryModel *> *)areaCodedataSource {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:2];

    SACountryModel *model = [SACountryModel modelWithDisplayText:SALocalizedString(@"cambodia", @"柬埔寨") countryCode:@"855"];
    [model updatePhoneNumberFormat:@"xx-xxx-xxxx" minimumDigits:8 maximumDigits:10];
    model.zeroPrefixPhoneNumberFormat = @"xxx-xxx-xxxx";
    @HDWeakify(model);
    model.isPhoneNumberValidBlock = ^BOOL(NSString *_Nonnull phoneNumber) {
        @HDStrongify(model);
        NSString *phoneTmp = phoneNumber;
        while ([phoneTmp hasPrefix:@"0"]) {
            phoneTmp = [phoneTmp substringFromIndex:1];
        }
        return phoneTmp.length >= model.minimumDigits && phoneTmp.length <= model.maximumDigits;
    };
    [mArr addObject:model];

    SACountryModel *cnModel = [SACountryModel modelWithDisplayText:SALocalizedString(@"china", @"中国") countryCode:@"86"];
    [cnModel updatePhoneNumberFormat:@"xxx-xxxx-xxxx" minimumDigits:11 maximumDigits:11];

    @HDWeakify(cnModel);
    cnModel.isPhoneNumberValidBlock = ^BOOL(NSString *_Nonnull phoneNumber) {
        @HDStrongify(cnModel);
        return phoneNumber.length >= cnModel.minimumDigits && phoneNumber.length <= cnModel.maximumDigits;
    };
    [mArr addObject:cnModel];
    return mArr;
}
@end
