//
//  SAAddressModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressModel.h"


@implementation SAAddressModel

+ (instancetype)addressModelWithAddressDictionary:(NSDictionary<SAAddressKey, id> *)addressDictionary {
    SAAddressModel *addressModel = SAAddressModel.new;
    addressModel.country = addressDictionary[SAAddressKeyCountry];
    addressModel.state = addressDictionary[SAAddressKeyState];
    addressModel.city = addressDictionary[SAAddressKeyCity];
    addressModel.subLocality = addressDictionary[SAAddressKeySubLocality];
    addressModel.street = addressDictionary[SAAddressKeyStreet];
    addressModel.shortName = addressDictionary[SAAddressKeyName];
    addressModel.consigneeAddress = addressDictionary[SAAddressKeySubThoroughfare];
    return addressModel;
}

+ (instancetype)addressModelWithAddressSearchItem:(SAAddressSearchRspModel *)searchItem {
    SAAddressModel *model = SAAddressModel.new;
    model.lon = searchItem.result.geometry.location.lng;
    model.lat = searchItem.result.geometry.location.lat;
    model.shortName = searchItem.result.name;
    model.address = searchItem.result.formatted_address;
    return model;
}

+ (instancetype)addressModelWithShoppingAddressModel:(SAShoppingAddressModel *)shoppingAddressModel {
    SAAddressModel *model = SAAddressModel.new;
    model.lon = shoppingAddressModel.longitude;
    model.lat = shoppingAddressModel.latitude;
    model.address = shoppingAddressModel.address;
    model.consigneeAddress = shoppingAddressModel.consigneeAddress;
    model.addressNo = shoppingAddressModel.addressNo;
    model.country = shoppingAddressModel.country;
    model.state = shoppingAddressModel.state;
    model.city = shoppingAddressModel.city;
    model.tags = shoppingAddressModel.tags;
    model.street = shoppingAddressModel.street;
    model.subLocality = shoppingAddressModel.subLocality;
    model.shortName = shoppingAddressModel.shortName;
    model.provinceCode = shoppingAddressModel.provinceCode;
    model.districtCode = shoppingAddressModel.districtCode;
    model.consigneeName = shoppingAddressModel.consigneeName;
    model.mobile = shoppingAddressModel.mobile;
    return model;
}

- (NSString *)fullAddress {
    NSMutableString *str = [NSMutableString string];
    if (HDIsStringNotEmpty(self.address)) {
        [str appendString:self.address];
    }
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        [str appendString:self.consigneeAddress ?: @""];
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        [str insertString:self.consigneeAddress ?: @"" atIndex:0];
    } else {
        [str insertString:self.consigneeAddress ?: @"" atIndex:0];
    }
    return str;
}

- (BOOL)isValid {
    if (HDIsObjectNil(self.lat)) {
        return NO;
    }
    if (HDIsObjectNil(self.lon)) {
        return NO;
    }

    BOOL isLatitudeValid = self.lat.doubleValue >= -90 && self.lat.doubleValue <= 90;
    BOOL isLongitudeValid = self.lon.doubleValue >= -180 && self.lon.doubleValue <= 180;

    if (isLatitudeValid && isLongitudeValid) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isNeedCompleteAddress {
    if (HDIsStringNotEmpty(self.provinceCode) || HDIsStringNotEmpty(self.districtCode)) {
        return false;
    }
    return true;
}

- (BOOL)isEqual:(SAAddressModel *)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:SAAddressModel.class])
        return NO;

    if (![self.lon isEqual:object.lon] || ![self.lat isEqual:object.lat] || ![self.country isEqualToString:object.country] || ![self.city isEqualToString:object.city]
        || ![self.address isEqualToString:object.address])
        return NO;

    return YES;
}

@end
