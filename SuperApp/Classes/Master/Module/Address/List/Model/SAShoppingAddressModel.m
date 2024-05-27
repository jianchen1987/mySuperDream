//
//  SAShoppingAddressModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressModel.h"
#import "SACacheManager.h"
#import "SAApolloManager.h"
#import "SAAddressModel.h"


@implementation SAShoppingAddressModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageURLs = @[];
        self.tags = @[];
        self.cellType = SAShoppingAddressCellTypeDefault;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"isDefault": @"def",
        @"tags": @"tag",
        @"state": @"provinceId",
        @"city": @"cityId",
        @"shortName": @"simpleName",
        @"subLocality": @"areaId",
    };
}

#pragma mark - public methods
- (BOOL)isNeedCompleteAddressInClientType:(SAClientType _Nullable)clientType {
    if (HDIsStringNotEmpty(clientType)) {
        BOOL needCheck = [[SAApolloManager getApolloConfigForKey:ApolloConfigKeyOrderSubmitNeedCheckAddress][clientType] boolValue];
        if (!needCheck) {
            return false;
        }
    }
    if (HDIsStringNotEmpty(self.provinceCode) || HDIsStringNotEmpty(self.districtCode)) {
        return false;
    }
    return true;
}

#pragma mark - setter
- (void)setInRange:(SABoolValue)inRange {
    if ([@[@"1", @"true", @"yes"] containsObject:inRange.lowercaseString]) {
        _inRange = SABoolValueTrue;
    } else {
        _inRange = SABoolValueFalse;
    }
}

- (void)setIsDefault:(SABoolValue)isDefault {
    if ([@[@"1", @"true", @"yes"] containsObject:isDefault.lowercaseString]) {
        _isDefault = SABoolValueTrue;
    } else {
        _isDefault = SABoolValueFalse;
    }
}

- (void)setSpeedDelivery:(SABoolValue)speedDelivery {
    if ([@[@"1", @"true", @"yes"] containsObject:speedDelivery.lowercaseString]) {
        _speedDelivery = SABoolValueTrue;
    } else {
        _speedDelivery = SABoolValueFalse;
    }
}

- (void)setSlowPayMark:(SABoolValue)slowPayMark {
    if ([@[@"1", @"true", @"yes"] containsObject:slowPayMark.lowercaseString]) {
        _slowPayMark = SABoolValueTrue;
    } else {
        _slowPayMark = SABoolValueFalse;
    }
}

#pragma mark - getter
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

+ (instancetype)shoppingAddressModelWithAddressModel:(SAAddressModel *)model {
    SAShoppingAddressModel *shoppingAddressModel = SAShoppingAddressModel.new;
    shoppingAddressModel.longitude = model.lon;
    shoppingAddressModel.latitude = model.lat;
    shoppingAddressModel.address = model.address;
    shoppingAddressModel.consigneeAddress = model.consigneeAddress;
    shoppingAddressModel.addressNo = model.addressNo;
    shoppingAddressModel.country = model.country;
    shoppingAddressModel.state = model.state;
    shoppingAddressModel.tags = model.tags;
    shoppingAddressModel.city = model.city;
    shoppingAddressModel.street = model.street;
    shoppingAddressModel.subLocality = model.subLocality;
    shoppingAddressModel.shortName = model.shortName;
    shoppingAddressModel.provinceCode = model.provinceCode;
    shoppingAddressModel.districtCode = model.districtCode;
    shoppingAddressModel.isDefault = model.temp;
    shoppingAddressModel.consigneeName = model.consigneeName;
    shoppingAddressModel.mobile = model.mobile;
    shoppingAddressModel.gender = model.gender;
    return shoppingAddressModel;
}
@end
