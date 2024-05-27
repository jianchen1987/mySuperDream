//
//  SACountryModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACountryModel.h"


@implementation SACountryModel
+ (instancetype)modelWithDisplayText:(NSString *)displayText countryCode:(NSString *)countryCode {
    SACountryModel *item = SACountryModel.new;
    item.displayText = displayText;
    item.countryCode = countryCode;
    return item;
}

- (void)updatePhoneNumberFormat:(NSString *)phoneNumberFormat minimumDigits:(NSUInteger)minimumDigits maximumDigits:(NSUInteger)maximumDigits {
    self.phoneNumberFormat = phoneNumberFormat;
    self.minimumDigits = minimumDigits;
    self.maximumDigits = maximumDigits;
}

#pragma mark - setter
- (void)setPhoneNumberFormat:(NSString *)phoneNumberFormat {
    _phoneNumberFormat = phoneNumberFormat;

    if (HDIsStringEmpty(self.zeroPrefixPhoneNumberFormat)) {
        self.zeroPrefixPhoneNumberFormat = phoneNumberFormat;
    }
}

#pragma mark - getter
- (NSString *)fullCountryCode {
    return [NSString stringWithFormat:@"+%@", self.countryCode];
}
@end
